# Supabase Integration Plan – Foxy Kids

**Phase**: Phase 4 (Weeks 11-12) + Backend Setup (Weeks 1-2)  
**Status**: Pre-implementation planning  
**Created**: November 26, 2025

---

## Executive Summary

This document outlines the complete Supabase integration strategy for Foxy Kids, covering authentication, real-time data sync, parent dashboards, analytics, and payments. The plan is structured in two parts: **foundation setup** (early, during data persistence phase) and **full integration** (Phase 4, after game logic is complete).

### Key Principles
- **Offline-first**: SQLite is source of truth during offline mode
- **Cloud-sync**: Supabase syncs when online, handles conflicts with "last-write-wins"
- **Parent-child separation**: Parent accounts manage child profiles with authentication
- **Privacy-first**: Row-level security (RLS) enforces user data isolation

---

## Architecture Overview

### Data Flow Diagram
```
┌─────────────────────────────────────────────────────────────────┐
│                    Foxy Kids User Session                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
        ┌─────────────────────┐  ┌──────────────────┐
        │  Local SQLite DB    │  │  Supabase Cloud  │
        │  (Offline Cache)    │  │  (Source Truth)  │
        │  ────────────────   │  │  ───────────────  │
        │ • Lessons           │  │ • Auth            │
        │ • Progress          │  │ • Analytics       │
        │ • Game Scores       │  │ • Parent Ctrl     │
        │ • Achievements      │  │ • Payments        │
        └─────────────────────┘  └──────────────────┘
                    ▲                   ▲
                    │        Sync       │
                    └───────────────────┘
              (Network Available Only)
```

### Technology Stack
- **Supabase Auth**: Email/password + OAuth (Google for parents)
- **Supabase Database**: PostgreSQL with RLS policies
- **Local SQLite**: Drift ORM for offline-first caching
- **Real-time**: Supabase RealtimeClient for multi-device sync
- **Payments**: Stripe integration (subscription management)
- **Analytics**: Custom events table + Supabase analytics

---

## Phase Breakdown

### Phase 0: Foundation Setup (Weeks 1-2) ⚡ PREREQUISITE

**Why**: Database models must exist before Supabase schema is created.

#### Task 1: Add Dependencies
**Files**: `pubspec.yaml`

```yaml
dependencies:
  supabase_flutter: ^1.10.0
  drift: ^2.13.0
  drift_flutter: ^0.0.1
  path_provider: ^2.1.1
  connectivity_plus: ^5.0.0
```

**Success**: Dependencies resolve with `flutter pub get`

---

#### Task 2: Create SQLite Database with Drift
**Files to Create**:
- `lib/data/database/app_database.dart` – Drift database definition
- `lib/data/models/user_model.dart` – User entity
- `lib/data/models/lesson_model.dart` – Lesson entity
- `lib/data/models/progress_model.dart` – Progress entity
- `lib/data/models/achievement_model.dart` – Achievement entity
- `lib/data/models/game_score_model.dart` – Game score entity

**Core Tables**:
```sql
-- Users (local cache of auth user data)
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT,
  child_age INTEGER,
  learning_mode TEXT,
  created_at DATETIME,
  updated_at DATETIME
);

-- Lessons (all available lessons)
CREATE TABLE lessons (
  id TEXT PRIMARY KEY,
  category TEXT,
  word TEXT,
  translation TEXT,
  pronunciation_url TEXT,
  image_url TEXT,
  difficulty INTEGER
);

-- Progress (user's lesson completion)
CREATE TABLE progress (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  lesson_id TEXT,
  completed_at DATETIME,
  score INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

-- Achievements (badges, streaks)
CREATE TABLE achievements (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  badge_type TEXT,
  unlocked_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Game Scores
CREATE TABLE game_scores (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  game_name TEXT,
  score INTEGER,
  played_at DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**Success**: 
- ✅ Database initializes on app launch
- ✅ Can create/read/update/delete records
- ✅ Unit tests pass for all CRUD operations

---

#### Task 3: Create Repository Pattern
**Files to Create**:
- `lib/data/repositories/user_repository.dart`
- `lib/data/repositories/lesson_repository.dart`
- `lib/data/repositories/progress_repository.dart`
- `lib/data/repositories/achievement_repository.dart`

**Pattern**:
```dart
abstract class UserRepository {
  Future<User> getUser(String userId);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
}

