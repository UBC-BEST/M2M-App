# Unity Embed Strategy

## Decision
- Embed Unity into the Flutter app using `flutter_unity_widget`.
- Target Android first for integration and stabilization.
- Bring iOS online after Android is validated end-to-end.

## Why this path
- The app already has a Flutter shell, BLE sensor pipeline, and game navigation.
- Unity-as-a-Library allows all games to run under a single app UX and session flow.
- Android-first lowers integration risk and gives faster feedback for sensor tuning.

## Runtime model
- Flutter owns BLE connection, calibration, and session lifecycle.
- Flutter sends normalized control payloads to Unity with `postMessage`.
- Unity sends events back (`ready`, `score_update`, `game_over`, `error`).
- Keyboard control remains available in Unity for editor/dev fallback only.

## Android-first rollout
1. Enable Unity embedding and game launcher in Flutter.
2. Implement shared Flutter-to-Unity message contract.
3. Validate Pizza game first.
4. Add Fishing and Jumping using the same adapter contract.
5. Add iOS integration once Android flow is stable.

## Constraints
- Keep bridge payload versioned (`bridgeVersion`) to avoid cross-repo drift.
- Preserve BLE disconnect handling in Flutter regardless of Unity state.
- Avoid game-specific transport logic in Flutter launch UI; keep it in a bridge service.
