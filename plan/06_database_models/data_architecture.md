# Database Models & Data Architecture

## Overview
The Foxy Kids app currently has no data persistence layer. This document outlines the required database models and data architecture for storing user progress, lesson content, and app settings.

## Current Status
- **Database**: ❌ Missing (No data persistence)
- **Models**: ❌ Missing (No data models defined)
- **Storage**: ❌ Missing (No local storage implementation)
- **Synchronization**: ❌ Missing (No cloud sync)

## Required Database Models

### 1. User Management

#### User Model
```dart
class User {
  String id;
  String name;
  int age;
  DateTime createdAt;
  DateTime lastActiveAt;
  UserPreferences preferences;
  UserProgress progress;
  List<Achievement> achievements;
}

class UserPreferences {
  bool soundEffects;
  bool backgroundMusic;
  double soundVolume;
  double musicVolume;
  bool notifications;
  String language;
  String difficulty;
  int dailyTimeLimit; // in minutes
  bool parentalControls;
}
```

### 2. Learning System Models

#### Lesson Models
```dart
class Lesson {
  String id;
  String title;
  String description;
  LessonType type;
  int difficulty;
  int estimatedDuration; // in minutes
  String category;
  List<LessonStep> steps;
  List<String> prerequisites;
  int maxStars;
  DateTime createdAt;
  DateTime updatedAt;
}

class LessonStep {
  String id;
  String lessonId;
  String content;
  StepType type; // vocabulary, matching, story, quiz, audio
  Map<String, dynamic> data;
  String audioUrl;
  String imageUrl;
  int order;
  int points;
}

enum LessonType {
  vocabulary,
  matching,
  story,
  quiz,
  alphabet,
  numbers,
  colors,
  phrases
}

enum StepType {
  wordIntroduction,
  pronunciation,
  matching,
  multipleChoice,
  storyReading,
  audioRecognition,
  spelling,
  comprehension
}
```

#### Vocabulary Models
```dart
class VocabularyWord {
  String id;
  String word;
  String pronunciation;
  String definition;
  String imageUrl;
  String audioUrl;
  String category;
  List<String> examples;
  int difficulty;
  DateTime createdAt;
}

class WordCategory {
  String id;
  String name;
  String description;
  String iconUrl;
  List<String> wordIds;
  int difficulty;
  int order;
}
```

### 3. Progress Tracking Models

#### User Progress Models
```dart
class UserProgress {
  String userId;
  Map<String, LessonProgress> lessons;
  Map<String, CategoryProgress> categories;
  int totalStars;
  int currentStreak;
  int longestStreak;
  DateTime lastActiveDate;
  int totalLearningTime; // in minutes
  Map<String, int> dailyProgress; // date -> minutes
}

class LessonProgress {
  String lessonId;
  String userId;
  bool completed;
  int score;
  int stars;
  int attempts;
  DateTime firstAttempt;
  DateTime lastAttempt;
  DateTime completedAt;
  List<StepProgress> steps;
  int totalTime; // in seconds
}

class StepProgress {
  String stepId;
  bool completed;
  int attempts;
  int score;
  DateTime completedAt;
  int timeSpent; // in seconds
}

class CategoryProgress {
  String categoryId;
  String userId;
  int completedLessons;
  int totalLessons;
  int totalStars;
  int maxStars;
  double progressPercentage;
  DateTime lastAccessed;
}
```

### 4. Achievement System Models

#### Achievement Models
```dart
class Achievement {
  String id;
  String title;
  String description;
  String iconUrl;
  AchievementType type;
  Map<String, dynamic> criteria;
  int points;
  bool isHidden;
  DateTime createdAt;
}

class UserAchievement {
  String userId;
  String achievementId;
  DateTime unlockedAt;
  int progress; // for progressive achievements
  bool isNotified;
}

enum AchievementType {
  lessonCompletion,
  streak,
  vocabulary,
  games,
  timeSpent,
  category,
  special
}
```

### 5. Game Models