class UserRepositoryImpl implements UserRepository {
  final AppDatabase _database;
  UserRepositoryImpl(this._database);
  
  @override
  Future<User> getUser(String userId) => 
    _database.users.select().where((u) => u.id.equals(userId)).getSingle();
  // ... rest of methods
}
```

**Success**: All repository methods implement CRUD operations

---

### Phase 1: Supabase Authentication (Week 11)

#### Task 1: Initialize Supabase Client
**Files to Create**:
- `lib/supabase/supabase_service.dart` – Core client setup

**Functionality**:
```dart
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late SupabaseClient _client;
  
  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://your-project.supabase.co',
      anonKey: 'your-anon-key',
    );
    _client = Supabase.instance.client;
  }
  
  SupabaseClient get client => _client;
  
  bool get isAuthenticated => _client.auth.currentUser != null;
  User? get currentUser => _client.auth.currentUser;
}
```

**Success**:
- ✅ Supabase credentials loaded from environment
- ✅ Client authenticated on app launch
- ✅ Session persisted across app restarts

---

#### Task 2: Implement Parent-Child Authentication Flow
**Files to Create**:
- `lib/supabase/auth_provider.dart` – Auth state management
- `lib/screens/auth/parent_signup_screen.dart` – Parent registration
- `lib/screens/auth/child_login_screen.dart` – Child selection/PIN

**Parent Flow**:
1. Parent signs up with email/password (Supabase Auth)
2. Parent verifies email (optional, for iOS/COPPA compliance)
3. Parent creates child profile(s) with name, age, learning mode
4. Child selects their profile with optional PIN

**Child Flow**:
1. Child sees list of child profiles (from parent account)
2. Child enters PIN or selects profile
3. Session creates temporary JWT scoped to child profile
4. SQLite syncs child's progress locally

**Supabase Auth Tables**:
```sql
-- auth.users (managed by Supabase)
-- [auto-created]

-- public.child_profiles (linked to auth.users via parent_id)
CREATE TABLE child_profiles (
  id UUID PRIMARY KEY,
  parent_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  age INTEGER NOT NULL,
  learning_mode TEXT,
  pin TEXT,
  created_at DATETIME DEFAULT NOW()
);

-- public.sessions (track login sessions)
CREATE TABLE sessions (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  child_profile_id UUID REFERENCES child_profiles(id),
  login_at DATETIME DEFAULT NOW(),
  logout_at DATETIME
);
```

**Success**:
- ✅ Parent can sign up and verify email
- ✅ Parent can create multiple child profiles
- ✅ Child can log in with PIN
- ✅ Session persists across app restarts

---

#### Task 3: Set Up Row-Level Security (RLS)
**Database**: Supabase PostgreSQL

**Policies**:
```sql
-- Users can only see their own data
CREATE POLICY "Users see own data"
ON public.child_profiles
FOR SELECT
USING (auth.uid() = parent_id);

-- Parents can only manage their own children
CREATE POLICY "Parents manage own children"
ON public.child_profiles
FOR UPDATE
USING (auth.uid() = parent_id);

-- Analytics visible only to parent
CREATE POLICY "Analytics visible to parent"
ON public.analytics_events
FOR SELECT
USING (
  auth.uid() = (
    SELECT parent_id FROM child_profiles 
    WHERE id = child_profile_id
  )
);
```

**Success**:
- ✅ RLS enabled on all tables
- ✅ Users cannot access other users' data
- ✅ All queries respect parent-child relationships

---

### Phase 2: Real-Time Data Sync (Week 11-12)

#### Task 1: Create Sync Manager
**Files to Create**:
- `lib/data/sync/sync_manager.dart` – Orchestrates SQLite ↔ Supabase sync

**Functionality**:
```dart
class SyncManager {
  final AppDatabase _localDb;
  final SupabaseClient _supabaseClient;
  
  Future<void> syncProgress() async {
    // 1. Fetch remote changes
    final remoteProgress = await _supabaseClient
      .from('progress')
      .select()
      .gt('updated_at', _lastSyncTime);
    
    // 2. Merge conflicts (last-write-wins)
    final merged = _mergeConflicts(remoteProgress, localProgress);
    
    // 3. Update local database
    await _localDb.batch((batch) {
      for (var item in merged) {
        batch.insertOnConflictUpdate(_localDb.progress, item);
      }
    });
    
    // 4. Upload local changes
    await _uploadLocalChanges();
  }
  
