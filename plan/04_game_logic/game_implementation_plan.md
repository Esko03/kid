# Game Logic Implementation Plan

## Overview
The Games Hub screen has UI for 6 different games, but none have actual game logic implemented. This document outlines the implementation requirements for each game.

## Current Status
- **UI**: ✅ Complete (GamesHubScreen with 6 game cards)
- **Logic**: ❌ Missing (All games are placeholder only)
- **Data**: ❌ Missing (No game content or scoring)

## Games to Implement

### 1. Word Match Game
**Current Status**: UI placeholder only
**Location**: `lib/screens/games/games_hub_screen.dart` - Word Match card

#### Implementation Requirements
```dart
class WordMatchGame {
  List<WordPair> wordPairs;
  List<Card> cards;
  int score;
  int timeRemaining;
  bool gameCompleted;
  
  void initializeGame();
  void flipCard(int index);
  void checkMatch();
  void calculateScore();
  void resetGame();
}

class WordPair {
  String word;
  String imageUrl;
  String audioUrl;
}
```

#### Game Mechanics
- Display 12 cards (6 pairs)
- Player flips cards to find matching word-image pairs
- Track attempts and time
- Award stars based on performance
- Sound effects for matches/mismatches

#### Required Assets
- Word images (animals, objects, colors)
- Audio pronunciations
- Match/unmatch sound effects
- Success animations

### 2. Memory Game
**Current Status**: UI placeholder only
**Location**: `lib/screens/games/games_hub_screen.dart` - Memory Game card

#### Implementation Requirements
```dart
class MemoryGame {
  List<MemoryCard> cards;
  List<int> flippedCards;
  int pairsFound;
  int moves;
  int timeElapsed;
  
  void initializeGame();
  void flipCard(int index);
  void checkForMatch();
  void shuffleCards();
  void resetGame();
}

class MemoryCard {
  String content; // word or image
  bool isFlipped;
  bool isMatched;
  String audioUrl;
}
```

#### Game Mechanics
- Classic memory card matching
- Track moves and time
- Progressive difficulty (more cards)
- Hint system for younger players
- Celebration animations

### 3. Spelling Bee
**Current Status**: UI placeholder only
**Location**: `lib/screens/games/games_hub_screen.dart` - Spelling Bee card

#### Implementation Requirements
```dart
class SpellingBeeGame {
  List<SpellingWord> words;
  int currentWordIndex;
  String userInput;
  int score;
  List<String> hints;
  
  void loadWord();
  void checkSpelling(String input);
  void provideHint();
  void nextWord();
  void calculateFinalScore();
}

class SpellingWord {
  String word;
  String pronunciation;
  String definition;
  String imageUrl;
  List<String> hints;
}
```

#### Game Mechanics
- Audio pronunciation of words
- Visual hints (images, definitions)
- Letter-by-letter feedback
- Progressive difficulty
- Score based on accuracy and speed

### 4. Quiz Time
**Current Status**: UI placeholder only
**Location**: `lib/screens/games/games_hub_screen.dart` - Quiz Time card

#### Implementation Requirements
```dart
class QuizGame {
  List<QuizQuestion> questions;
  int currentQuestion;
  int score;
  int timePerQuestion;
  
  void loadQuestion();
  void submitAnswer(String answer);
  void nextQuestion();
  void calculateScore();
  void showResults();
}

class QuizQuestion {
  String question;
  List<String> options;
  String correctAnswer;
  String explanation;
  String imageUrl;
  String audioUrl;
}
```

#### Game Mechanics
- Multiple choice questions
- Timer for each question
- Immediate feedback
- Progress tracking
- Difficulty adjustment

### 5. Picture Puzzle
**Current Status**: UI placeholder only
**Location**: `lib/screens/games/games_hub_screen.dart` - Picture Puzzle card

#### Implementation Requirements
```dart
class PicturePuzzleGame {
  String imageUrl;
  List<PuzzlePiece> pieces;
  List<int> correctOrder;
  int moves;
  
  void initializePuzzle();
  void swapPieces(int index1, int index2);
  void checkCompletion();
  void resetPuzzle();
}

class PuzzlePiece {
  String imagePath;
  int correctPosition;
  int currentPosition;
}
```

#### Game Mechanics
- Drag and drop puzzle pieces
- Image-based vocabulary learning
- Hint system (show correct position)
- Completion celebration
- Multiple difficulty levels (3x3, 4x4, 5x5)

