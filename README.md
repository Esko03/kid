# Foxy Kids - English Learning App for Children

A fun and engaging Flutter application designed to help children aged 4-12 learn English through interactive lessons, games, and activities.

## Features

- **Glassmorphism Design**: Beautiful frosted glass UI with smooth animations
- **Animated Foxy Mascot**: Friendly fox character that guides children through their learning journey
- **Interactive Lessons**: Engaging learning modules covering alphabet, vocabulary, phrases, numbers, colors, and stories
- **Fun Games**: Educational games including word match, memory games, spelling bee, and more
- **Progress Tracking**: Visual progress indicators and achievement system to motivate learners
- **Kid-Friendly Interface**: Large touch targets, rounded corners, and child-appropriate design

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

### Dependencies

- `google_fonts`: Custom typography using Nunito font family
- `flutter_animate`: Smooth animations and transitions
- `shared_preferences`: Local data storage
- `audioplayers`: Sound effects and background music
- `confetti`: Celebration animations
- `flutter_svg`: SVG image support
- `lottie`: Advanced animations

## Project Structure

\`\`\`
lib/
├── main.dart                 # App entry point
├── utils/
│   ├── app_colors.dart      # Color palette
│   └── app_theme.dart       # Theme configuration
├── widgets/
│   ├── glass_card.dart      # Glassmorphism card widget
│   ├── primary_button.dart  # Custom button widget
│   ├── foxy_mascot.dart     # Animated mascot widget
│   └── bottom_nav_bar.dart  # Navigation bar
└── screens/
    ├── splash_screen.dart
    ├── onboarding/
    │   ├── welcome_screen.dart
    │   ├── age_selection_screen.dart
    │   └── mode_selection_screen.dart
    ├── home/
    │   └── home_screen.dart
    ├── lessons/
    │   └── lesson_category_screen.dart
    ├── games/
    │   └── games_hub_screen.dart
    ├── progress/
    │   └── progress_screen.dart
    └── profile/
        └── profile_screen.dart
\`\`\`

## Design System

### Colors
- Primary Orange: #EE6402
- Warm Cream: #FDECB3
- Dark Brown: #531901
- Rich Brown-Black: #2E1B0B

### Typography
- Font Family: Nunito
- Rounded, child-friendly letterforms
- Multiple weights for hierarchy

### Layout Principles
- 16px base spacing unit
- 24px border radius for glassmorphic cards
- Generous padding for touch-friendly interactions

## License

This project is licensed under the MIT License.
