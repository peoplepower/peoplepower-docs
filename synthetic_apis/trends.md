# Synthetic API: Trends

Trends allow us to understand if the knowledge we're observing now are normal or abnormal vs. historical lifestyle patterns. Trends are largely statistical in nature, and much of the underlying machinery focuses on the processing of historical data to provide high quality insights.

## Properties

#### `trends` Properties

| Property | Type | Description |
| -------- | ---- | ----------- |
| trends | Dictionary | Dictionary of trends, where the key is the `trend_id`. |
| title | String | Short human-readable title for this trend. |
| comment | String | Human-readable description for this trend. |
| services | List | List of `service_id`'s that this trend is related to, for linking inside the UI. |
| units | String | Units of measurement for this measurement. |
| updated_ms | int | Timestamp in milliseconds of the last update. |
| window | int | Number of days that trend data is accumulated, for comparing to today's values. |
| icon | String | Icon to apply to this trend. |
| icon_font | String | Icon font to apply to the icon, default is FontAwesome Regular ('far'). |
| operation | int | Type of operation applied to this data. See the Operations table. |
| daily | Boolean | True if this trend is captured once per day, False if the trend is captured multiple times per day. |
| parent_id | String | Trend ID of this trend's parent, may be null. |

#### Operations

Operations are applied internally as data is being captured by bot microservices.

| `operation` value | Name | Description |
| ----------------- | ---- | ----------- |
| 1 | Instantaneous | For values measured multiple times per day, store the instantaneous value each hour. Example: the instantaneous time occupants woke up, or the instantaneous set-point the thermostat was set to. |
| 2 | Accumulate | For values measured multiple times per day, accumulate the values throughout the day. Example: Number of minutes a person sat in a chair today, or the number of steps taken throughout the day. |
| 3 | Average | For values measured multiple times per day, take the average of all values throughout the day each hour. Example: Your average mobility % score throughout the day. |

#### Trend Data Properties

Trend statistics are calculated using a data set that is extracted from historical data. We want to compare the values right now against historical values, but with context that includes the time-of-day. 

For example, even though you might historically walk your 10,000 steps yesterday by midnight each day, by 8:00 AM you're usually averaging about 2,000 steps. If we capture this same data today each hour, how do your total steps by 8:00 AM compare with similar totals by 8:00 AM over the past 30 days?

Here's how we extract the data sets:
* **Instantaneous Operations** : The data set is composed of the newest value captured before this relative hour of the day, for all previous days captured. 
* **Accumulation Operations** : The data set is composed of the accumulated value by this relative hour of the day, for all previous days captured.
* **Averaging Operations** : The data set averages all the previous days up until now, for hours starting at the beginning of the day until this relative hour of the day. Each day's latest average by this time of day becomes a data point in this set.

| Property | Type | Description |
| -------- | ---- | ----------- |
| value | Float | The newest value captured, pre-processed based on the applied operation |
| avg | Float | Average across the data set |
| std | Float | Standard deviation of the data set |
| zscore | Float | Z-Score of the current value relative to the historical data set - this is used to describe where the newest value is relative to the standard deviations |
| display | String | Human-readable display value |
| updated_ms | int | Timestamp in milliseconds this trend data was last updated |
| n | int | total number of data points that have gone into a calculation for averages and standard deviations |


## Inputs

Trends are typically captured internally by bots. When a trend is finished processing, an additional data stream message is distributed internally with the update trend info to allow any interested microservices to perform higher-level calculations. For example, a microservice might observe the change in trends over the past few days, and alert if trends have been going in a bad direction.

#### Create or Update a trend

Data Stream Address : `capture_trend_data`

```
{
    "trend_id": trend_id,
    "value": value,
    "display_value": display_value,
    "title": title,
    "comment": comment,
    "icon": icon,
    "icon_font": icon_font,
    "units": units,
    "window": window,
    "once": once,
    "operation": operation,
    "services": related_services,
    "timestamp_ms": timestamp_override_ms
}
```

#### Delete a trend

Data Stream Address : `remove_trend`

```
{
    "trend_id": trend_id
}
```

## Output

