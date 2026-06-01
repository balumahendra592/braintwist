# Brain Twist

A Brain Test-style tricky puzzle game built with Flutter. 75 offline brain teasers across 3 difficulty chapters, monetized with Google AdMob.

## Features

- 75 puzzles across 3 chapters (Easy / Getting Tricky / Mind Benders)
- 5 puzzle types: multiple choice, tap target, drag & drop, type answer, visual trick
- Fully offline — no internet required to play
- Hint system with coins (earn by playing or watching rewarded ads)
- Star ratings per level (3 stars = no hints used)
- Sound effects and Lottie win/lose animations
- AdMob banner, interstitial, and rewarded video ads

## Tech Stack

| Package | Version | Purpose |
|---------|---------|---------|
| Flutter | stable 3.29.2+ | UI framework |
| shared_preferences | ^2.2.3 | Offline storage |
| provider | ^6.1.2 | State management |
| google_mobile_ads | ^4.0.0 | AdMob ads |
| audioplayers | ^5.2.1 | Sound effects |
| lottie | ^3.1.0 | Win/lose animations |
| flutter_animate | ^4.5.0 | Screen transitions |

## Project Structure

```
lib/
  main.dart
  theme/app_theme.dart
  models/puzzle_model.dart
  data/puzzle_repository.dart         ← all 75 puzzles
  services/
    game_storage.dart                 ← SharedPreferences wrapper
    ad_manager.dart                   ← AdMob banner/interstitial/rewarded
    sound_service.dart                ← audio playback
  screens/
    splash_screen.dart
    home_screen.dart
    level_select_screen.dart
    game_screen.dart
    result_overlay.dart
    settings_screen.dart
  widgets/puzzle_widgets/
    multi_choice_puzzle.dart          ← 35 puzzles
    tap_target_puzzle.dart            ← 15 puzzles
    drag_drop_puzzle.dart             ← 10 puzzles
    type_answer_puzzle.dart           ← 10 puzzles
    visual_trick_puzzle.dart          ← 5 puzzles
assets/
  animations/win.json, lose.json
  sounds/correct.mp3, wrong.mp3, hint.mp3
  icon/app_icon.png
```

## Getting Started

```bash
flutter pub get
flutter run
```

## Build for Release

```bash
# Generate launcher icons (after placing app_icon.png in assets/icon/)
dart run flutter_launcher_icons

# Build Android App Bundle for Play Store
flutter build appbundle --release
```

## AdMob

Test IDs are active during development. Replace with real IDs before publishing:

| Ad Type | Test ID |
|---------|---------|
| Banner | `ca-app-pub-3940256099942544/6300978111` |
| Interstitial | `ca-app-pub-3940256099942544/1033173712` |
| Rewarded | `ca-app-pub-3940256099942544/5224354917` |

Real IDs go in `android/AndroidManifest.xml` (App ID) and `lib/services/ad_manager.dart` (unit IDs).

## Build Status

All 8 weeks of development are complete. See [BUILD_PROGRESS.md](BUILD_PROGRESS.md) for a full checklist and [PLAY_STORE_GUIDE.md](PLAY_STORE_GUIDE.md) for Play Store submission steps.

### Remaining manual steps before publishing

- [ ] Design app icon 512×512 PNG → `assets/icon/app_icon.png` → run `dart run flutter_launcher_icons`
- [ ] Generate release keystore (`keytool -genkey ...`)
- [ ] Create AdMob account → replace test IDs with real App ID and unit IDs
- [x] Package name set to `com.balumahendra592.braintwist` across all Android files
- [ ] Take 8 screenshots on device/emulator
- [x] Privacy policy hosted at: https://balumahendra592.github.io/braintwist/privacy_policy/
- [ ] Pay $25 Google Play developer fee (one-time)
- [ ] Upload AAB to Play Console
