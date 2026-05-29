# Brain Twist — Flutter Game

## Project Summary
Brain Test-style tricky puzzle game. 75 offline puzzles across 3 chapters. Monetized via Google AdMob.

## Working Directory
`/home/dev13/Downloads/persona;/brain_twist`

## Tech Stack
- Flutter stable 3.29.2+ / Dart >=3.0.0
- `shared_preferences` — offline storage
- `provider` — state management
- `google_mobile_ads` — AdMob
- `audioplayers` — sound effects
- `lottie` — win/lose animations
- `flutter_animate` — transitions

## Folder Structure
```
lib/
  main.dart
  theme/app_theme.dart
  models/puzzle_model.dart
  data/puzzle_repository.dart
  services/
    game_storage.dart
    ad_manager.dart          ← TODO
  screens/
    splash_screen.dart       ← TODO
    home_screen.dart         ← TODO
    level_select_screen.dart ← TODO
    game_screen.dart         ← TODO
    result_overlay.dart      ← TODO
    settings_screen.dart     ← TODO
  widgets/puzzle_widgets/
    multi_choice_puzzle.dart  ← TODO
    tap_target_puzzle.dart    ← TODO
    drag_drop_puzzle.dart     ← TODO
    type_answer_puzzle.dart   ← TODO
    visual_trick_puzzle.dart  ← TODO
assets/
  animations/win.json, lose.json
  sounds/correct.mp3, wrong.mp3, hint.mp3
```

## Key Rules
- Portrait-only (locked in main.dart)
- All data via GameStorage (SharedPreferences) — no database
- Use test AdMob IDs during dev, swap real IDs before Play Store upload
- Font: Nunito (AppTheme.theme)
- Primary color: #7C3AED (purple)

## Puzzle Types
| Type | Count | Widget |
|------|-------|--------|
| multiChoice | 35 | MultiChoicePuzzle |
| tapTarget | 15 | TapTargetPuzzle |
| dragDrop | 10 | DragDropPuzzle |
| typeAnswer | 10 | TypeAnswerPuzzle |
| visualTrick | 5 | VisualTrickPuzzle |

## AdMob Test IDs
- Banner: `ca-app-pub-3940256099942544/6300978111`
- Interstitial: `ca-app-pub-3940256099942544/1033173712`
- Rewarded: `ca-app-pub-3940256099942544/5224354917`

## Build Commands
```bash
flutter pub get
flutter run
flutter build appbundle   # for Play Store
```
