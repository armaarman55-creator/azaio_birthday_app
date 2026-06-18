# 🎂 Azaio Ihla Saige's Birthday App

A magical Flutter birthday app for Azaio's 4th birthday on **June 23rd, 2026**!

## ✨ Features

| Screen | What It Does |
|--------|-------------|
| 🌟 Splash Screen | Animated welcome with colour burst |
| 🏠 Home Screen | Live birthday countdown + magic cake |
| 🎂 Magic Cake | Tap it to cycle Bluey → Peppa → K-Pop themes + confetti |
| 📺 Show Selector | Switch between all 3 of Azaio's favourite shows |
| 🎵 Dance Party | Interactive dance mode with animated emojis |
| 🎨 Draw & Colour | Full finger-painting canvas with colours & brush sizes |
| 🧠 Fun Quiz | 5-question quiz about her favourite shows |
| 🐾 Fun Facts | Interesting facts about Bluey, Peppa & Demon Hunters |
| 💌 Birthday Messages | Flip-cards with secret birthday messages from characters |
| 🌠 Wish Maker | Tap to send a birthday wish to the stars |

## 🎨 Themes
- **Bluey** 🐕 — Sky blue palette, "Wackadoo!" energy
- **Peppa Pig** 🐷 — Coral pink palette, muddy puddles vibes
- **K-Pop Demon Hunters** ⭐ — Purple/gold palette, superstar energy

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+  →  https://flutter.dev/docs/get-started/install
- Dart SDK 3.0+
- Android Studio or Xcode (for device deployment)

### Install & Run

```bash
# 1. Navigate to project folder
cd azaio_birthday

# 2. Get dependencies
flutter pub get

# 3. Run on connected device or emulator
flutter run

# 4. Build APK for Android
flutter build apk --release

# 5. Build for iOS
flutter build ios --release
```

### Run on Android (APK)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
# Transfer APK to Android device and install
```

### Run on iPhone
```bash
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode
# Select your device and press Run
```

## 📦 Dependencies

```yaml
flutter_animate: ^4.5.0    # Smooth animations
confetti: ^0.7.0           # Birthday confetti explosions  
audioplayers: ^6.0.0       # Sound effects (optional)
shared_preferences: ^2.2.0 # Save birthday wishes
```

## 🗂️ File Structure

```
azaio_birthday/
├── lib/
│   ├── main.dart              # Main app + all screens
│   └── screens/               # (optional split-out)
├── assets/                    # Images & sounds
├── pubspec.yaml               # Dependencies
└── README.md                  # This file
```

## 🎁 Personalisation Tips

To customise for Azaio or another child:
1. Change the name `Azaio Ihla Saige` in `main.dart` (search & replace)
2. Change the birthday date: `DateTime(2026, 6, 23)`
3. Add/remove quiz questions in `_quizQuestions` list
4. Swap emoji themes to different shows

## 🛠️ Adding Sounds (Optional)

Place `.mp3` files in `assets/` and update `pubspec.yaml`:
```yaml
assets:
  - assets/bluey_theme.mp3
  - assets/peppa_theme.mp3
```

Then trigger them with `audioplayers`:
```dart
final player = AudioPlayer();
await player.play(AssetSource('bluey_theme.mp3'));
```

## 💜 Made with love for Azaio Ihla Saige — Happy 4th Birthday! 🎉
