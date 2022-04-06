# Synthetic API: Location Summary

The `summary` state variable assists user interfaces by providing snapshots of 'scores' back in time which rank
how well this location is doing or was doing. It can also include a 'badge' which may notify a person
to pay more attention to this location, plus methods to clear or set ("Mark as unread") that badge.

These location summaries are used when loading a list of locations where we want to identify the
location we should focus human attention upon.

| Property  | Type  | Description                                     |
|-----------|-------|-------------------------------------------------|
| `badge`   | int   | 0 = No notification; 1 = Show a notification badge |
 | `now` key | str   | Latest snapshot                            |
 | `0` key   | str   | 7-day averaged trends from the past 7-days      |
 | `15` key  | str   | 7-day averaged trends from 15 days ago |
 | `30` key  | str   | 7-day averaged trends from 30 days ago |
 | `45` key  | str   | 7-day averaged trends from 45 days ago |
 | `60` key  | str   | 7-day averaged trends from 60 days ago |
 | `90` key  | str   | 7-day averaged trends from 90 days ago |
 | `avg`     | float | Average value |
 | `std`     | float | Standard deviation |
 | `n`       | int | Number of measurements that went into the average and standard deviation |
 | `diff`    | int | Rounded difference between the latest snapshop and this past value |


| Badge Value | Description       |
|-------------|-------------------|
| 0           | No notification   |
 | 1           | Show Notification |


## Output

State Variable : `summary`

#### Example

```
{
    "value": {
        "badge": 0,
        "now": {
            "value": 76,
            "diff": 0
        },
        0: {
            "value": {
                "avg": 71.37,
                "std": 0.32,
                "n": 7
            },
            "diff": 4
        }
    }
}
```

## Input

#### Data stream address

`set_badge`

#### Data stream content

Clear the badge
```
{
    "badge": 0
}
```

Mark unread (set the badge again)
```
{
    "badge": 1
}
```
