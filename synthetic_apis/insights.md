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
| `sleep.bedtime_ms` | int | Bedtime in unix epoch milliseconds. |
| `sleep.wakeup_ms` | int | Wakeup time in unix epoch milliseconds. |
| `sleep.overslept` | True | Appears when occupants overslept today relative to historic patterns. |
| `sleep.underslept` | True | Appears when occupants woke up too early today relative to historic patterns. |
| `sleep.low_sleep_quality.days` | int | Number of days that occupants have experienced a low sleep quality. |
| `sleep.low_sleep_quality.warning` | True | Appears when there have been 4+ consecutive days of below-average sleep quality. |
| `sleep.too_many_bathrooms.days` | int | Number of days that occupants have visited the bathroom 'too many times' at night. |
| `sleep.too_many_bathrooms.warning` | True | Appears when there have been 2+ consecutive days of too many bathroom visits at night. |
| `bathroom_visits.high` | int | Abnormally high number of bathroom visits. The value is the total number of visits. |
| `bathroom_visits.low` | int | Abnormally low number of bathroom visits. The value is the total number of visits. |
| `device.blindspot.{device_id}` | True | Appears when there is a blind spot identified near a sensor with this device ID. Indicates a missing entry or motion sensor nearby. |
| `device.alwaysopen.{device_id}` | True | Appears when the entry sensor with this device ID appears to be always open, and therefore broken (magnet fell off, door is always open, etc.). |
| `device.name_behavior_mismatched.{device_id}` | True | Appears when the descriptive name of the device does not match the behavior selected for that device. For example, an entry sensor with a behavior for a perimeter door named 'Medicine Cabinet'. |
| `device.wall_powered.{device_id}` | True | Appears when the gateway is on wall power. |
| `device.battery_powered.{device_id}` | True | Appears when the gateway with the given device ID is being powered by battery. |
| `device.cellular.{device_id}` | True | Appears when the gateway with the given device ID is connected to cellular. |
| `device.broadband.{device_id}` | True | Appears when the gateway with the given device ID is connected to broadband internet (WiFi/Ethernet). |
| `device.offline.{device_id}` | True | The device with the given ID is offline. |
| `device.low_battery.{device_id}` | int | This device has a low battery. The value is the current battery level from 0-100%. |
| `device.low_signal.{device_id}` | float | This device appears to have a low wireless signal strength. The value is the average RSSI (receive signal strength indicator). |
| `security_mode` | String | Mode of the system - HOME (disarmed); AWAY (fully armed); STAY (perimeter armed); TEST (test mode). |
| `occupancy.status` | String | Occupancy status - PRESENT; ABSENT; SLEEP; VACATION; H2A (going away); A2H (expected home soon); H2S (going to sleep soon); S2H (waking up soon). | 
| `occupancy.return_ms` | int | Approximate time in unix epoch ms occupants are expected to return. This could be in the past if occupants were expected home earlier. | 
| `occupancy.last_seen` | String | Description of where occupants were last seen. Note the `device_id` and `device_desc` fields will provide extra details about the sensors that last observed activity. |

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
