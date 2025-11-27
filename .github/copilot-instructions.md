# Foxy Kids - AI Coding Agent Instructions

**Foxy Kids**: Flutter kids' English app (4-12), ~30% complete. UI/navigation done. Missing: game logic, data persistence, audio.

## Quick Reference: Core UI System

### Mandatory Widgets
- **`GlassCard`** – ALL main content must wrap in this (frosted glass + backdrop blur)
- **`PrimaryButton`** – Only button type for user actions (orange gradient, 56px height)
- **`FoxyMascot`** – Animated fox with 6 states: `idle`, `waving`, `celebrating`, `thinking`, `encouraging`, `pointing`
- **`BottomNavBar`** – 5-item nav (Home, Learn, Play/Games, Progress, Profile); manages `_currentIndex` in `HomeScreen`

### Design Constants (`lib/utils/app_colors.dart`)
- **Colors**: `primaryOrange` (#EE6402), `warmCream` (#FDECB3), `darkBrown` (#531901), `richBrownBlack` (#2E1B0B)
- **Glassmorphism**: `glassWhite` (white 15% opacity), `glassBorder` (white 25%), blur=20px
- **Spacing**: 16px base unit, 24px border radius, 56px min touch target

### Navigation Pattern
- **Entry**: `main.dart` → `SplashScreen` (2s delay) → onboarding or `HomeScreen`
- **Routing**: Use `Navigator.of(context).push()` with `MaterialPageRoute` for screen transitions
- **State**: `HomeScreen` is `StatefulWidget` managing nav index; passes to `BottomNavBar.onTap`
- **Onboarding**: `WelcomeScreen` → `AgeSelectionScreen` → `ModeSelectionScreen` → `HomeScreen` (via `pushAndRemoveUntil`)

## Developer Commands
```bash
flutter run                    # Portrait-only dev build
dart format .                 # Auto-format all Dart files
flutter analyze              # Lint check
flutter test                 # Run test/ suite
```

## Code Patterns & Conventions

### File Organization
- **Screens**: Single file per screen (`lib/screens/{feature}/{feature}_screen.dart`)
- **Widgets**: Shared UI components in `lib/widgets/`; complex screens can have internal `_buildWidget()` methods
- **Examples**: `IndividualLessonScreen` (StatefulWidget, 500+ lines with internal helpers), `GamesHubScreen` (StatelessWidget)

### State Management & Routing
- **Current approach**: Mostly stateless + minimal state (e.g., `HomeScreen` tracks nav index)
- **Routing**: `Navigator.of(context).push(MaterialPageRoute(...))` for screens
- **Scaffolds**: Always apply gradient background + `SafeArea` wrapper in screens
- **Layouts**: Prefer `CustomScrollView` with `SliverToBoxAdapter` for flexible layouts

### Style Checklist
✅ **Always**: const constructors, trailing commas, Material 3, `flutter_animate` for UI transitions  
✅ **In screens**: Gradient backgrounds, `SafeArea`, `GlassCard` for content, `FoxyMascot` for guidance  
❌ **Never**: Material buttons (use `PrimaryButton`), flat containers (use `GlassCard`), manual animation controllers (use `flutter_animate`)

## Placeholder Code Reference (`plan/02_placeholder_code/`)

When implementing features, target these empty handlers:
- **Games**: All 6 game cards (`games_hub_screen.dart:124`) have `onTap: () {}` – add game navigation + logic
- **Lessons**: Pronunciation button (`individual_lesson_screen.dart:168`) needs audio playback; answer checking (line 402) is hardcoded
- **Settings**: Profile switches (`profile_screen.dart:102`) have empty `onChanged`; no persistence yet
- **Search**: Voice search (`search_explore_screen.dart:118`), filters (143, 161) are stubs
- **Parent Dashboard**: Time limits (parent_dashboard_screen.dart:183), report downloads (289) unimplemented

**Data sources**: All hardcoded (e.g., streak = '7', game scores static). Ready for database wiring.

## Database Models (See `plan/06_database_models/`)

**Current**: Fully stateless (all data hardcoded). When implementing persistence:
- **Stack**: SQLite + drift ORM (or sqflite + sembast as lighter alternative)
- **Models**: User (age/mode), Lesson (category/vocab/audio_path), Progress (completed/score/timestamp), Achievement (badge/unlock_date)
- **Pattern**: Create `lib/data/repositories/` with query logic, inject into screens
- **Enable assets** (pubspec.yaml): Uncomment image/animation/sound asset paths when adding media

## Dependencies Ready for Implementation

- **`google_fonts`**: Use `GoogleFonts.nunito()` everywhere (not TextStyle + fontFamily)
- **`flutter_animate`**: Preferred over manual AnimationControllers for UI feedback
- **`shared_preferences`**: For settings (currently unused—implement when needed)
- **`audioplayers`**: Audio ready; add pronunciation/SFX files to `assets/sounds/`
- **`confetti`**, **`flutter_svg`**, **`lottie`**: Available for celebrations/graphics

## Anti-Patterns (Things NOT to Do)

❌ Never use Material buttons—use `PrimaryButton` every time  
❌ Never create flat containers—wrap in `GlassCard` for consistency  
❌ Never hardcode colors—reference `AppColors` constants  
❌ Never use custom animation logic—use `flutter_animate` package  
❌ Never forget `const` constructors where possible  
❌ Never skip `SafeArea` + gradient background in screens
