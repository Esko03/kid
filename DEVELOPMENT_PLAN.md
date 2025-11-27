# Foxy Kids - Development Plan 2025

**Project**: Flutter English Learning App for Kids (4-12)  
**Current Status**: ~30% complete (UI done, no persistence/logic)  
**Updated**: November 26, 2025

---

## Executive Summary

Foxy Kids has a solid UI foundation with glassmorphism design and animated mascot. Next priority is implementing data persistence, game logic, and audio integration. This plan maps 16 weeks of development with Supabase + SQLite hybrid architecture.

---

## Architecture Overview

### Tech Stack
- **Frontend**: Flutter (cross-platform)
- **Local DB**: SQLite + drift ORM (offline-first game logic)
- **Cloud**: Supabase (auth, parent dashboard, analytics)
- **Audio**: `audioplayers` package
- **Animations**: `flutter_animate` (no manual controllers)
- **UI**: Glassmorphism with `GlassCard`, `PrimaryButton`, `FoxyMascot`

### Data Flow
```
User Input → Game Logic → Local SQLite → Supabase (async sync)
                            ↓
                        Progress Tracked
                            ↓
                        Parent Dashboard
```

---

## Phase Breakdown

### Phase 1: Data Persistence Foundation (Weeks 1-4)

#### Week 1: SQLite + Drift Setup
**Duration**: 5 days  
**Priority**: CRITICAL

**Tasks**:
- [ ] Add `drift`, `drift_flutter` dependencies
- [ ] Create `lib/data/database/app_database.dart` with drift schema
- [ ] Define core models: `UserModel`, `LessonModel`, `ProgressModel`, `AchievementModel`
- [ ] Create database migration system
- [ ] Write unit tests for DB operations

**Files to Create**:
- `lib/data/database/app_database.dart`
- `lib/data/models/user_model.dart`
- `lib/data/models/lesson_model.dart`
- `lib/data/models/progress_model.dart`
- `test/database_test.dart`

**Success Criteria**:
- ✅ Database initializes on app launch
- ✅ Can create/read/update user data
- ✅ All migrations pass

---

#### Week 2: Lesson Content System
**Duration**: 5 days  
**Priority**: CRITICAL

**Tasks**:
- [ ] Create lesson content JSON seed data (100+ vocabulary words)
- [ ] Implement lesson loading from SQLite
- [ ] Update `LessonCategoryScreen` to display real lessons
- [ ] Update `IndividualLessonScreen` to load from database
- [ ] Implement lesson step progression with real data
- [ ] Add progress tracking (completed_at timestamp)

**Files to Modify**:
- `lib/screens/lessons/lesson_category_screen.dart`
- `lib/screens/lessons/individual_lesson_screen.dart`
- `lib/data/repositories/lesson_repository.dart` (new)

**Success Criteria**:
- ✅ Real vocabulary words display in lessons
- ✅ Can complete lesson and progress saves
- ✅ Next button navigates to next lesson

---

#### Week 3: User Progress & Achievements
**Duration**: 4 days  
**Priority**: HIGH

**Tasks**:
- [ ] Implement progress calculation logic
- [ ] Create achievement unlock system (badges, streaks)
- [ ] Update `ProgressScreen` to show real data
- [ ] Add streak counter (daily login bonus)
- [ ] Implement achievement notifications with `FoxyMascot`

**Files to Create**:
- `lib/data/repositories/progress_repository.dart`
- `lib/data/repositories/achievement_repository.dart`
- `lib/widgets/achievement_popup.dart` (glassmorphic)

**Success Criteria**:
- ✅ Progress screen shows real completion %
- ✅ Achievements unlock and display
- ✅ Streaks persist across sessions

---

#### Week 4: Settings & Preferences
**Duration**: 4 days  
**Priority**: MEDIUM

**Tasks**:
- [ ] Implement `shared_preferences` for quick settings
- [ ] Add theme toggle (dark/light mode ready)
- [ ] Implement sound on/off toggle
- [ ] Add language preference (future: Spanish, French, etc.)
- [ ] Create settings sync to Supabase (optional)