The output for trends is broken into several parts:
* Metadata: `trends_metadata`
* Time-series daily trend information : `trends`
* Average trends over the past 7 days: `trends_recently`
* Time-series 7-day incremental trend information : `trends_weekly`
* Highlights of top-level trends for history : `trends_highlights`

The `trends_metadata` captures the configuration values that are like overhead and remain quite static, to optimize data usage by preventing duplicate data. 

### `trends_metadata` Example

Trends related to specific device instances typically references the device ID's in the `trend_id`.

```
{
    "sitting": {
      "comment": "Time spent sitting today.",
      "daily": false,
      "icon": "loveseat",
      "operation": 2,
      "parent_id": null,
      "services": [],
      "title": "Sitting",
      "units": "ms",
      "updated_ms": 1639717200000,
      "window": 30
    },
    "trend.bedtime": {
      "comment": "Time occupants went to sleep.",
      "daily": true,
      "icon": "bed",
      "operation": 1,
      "parent_id": null,
      "services": [
        "care.latenight"
      ],
      "title": "Bedtime",
      "units": "timestamp_ms",
      "updated_ms": 1639666016115,
      "window": 30
    },
    "trend.sleep_bathroom_visits": {
      "comment": "Number of bathroom visits at night.",
      "daily": true,
      "icon": "house-night",
      "operation": 1,
      "parent_id": null,
      "services": [
        "care.bathroomactivity"
      ],
      "title": "Bathroom Visits at Night",
      "units": "Visits",
      "updated_ms": 1639666016115,
      "window": 30
    },
    "trend.sleep_cycle_score": {
      "comment": "Relative sleep cycle score.",
      "daily": true,
      "icon": "snooze",
      "operation": 1,
      "parent_id": null,
      "services": [
        "care.latenight"
      ],
      "title": "Sleep Cycle Score",
      "units": "%",
      "updated_ms": 1639666016115,
      "window": 30
    },
    "trend.sleep_duration": {
      "comment": "Amount of sleep.",
      "daily": true,
      "icon": "alarm-clock",
      "operation": 1,
      "parent_id": null,
      "services": [
        "care.latenight"
      ],
      "title": "Sleep Duration",
      "units": "ms",
      "updated_ms": 1639666016115,
      "window": 30
    },
    "trend.wakeup": {
      "comment": "Time occupants woke up.",
      "daily": true,
      "icon": "bed",
      "operation": 1,
      "parent_id": null,
      "services": [
        "care.latenight"
      ],
      "title": "Wake Time",
      "units": "timestamp_ms",
      "updated_ms": 1639666016115,
      "window": 30
    },
    "trends.absent": {
      "comment": "Time occupants have been away from home today, a possible indicator of exercise or social activity.",
      "daily": false,
      "icon": "house-leave",
      "operation": 2,
      "parent_id": null,
      "services": [],
      "title": "Time Away from Home",
      "units": "ms",
      "updated_ms": 1639717200000,
      "window": 30
    },
    "trends.movement_score": {
      "comment": "Relative mobility score.",
      "daily": false,
      "icon": "walking",
      "operation": 3,
      "parent_id": null,
      "services": [
        "care.generalinactivity",
        "care.morninginactivity"
      ],
      "title": "Mobility Score",
      "units": "%",
      "updated_ms": 1639717200000,
      "window": 30
    }
}
```

### `trends` Example

The time-series state variable `trends` contains a Dictionary of trends, identified by their `trend_id`. The `trend_id` is captured again in the data for ease-of-processing by bots.

