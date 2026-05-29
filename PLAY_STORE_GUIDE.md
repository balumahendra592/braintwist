# Brain Twist — Play Store Launch Guide

## Before You Build

### 1. Replace AdMob IDs
In `android/app/src/main/AndroidManifest.xml`:
```xml
android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"
```
In `lib/services/ad_manager.dart`, replace the three `_...IdTest` constants with your real AdMob unit IDs.

### 2. Change Application ID
In `android/app/build.gradle.kts`:
```kotlin
applicationId = "com.yourname.braintwist"  // must be unique on Play Store
namespace   = "com.yourname.braintwist"
```
In `android/app/src/main/AndroidManifest.xml` — update the package reference if any.

---

## App Icon (512×512 PNG required)

1. Design a 512×512 PNG with your brain/puzzle theme (purple #1B0A3A background, 🧠 emoji or custom brain)
2. Save as `assets/icon/app_icon.png`
3. Save a foreground-only version (transparent bg) as `assets/icon/app_icon_fg.png`
4. Run:
```bash
flutter pub get
dart run flutter_launcher_icons
```
This auto-generates all sizes for Android.

---

## Release Keystore (one-time setup)

```bash
# Generate a keystore — DO THIS ONCE and keep the file safe forever
keytool -genkey -v \
  -keystore ~/brain_twist_keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias brain_twist

# Set environment variables before building
export KEYSTORE_PATH=~/brain_twist_keystore.jks
export KEYSTORE_PASSWORD=your_store_password
export KEY_ALIAS=brain_twist
export KEY_PASSWORD=your_key_password
```

> ⚠️ NEVER commit the keystore file or passwords to git. Add `*.jks` to `.gitignore`.

---

## Build the App Bundle (AAB)

```bash
flutter pub get
flutter build appbundle --release
```

The output file is at:
```
build/app/outputs/bundle/release/app-release.aab
```
Upload **this file** (not the .apk) to Play Console.

---

## Play Store Listing Text

### App Name (max 30 chars)
```
Brain Twist: Tricky Puzzles
```

### Short Description (max 80 chars)
```
80 tricky brain puzzles to test your IQ — play offline for free!
```

### Full Description (max 4000 chars)
```
🧠 BRAIN TWIST — The Ultimate Tricky Puzzle Game!

Can you outsmart these mind-bending puzzles? Brain Twist challenges you with 75 brain teasers across 3 difficulty chapters — and the answers are never what you expect!

🌱 EASY WARM-UP (Levels 1–25)
Build your confidence with classic riddles and lateral thinking puzzles. Perfect for beginners and kids!

🔥 GETTING TRICKY (Levels 26–50)
Wordplay, visual tricks, and logic puzzles that make you question everything. This is where it gets fun!

💥 MIND BENDERS (Levels 51–75)
Only the sharpest minds can solve these. Challenge your friends and family — who can get through all 75?

✨ FEATURES
• 75 unique brain teasers — no two are alike
• 5 puzzle types: multiple choice, type the answer, tap the target, drag & drop, visual tricks
• Earn stars and coins on every level
• Use hint coins when you're truly stuck
• Watch rewarded ads for free extra coins
• 100% offline — no internet needed to play
• No registration, no account needed
• Completely free to play

🎯 WHY PLAYERS LOVE IT
The answers feel obvious once you see them — but you'll never guess them first try! These puzzles are perfect for sharing with friends and family. Warning: highly addictive!

📱 SUITABLE FOR ALL AGES
Age 8 and above. Clean content, no violence, no inappropriate material.

💰 FREE TO PLAY
Brain Twist is free with optional rewarded ads to earn hint coins. No pay-to-win, no forced purchases.
```

### Content Rating
Complete IARC questionnaire in Play Console → select **Everyone (3+)**

### Category
**Brain & Puzzle Games**

---

## Screenshots Required (8 minimum)

Use phone size 1080×1920. Capture these screens:
1. Home screen — show chapter cards
2. Level select — show the 75-level grid
3. Easy puzzle in progress — multiple choice
4. Hard puzzle — type answer type
5. Hint visible on screen
6. Result overlay — 3 stars earned
7. Settings screen
8. Another puzzle type (drag/drop or visual trick)

Use Android emulator or real phone:
```bash
flutter run
# Take screenshots via Android Studio or: adb exec-out screencap -p > screenshot.png
```

---

## Privacy Policy (REQUIRED for AdMob)

1. Go to https://www.privacypolicygenerator.info
2. App name: Brain Twist, Developer: your name
3. Check: Google AdMob, Analytics
4. Generate and copy the URL
5. Host on GitHub Pages (free):
   - Create repo `brain-twist-privacy`
   - Add `index.html` with the policy text
   - Enable GitHub Pages → your URL is `https://yourusername.github.io/brain-twist-privacy`
6. Add this URL in Play Console → App Content → Privacy Policy

---

## Play Console Submission Checklist

- [ ] Real AdMob App ID in AndroidManifest.xml
- [ ] Real ad unit IDs in ad_manager.dart
- [ ] Unique applicationId (not com.example...)
- [ ] App icon 512×512 PNG uploaded
- [ ] At least 8 screenshots uploaded
- [ ] Feature graphic 1024×500 PNG (optional but recommended)
- [ ] Short description filled
- [ ] Full description filled
- [ ] Privacy policy URL added
- [ ] Content rating completed (IARC)
- [ ] Target audience set (Everyone, age 8+)
- [ ] Data safety form completed (AdMob collects device identifiers)
- [ ] Release track selected (start with Internal Testing, then Production)
- [ ] AAB file uploaded (`flutter build appbundle`)
- [ ] $25 one-time developer fee paid (if first app)

---

## After Launch

- Reply to all reviews in first month (boosts ranking signals)
- Push v1.1 update within 4 weeks with 25 new puzzles
- Add "Share this puzzle" button in v1.1
- Add daily challenge in v1.2
