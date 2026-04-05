# Flutter ↔ Unity Bridge Contract

## Transport
- Flutter sends messages with `postMessage("SensorInputAdapter", "OnSensorPayload", json)`.
- Flutter starts sessions with `postMessage("SensorInputAdapter", "OnSessionStart", json)`.
- Unity emits JSON back through `UnityMessageManager` using event keys.

## Session Start Payload
```json
{
  "event": "session_start",
  "game": "pizza|fishing|jumping",
  "scene": "PizzaGame|FishingGame|JumpingGame",
  "route": "/pizza|/fishing|/jumping",
  "bridgeVersion": 1
}
```

## Sensor Frame Payload
```json
{
  "bridgeVersion": 1,
  "game": "pizza|fishing|jumping",
  "ts": 1712000000000,
  "channels": {
    "raw": 0.41,
    "normalized": 0.57,
    "axis": 0.22,
    "grip": 0.57,
    "flexion": 0.57,
    "extension": 0.57,
    "rotation": 0.57
  },
  "actions": {
    "connected": true,
    "unityReady": true,
    "sensorPercent": 57.4,
    "tap": false,
    "lane": "index",
    "index": false,
    "middle": false,
    "ring": false,
    "pinky": false,
    "verticalAxis": 0.22,
    "reelUp": true,
    "reelDown": false,
    "horizontalAxis": -0.12,
    "moveLeft": false,
    "moveRight": true
  },
  "calib": {
    "center": 0.5,
    "min": 0.0,
    "max": 1.0,
    "deadZone": 0.08,
    "sensitivity": 1.0,
    "triggerThreshold": 0.7,
    "triggerCooldownMs": 180
  }
}
```

## Unity → Flutter Event Payload
```json
{ "event": "ready" }
{ "event": "score_update", "score": 120 }
{ "event": "game_over", "score": 180, "durationMs": 95231 }
{ "event": "error", "message": "Input adapter not initialized" }
```

## Backward Compatibility
- Always include `bridgeVersion`.
- Ignore unknown fields in both directions.
- Add new fields without removing existing keys in v1.