```
{
  "value": {
    "trend.bathroom_duration": {
      "avg": 80422.63,
      "display": "6 minutes",
      "std": 186040.41,
      "trend_id": "trend.bathroom_duration",
      "updated_ms": 1620889983312,
      "value": 377370.0,
      "zscore": 1.6
    },
    "trend.bathroom_visits": {
      "avg": 0.2,
      "display": "1.0 visits",
      "std": 0.41,
      "trend_id": "trend.bathroom_visits",
      "updated_ms": 1620889983312,
      "value": 1.0,
      "zscore": 1.95
    },
    "trend.bedtime": {
      "avg": 21.95,
      "display": "8:48 PM on Wednesday",
      "std": 1.11,
      "trend_id": "trend.bedtime",
      "updated_ms": 1620877716962,
      "value": 20.8,
      "zscore": -1.04
    },
    "trend.sleep_bathroom_visits": {
      "avg": 1.21,
      "display": "3.0 visits",
      "std": 0.62,
      "trend_id": "trend.sleep_bathroom_visits",
      "updated_ms": 1620829074205,
      "value": 3.0,
      "zscore": 2.89
    },
    "trend.sleep_duration": {
      "avg": 32853783.48,
      "display": "10.2 hours",
      "std": 4778427.33,
      "trend_id": "trend.sleep_duration",
      "updated_ms": 1620829074205,
      "value": 36695510.0,
      "zscore": 0.8
    },
    "trend.sleep_movement": {
      "avg": 1195848.72,
      "display": "43.36 minutes.",
      "std": 693201.71,
      "trend_id": "trend.sleep_movement",
      "updated_ms": 1620829074205,
      "value": 2601709.0,
      "zscore": 2.03
    },
    "trend.sleep_score": {
      "avg": 56.03,
      "display": "56% sleep score",
      "std": 12.01,
      "trend_id": "trend.sleep_score",
      "updated_ms": 1620829074205,
      "value": 56.0,
      "zscore": -0.0
    },
    "trend.wakeup": {
      "avg": 7.21,
      "display": "7:17 AM on Wednesday",
      "std": 1.09,
      "trend_id": "trend.wakeup",
      "updated_ms": 1620829074205,
      "value": 7.283333333333333,
      "zscore": 0.07
    },
    "trends.00155F00F84539D6-039B": {
      "avg": 3.69,
      "display": "7.0 times today",
      "std": 3.9,
      "trend_id": "trends.00155F00F84539D6-039B",
      "updated_ms": 1620763719765,
      "value": 7.0,
      "zscore": 0.85
    },
    "trends.506eda0a006f0d00": {
      "avg": 2.07,
      "display": "5.0 times today",
      "std": 1.77,
      "trend_id": "trends.506eda0a006f0d00",
      "updated_ms": 1620852356291,
      "value": 5.0,
      "zscore": 1.66
    },
    "trends.63a5f00e006f0d00": {
      "avg": 1.25,
      "display": "Once today",
      "std": 1.26,
      "trend_id": "trends.63a5f00e006f0d00",
      "updated_ms": 1620434150567,
      "value": 1.0,
      "zscore": -0.2
    },
    "trends.94f3b202008d1500": {
      "avg": 2.09,
      "display": "2.0 times today",
      "std": 1.04,
      "trend_id": "trends.94f3b202008d1500",
      "updated_ms": 1620885137728,
      "value": 2.0,
      "zscore": -0.09
    },
    "trends.absent": {
      "avg": 0.0,
      "display": "0 hours",
      "std": 0.0,
      "trend_id": "trends.absent",
      "updated_ms": 1620903600620,
      "value": 0.0,
      "zscore": 0.0
    },
    "trends.ambient_31ab6305006f0d00": {
      "avg": 20.21,
      "display": "70.3F / 21.3C",
      "std": 0.65,
      "updated_ms": 1620906622075,
      "value": 21.3,
      "zscore": 1.68
    },
    "trends.cooling_31ab6305006f0d00": {
      "avg": 24.07,
      "display": "76.3F / 24.6C",
      "std": 0.86,
      "trend_id": "trends.cooling_31ab6305006f0d00",
      "updated_ms": 1620879832346,
      "value": 24.6,
      "zscore": 0.62
    },
    "trends.heating_31ab6305006f0d00": {
      "avg": 19.46,
      "display": "67.3F / 19.6C",
      "std": 0.57,
      "trend_id": "trends.heating_31ab6305006f0d00",
      "updated_ms": 1620879578894,
      "value": 19.6,
      "zscore": 0.25
    },
    "trends.movement_duration": {
      "avg": 242246.53,
      "display": "7 minutes",
      "std": 232689.2,
      "trend_id": "trends.movement_duration",
      "updated_ms": 1620903600620,
      "value": 421414.0,
      "zscore": 0.77
    },
    "trends.movement_score": {
      "avg": 6.3,
      "display": "19%",
      "std": 10.01,
      "trend_id": "trends.movement_score",
      "updated_ms": 1620903600620,
      "value": 18.75,
      "zscore": 1.24
    },
    "trends.present": {
      "avg": 370033.77,
      "display": "0 hours",
      "std": 1230696.63,
      "trend_id": "trends.present",
      "updated_ms": 1620903600620,
      "value": 0.0,
      "zscore": -0.3
    }
  }
}
```

