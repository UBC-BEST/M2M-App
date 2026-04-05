# Jumping Game Input Migration

Target file in Unity repo:
- `Assets/PlayerController.cs`

## Replace `Input.GetAxis("Horizontal")` with sensor axis

```csharp
void Update()
{
  float horizontal = 0f;
  var adapter = SensorInputAdapter.Instance;

  if (adapter != null && adapter.HasFrame)
  {
    horizontal = adapter.GetHorizontalAxis();
  }
  else
  {
    // Keep editor fallback
    horizontal = Input.GetAxis("Horizontal");
  }

  moveX = horizontal * moveSpeed;
  CheckDeathZone();
}
```