### 6. Sound Match
**Current Status**: UI placeholder only
**Location**: `lib/screens/games/games_hub_screen.dart` - Sound Match card

#### Implementation Requirements
```dart
class SoundMatchGame {
  List<SoundItem> sounds;
  List<SoundItem> displayedItems;
  String playingSound;
  int score;
  
  void playSound(int index);
  void selectItem(int index);
  void checkMatch();
  void loadNewRound();
}

class SoundItem {
  String name;
  String audioUrl;
  String imageUrl;
  SoundCategory category;
}

enum SoundCategory {
  animals,
  instruments,
  vehicles,
  nature,
  household
}
```

#### Game Mechanics
- Audio-only identification
- Visual confirmation after selection
- Multiple sound categories
- Progressive difficulty
- Audio feedback system

## Implementation Priority

### Phase 1: Core Game Framework
1. Create base game classes
2. Implement common game mechanics
3. Add scoring system
4. Create game state management

### Phase 2: Individual Games
1. **Word Match** - Simplest to implement
2. **Memory Game** - Classic mechanics
3. **Quiz Time** - Multiple choice logic
4. **Spelling Bee** - Audio integration
5. **Picture Puzzle** - Drag and drop
6. **Sound Match** - Audio recognition

### Phase 3: Polish & Features
1. Add animations and effects
2. Implement hint systems
3. Add difficulty progression
4. Create achievement integration

## Files to Create/Modify

### New Game Files
```
lib/
├── games/
│   ├── word_match/
│   │   ├── word_match_game.dart
│   │   ├── word_match_screen.dart
│   │   └── word_match_controller.dart
│   ├── memory/
│   │   ├── memory_game.dart
│   │   ├── memory_screen.dart
│   │   └── memory_controller.dart
│   ├── spelling_bee/
│   │   ├── spelling_bee_game.dart
│   │   ├── spelling_bee_screen.dart
│   │   └── spelling_bee_controller.dart
│   ├── quiz/
│   │   ├── quiz_game.dart
│   │   ├── quiz_screen.dart
│   │   └── quiz_controller.dart
│   ├── puzzle/
│   │   ├── puzzle_game.dart
│   │   ├── puzzle_screen.dart
│   │   └── puzzle_controller.dart
│   └── sound_match/
│       ├── sound_match_game.dart
│       ├── sound_match_screen.dart
│       └── sound_match_controller.dart
├── models/
│   ├── game_models.dart
│   └── score_models.dart
└── services/
    ├── game_service.dart
    └── audio_service.dart
```

### Files to Modify
- `lib/screens/games/games_hub_screen.dart` - Connect to actual game screens
- `lib/screens/progress/progress_screen.dart` - Add game progress tracking

## Required Assets

### Audio Files
```
assets/audio/games/
├── word_match/
│   ├── match_success.mp3
│   ├── match_fail.mp3
│   └── words/
├── memory/
│   ├── flip.mp3
│   ├── match.mp3
│   └── complete.mp3
├── spelling_bee/
│   ├── correct.mp3
│   ├── incorrect.mp3
│   └── words/
├── quiz/
│   ├── correct.mp3
│   ├── incorrect.mp3
│   └── time_up.mp3
├── puzzle/
│   ├── piece_move.mp3
│   ├── piece_drop.mp3
│   └── puzzle_complete.mp3
└── sound_match/
    ├── play_sound.mp3
    ├── correct.mp3
    └── sounds/
```

### Image Assets
```
assets/images/games/
├── word_match/
│   ├── animals/
│   ├── objects/
│   └── colors/
├── memory/
│   ├── cards/
│   └── backs/
├── spelling_bee/
│   ├── word_images/
│   └── hints/
├── quiz/
│   ├── question_images/
│   └── options/
├── puzzle/
│   ├── puzzle_images/
│   └── pieces/
└── sound_match/
    ├── sound_images/
    └── categories/
```

## Success Metrics
- [ ] All 6 games have functional gameplay
- [ ] Scoring system works correctly
- [ ] Audio integration functions properly
- [ ] Games save and load progress
- [ ] Difficulty progression is implemented
- [ ] Games integrate with achievement system
- [ ] Performance is smooth on target devices
- [ ] Games are accessible to age 4-12 users
