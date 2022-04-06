# Synthetic API: Fall History

Fall history will maintain a time-series record of each fall incident from a Vayyar Care device.

| Property            | Type          | Description                                                                                                                                                                           |
|---------------------|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `device_id`         | String        | Device ID that detected the fall.                                                                                                                                                     |
| `device_desc`       | String        | Nickname / description of the device that detected the fall.                                                                                                                          |
| `device_type`       | int           | Device type that detected the fall.                                                                                                                                                   |
| `targets`           | List of Dicts | 3D target data points recorded during the fall.                                                                                                                                       |
| `end_time_ms`       | int           | End timestamp of the fall event in milliseconds. If this exists, the fall has concluded. Note the start time is recorded as the unique identifier in this time-series state variable. |
| `duration_ms`       | int           | Duration of the fall event in milliseconds. If this exists, the fall has concluded.                                                                                                   |

## Output

State Variable : `falls`

#### Example

```
"1644866155487": {
    "falls": {
      "device_desc": "Office",
      "device_id": "id_MzA6QUUQTQ6RTM6OY6RUMF",
      "device_type": 2000,
      "duration_ms": 163909,
      "end_time_ms": 1644866319396,
      "locationId": 271383,
      "organizationId": null,
      "targets": [
        {
          "1": {
            "x": 104,
            "y": 37,
            "z": 40
          }
        },
        {
          "1": {
            "x": 107,
            "y": 38,
            "z": 32
          }
        },
        {
          "1": {
            "x": 110,
            "y": 38,
            "z": 38
          }
        },
        {
          "1": {
            "x": 108,
            "y": 36,
            "z": 43
          }
        }
      ]
    }
  }
}
```
