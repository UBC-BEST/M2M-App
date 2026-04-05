# Pizza Game Input Migration

Target file in Unity repo:
- `Assets/Scripts/PizzaGame/InputHandler.cs`

## Replace serial + keyboard reads with adapter events

```csharp
using UnityEngine;

public class InputHandlerScript : MonoBehaviour
{
  [SerializeField] private GameEvent indexInput, middleInput, ringInput, pinkyInput;
  [SerializeField] private bool useLegacyKeyboardInEditor = true;
  private int inputTimeout = 0;

  private void Update()
  {
    if (TrySensorInput()) return;
    if (useLegacyKeyboardInEditor) KeyboardInput();
  }

  private bool TrySensorInput()
  {
    var adapter = SensorInputAdapter.Instance;
    if (adapter == null || !adapter.HasFrame) return false;
    var frame = adapter.LatestFrame;
    if (frame == null || frame.actions == null) return false;

    if (inputTimeout == 0 && frame.actions.tap)
    {
      TriggerLane(frame.actions.lane);
      inputTimeout = 10;
    }

    if (inputTimeout > 0) inputTimeout--;
    return true;
  }

  private void TriggerLane(string lane)
  {
    if (lane == "index") indexInput.TriggerEvent();
    else if (lane == "middle") middleInput.TriggerEvent();
    else if (lane == "ring") ringInput.TriggerEvent();
    else if (lane == "pinky") pinkyInput.TriggerEvent();
  }
}
```
