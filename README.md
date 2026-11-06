# Veto

**The app that vetoes overtrading.**

Veto locks your selected trading apps until you complete the morning checklist and affirmation. After a loss or when you hit your max trades, it locks them again.

## Features (V1)
- Onboarding with rule setup and app selection
- Morning checklist + affirmation gate
- Lock state machine (Locked / Unlocked / Day Closed)
- Trade logging with result, hold/interfere tracking + persistence
- History and clean-day streak
- **Platform channel integrations**:
  - **Android**: Full Accessibility Service that sends blocked apps to home when locked
  - **iOS**: MethodChannel structure for Family Controls / ManagedSettings (requires entitlement; graceful fallback)

## UI
Vibrant dark theme with blue accents matching TradingView chart style (#0A0E17 background, #1E88E5 primary).

## Platform Blocker Details

### Android
1. User grants Accessibility permission (prompted during onboarding).
2. `VetoAccessibilityService` watches `TYPE_WINDOW_STATE_CHANGED`.
3. When locked and a selected package opens, it performs `GLOBAL_ACTION_HOME`.

### iOS
Family Controls entitlement is required for real app shielding. The channel is wired; without the entitlement the calls log and continue. Fallback is strong UI friction + notifications.

## Getting Started
```bash
flutter pub get
flutter run
```

On Android, after install go to Settings → Accessibility and enable Veto.

Built for traders who are good at analysis but struggle with stopping after a loss.
