# Synthetic API: Vayyar Care

Vayyar Care can sense falls in real-time, and detect occupants in the room.

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

| Property | Mounting Type | Value Type | Description |
| -------- | ------------- | ---------- | ----------- |
| device_id | | String | Device ID to apply these room boundaries to. |
| x_min_meters | Wall | Float | Looking into the room from the device, this is the distance from the center of the device to the left wall of the room in meters. This is a negative number, and if a positive number is given, then it will be turned into a negative number. Valid values range from `-2.0` to `0.0` |
| x_max_meters | Wall | Float | Looking into the room from the device, this is the distance from the center of the device to the right wall of the room in meters. This is a positive number, and if a negative number is given, then it will be turned into a positive number. Valid values range from `0.0` to `2.0` |
| y_max_meters | Wall | Float | In a wall mount, this is the distance from the Vayyar Care to the opposite wall. Valid values range from `1.0` to `4.0`. |
| y_min_meters | Wall | Float | Optional (0.3 default). In a wall mount, this is typically 0.3 meters which is just in front of the wall the Vayyar Care is mounted on. |
| x_left_meters | Wall (deprecated) | Float | Deprecated but still functional. Migrate to `x_min_meters`. Same outcome as defining `x_min_meters`. |
| x_right_meters | Wall (deprecated) | Float | Deprecated but still functional. Migrate to `x_max_meters`. Same outcome as defining `x_max_meters`. |
| x_min_meters | Ceiling | Float | In a ceiling mount, this is the distance from the Vayyar Care to the wall in the direction of the cable. Negative numbers only. -2.0 meters maximum. |
| x_max_meters | Ceiling | Float | In a ceiling mount, this is the distance from the Vayyar Care to the wall in the opposite direction of the cable. Positive numbers only. +2.0 meters maximum. |
| y_min_meters | Ceiling | Float | In a ceiling mount, this is the distance from the Vayyar Care to the wall toward the right of cable. Negative numbers only. -2.5 meters maximum. |
| y_max_meters | Ceiling | Float | In a ceiling mount, this is the distance from the Vayyar Care to the wall toward the left of the cable. Positive numbers only. +2.5 meters maximum. |
| z_min_meters | | Float | Optional. The minimum height to detect, usually 0.0 (the ground). |
| z_max_meters | | Float | Optional. The maximum height to detect, default is 2.0 meters. If set too high, objects (like vent fans) in the ceiling can cause false positive presence detects. |
| mounting_type | | int | 0 (default) = wall; 1 = ceiling; 2 = 45-degree ceiling |
| sensor_height_m | | Float | 1.5 is the default for the wall; Ceiling-mounted devices require this to define the distance from the ceiling to the floor. |
| near_exit | | Boolean | True if this Vayyar Care device is located nearest to an exit door and can be used to determine occupancy of the living space. |


#### Set Room Boundary Example

**Wall Mount Example**
```
{
    "device_id": device_id,
    "x_min_meters": x_min_meters,
    "x_max_meters": x_max_meters,
    "y_max_meters": y_max_meters,
    "mounting_type": 0,
    "near_exit": False
}
```

<img src="https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/img/vayyar_wall_mount.jpg" width="600">

**Ceiling Mount Example**
```
{
    "device_id": device_id,
    "x_min_meters": x_min_meters,
    "x_max_meters": x_max_meters,
    "y_min_meters": y_min_meters,
    "y_max_meters": y_max_meters,
    "sensor_height_m": 2.3,
    "mounting_type": 1,
    "near_exit": True
}
```

