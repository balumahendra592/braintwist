# Brain Twist — Build Progress

## Week 1–2: Core Engine ✅ DONE
- [x] `lib/models/puzzle_model.dart` — Puzzle class + PuzzleType enum
- [x] `lib/data/puzzle_repository.dart` — 25 easy puzzles
- [x] `lib/services/game_storage.dart` — SharedPreferences storage
- [x] `lib/theme/app_theme.dart` — Colors, fonts, button styles
- [x] `lib/main.dart` — App entry, portrait lock, GameStorage.init()

## Week 3–4: Screens ✅ DONE
- [x] `lib/screens/splash_screen.dart`
- [x] `lib/screens/home_screen.dart`
- [x] `lib/screens/level_select_screen.dart`
- [x] `lib/screens/game_screen.dart`
- [x] `lib/screens/result_overlay.dart`
- [x] `lib/screens/settings_screen.dart`

### Puzzle Widgets
- [x] `lib/widgets/puzzle_widgets/multi_choice_puzzle.dart`
- [x] `lib/widgets/puzzle_widgets/tap_target_puzzle.dart`
- [x] `lib/widgets/puzzle_widgets/drag_drop_puzzle.dart`
- [x] `lib/widgets/puzzle_widgets/type_answer_puzzle.dart`
- [x] `lib/widgets/puzzle_widgets/visual_trick_puzzle.dart`


## Week 5: Puzzles + AdMob ✅ DONE
- [x] 25 medium puzzles (levels 26–50) in puzzle_repository.dart
- [x] 25 hard puzzles (levels 51–75) in puzzle_repository.dart
- [x] `lib/services/ad_manager.dart`
- [x] Banner ad on Game screen (bottom)
- [x] Interstitial every 3 levels (triggered from ResultOverlay)
- [x] Rewarded video on Hint button + Result overlay "Watch Ad" button

## Week 6: Polish ✅ DONE
- [x] `assets/animations/win.json` + `lose.json` (Lottie — placeholder JSON, replace with real from lottiefiles.com)
- [x] `assets/sounds/correct.mp3`, `wrong.mp3`, `hint.mp3` (placeholder files, replace with real audio)
- [x] `lib/services/sound_service.dart` — sound effects wired in game_screen.dart (correct/wrong/hint)
- [x] Lottie win animation in result_overlay.dart (graceful fallback emoji if asset fails)
- [x] Bug pass — fixed dead _coinNotifier, removed typo splash_scree.dart, 0 analyzer issues

## Week 7–8: Play Store ✅ DONE (code side)
- [x] `AndroidManifest.xml` — internet permission + AdMob App ID + app label "Brain Twist"
- [x] `android/app/build.gradle.kts` — applicationId, targetSdk 35, minSdk 21, release signing via env vars, ProGuard enabled
- [x] `android/app/proguard-rules.pro` — keep rules for Flutter, AdMob, Kotlin
- [x] `pubspec.yaml` — flutter_launcher_icons added, description updated
- [x] `.gitignore` — keystore + local.properties protected
- [x] `PLAY_STORE_GUIDE.md` — full step-by-step launch guide

### Still needs YOU to do (cannot be automated):
- [ ] Design app icon 512×512 PNG → save to `assets/icon/app_icon.png`, run `dart run flutter_launcher_icons`
- [ ] Generate release keystore (`keytool -genkey ...`)
- [ ] Create AdMob account → get real App ID + unit IDs → replace in AndroidManifest + ad_manager.dart
- [ ] Change applicationId from `com.example.brain_twist` to your own
- [ ] Take 8 screenshots on device/emulator
- [ ] Create privacy policy (privacypolicygenerator.info) + host on GitHub Pages
- [ ] Pay $25 Google developer fee (one-time)
- [ ] `flutter build appbundle --release` → upload AAB to Play Console

---
_Last updated: Week 7-8 complete — all code done, 0 analyzer issues. See PLAY_STORE_GUIDE.md for launch steps._