**Files to Modify**:
- `lib/screens/profile/profile_screen.dart`
- `lib/data/repositories/settings_repository.dart` (new)

**Success Criteria**:
- ✅ Settings persist across app restarts
- ✅ All switches functional
- ✅ Sound toggle affects gameplay

---

### Phase 2: Game Implementation (Weeks 5-8)

#### Week 5: Game Framework & Memory Match
**Duration**: 5 days  
**Priority**: CRITICAL

**Tasks**:
- [ ] Create abstract game controller base class
- [ ] Implement Memory Match game logic
- [ ] Add scoring system
- [ ] Implement win/lose conditions
- [ ] Create game result screen (glassmorphic)

**Files to Create**:
- `lib/games/base_game_controller.dart`
- `lib/games/memory_match/memory_match_game.dart`
- `lib/games/memory_match/memory_match_controller.dart`
- `lib/screens/games/memory_match_screen.dart`

**Success Criteria**:
- ✅ Can play complete game from start to finish
- ✅ Score calculated correctly
- ✅ Results saved to database

---

#### Week 6-7: Remaining 5 Games
**Duration**: 10 days  
**Priority**: HIGH

**Game Implementation Order**:
1. **Word Match** (cards flip to match word pairs)
2. **Spelling Bee** (spell word after hearing pronunciation)
3. **Quiz Challenge** (multiple choice questions)
4. **Picture Puzzle** (match picture to word)
5. **Sound Match** (match sound to word)

**Per-Game Deliverables**:
- Game logic controller
- Game screen UI (glassmorphic)
- Score calculation
- Result persistence
- Analytics logging

**Files to Create**:
- `lib/games/{game_name}/{game_name}_game.dart`
- `lib/games/{game_name}/{game_name}_controller.dart`
- `lib/screens/games/{game_name}_screen.dart`

**Success Criteria**:
- ✅ All 6 games playable end-to-end
- ✅ Scores persist in database
- ✅ Analytics logged

---

#### Week 8: Game Balancing & Polish
**Duration**: 5 days  
**Priority**: MEDIUM

**Tasks**:
- [ ] Difficulty progression (easy/medium/hard modes)
- [ ] Add timer/challenge modes
- [ ] Implement power-ups (hints, extra time)
- [ ] Add celebratory animations with `FoxyMascot`
- [ ] Balance difficulty curves

**Files to Modify**:
- All game controller files
- `lib/widgets/foxy_mascot.dart` (add more states if needed)

**Success Criteria**:
- ✅ Games feel balanced for 4-12 age range
- ✅ Difficulty progression works
- ✅ Celebratory feedback engaging

---

### Phase 3: Audio Integration (Weeks 9-10)

#### Week 9: Audio Setup & Pronunciation
**Duration**: 5 days  
**Priority**: HIGH

**Tasks**:
- [ ] Add audio files to `assets/sounds/` (pronunciation for 500+ words)
- [ ] Implement audio player controller
- [ ] Add pronunciation button to lessons
- [ ] Implement audio loading with caching
- [ ] Add audio error handling

**Files to Create**:
- `lib/services/audio_service.dart`
- Update `pubspec.yaml` with asset paths

**Success Criteria**:
- ✅ Pronunciation plays on button tap
- ✅ Audio preloads quickly
- ✅ Works with sound settings toggle

---

#### Week 10: Sound Effects & Background Music
**Duration**: 5 days  
**Priority**: MEDIUM

**Tasks**:
- [ ] Add UI sound effects (correct/wrong/button clicks)
- [ ] Implement background music for home/games
- [ ] Add audio settings (on/off, volume control)
- [ ] Create audio asset management system
- [ ] Test audio on multiple devices

**Files to Modify**:
- `lib/services/audio_service.dart`
- All game screens
- `lib/screens/profile/profile_screen.dart`

**Success Criteria**:
- ✅ Sound effects enhance gameplay
- ✅ Background music doesn't repeat harshly
- ✅ Audio settings respected

---