<img src="https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/img/vayyar_ceiling_mount.png" width="400">


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
| name | String | Descriptive name of this subregion, default is the `title` of the subregion context that was selected. |
| x_min_meters | Float | Required. For wall installs, looking into the room from the device, this is the left-most side of the sub-region. Remember to the left of Vayyar Care is negative numbers on the x-axis. For ceiling installs, standing at the cable side of the device and looking towards the device, this is the left-most side of the subregion. |
| x_max_meters | Float | Required. For wall installs, looking into the room from the device, this is the right-most side of the sub-region. For ceiling installs, standing at the cable side of the device and looking towards the device, this is the right-most side of the subregion. |
| y_min_meters | Float | Required. For wall installs, this is the distance from the Vayyar Care to the nearest side of the sub-region. Valid values are greater than or equal to `0.3`. For ceiling installs, standing at the cable side and looking towards the device, this is the rear side of the subregion. (e.g. distance from the device to your back) |
| y_max_meters | Float | Required. For wall installs, this is the distance from the Vayyar Care to the farthest side of the sub-region. For ceiling installs, standing at the cable side and looking towards the device, this is the front side of the subregion. (e.g. distance from the device to your front) |
| z_min_meters | Float | Optional. For 3D subregions, this is the minimum z-axis boundary. |
| z_max_meters | Float | Optional. For 3D subregions, this is the maximum z-axis boundary. |
| detect_falls | Boolean | Optional. True to detect falls in this room, False to avoid detecting fall (default is True). |
| detect_presence | Boolean | Optional. True to detect people, False to not detect people (default is True). |
| enter_duration_s | int | Optional. Number of seconds to wait until Vayyar Care declares someone entered this sub-region (default is 3 seconds). |
| exit_duration_s | int | Optional. Number of seconds to wait until Vayyar Care declares the sub-region is unoccupied (default is 3 seconds). |
| hidden | Boolean | Optional. True if this subregion should be hidden from the end-user's view and only available for professional debugging. |
| ai | Boolean | Optional. Set to True if this subregion was AI-generated. |

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
    "context_id": context,
    "hidden": False
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
        "x_min_meters": x_min_meters,
        "x_max_meters": x_max_meters,
        "y_min_meters": y_min_meters,
        "y_max_meters": y_max_meters,
        "z_min_meters": z_min_meters,
        "z_max_meters": z_max_meters,
        "near_exit": False,
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
        "hidden": False,
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
        "hidden": False,
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
        "hidden": False,
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
        "hidden": False,
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
        "hidden": False,
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
| snap_to_wall | Boolean | True if this subregion must be snapped to at least one nearby wall, False if the subregion can be placed anywhere around the room. |

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
      "snap_to_wall": true,
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
      "snap_to_wall": true,
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
      "snap_to_wall": true,
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
      "snap_to_wall": true,
      "title": "Full Bed",
      "width_cm": 135
    },
    {
      "compatible_behaviors": [
        0
      ],
      "context_id": 5,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": false,
      "icon": "bed-empty",
      "icon_font": "far",
      "length_cm": 204,
      "snap_to_wall": true,
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
      "snap_to_wall": true,
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
      "snap_to_wall": true,
      "title": "Crib",
      "width_cm": 69
    },
    {
      "compatible_behaviors": [
        0,
        2
      ],
      "context_id": 8,
      "detect_falls": false,
      "detect_presence": false,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "lamp-desk",
      "icon_font": "far",
      "length_cm": 55,
      "snap_to_wall": false,
      "title": "End Table",
      "width_cm": 55
    },
    {
      "compatible_behaviors": [
        0
      ],
      "context_id": 9,
      "detect_falls": false,
      "detect_presence": false,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "air-conditioner",
      "icon_font": "far",
      "length_cm": 25,
      "snap_to_wall": false,
      "title": "CPAP Machine",
      "width_cm": 25
    },
    {
      "compatible_behaviors": [
        1
      ],
      "context_id": 10,
      "description": "Include the area surrounding the toilet to detect people.",
      "detect_falls": true,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "toilet",
      "icon_font": "far",
      "length_cm": 120,
      "snap_to_wall": true,
      "title": "Toilet Area",
      "width_cm": 76
    },
    {
      "compatible_behaviors": [
        1
      ],
      "context_id": 14,
      "description": "Define the physical toilet to decrease false alarms.",
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": false,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "toilet",
      "icon_font": "far",
      "length_cm": 75,
      "title": "Physical Toilet",
      "width_cm": 50
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
      "snap_to_wall": true,
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
      "snap_to_wall": true,
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
      "snap_to_wall": true,
      "title": "Sink Area",
      "width_cm": 100
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
      "snap_to_wall": false,
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
      "snap_to_wall": false,
      "title": "Small Chair",
      "width_cm": 50
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
      "snap_to_wall": false,
      "title": "Sofa / Couch",
      "width_cm": 259
    },
    {
      "compatible_behaviors": [
        0,
        3,
        2,
        4
      ],
      "context_id": 23,
      "detect_falls": false,
      "detect_presence": true,
      "edit_falls": false,
      "edit_presence": true,
      "enter_duration_s": 3,
      "exit_duration_s": 3,
      "flexible_cm": true,
      "icon": "archive",
      "icon_font": "far",
      "length_cm": 80,
      "snap_to_wall": false,
      "title": "Table / Desk",
      "width_cm": 150
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
      "snap_to_wall": false,
      "title": "Ignore this area",
      "width_cm": 50
    }
  ]
}
```

## References
* `com.ppp.BotProprietary/signals/vayyar.py`
* `com.ppc.Microservices/intelligence/vayyar`
