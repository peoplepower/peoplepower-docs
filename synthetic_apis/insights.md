# Synthetic API: Insights

Insights provide situational awareness and current predictions taking place in the home. The content captured in insights is intended to enable mobile applications to dynamically render useful information.

Insights are captured in a JSON dictionary structure where the key is a unique (predictable) **Insight ID**, and the JSON object underneath includes the value, a developer-readable description, an optional device ID, and the timestamp of the last update in milliseconds.

#### Standardized Insights

Insights are based on available data and not guaranteed to exist in the `insights` state variable.

| Insight ID              | Value Type | Description | 
| ----------------------- | ---------- | ----------- |
| `ambient_temperature_c` | float      | The ambient temperature in Celsius. The fastest update interval is once every 5 minutes. Motion sensors with temperature sensing capabilities will update this value based on where occupants were last observed. If no motion is detected recently, the value will fall back to a reading from a connected thermostat, if available. |
| `sleep.wake_prediction_ms` | int | Predicted wake-up time in unix epoch milliseconds. Could be in the past if occupants have not woken up yet. |
| `sleep.sleep_prediction_ms` | int | Predicted go-to-sleep time in unix epoch milliseconds. Could be in the past if occupants have not gone to sleep yet. | 
| `sleep.duration_ms` | int | Recent sleep duration in milliseconds - gets erased when we're starting to go to sleep again. |
| `sleep.sleep_score` | float | Relative sleep score. Deleted when occupants start sleeping. |
| `sleep.bedtime_score` | float | Consistency of bedtime, a component of the sleep score. A low value indicates the occupants should try to go to bed at a more consistent time. Deleted when occupants start sleeping. |
| `sleep.wakeup_score` | float | Consistency of wake-up time, a component of the sleep score. A low value indicates the occupants should try to wake up at a more consistent time. Deleted when occupants start sleeping. |
| `security_mode` | String | Mode of the system - HOME (disarmed); AWAY (fully armed); STAY (perimeter armed); TEST (test mode). |
| `occupancy_status` | String | Occupancy status - PRESENT; ABSENT; SLEEP; VACATION; H2A (going away); A2H (expected home soon); H2S (going to sleep soon); S2H (waking up soon). | 
| `last_seen` | String | Description of where occupants were last seen. Note the `device_id` and `device_desc` fields will provide extra details about the sensors that last observed activity. |

## Output

State Variable : `insights`

#### Insight Properties

| Property    | Description |
| ----------- | ----------- |
| value | The current value of this insight |
| description | Human-readable description intended to help developers |
| device_id | Optional field used to capture the device ID string of the device producing this insight, if applicable. |
| device_desc | Optional field used to capture the nickname of the device producing this insight, if applicable. |
| updated_ms | Timestamp of the last update to this insight, in unix epoch milliseconds. Can be used to render display information like "5 minutes ago", or simply see if this insight was updated. |

#### Insight JSON Content Example

```
{
  "value": {
    "ambient_temperature_c": {
      "description": "Ambient temperature in Celsius",
      "device_id": "0015BC001A016275",
      "device_desc": "Office Motion Sensor",
      "updated_ms": 1625274850077,
      "value": 24.4
    }
  }
}
```