### `trends_recently` Example

This shows the average trends over the past 7 days, for comparison with entries from `trends_weekly`.

```
{
    "sitting": {
      "avg": 0.0,
      "n": 2,
      "std": 0.0
    },
    "trend.bedtime": {
      "avg": 21.95,
      "n": 1,
      "std": 0.0
    },
    "trend.sleep_bathroom_visits": {
      "avg": 0.0,
      "n": 1,
      "std": 0.0
    },
    "trend.sleep_duration": {
      "avg": 61326874.0,
      "n": 1,
      "std": 0.0
    },
    "trend.wakeup": {
      "avg": 15.0,
      "n": 1,
      "std": 0.0
    },
    "trends.absent": {
      "avg": 0.0,
      "n": 2,
      "std": 0.0
    },
    "trends.movement_score": {
      "avg": 6.43,
      "n": 2,
      "std": 9.1
    }
}
```


### `trends_weekly` Example

Exactly the same as `trends_recently` but saved as time-series information many weeks ago.

```
{
    "sitting": {
      "avg": 0.0,
      "n": 2,
      "std": 0.0
    },
    "trend.bedtime": {
      "avg": 21.95,
      "n": 1,
      "std": 0.0
    },
    "trend.sleep_bathroom_visits": {
      "avg": 0.0,
      "n": 1,
      "std": 0.0
    },
    "trend.sleep_duration": {
      "avg": 61326874.0,
      "n": 1,
      "std": 0.0
    },
    "trend.wakeup": {
      "avg": 15.0,
      "n": 1,
      "std": 0.0
    },
    "trends.absent": {
      "avg": 0.0,
      "n": 2,
      "std": 0.0
    },
    "trends.movement_score": {
      "avg": 6.43,
      "n": 2,
      "std": 9.1
    }
}
```

### `trends_highlights` Example

The `trends_highlights` state summarizes the history of the top-level categories for graphing or rendering on a UI. 

Here's an example of that data structure.

```
{
    "now": {
        "trend.bathroom_score": {
            "avg": 0.0,
            "std": 0.0,
            "trend_category": "category.bathroom",
            "updated_ms": 1644944400000,
            "value": 0.0,
            "zscore": 0.0
        },
        "trend.hygiene_score": {
            "avg": 100.0,
            "std": 0.0,
            "trend_category": "category.bathroom",
            "updated_ms": 1644940701216,
            "value": 100.0,
            "zscore": 0.0
        },
        "trend.mobility_score": {
            "avg": 46.67,
            "std": 0.0,
            "trend_category": "category.activity",
            "updated_ms": 1644944400000,
            "value": 46.666666666666664,
            "zscore": 0.0
        },
        "trend.sleep_score": {
            "avg": 80.0,
            "std": 0.0,
            "trend_category": "category.sleep",
            "updated_ms": 1644935530825,
            "value": 80.0,
            "zscore": 0.0
        },
        "trend.wellness_score": {
            "avg": 33.5,
            "std": 0.0,
            "trend_category": "category.summary",
            "updated_ms": 1644944400000,
            "value": 33.5,
            "zscore": 0.0
      }
    },
    "0": {
        "trend.bathroom_score": {
            "avg": 0.0,
            "n": 1,
            "std": 0.0
        },
        "trend.hygiene_score": {
            "avg": 0.0,
            "n": 1,
            "std": 0.0
        },
        "trend.mobility_score": {
            "avg": 39.2,
            "n": 1,
            "std": 0.0
        }
    },
    "15": {},
    "30": {},
    "45": {},
    "60": {},
    "90": {}
}
```
