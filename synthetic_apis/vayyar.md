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
| x_left_meters | Float | Looking into the room from the device, this is the distance from the center of the device to the left wall of the room in meters. This is a negative number, and if a positive number is given, then it will be turned into a negative number. |
| x_right_meters | Float | Looking into the room from the device, this is the distance from the center of the device to the right wall of the room in meters. This is a positive number, and if a negative number is given, then it will be turned into a positive number. |
| y_max_meters | Float | Distance from the Vayyar Home to the opposite wall. |

#### Set Room Boundary Example

```
{
    "device_id": device_id,
    "x_left_meters": x_left_meters,
    "x_right_meters": x_right_meters,
    "y_max_meters": y_max_meters
}
```

### Set a Subregion

Data Stream Address : `set_vayyar_subregion`

There can be only 4 subregions maximum. Their ID's are 0, 1, 2, or 3.

#### Set Subregion Properties

| Property | Type | Description |
| -------- | ---- | ----------- |
| device_id | String | Device ID to apply this subregion to |
| subregion_id | int | Optional - used primarily for modifying or deleting. 0, 1, 2, or 3 and nothing else. You can specify the next valid integer to insert a new subregion, but out-of-bounds values are ignored. |
| context_id | int | Context / behavior of this subregion - see the [Subregion Behavior Properties](#subregion-behavior-properties) |
| name | String | Descriptive name of this subregion, default is the `title` of the subregion context that was selected. |
| x_min_meters | Float | Required. Looking into the room from the device, this is the left-most side of the sub-region. Remember to the left of Vayyar Home is negative numbers on the x-axis. |
| x_max_meters | Float | Required.Looking into the room from the device, this is the right-most side of the sub-region. |
| y_min_meters | Float | Required. Distance from the Vayyar Home to the nearest side of the sub-region. |
| y_max_meters | Float | Required. Distance from the Vayyar Home to the farthest side of the sub-region. |
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
    "detect_falls": detect_falls,
    "detect_presence": detect_presence,
    "enter_duration_s": enter_duration_s,
    "exit_duration_s": exit_duration_s,
    "context_id": context
}
```

### Delete a Subregion

Data Stream Address : `delete_vayyar_subregion`

If you want to delete all subregions for a given device, simply do not pass in a `subregion_id`.

```
{
    "device_id": device_id,
    "subregion_id": subregion_id
}
```

## Outputs

### Get the room boundaries

State Variable : `vayyar_room`

#### `vayyar_room` Example

```
{
    "device_id": {
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
      "flexible_cm": false,
      "icon": "bed-alt",
      "icon_font": "far",
      "context_id": 4,
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
      "flexible_cm": false,
      "icon": "toilet",
      "icon_font": "far",
      "context_id": 8,
      "length_cm": 120,
      "title": "Toilet",
      "width_cm": 76
    },
    {
      "compatible_behaviors": [
        1
      ],
      "context_id": 9,
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
      "context_id": 10,
      "flexible_cm": true,
      "icon": "shower",
      "icon_font": "far",
      "length_cm": 91,
      "title": "Walk-in Shower",
      "width_cm": 152
    },
    {
      "compatible_behaviors": [
        2
      ],
      "context_id": 10,
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
      "context_id": 11,
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
      "context_id": 11,
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
      "context_id": 11,
      "detail": "Large area in front of an exit door.",
      "flexible_cm": true,
      "icon": "door-open",
      "icon_font": "far",
      "length_cm": 100,
      "title": "Exit Perimeter Door Area",
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
