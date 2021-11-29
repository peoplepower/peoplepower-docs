# Synthetic API: Vayyar Home

Vayyar Home can sense falls in real-time, and detect occupants in the room.

To use the device, we need to specify (a) the boundaries of the room, and (b) subregions within that room to ignore or detect special occupancy status (like a bed).

The device itself receives a behavior, using the standard `behaviors` state variable method. This gives context to the room the device is in.

Subregions require context, provided by the `vayyar_subregion_behaviors` state variable. Subregion descriptions will also describe what rooms they're compatible with (for example, you won't put a bed in the bathroom), the recommended size of that subregion (we know the size of a king size bed), and whether the subregion size is flexible. 

**Inputs:**
* [Set the Room Boundaries](#set-the-room-boundaries)
* [Set a Subregion](#set-a-subregion)
* [Delete a Subregion](#delete-a-subregion)

**Outputs:**
* [Get the Room Boundaries](#get-the-room-boundaries)
* [Get the Available Subregion Behaviors](#get-the-available-subregion-behaviors)


## Inputs

### Set the Room Boundaries

Data Stream Address : `set_vayyar_room`

#### Set Room Boundary Properties

| Property | Type | Description |
| -------- | ---- | ----------- |
| device_id | String | Device ID to apply these room boundaries to. |
| x_left_meters | Float | Looking into the room from the device, this is the distance from the center of the device to the left wall of the room in meters. This is a negative number, and if a positive number is given, then it will be turned into a negative number. Valid values range from `-2.0` to `0.0` |
| x_right_meters | Float | Looking into the room from the device, this is the distance from the center of the device to the right wall of the room in meters. This is a positive number, and if a negative number is given, then it will be turned into a positive number. Valid values range from `0.0` to `2.0` |
| y_max_meters | Float | Distance from the Vayyar Home to the opposite wall. Valid values range from `1.0` to `4.0` |
| mounting_type | int | 0 (default) = wall; 1 = ceiling |
| sensor_height_m | Float | 1.5 is the default for the wall; Ceiling-mounted devices require this to define the distance from the ceiling to the floor. |

#### Set Room Boundary Example

```
{
    "device_id": device_id,
    "x_left_meters": x_left_meters,
    "x_right_meters": x_right_meters,
    "y_max_meters": y_max_meters,
    "mounting_type": 0
}
```

### Set a Subregion

Data Stream Address : `set_vayyar_subregion`

Applications should ensure subregion width and height are greater then or equal to 0.5 meters.

#### Set Subregion Properties

| Property | Type | Description |
| -------- | ---- | ----------- |
| device_id | String | Device ID to apply this subregion to |
| unique_id | String | Some unique ID to add / edit / delete. If not defined, it will be assumed this is an add operation and will automatically generate a UUID4 unique ID for this new subregion. |
| subregion_id | int | Optional - used primarily for modifying or deleting and for backwards compatibility. |
| context_id | int | Context / behavior of this subregion - see the [Subregion Behavior Properties](#subregion-behavior-properties) |
| unique_id | String | UUID to uniquely identify this subregion, auto-defined by the bot. |
| name | String | Descriptive name of this subregion, default is the `title` of the subregion context that was selected. |
| x_min_meters | Float | Required. Looking into the room from the device, this is the left-most side of the sub-region. Remember to the left of Vayyar Home is negative numbers on the x-axis. |
| x_max_meters | Float | Required.Looking into the room from the device, this is the right-most side of the sub-region. |
| y_min_meters | Float | Required. Distance from the Vayyar Home to the nearest side of the sub-region. Valid values are greater than or equal to `0.3` |
| y_max_meters | Float | Required. Distance from the Vayyar Home to the farthest side of the sub-region. |
| z_min_meters | Float | Optional. For 3D subregions, this is the minimum z-axis boundary. |
| z_max_meters | Float | Optional. For 3D subregions, this is the maximum z-axis boundary. |
| detect_falls | Boolean | Optional. True to detect falls in this room, False to avoid detecting fall (default is True). |
| detect_presence | Boolean | Optional. True to detect people, False to not detect people (default is True). |
| enter_duration_s | int | Optional. Number of seconds to wait until Vayyar Home declares someone entered this sub-region (default is 3 seconds). |
| exit_duration_s | int | Optional. Number of seconds to wait until Vayyar Home declares the sub-region is unoccupied (default is 3 seconds). |

#### Set Subregion Example

```
{
    "device_id": device_id,
    "subregion_id": subregion_id,
    "name": descriptive_name,
    "x_min_meters": x_min_meters,
    "x_max_meters": x_max_meters,
    "y_min_meters": y_min_meters,
    "y_max_meters": y_max_meters,
    "z_min_meters": z_min_meters,
    "z_max_meters": z_max_meters,
    "detect_falls": detect_falls,
    "detect_presence": detect_presence,
    "enter_duration_s": enter_duration_s,
    "exit_duration_s": exit_duration_s,
    "context_id": context
}
```

### Delete a Subregion

Data Stream Address : `delete_vayyar_subregion`

Passing in a `unique_id` is preferred, but this Synthetic API will also accept a `subregion_id` for backwards compatibility reasons.

```
{
    "device_id": device_id,
    "unique_id": unique_id
}
```

```
{
    "device_id": device_id,
    "subregion_id": subregion_id
}
```

### Set Configuration

Data Stream Address : `set_vayyar_config`

```
# fall_sensitivity
FALL_SENSITIVITY_LOW = 1
FALL_SENSITIVITY_NORMAL = 2

# led_mode
LED_MODE_OFF = 0
LED_MODE_ON = 1

# telementry_policy
TELEMETRY_POLICY_OFF = 0
TELEMETRY_POLICY_ON = 1
TELEMETRY_POLICY_FALLS_ONLY = 2
```

#### `set_vayyar_config` Example

All fields are optional except for `device_id`.

```
{
    "device_id": "id_MzA6QUU6QTQ6TM6OEY6",
    "fall_sensitivity": FALL_SENSITIVITY_NORMAL,
    "alert_delay_s": 15,
    "led_mode": LED_MODE_ON,
    "volume": 100,
    "telemetry_policy": TELEMETRY_POLICY_FALLS_ONLY,
    "reporting_rate_ms": 10000,
    "silent_mode": False,
    "target_change_threshold_m": 0.2
}
```


## Outputs

### Get the room boundaries

State Variable : `vayyar_room`

#### `vayyar_room` Example

```
{
    "device_id": {
        "mounting_type": 0,
        "sensor_height_m": 1.5,
        "x_min": x_min,
        "x_max": x_max,
        "y_min": y_min,
        "y_max": y_max,
        "z_min": z_min,
        "z_max": z_max,
        "update_ms": update_ms
    },
    ...
}
```

### Get the defined subregions

State Variable : `vayyar_subregions`

#### `vayyar_subregions` Example

```
{
  "value": {
    "id_MzA6QUU6QTQ6RTI": [
      {
        "context_id": 11,
        "unique_id": "d19978fe-606a-4ebf-8c51-b573b6ed0a23",
        "detect_falls": true,
        "detect_presence": true,
        "enter_duration_s": 3,
        "exit_duration_s": 3,
        "name": "Bathtub / Shower",
        "subregion_id": 0,
        "x_max_meters": -0.5,
        "x_min_meters": -1.285,
        "y_max_meters": 1.5,
        "y_min_meters": 0,
        "z_min_meters": -2,
        "z_max_meters": 2
      },
      {
        "context_id": 10,
        "unique_id": "2cc5d300-46df-4375-849b-1c4e32ceb466",
        "detect_falls": true,
        "detect_presence": true,
        "enter_duration_s": 3,
        "exit_duration_s": 3,
        "name": "Toilet",
        "subregion_id": 1,
        "x_max_meters": 0.25,
        "x_min_meters": -0.5,
        "y_max_meters": 1.3,
        "y_min_meters": 0,
        "z_min_meters": -2,
        "z_max_meters": 2
      },
      {
        "context_id": 13,
        "unique_id": "9c747dd7-1824-43d7-aeaa-2e4400928dfe",
        "detect_falls": true,
        "detect_presence": true,
        "enter_duration_s": 3,
        "exit_duration_s": 3,
        "name": "Sink",
        "subregion_id": 2,
        "x_max_meters": 1.25,
        "x_min_meters": 0.25,
        "y_max_meters": 1.3,
        "y_min_meters": 0,
        "z_min_meters": -2,
        "z_max_meters": 2
      }
    ],
    "id_MzA6QUU6QTQ6RTI": [
      {
        "context_id": 1,
        "unique_id": "49f9c146-8367-4d4d-ac06-172634473fe6",
        "detect_falls": false,
        "detect_presence": true,
        "enter_duration_s": 3,
        "exit_duration_s": 3,
        "name": "Bed",
        "subregion_id": 0,
        "x_max_meters": 0.83,
        "x_min_meters": -1.1,
        "y_max_meters": 3.35,
        "y_min_meters": 1.25,
        "z_min_meters": -2,
        "z_max_meters": 2
      }
    ],
    "id_MzA6QUU6QTQ6RTM6": [
      {
        "context_id": 20,
        "unique_id": "3b7fd31c-5c59-462e-b97a-5d99127a94d4",
        "detect_falls": true,
        "detect_presence": true,
        "enter_duration_s": 1,
        "exit_duration_s": 3,
        "name": "Office chair",
        "subregion_id": 0,
        "x_max_meters": 0.0,
        "x_min_meters": -1.0,
        "y_max_meters": 1.52,
        "y_min_meters": 0.61,
        "z_min_meters": -2,
        "z_max_meters": 2
      }
    ]
  }
}
```

### Get the available Subregion Behaviors

State Variable : `vayyar_subregion_behaviors`

The device has to be associated with the correct location before you set the subregion, because the subregion requires context to be stored in non-volatile memory that is only associated with the location. If you move the device to a different location, you need to set the subregions again.

#### Subregion Behavior Properties

| Property | Type | Description |
| -------- | ---- | ----------- |
| context_id | int | Subregion Context ID to apply to this subregion. |
| title | String | Title of the subregion |
| detail | String | Optional detail description if it helps - usually the title is enough, but there were a few that deserved a bit more explanation. |
| icon | String | Icon name |
| icon_font | String | Icon font to apply |
| width_cm | int | Recommended width of the subregion, in centimeters |
| length_cm | int | Recommended length of the subregion, in centimeters |
| flexible_cm | Boolean | True if the subregion size is flexible from our recommendations, False if this is a standard size |
| detect_falls | Boolean | True to recommend falls be detected for this subregion context. |
| edit_falls | Boolean | True to allow the user to see / edit whether fall detection can be turned on/off for this subregion context. False to prevent the user from seeing / editing whether fall detection can turn on or off for this subregion context. |
| detect_presence | Boolean | True to recommend detecting presence for this subregion context. |
| edit_presence | Boolean | True to allow the user to see / edit whether presence detection can be turned on/off for this subregion context. False to prevent the user from seeing / editing whether presence detection can turn on or off for this subregion context. |
| enter_duration_s | int | Recommended enter duration in seconds to set for this subregion context. |
| exit_duration_s | int | Recommended exit duration in seconds to set for this subregion context. |
| compatible_behaviors | List | List of compatible behavior ID's, as defined in the `behaviors` state |

#### `vayyar_subregion_behaviors` Example

```
{
  "value": [
    {
      "compatible_behaviors": [
        0
      ],
      "context_id": 1,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": false,
      "icon": "bed-alt",
      "icon_font": "far",
      "length_cm": 204,
      "title": "King Bed",
      "width_cm": 193
    },
    {
      "compatible_behaviors": [
        0
      ],
      "context_id": 2,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": false,
      "icon": "bed-alt",
      "icon_font": "far",
      "length_cm": 214,
      "title": "Cal King Bed",
      "width_cm": 183
    },
    {
      "compatible_behaviors": [
        0
      ],
      "context_id": 3,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": false,
      "icon": "bed-alt",
      "icon_font": "far",
      "length_cm": 204,
      "title": "Queen Bed",
      "width_cm": 153
    },
    {
      "compatible_behaviors": [
        0
      ],
      "context_id": 4,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": false,
      "icon": "bed-alt",
      "icon_font": "far",
      "length_cm": 191,
      "title": "Full Bed",
      "width_cm": 135
    },
    {
      "compatible_behaviors": [
        0
      ],
      "context_id": 5,
      "flexible_cm": false,
      "icon": "bed-empty",
      "icon_font": "far",
      "length_cm": 204,
      "title": "Twin XL Bed",
      "width_cm": 97
    },
    {
      "compatible_behaviors": [
        0
      ],
      "context_id": 6,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": false,
      "icon": "bed-empty",
      "icon_font": "far",
      "length_cm": 191,
      "title": "Twin Bed",
      "width_cm": 97
    },
    {
      "compatible_behaviors": [
        0
      ],
      "context_id": 7,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": false,
      "icon": "baby",
      "icon_font": "far",
      "length_cm": 132,
      "title": "Crib",
      "width_cm": 69
    },
    {
      "compatible_behaviors": [
        1
      ],
      "context_id": 10,
      "description": "Include the area in front of the toilet to detect people.",
      "detect_falls": true,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": false,
      "icon": "toilet",
      "icon_font": "far",
      "length_cm": 120,
      "title": "Toilet",
      "width_cm": 76
    },
    {
      "compatible_behaviors": [
        1
      ],
      "context_id": 11,
      "detect_falls": true,
      "detect_presence": true,
      "edit_falls": true,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": false,
      "icon": "bath",
      "icon_font": "far",
      "length_cm": 82,
      "title": "Bathtub / Shower",
      "width_cm": 152
    },
    {
      "compatible_behaviors": [
        1
      ],
      "context_id": 12,
      "detect_falls": true,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "shower",
      "icon_font": "far",
      "length_cm": 91,
      "title": "Walk-in Shower",
      "width_cm": 152
    },
    {
      "compatible_behaviors": [
        1
      ],
      "context_id": 13,
      "description": "Include the area in front of the sink to detect people.",
      "detect_falls": true,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": true,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "sink",
      "icon_font": "far",
      "length_cm": 130,
      "title": "Sink Area",
      "width_cm": 1.0
    },
    {
      "compatible_behaviors": [
        2
      ],
      "context_id": 20,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": true,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "loveseat",
      "icon_font": "far",
      "length_cm": 114,
      "title": "Large Chair",
      "width_cm": 135
    },
    {
      "compatible_behaviors": [
        2,
        3
      ],
      "context_id": 21,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": true,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "chair",
      "icon_font": "far",
      "length_cm": 52,
      "title": "Small Chair",
      "width_cm": 48
    },
    {
      "compatible_behaviors": [
        2
      ],
      "context_id": 22,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": true,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "couch",
      "icon_font": "far",
      "length_cm": 98,
      "title": "Sofa / Couch",
      "width_cm": 259
    },
    {
      "compatible_behaviors": [
        2,
        0,
        3
      ],
      "context_id": 100,
      "detail": "Large area in front of an exit door.",
      "detect_falls": true,
      "detect_presence": true,
      "edit_falls": true,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "door-open",
      "icon_font": "far",
      "length_cm": 100,
      "title": "Exit Door Area",
      "width_cm": 152
    },
    {
      "compatible_behaviors": [
        2,
        0,
        3,
        1,
        4
      ],
      "context_id": -1,
      "description": "Select this to prevent false alarms in this area of the room.",
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": true,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "eye-slash",
      "icon_font": "far",
      "length_cm": 50,
      "title": "Ignore this area",
      "width_cm": 50
    }
  ]
}
```

## References
* `com.ppp.BotProprietary/signals/vayyar.py`
* `com.ppc.Microservices/intelligence/vayyar`
