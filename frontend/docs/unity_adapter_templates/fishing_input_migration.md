# Fishing Game Input Migration

Target file in Unity repo:
- `Assets/FishingLineLogic.cs`

## Replace `Input.GetAxis("Vertical")` with sensor axis

```csharp
void Update()
{
  float verticalInput = 0f;
  var adapter = SensorInputAdapter.Instance;

  if (adapter != null && adapter.HasFrame)
  {
    verticalInput = adapter.GetVerticalAxis();
  }
  else
  {
    // Keep editor fallback
    verticalInput = Input.GetAxis("Vertical");
  }

  bottomPoint += new Vector3(0, verticalInput * moveSpeed * Time.deltaTime, 0);
  bottomPoint.y = Mathf.Clamp(bottomPoint.y, topPoint.y - maxDepth, topPoint.y);
  UpdateLine();
  fishingHook.position = bottomPoint;
}
```
