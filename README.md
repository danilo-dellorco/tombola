# Tombola Board

A Flutter app for projecting a tombola (Italian bingo) board on a screen or TV.
Numbers are marked as they are drawn, prizes (ambo, terna, quaterna, cinquina,
tombola and optional tombolino) are tracked, and each draw and win comes with animations and sound.

## Features

- Full 1–90 board
- Animated overlay for every drawn number
- Prize tracking with celebration animations and escalating sounds
- Configurable prizes and game settings, saved between sessions
- Fullscreen, landscape-first layout for projectors and TVs

## Platforms

Windows, Android, iOS, macOS, Linux and Web.

## Getting started

```bash
flutter pub get
flutter run -d windows   # or: chrome, android, macos, linux, ios
```

Release build, for example:

```bash
flutter build windows --release
```

## Project structure

```
lib/
  models/      game state, settings and prize models
  providers/   GameProvider (state management via provider)
  screens/     home, setup, settings and prize-rules screens
  widgets/     board, info panel and animation overlays
  utils/       theme and audio service
assets/
  audio/       number and prize sound effects (.mp3 / .ogg)
  icons/       app icon
```