  Future<void> syncAchievements() async { /* similar */ }
  Future<void> syncGameScores() async { /* similar */ }
  
  List<ProgressModel> _mergeConflicts(List remote, List local) {
    // last-write-wins: use timestamp to determine winner
    return remote.map((r) {
      final l = local.firstWhereOrNull((l) => l.id == r['id']);
      if (l == null) return r;
      return DateTime.parse(r['updated_at']).isAfter(l.updatedAt) ? r : l;
    }).toList();
  }
}
```

**Success**:
- ✅ Local changes upload to Supabase
- ✅ Remote changes download to local database
- ✅ Conflicts resolved without data loss

---

#### Task 2: Handle Offline/Online Transitions
**Files to Modify**:
- `lib/main.dart` – Initialize connectivity listener

**Implementation**:
```dart
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final SupabaseService _supabase;
  
  Stream<bool> get isOnline => _connectivity.onConnectivityChanged
    .map((result) => result != ConnectivityResult.none);
  
  void listenToConnectivity() {
    isOnline.listen((online) {
      if (online) {
        _supabase.syncManager.syncAll(); // Sync all tables
      } else {
        // Show "offline mode" indicator
      }
    });
  }
}
```

**Success**:
- ✅ App detects network changes
- ✅ Auto-syncs when coming online
- ✅ Shows offline indicator to user

---

### Phase 3: Parent Dashboard Integration (Week 12)

#### Task 1: Update Parent Dashboard with Real Data
**Files to Modify**:
- `lib/screens/parent/parent_dashboard_screen.dart`

**Data Sources** (from Supabase):
- Learning time: `SELECT SUM(duration) FROM sessions WHERE date = TODAY`
- Lesson progress: `SELECT COUNT(*) FROM progress WHERE completed_at > NOW() - '7 days'`
- Achievements unlocked: `SELECT COUNT(*) FROM achievements WHERE unlocked_at > NOW() - '7 days'`
- Game scores: `SELECT AVG(score) FROM game_scores WHERE played_at > NOW() - '7 days'`

**Real-time Updates**:
```dart
class ParentDashboardController {
  final SupabaseClient _supabase;
  final StreamController<DashboardData> _dataController = StreamController();
  
  void subscribeToDashboard(String parentId) {
    _supabase.from('analytics_events')
      .on(RealtimeListenTypes.all, postgresql: 'UPDATE')
      .eq('parent_id', parentId)
      .subscribe((payload) {
        _updateDashboard(payload.newRecord);
      });
  }
}
```

**Success**:
- ✅ Parent sees real-time child progress
- ✅ Learning time tracked and displayed
- ✅ Dashboard updates without manual refresh

---

#### Task 2: Implement Parent Controls
**Features**:
- Time limits per day (enforced on child app)
- Content filtering by age/difficulty
- Weekly leaderboards (if multiple children)
- Achievement notifications

**Database Tables**:
```sql
CREATE TABLE parent_controls (
  id UUID PRIMARY KEY,
  parent_id UUID REFERENCES auth.users(id),
  child_profile_id UUID REFERENCES child_profiles(id),
  daily_time_limit_minutes INTEGER DEFAULT 120,
  content_filter_age INTEGER,
  enable_notifications BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT NOW()
);

CREATE TABLE notifications (
  id UUID PRIMARY KEY,
  parent_id UUID REFERENCES auth.users(id),
  type TEXT, -- 'achievement', 'daily_limit', 'streak'
  message TEXT,
  read_at DATETIME,
  created_at DATETIME DEFAULT NOW()
);
```

**Success**:
- ✅ Parent can set time limits
- ✅ Child app enforces limits (blocks after limit reached)
- ✅ Notifications sent when child unlocks achievement

---

#### Task 3: Generate & Download Reports
**Files to Create**:
- `lib/services/report_service.dart` – PDF generation

**Features**:
- Weekly learning summary (hours spent per category)
- Vocabulary mastered (count + list)
- Game performance (scores, progress)
- Achievement timeline (badges unlocked)

**Implementation**:
```dart
class ReportService {
  Future<Uint8List> generateWeeklyReport(String parentId, String childId) async {
    final pdf = pw.Document();
    
    final analytics = await _supabase
      .from('analytics_events')
      .select()
      .eq('child_profile_id', childId)
      .gte('created_at', _weekAgo);
    
    pdf.addPage(pw.Page(
      build: (context) => pw.Column(
        children: [
          pw.Text('Weekly Learning Report'),
          pw.SizedBox(height: 20),
          _buildSummarySection(analytics),
          _buildVocabularySection(analytics),
          _buildGameScoresSection(analytics),
        ],
      ),
    ));
    
    return pdf.save();
  }
}
```

**Success**:
- ✅ PDF generated and downloaded
- ✅ Report includes all key metrics
- ✅ Parent can share with educators

---

### Phase 4: Payments & Subscriptions (Week 12+)

#### Task 1: Set Up Stripe Integration
**Files to Create**:
- `lib/supabase/payment.dart` – Stripe payment handler

**Stripe Setup**:
1. Create Stripe account and add webhook
2. Create subscription plans (Free, Premium $4.99/mo, Family $9.99/mo)
3. Handle customer creation & billing

**Implementation**:
```dart
class PaymentService {
  final SupabaseClient _supabase;
  final Stripe _stripe = Stripe.instance;
  