### Phase 4: Supabase Integration (Weeks 11-12)

#### Week 11: Authentication & Cloud Sync
**Duration**: 5 days  
**Priority**: HIGH

**Tasks**:
- [ ] Set up Supabase project (create tables in SQL)
- [ ] Implement user authentication (email/password)
- [ ] Create auth flow in onboarding screens
- [ ] Implement local ↔ cloud sync for progress
- [ ] Add offline queue for pending syncs

**Files to Create**:
- `lib/data/repositories/auth_repository.dart`
- `lib/data/repositories/sync_repository.dart`
- Update `lib/screens/onboarding/*.dart`

**Success Criteria**:
- ✅ User can sign up and log in
- ✅ Progress syncs to Supabase
- ✅ Works offline (syncs when online)

---

#### Week 12: Analytics & Parent Dashboard
**Duration**: 5 days  
**Priority**: HIGH

**Tasks**:
- [ ] Create `game_analytics` table in Supabase
- [ ] Implement analytics logging (all game plays)
- [ ] Create parent account linking
- [ ] Build parent dashboard screen (real-time stats)
- [ ] Add game leaderboards

**Files to Create**:
- `lib/data/repositories/analytics_repository.dart`
- `lib/screens/parent/parent_dashboard_screen.dart` (update)
- `lib/widgets/analytics_chart.dart`

**Success Criteria**:
- ✅ Parents can see child's game play stats
- ✅ Most played games visible
- ✅ Leaderboards show top performers

---

### Phase 5: Polish & Launch Prep (Weeks 13-16)

#### Week 13: Testing & QA
**Duration**: 5 days  
**Priority**: CRITICAL

**Tasks**:
- [ ] Write unit tests for all core logic (50%+ coverage)
- [ ] Perform end-to-end testing on real devices
- [ ] Test on multiple device sizes (phones, tablets)
- [ ] Performance profiling & optimization
- [ ] Memory leak detection

**Files to Create**:
- `test/unit/game_logic_test.dart`
- `test/integration/full_game_flow_test.dart`

**Success Criteria**:
- ✅ No critical bugs
- ✅ App runs smoothly on mid-range phones
- ✅ Memory usage within limits

---

#### Week 14: Optimization & Accessibility
**Duration**: 5 days  
**Priority**: HIGH

**Tasks**:
- [ ] Optimize animation performance
- [ ] Add accessibility labels (screen reader support)
- [ ] Test with slow networks (3G simulation)
- [ ] Reduce app bundle size
- [ ] Implement proper error messages

**Files to Modify**:
- All UI files (add Semantics widgets)
- Animation chains (optimize flutter_animate)

**Success Criteria**:
- ✅ App accessible for children with disabilities
- ✅ Bundle size < 100MB
- ✅ Works on 3G networks

---

#### Week 15: Design Polish & Content
**Duration**: 5 days  
**Priority**: MEDIUM

**Tasks**:
- [ ] Add splash screen animations (2s delay with Foxy)
- [ ] Polish all transitions with flutter_animate
- [ ] Add 50+ more vocabulary words
- [ ] Create welcome tutorial overlay
- [ ] Add app icons & app store graphics

**Files to Modify**:
- `lib/screens/splash_screen.dart`
- All screen transition animations
- `pubspec.yaml` (app icons)

**Success Criteria**:
- ✅ App feels polished and professional
- ✅ Content rich (500+ vocabulary words)
- ✅ Store graphics ready

---

#### Week 16: Final Testing & Launch Prep
**Duration**: 5 days  
**Priority**: CRITICAL

**Tasks**:
- [ ] Final security audit (API keys, data handling)
- [ ] Privacy policy & COPPA compliance (kids app)
- [ ] Build release APK/IPA
- [ ] Prepare app store listings
- [ ] Set up beta testing via TestFlight/Firebase
- [ ] Create README for deployment

**Success Criteria**:
- ✅ App ready for Play Store/App Store submission
- ✅ All legal/compliance docs ready
- ✅ Beta testers can install via TestFlight

---

