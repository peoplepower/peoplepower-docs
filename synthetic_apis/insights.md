# Synthetic API: Insights

Insights provide situational awareness and current predictions taking place in the home. The content captured in insights is intended to enable mobile applications to dynamically render useful information.

Insights are captured in a JSON dictionary structure where the key is a unique (predictable) **Insight ID**, and the JSON object underneath includes the value, a developer-readable description, an optional device ID, and the timestamp of the last update in milliseconds.

#### Standardized Insights

Insights are based on available data and not guaranteed to exist in the `insights` state variable.

| Insight ID              | Value Type | Description | 
| ----------------------- | ---------- | ----------- |
| `ambient_temperature_c` | float      | The ambient temperature in Celsius. The fastest update interval is once every 5 minutes. Motion sensors with temperature sensing capabilities will update this value based on where occupants were last observed. If no motion is detected recently, the value will fall back to a reading from a connected thermostat, if available. |
| `ambient_temperature.zscore` | float | Z-score of ambient temperature based on the previous 15-day hourly history. |
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
| `sleep.low_sleep_quality.warning` | int | Appears when there have been 4+ consecutive days of below-average sleep quality. The value is the number of consecutive days with low sleep quality. |
| `sleep.too_many_bathrooms.warning` | int | Appears when there have been 2+ consecutive days of too many bathroom visits at night. The value is the number of consecutive nights with a high number of bathroom visits. |
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
| `occupancy.last_seen` | None | The `title`, `description`, `device_id`, and `device_desc` describe where occupants were last seen. |

## Output

State Variable : `insights`

#### Insight Properties

| Property    | Description |
| ----------- | ----------- |
| value | The current value of this insight. |
| title | Human-readable title recommended for end-users. |
| description | Human-readable description for end-users. |
| icon | Optional recommended icon name, may be None / Null |
| icon_font | Optional icon font package, for example `far` means 'FontAwesome Regular', may be None / Null. |
| device_id | Optional field used to capture the device ID string of the device producing this insight, if applicable. |
| device_desc | Optional field used to capture the nickname of the device producing this insight, if applicable. |
| updated_ms | Timestamp of the last update to this insight, in unix epoch milliseconds. Can be used to render display information like "5 minutes ago", or simply see if this insight was updated. |

#### Insight JSON Content Example

```
{
  "device.low_battery.00155F00F861FCF5-03B7": {
    "description": "'Garage Back Door' has a low battery.",
    "device_desc": "Garage Back Door",
    "device_id": "00155F00F861FCF5-03B7",
    "icon": "battery-empty",
    "icon_font": "far",
    "title": "Low battery",
    "updated_ms": 1630956432881,
    "value": 1
  },
  "device.low_battery.FFFFFFFF006b34e8": {
    "description": "'Front Door' has a low battery.",
    "device_desc": "Front Door",
    "device_id": "FFFFFFFF006b34e8",
    "icon": "battery-empty",
    "icon_font": "far",
    "title": "Low battery",
    "updated_ms": 1630627884736,
    "value": 10
  },
  "device.low_signal.94f3b202008d1500": {
    "description": "Low wireless signal strength on 'TV'.",
    "device_desc": "TV",
    "device_id": "94f3b202008d1500",
    "icon": null,
    "icon_font": null,
    "title": "Low signal strength",
    "updated_ms": 1632351525676,
    "value": -89
  },
  "device.offline.00155F0074838333-0375": {
    "description": "Device 'Bathroom' is offline.",
    "device_desc": "Bathroom",
    "device_id": "00155F0074838333-0375",
    "icon": "unlink",
    "icon_font": "far",
    "title": "Device Offline",
    "updated_ms": 1629964522663,
    "value": true
  },
  "device.offline.020000013000042E": {
    "description": "'Smart Home Center Develco' is disconnected",
    "device_desc": "Smart Home Center Develco",
    "device_id": "020000013000042E",
    "icon": "unlink",
    "icon_font": "far",
    "title": "Disconnected",
    "updated_ms": 1632749668747,
    "value": true
  },
  "device.wall_powered.020000013000042E": {
    "description": "'Smart Home Center Develco' is on wall power",
    "device_desc": "Smart Home Center Develco",
    "device_id": "020000013000042E",
    "icon": "battery-bolt",
    "icon_font": "far",
    "title": "Wall Powered",
    "updated_ms": 1630020688468,
    "value": true
  },
  "occupancy.last_seen": {
    "description": "Last seen closing the 'Front Door'.",
    "device_desc": "Front Door",
    "device_id": "FFFFFFFF006b34e8",
    "icon": null,
    "icon_font": null,
    "title": "Last seen",
    "updated_ms": 1633445856657,
    "value": 0
  },
  "occupancy.return_ms": {
    "description": "Occupants are predicted to return around 8:42 PM on Monday.",
    "icon": "house-return",
    "icon_font": "far",
    "title": "Expected home later",
    "updated_ms": 1633405346951,
    "value": 1633432002178.5
  },
  "occupancy.status": {
    "description": "Appears to be away for a long time.",
    "icon": null,
    "icon_font": null,
    "title": "Vacation",
    "updated_ms": 1633527002299,
    "value": "VACATION"
  },
  "security_mode": {
    "description": "Security system is armed.",
    "icon": null,
    "icon_font": null,
    "title": "Armed",
    "updated_ms": 1633446324363,
    "value": "AWAY"
  },
  "sleep.bedtime_ms": {
    "description": "Appears to have gone to sleep around 11:31 PM on Monday.",
    "icon": null,
    "icon_font": null,
    "title": "Likely asleep",
    "updated_ms": 1633415519404,
    "value": 1633415519404
  },
  "sleep.bedtime_score": {
    "description": "15% bedtime consistency score.",
    "icon": null,
    "icon_font": null,
    "title": "Bedtime consistency",
    "updated_ms": 1633443242664,
    "value": 15.0
  },
  "sleep.duration_ms": {
    "description": "7.7 hours of sleep.",
    "icon": "alarm-clock",
    "icon_font": "far",
    "title": "Sleep Duration",
    "updated_ms": 1633443242664,
    "value": 27723260
  },
  "sleep.restlessness_score": {
    "description": "23% restlessness score while sleeping.",
    "icon": null,
    "icon_font": null,
    "title": "Restlessness",
    "updated_ms": 1633443242664,
    "value": 23.0
  },
  "sleep.sleep_prediction_ms": {
    "description": "Expected to go to sleep tonight around 11:24 PM.",
    "icon": "bed",
    "icon_font": "far",
    "title": "Predicted Bedtime",
    "updated_ms": 1633550600399,
    "value": 1633587840000
  },
  "sleep.sleep_score": {
    "description": "46% sleep score.",
    "icon": null,
    "icon_font": null,
    "title": "Sleep score",
    "updated_ms": 1633443242664,
    "value": 46.0
  },
  "sleep.wakeup_ms": {
    "description": "Woke up around 7:14 AM on Tuesday.",
    "icon": null,
    "icon_font": null,
    "title": "Good morning",
    "updated_ms": 1633443242664,
    "value": 1633443242664
  },
  "sleep.wakeup_score": {
    "description": "14% wakeup consistency score.",
    "icon": null,
    "icon_font": null,
    "title": "Wakeup consistency",
    "updated_ms": 1633443242664,
    "value": 14.0
  }
}
```
