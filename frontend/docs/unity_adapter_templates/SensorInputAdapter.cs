using System;
using UnityEngine;

[Serializable]
public class SensorFrame
{
  public int bridgeVersion;
  public string game;
  public long ts;
  public Channels channels;
  public Actions actions;
}

[Serializable]
public class Channels
{
  public float raw;
  public float normalized;
  public float axis;
  public float grip;
  public float flexion;
  public float extension;
  public float rotation;
}

[Serializable]
public class Actions
{
  public bool connected;
  public bool unityReady;
  public float sensorPercent;
  public bool tap;
  public string lane;
  public bool index;
  public bool middle;
  public bool ring;
  public bool pinky;
  public float verticalAxis;
  public bool reelUp;
  public bool reelDown;
  public float horizontalAxis;
  public bool moveLeft;
  public bool moveRight;
}

public class SensorInputAdapter : MonoBehaviour
{
  public static SensorInputAdapter Instance { get; private set; }
  public SensorFrame LatestFrame { get; private set; }
  public bool HasFrame { get; private set; }

  private void Awake()
  {
    if (Instance == null)
    {
      Instance = this;
      DontDestroyOnLoad(gameObject);
    }
    else
    {
      Destroy(gameObject);
    }
  }

  private void Start()
  {
    EmitReady();
  }

  public void OnSessionStart(string payload)
  {
    Debug.Log($"SessionStart payload: {payload}");
  }

  public void OnSensorPayload(string payload)
  {
    try
    {
      LatestFrame = JsonUtility.FromJson<SensorFrame>(payload);
      HasFrame = LatestFrame != null;
    }
    catch (Exception error)
    {
      EmitError(error.Message);
    }
  }

  public float GetHorizontalAxis()
  {
    if (!HasFrame || LatestFrame.actions == null) return 0f;
    return LatestFrame.actions.horizontalAxis;
  }

  public float GetVerticalAxis()
  {
    if (!HasFrame || LatestFrame.actions == null) return 0f;
    return LatestFrame.actions.verticalAxis;
  }

  public bool GetTapAction()
  {
    if (!HasFrame || LatestFrame.actions == null) return false;
    return LatestFrame.actions.tap;
  }

  private void EmitReady()
  {
    var message = "{\"event\":\"ready\"}";
    Debug.Log(message);
  }

  private void EmitError(string message)
  {
    Debug.Log($"{{\"event\":\"error\",\"message\":\"{message}\"}}");
  }
}