## Implementation Order (Start Here)

### Immediate (This Week)
1. ✅ Enhanced `FoxyMascot` widget (DONE)
2. ⚠️ Fix `BottomNavBar` `isActive` issue
3. **→ Set up SQLite + drift database**
4. **→ Create data models**

### Next 2 Weeks
5. Implement lesson content system
6. Add progress tracking
7. Create game framework
8. Implement Memory Match game

### Weeks 3-4
9. Implement remaining 5 games
10. Add audio integration
11. Set up Supabase

---

## Critical Path Dependencies

```
Database Setup
    ↓
Lesson Content + Models
    ↓
Game Framework + Memory Match
    ↓
Remaining Games + Audio
    ↓
Supabase Auth + Sync
    ↓
Analytics + Parent Dashboard
    ↓
Testing & Polish
    ↓
Launch Prep
```

---

## Resource Requirements

### External Assets Needed
- **Audio**: 500+ pronunciation MP3s (4-12 age-appropriate)
- **Images**: Lesson illustration assets (50+)
- **Animations**: Lottie files for achievements (10+)
- **Fonts**: Nunito (already configured via Google Fonts)

### Time Estimate
- **Total**: 16 weeks
- **Developer Capacity**: 1 full-time + 0.5 part-time (testing)
- **Per Week**: 40 hours development + 8 hours testing

### Cost Estimates
- Supabase: ~$10-50/month (with free tier starting)
- Assets: $300-500 (audio, images)
- Testing tools: Free (Firebase, TestFlight)

---

## Success Metrics

- [ ] 500+ vocabulary words in lessons
- [ ] 6 fully functional games
- [ ] <2s load time on all screens
- [ ] <50MB app bundle size
- [ ] 95%+ test coverage for game logic
- [ ] Parent dashboard shows real-time stats
- [ ] <5 second app startup
- [ ] Works offline (progress syncs online)

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Audio asset delays | HIGH | Start asset collection in Week 1; use placeholder audio initially |
| Performance issues | MEDIUM | Profile regularly; test on low-end devices early |
| Supabase learning curve | LOW | Start with simple auth; expand complexity gradually |
| Data loss on sync | HIGH | Implement conflict resolution; test offline scenarios |
| Kids app compliance | HIGH | Consult COPPA requirements early (Week 14) |

---

## File Structure (Target)

```
lib/
├── data/
│   ├── database/
│   │   └── app_database.dart (drift database)
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── lesson_model.dart
│   │   ├── progress_model.dart
│   │   └── achievement_model.dart
│   └── repositories/
│       ├── user_repository.dart
│       ├── lesson_repository.dart
│       ├── progress_repository.dart
│       ├── auth_repository.dart
│       ├── analytics_repository.dart
│       └── sync_repository.dart
├── games/
│   ├── base_game_controller.dart
│   ├── memory_match/
│   ├── word_match/
│   ├── spelling_bee/
│   ├── quiz_challenge/
│   ├── picture_puzzle/
│   └── sound_match/
├── services/
│   └── audio_service.dart
├── screens/ (existing structure maintained)
├── widgets/ (existing + new: analytics_chart.dart, achievement_popup.dart)
├── utils/ (existing)
└── main.dart (updated with Supabase init)
```

---

## Next Actions

**Today**:
1. Review and approve this plan
2. Clarify any questions about tech choices
3. Confirm resource availability

**This Week**:
1. Set up SQLite + drift dependencies
2. Create initial database schema
3. Create user and lesson models
4. Write first database unit tests

**Next Week**:
1. Implement lesson loading system
2. Update lesson screens to use real data
3. Start game framework

---

## Document Maintenance

**Last Updated**: November 26, 2025  
**Owner**: Development Team  
**Review Frequency**: Weekly  
**Next Review**: Week 1 completion check

For questions or updates, refer to:
- Copilot Instructions: `.github/copilot-instructions.md`
- Architecture Docs: `plan/06_database_models/data_architecture.md`
- Game Logic: `plan/04_game_logic/game_implementation_plan.md`