#### Game Models
```dart
class Game {
  String id;
  String name;
  GameType type;
  String description;
  int difficulty;
  List<GameLevel> levels;
  Map<String, dynamic> settings;
}

class GameLevel {
  String id;
  String gameId;
  String name;
  int levelNumber;
  Map<String, dynamic> content;
  int targetScore;
  int timeLimit; // in seconds
  List<String> requiredWords;
}

class GameSession {
  String id;
  String userId;
  String gameId;
  String levelId;
  int score;
  int timeSpent;
  DateTime startedAt;
  DateTime completedAt;
  bool completed;
  Map<String, dynamic> results;
}

enum GameType {
  wordMatch,
  memory,
  spellingBee,
  quiz,
  picturePuzzle,
  soundMatch
}
```

### 6. Parent Dashboard Models

#### Analytics Models
```dart
class LearningAnalytics {
  String userId;
  DateTime date;
  int totalTimeSpent; // in minutes
  int lessonsCompleted;
  int gamesPlayed;
  int newWordsLearned;
  int correctAnswers;
  int totalAnswers;
  Map<String, int> categoryProgress;
  List<SessionData> sessions;
}

class SessionData {
  DateTime startTime;
  DateTime endTime;
  String activityType; // lesson, game, review
  String activityId;
  int duration; // in minutes
  int score;
  bool completed;
}

class ParentReport {
  String userId;
  DateTime generatedAt;
  DateTime periodStart;
  DateTime periodEnd;
  LearningAnalytics analytics;
  List<Achievement> newAchievements;
  List<String> recommendations;
  String summary;
}
```

## Database Architecture

### Local Database (SQLite)

#### Database Schema
```sql
-- Users table
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  age INTEGER NOT NULL,
  created_at INTEGER NOT NULL,
  last_active_at INTEGER NOT NULL,
  preferences TEXT NOT NULL -- JSON
);

-- Lessons table
CREATE TABLE lessons (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  type TEXT NOT NULL,
  difficulty INTEGER NOT NULL,
  estimated_duration INTEGER NOT NULL,
  category TEXT NOT NULL,
  steps TEXT NOT NULL, -- JSON
  prerequisites TEXT, -- JSON
  max_stars INTEGER NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Vocabulary words table
CREATE TABLE vocabulary_words (
  id TEXT PRIMARY KEY,
  word TEXT NOT NULL,
  pronunciation TEXT,
  definition TEXT,
  image_url TEXT,
  audio_url TEXT,
  category TEXT NOT NULL,
  examples TEXT, -- JSON
  difficulty INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);

-- User progress table
CREATE TABLE user_progress (
  user_id TEXT PRIMARY KEY,
  lessons TEXT NOT NULL, -- JSON
  categories TEXT NOT NULL, -- JSON
  total_stars INTEGER NOT NULL DEFAULT 0,
  current_streak INTEGER NOT NULL DEFAULT 0,
  longest_streak INTEGER NOT NULL DEFAULT 0,
  last_active_date INTEGER NOT NULL,
  total_learning_time INTEGER NOT NULL DEFAULT 0,
  daily_progress TEXT NOT NULL -- JSON
);

-- Lesson progress table
CREATE TABLE lesson_progress (
  lesson_id TEXT,
  user_id TEXT,
  completed INTEGER NOT NULL DEFAULT 0,
  score INTEGER NOT NULL DEFAULT 0,
  stars INTEGER NOT NULL DEFAULT 0,
  attempts INTEGER NOT NULL DEFAULT 0,
  first_attempt INTEGER NOT NULL,
  last_attempt INTEGER NOT NULL,
  completed_at INTEGER,
  steps TEXT NOT NULL, -- JSON
  total_time INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (lesson_id, user_id)
);

-- Achievements table
CREATE TABLE achievements (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon_url TEXT,
  type TEXT NOT NULL,
  criteria TEXT NOT NULL, -- JSON
  points INTEGER NOT NULL,
  is_hidden INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL
);

-- User achievements table
CREATE TABLE user_achievements (
  user_id TEXT,
  achievement_id TEXT,
  unlocked_at INTEGER NOT NULL,
  progress INTEGER NOT NULL DEFAULT 0,
  is_notified INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, achievement_id)
);

-- Game sessions table
CREATE TABLE game_sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  game_id TEXT NOT NULL,
  level_id TEXT NOT NULL,
  score INTEGER NOT NULL DEFAULT 0,
  time_spent INTEGER NOT NULL DEFAULT 0,
  started_at INTEGER NOT NULL,
  completed_at INTEGER,
  completed INTEGER NOT NULL DEFAULT 0,
  results TEXT -- JSON
);

-- Learning analytics table
CREATE TABLE learning_analytics (
  user_id TEXT,
  date INTEGER NOT NULL,
  total_time_spent INTEGER NOT NULL DEFAULT 0,
  lessons_completed INTEGER NOT NULL DEFAULT 0,
  games_played INTEGER NOT NULL DEFAULT 0,
  new_words_learned INTEGER NOT NULL DEFAULT 0,
  correct_answers INTEGER NOT NULL DEFAULT 0,
  total_answers INTEGER NOT NULL DEFAULT 0,
  category_progress TEXT NOT NULL, -- JSON
  sessions TEXT NOT NULL, -- JSON
  PRIMARY KEY (user_id, date)
);
```

