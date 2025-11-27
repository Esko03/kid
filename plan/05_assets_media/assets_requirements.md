# Assets & Media Requirements

## Overview
The Foxy Kids app requires extensive audio, visual, and animation assets to provide a rich learning experience. Currently, most assets are missing or commented out in the pubspec.yaml.

## Current Status
- **Images**: ❌ Missing (Only placeholder icons)
- **Audio**: ❌ Missing (Audio players configured but no files)
- **Animations**: ❌ Missing (Lottie configured but no animations)
- **Fonts**: ❌ Missing (Commented out in pubspec.yaml)

## Required Asset Structure

### 1. Audio Assets

#### Pronunciation Audio Files
```
assets/audio/pronunciation/
├── animals/
│   ├── dog.mp3
│   ├── cat.mp3
│   ├── bird.mp3
│   ├── fish.mp3
│   ├── cow.mp3
│   ├── pig.mp3
│   ├── horse.mp3
│   ├── sheep.mp3
│   ├── duck.mp3
│   ├── chicken.mp3
│   └── ...
├── objects/
│   ├── book.mp3
│   ├── ball.mp3
│   ├── car.mp3
│   ├── house.mp3
│   ├── tree.mp3
│   ├── sun.mp3
│   ├── moon.mp3
│   ├── star.mp3
│   ├── flower.mp3
│   └── ...
├── colors/
│   ├── red.mp3
│   ├── blue.mp3
│   ├── green.mp3
│   ├── yellow.mp3
│   ├── orange.mp3
│   ├── purple.mp3
│   ├── pink.mp3
│   ├── brown.mp3
│   ├── black.mp3
│   └── white.mp3
├── numbers/
│   ├── one.mp3
│   ├── two.mp3
│   ├── three.mp3
│   ├── four.mp3
│   ├── five.mp3
│   ├── six.mp3
│   ├── seven.mp3
│   ├── eight.mp3
│   ├── nine.mp3
│   └── ten.mp3
├── alphabet/
│   ├── a.mp3
│   ├── b.mp3
│   ├── c.mp3
│   └── ... (all 26 letters)
└── phrases/
    ├── hello.mp3
    ├── goodbye.mp3
    ├── please.mp3
    ├── thank_you.mp3
    ├── sorry.mp3
    └── ...
```

#### Background Music
```
assets/audio/music/
├── main_theme.mp3
├── learning_ambient.mp3
├── game_theme.mp3
├── celebration.mp3
└── relaxation.mp3
```

#### Sound Effects
```
assets/audio/effects/
├── ui/
│   ├── button_click.mp3
│   ├── button_hover.mp3
│   ├── menu_open.mp3
│   ├── menu_close.mp3
│   └── notification.mp3
├── learning/
│   ├── correct_answer.mp3
│   ├── incorrect_answer.mp3
│   ├── lesson_complete.mp3
│   ├── star_earned.mp3
│   └── achievement.mp3
├── games/
│   ├── card_flip.mp3
│   ├── match_success.mp3
│   ├── match_fail.mp3
│   ├── game_complete.mp3
│   └── high_score.mp3
└── mascot/
    ├── foxy_greeting.mp3
    ├── foxy_encouraging.mp3
    ├── foxy_celebrating.mp3
    └── foxy_thinking.mp3
```

### 2. Image Assets

#### Learning Content Images
```
assets/images/lessons/
├── animals/
│   ├── dog.png
│   ├── cat.png
│   ├── bird.png
│   ├── fish.png
│   ├── cow.png
│   ├── pig.png
│   ├── horse.png
│   ├── sheep.png
│   ├── duck.png
│   ├── chicken.png
│   ├── elephant.png
│   ├── lion.png
│   ├── tiger.png
│   ├── bear.png
│   └── ...
├── objects/
│   ├── book.png
│   ├── ball.png
│   ├── car.png
│   ├── house.png
│   ├── tree.png
│   ├── sun.png
│   ├── moon.png
│   ├── star.png
│   ├── flower.png
│   ├── apple.png
│   ├── banana.png
│   ├── chair.png
│   ├── table.png
│   └── ...
├── colors/
│   ├── red_swatch.png
│   ├── blue_swatch.png
│   ├── green_swatch.png
│   ├── yellow_swatch.png
│   ├── orange_swatch.png
│   ├── purple_swatch.png
│   ├── pink_swatch.png
│   ├── brown_swatch.png
│   ├── black_swatch.png
│   └── white_swatch.png
└── numbers/
    ├── 1.png
    ├── 2.png
    ├── 3.png
    ├── 4.png
    ├── 5.png
    ├── 6.png
    ├── 7.png
    ├── 8.png
    ├── 9.png
    └── 10.png
```

#### Game Assets
```
assets/images/games/
├── word_match/
│   ├── card_back.png
│   ├── card_front.png
│   └── game_background.png
├── memory/
│   ├── card_back.png
│   ├── card_front.png
│   └── memory_board.png
├── spelling_bee/
│   ├── bee_character.png
│   ├── hive_background.png
│   └── letter_tiles.png
├── quiz/
│   ├── question_mark.png
│   ├── timer_icon.png
│   └── quiz_background.png
├── puzzle/
│   ├── puzzle_pieces/
│   └── puzzle_background.png
└── sound_match/
    ├── speaker_icon.png
    ├── sound_waves.png
    └── match_background.png
```

