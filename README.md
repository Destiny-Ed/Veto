# Veto

**The app that vetoes overtrading.**

Veto locks your selected trading apps until you complete the morning checklist and affirmation. After a loss or when you hit your max trades, it locks them again.

## Features (V1)
- Onboarding with rule setup and app selection
- Morning checklist + affirmation gate
- Lock state machine (Locked / Unlocked / Day Closed)
- Trade logging with result, hold/interfere tracking
- History and clean-day streak
- Platform channel ready for Android Accessibility Service and iOS Family Controls / Screen Time blocker

## UI
Vibrant dark theme with blue accents matching TradingView chart style (#0A0E17 background, #1E88E5 primary).

## Platform Blocker
- **Android**: Accessibility Service (to be implemented in native code) to detect and close/overlay selected packages when locked.
- **iOS**: Family Controls + ManagedSettings via platform channel. Requires Family Controls entitlement (restricted; fallback to friction UI if denied).

## Getting Started
```bash
flutter pub get
flutter run
```

Built for traders who are good at analysis but struggle with stopping after a loss.