  Future<bool> initiateSubscription(String priceId) async {
    final user = _supabase.auth.currentUser!;
    
    // Create Stripe customer in Supabase
    final response = await _supabase.functions.invoke('create_payment_intent', 
      body: {'priceId': priceId}
    );
    
    // Initiate payment
    final clientSecret = response.data['clientSecret'];
    await _stripe.confirmPaymentSheetPayment();
    
    return true;
  }
  
  Future<bool> cancelSubscription() async {
    return await _supabase.functions.invoke('cancel_subscription');
  }
}
```

**Success**:
- ✅ Subscription created and charged monthly
- ✅ Subscription status stored in Supabase
- ✅ Premium features enabled for subscribers

---

#### Task 2: Track Premium Features
**Database Table**:
```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY,
  parent_id UUID REFERENCES auth.users(id),
  stripe_customer_id TEXT,
  stripe_subscription_id TEXT,
  plan_type TEXT, -- 'free', 'premium', 'family'
  status TEXT, -- 'active', 'canceled', 'past_due'
  created_at DATETIME DEFAULT NOW(),
  current_period_end DATETIME,
  canceled_at DATETIME
);
```

**Features Tied to Premium**:
- Unlimited vocabulary (free: 50/month)
- All 6 games (free: Word Match only)
- Ad-free experience
- Offline mode (free: online only)
- Parent dashboard (family plan)
- PDF reports (family plan)

**Success**:
- ✅ Free tier users limited appropriately
- ✅ Premium features unlock when subscribed
- ✅ Billing works correctly

---

## Implementation Steps by File

### Core Files to Create

| File | Purpose | Lines | Priority |
|------|---------|-------|----------|
| `lib/data/database/app_database.dart` | Drift database definition | 300 | P0 |
| `lib/data/repositories/user_repository.dart` | User CRUD | 50 | P0 |
| `lib/data/repositories/lesson_repository.dart` | Lesson CRUD | 60 | P0 |
| `lib/data/repositories/progress_repository.dart` | Progress CRUD | 70 | P0 |
| `lib/supabase/supabase_service.dart` | Client initialization | 80 | P1 |
| `lib/supabase/auth_provider.dart` | Auth state management | 150 | P1 |
| `lib/data/sync/sync_manager.dart` | Offline sync orchestration | 200 | P1 |
| `lib/services/connectivity_service.dart` | Network detection | 60 | P1 |
| `lib/supabase/payment.dart` | Payment processing | 120 | P2 |
| `lib/services/report_service.dart` | PDF generation | 150 | P2 |

### Files to Modify

| File | Changes | Impact |
|------|---------|--------|
| `pubspec.yaml` | Add Supabase + Drift dependencies | Enables all backend features |
| `lib/main.dart` | Initialize SupabaseService + connectivity listener | App startup setup |
| `lib/screens/home/home_screen.dart` | Connect to real progress data from SQLite | Real learning metrics |
| `lib/screens/parent/parent_dashboard_screen.dart` | Subscribe to Supabase real-time updates | Live parent metrics |
| `lib/screens/auth/` | Integrate auth flow (new screens) | Authentication system |

---

## Data Architecture Summary

### Tables in Supabase (PostgreSQL)

```
auth.users
├── email
├── created_at
└── updated_at

public.child_profiles
├── parent_id (FK → auth.users)
├── name, age, learning_mode, pin
└── created_at

public.sessions
├── user_id (FK → auth.users)
├── child_profile_id (FK → child_profiles)
└── login_at, logout_at