#### UI Assets
```
assets/images/ui/
├── mascot/
│   ├── foxy_idle.png
│   ├── foxy_waving.png
│   ├── foxy_celebrating.png
│   ├── foxy_thinking.png
│   ├── foxy_encouraging.png
│   └── foxy_speech_bubble.png
├── icons/
│   ├── star_empty.png
│   ├── star_filled.png
│   ├── heart_empty.png
│   ├── heart_filled.png
│   ├── trophy.png
│   ├── medal.png
│   ├── badge.png
│   └── certificate.png
├── backgrounds/
│   ├── gradient_bg.png
│   ├── learning_bg.png
│   ├── game_bg.png
│   └── celebration_bg.png
└── buttons/
    ├── play_button.png
    ├── pause_button.png
    ├── next_button.png
    ├── back_button.png
    └── close_button.png
```

#### Achievement & Progress Assets
```
assets/images/achievements/
├── badges/
│   ├── first_lesson.png
│   ├── week_streak.png
│   ├── month_streak.png
│   ├── vocabulary_master.png
│   ├── spelling_champ.png
│   ├── memory_wizard.png
│   ├── puzzle_solver.png
│   └── sound_expert.png
├── certificates/
│   ├── level_complete.png
│   ├── course_complete.png
│   └── achievement_cert.png
└── progress/
    ├── progress_bar.png
    ├── level_indicator.png
    └── streak_icon.png
```

### 3. Animation Assets

#### Lottie Animations
```
assets/animations/lottie/
├── mascot/
│   ├── foxy_wave.json
│   ├── foxy_celebration.json
│   ├── foxy_thinking.json
│   ├── foxy_encouraging.json
│   ├── foxy_sleeping.json
│   └── foxy_dancing.json
├── learning/
│   ├── star_sparkle.json
│   ├── lesson_complete.json
│   ├── achievement_unlock.json
│   ├── progress_fill.json
│   └── streak_fire.json
├── games/
│   ├── card_flip.json
│   ├── match_success.json
│   ├── game_complete.json
│   ├── high_score.json
│   └── puzzle_solve.json
└── ui/
    ├── button_press.json
    ├── loading_spinner.json
    ├── success_check.json
    └── error_animation.json
```

### 4. Font Assets

#### Custom Fonts
```
assets/fonts/
├── Nunito/
│   ├── Nunito-Regular.ttf
│   ├── Nunito-Bold.ttf
│   ├── Nunito-SemiBold.ttf
│   ├── Nunito-Light.ttf
│   └── Nunito-ExtraBold.ttf
└── Comic/
    ├── Comic-Sans-Regular.ttf
    └── Comic-Sans-Bold.ttf
```

## Asset Specifications

### Audio Specifications
- **Format**: MP3 (compressed) or WAV (uncompressed)
- **Sample Rate**: 44.1 kHz
- **Bit Depth**: 16-bit
- **Channels**: Mono (for pronunciation), Stereo (for music)
- **Duration**: 
  - Pronunciation: 1-3 seconds per word
  - Music: 30-60 seconds loops
  - Effects: 0.5-2 seconds

### Image Specifications
- **Format**: PNG (with transparency) or WebP (optimized)
- **Resolution**: 
  - Learning images: 512x512px minimum
  - UI icons: 256x256px minimum
  - Backgrounds: 1920x1080px (scalable)
- **Color Space**: sRGB
- **Compression**: Optimized for mobile

### Animation Specifications
- **Format**: JSON (Lottie)
- **Duration**: 1-5 seconds loops
- **Frame Rate**: 30-60 FPS
- **Size**: Optimized for mobile performance
- **Color**: Consistent with app theme

## Asset Creation Guidelines

### 1. Audio Guidelines
- Use native English speakers for pronunciation
- Consistent volume levels across all audio
- Clear, slow pronunciation for children
- Background music should be non-distracting
- Sound effects should be pleasant and encouraging

### 2. Image Guidelines
- Bright, colorful, child-friendly designs
- Consistent art style across all images
- High contrast for visibility
- Simple, recognizable objects
- Avoid scary or inappropriate content

### 3. Animation Guidelines
- Smooth, fluid animations
- Consistent with mascot personality
- Positive, encouraging themes
- Optimized for performance
- Accessible to all users

## Implementation Priority

### Phase 1: Essential Assets
1. Basic pronunciation audio (100 most common words)
2. Core learning images (animals, colors, numbers)
3. Basic UI icons and mascot assets
4. Essential sound effects

### Phase 2: Enhanced Content
1. Extended vocabulary audio
2. Game-specific assets
3. Achievement badges
4. Background music

### Phase 3: Polish & Variety
1. Advanced animations
2. Seasonal/holiday assets
3. Multiple difficulty levels
4. Accessibility assets

## Asset Management

### File Organization
- Use descriptive, consistent naming conventions
- Group by category and functionality
- Maintain version control for asset updates
- Optimize file sizes for mobile distribution

### Performance Considerations
- Lazy load large assets
- Cache frequently used assets
- Compress without quality loss
- Use appropriate formats for each asset type

### Localization Support
- Separate folders for each language
- Consistent naming across languages
- Cultural appropriateness considerations
- Regional pronunciation variations

## Success Metrics
- [ ] All essential learning content has audio pronunciation
- [ ] Visual assets are consistent and child-friendly
- [ ] Animations enhance user experience without performance issues
- [ ] Assets load quickly on target devices
- [ ] Audio quality is clear and appropriate for children
- [ ] All UI elements have proper visual assets
- [ ] Game assets support all planned game mechanics
- [ ] Achievement system has complete visual feedback