### Cloud Synchronization

#### Sync Strategy
```dart
class SyncManager {
  Future<void> syncUserProgress(String userId);
  Future<void> syncAchievements(String userId);
  Future<void> syncGameSessions(String userId);
  Future<void> syncAnalytics(String userId);
  Future<void> downloadLessonContent();
  Future<void> uploadOfflineProgress();
}
```

#### Conflict Resolution
- Last-write-wins for progress data
- Merge for analytics data
- User preference for achievement notifications

## Data Services

### Service Layer Architecture
```dart
abstract class DataService {
  Future<T> get<T>(String id);
  Future<List<T>> getAll<T>();
  Future<void> save<T>(T item);
  Future<void> delete<T>(String id);
}

class LessonService extends DataService {
  Future<List<Lesson>> getLessonsByCategory(String category);
  Future<Lesson> getNextRecommendedLesson(String userId);
  Future<void> updateLessonProgress(LessonProgress progress);
}

class ProgressService extends DataService {
  Future<UserProgress> getUserProgress(String userId);
  Future<void> updateProgress(UserProgress progress);
  Future<List<Achievement>> getUnlockedAchievements(String userId);
  Future<void> checkAndUnlockAchievements(String userId);
}

class AnalyticsService extends DataService {
  Future<LearningAnalytics> getDailyAnalytics(String userId, DateTime date);
  Future<ParentReport> generateParentReport(String userId, DateTime start, DateTime end);
  Future<void> recordSession(SessionData session);
}
```

## Implementation Priority

### Phase 1: Core Data Layer
1. SQLite database setup
2. Basic user and lesson models
3. Simple progress tracking
4. Local data persistence

### Phase 2: Learning System Integration
1. Lesson content loading
2. Progress calculation
3. Achievement system
4. Basic analytics

### Phase 3: Advanced Features
1. Cloud synchronization
2. Parent dashboard data
3. Advanced analytics
4. Offline support

### Phase 4: Optimization
1. Database optimization
2. Caching strategies
3. Performance monitoring
4. Data migration

## Files to Create

### Database Layer
```
lib/
├── database/
│   ├── database_helper.dart
│   ├── models/
│   │   ├── user.dart
│   │   ├── lesson.dart
│   │   ├── vocabulary_word.dart
│   │   ├── progress.dart
│   │   ├── achievement.dart
│   │   └── game.dart
│   └── migrations/
│       ├── migration_001.dart
│       ├── migration_002.dart
│       └── migration_003.dart
├── services/
│   ├── data_service.dart
│   ├── lesson_service.dart
│   ├── progress_service.dart
│   ├── achievement_service.dart
│   ├── analytics_service.dart
│   └── sync_service.dart
└── repositories/
    ├── user_repository.dart
    ├── lesson_repository.dart
    ├── progress_repository.dart
    └── achievement_repository.dart
```

## Success Metrics
- [ ] User progress persists across app sessions
- [ ] Lesson content loads from database
- [ ] Achievement system tracks and unlocks properly
- [ ] Analytics data is accurate and comprehensive
- [ ] Parent dashboard shows real data
- [ ] Offline functionality works correctly
- [ ] Cloud sync handles conflicts properly
- [ ] Database performance is optimized
- [ ] Data migration works seamlessly
- [ ] All CRUD operations function correctly