public.subscriptions
├── parent_id (FK → auth.users)
├── stripe_customer_id, stripe_subscription_id
├── plan_type, status
└── created_at, current_period_end

public.parent_controls
├── parent_id, child_profile_id
├── daily_time_limit_minutes
├── content_filter_age
└── enable_notifications

public.notifications
├── parent_id (FK → auth.users)
├── type, message
├── read_at
└── created_at

public.analytics_events
├── child_profile_id (FK → child_profiles)
├── event_type, event_data
└── created_at
```

### Tables in Local SQLite (Drift)

```
users (synced from Supabase)
├── id, email, child_age, learning_mode
└── created_at, updated_at

lessons (seed data, read-only)
├── id, category, word, translation
├── pronunciation_url, image_url
└── difficulty

progress (synced to/from Supabase)
├── id, user_id, lesson_id
├── completed_at, score
└── synced_at

achievements (synced to/from Supabase)
├── id, user_id, badge_type
├── unlocked_at
└── synced_at

game_scores (synced to/from Supabase)
├── id, user_id, game_name
├── score, played_at
└── synced_at
```

---

## Testing Strategy

### Unit Tests
- Repository CRUD operations
- Sync conflict resolution
- Payment processing (mocked)

### Integration Tests
- Auth flow (sign up → child profile → login)
- Sync workflow (offline → online → sync)
- Dashboard updates (real-time subscription)

### End-to-End Tests
- Parent dashboard shows child progress
- Child progress syncs across devices
- Payment processes correctly

---

## Security Considerations

1. **Row-Level Security**: All tables have RLS policies enforced
2. **COPPA Compliance**: No ads, no data collection from kids <13
3. **Encryption**: Use Supabase's default SSL/TLS
4. **API Keys**: Store as environment variables, never commit to repo
5. **Payment Secrets**: Never expose Stripe secret key on client
6. **Session Validation**: Verify child profile ownership before syncing

---

## Environment Configuration

### Development
```env
SUPABASE_URL=https://dev-project.supabase.co
SUPABASE_ANON_KEY=dev-anon-key-...
STRIPE_PUBLISHABLE_KEY=pk_test_...
```

### Production
```env
SUPABASE_URL=https://prod-project.supabase.co
SUPABASE_ANON_KEY=prod-anon-key-...
STRIPE_PUBLISHABLE_KEY=pk_live_...
```

---

## Success Metrics

### Phase 0 Completion
- ✅ SQLite database creates/reads/updates records
- ✅ All repository methods implemented
- ✅ 80%+ code coverage for data layer

### Phase 1 Completion
- ✅ Parent can sign up and verify email
- ✅ Parent can create child profile(s)
- ✅ Child can log in and start learning
- ✅ Session persists across app restarts

### Phase 2 Completion
- ✅ Progress syncs automatically when online
- ✅ App works fully offline (no network needed)
- ✅ Conflicts resolved without data loss

### Phase 3 Completion
- ✅ Parent dashboard shows real-time child progress
- ✅ Time limits enforced on child app
- ✅ PDF reports generate successfully

### Phase 4 Completion
- ✅ Stripe integration processes subscriptions
- ✅ Premium features unlock for subscribers
- ✅ Billing handles edge cases (cancellation, upgrades)

---

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| **Network failures** | Child loses progress | Local SQLite caching + retry on reconnect |
| **Sync conflicts** | Data inconsistency | Last-write-wins strategy + timestamps |
| **Auth issues** | Child cannot log in | Fallback to last-known session, PIN recovery |
| **Payment failures** | Revenue loss | Webhook retries, email receipts |
| **COPPA violations** | Legal liability | No data collection < 13, no ads, parent consent |

---

## Timeline

- **Week 1-2**: Phase 0 (Database setup) – BLOCKER
- **Week 3-10**: Game implementation (parallel)
- **Week 11**: Phase 1-2 (Auth + Sync)
- **Week 12**: Phase 3-4 (Dashboard + Payments)
- **Week 13-16**: Polish, testing, launch prep

---

## Next Steps

1. **Review this plan** with team
2. **Choose Supabase region** (closest to users)
3. **Create Supabase project** and get API keys
4. **Begin Phase 0**: Set up SQLite with Drift
5. **Parallelize game logic** development while data layer builds

---

**Document Version**: 1.0  
**Last Updated**: November 26, 2025  
**Owner**: Development Team
