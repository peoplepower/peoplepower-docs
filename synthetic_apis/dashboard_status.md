# Synthetic API: Dashboard Status Now

Dashboard status shows noteworthy events that recently happened. These typically appear below the main dashboard header in the app.

### Properties
The `now` state variable contains a list of cards to show. Although this concept of 'cards' is now a bit deprecated versus what our latest UI's display. This was originally designed to support multiple sections on the main page of the app, each section having its own weight and title and sub-elements.

The main information is stored in the `content` list on the first and only card. These should have been pre-sorted by weight, where smaller numbers are lighter and float to the top.

| Property | Type | Description | 
| -------- | ---- | ----------- |
| content.id | String | Unique app-generated ID for this content. |
| content.comment | String | Comment to display about something that happened. |
| content.status | int | See the status table |
| content.icon | String | Icon to apply |
| content.icon_font | String | Icon font for the icon selection |
| content.updated | int | Timestamp in milliseconds when this content was updated |
| content.weight | int | Lower values float to the top. Used internally by the microservice to auto-sort the list before saving the state variable, so the apps shouldn't have to do anything else to sort this list. |
| content.device_id | String | Optional device ID this content is related to. If this is populated, we recommend allowing the user to tap on this item and be taken directly to that device UI. |
| content.alarms | Dictionary | Ignore. Used internally by the microservice to automatically change this item's information over time. |
| content.url | String | Optional URL so when a user taps on this content they are taken to this URL. You typically won't have a URL and a device_id in the same status content, because a user can only click one. |

### Status
| Status | Meaning | Recommended Color |
| ------ | ------- | ----------------- |
| -2     | Delete  | Used internally   |
| -1     | Hidden  | Invisible and waiting |
| 0      | Good    | Green             |
| 1      | Warning | Orange            |
| 2      | Critical | Red              |

You can generally ignore these deprecated fields which will remain for historical reasons:
* `type`
* `title`

## Inputs

Data Stream Address : `update_dashboard_content`

Typically controlled by bots.

* To create some status - populate the data stream content as you see below.
* To delete an object - populate the type, title, content.id, and nothing else.

### Data Stream Content
This content goes into the `feed` of a data stream message.

```
{
    "type": 0,
    "title": "NOW",
    "weight": 0,
    "content": {
        "alarms": {
          # FYI - this mean 'At 1620858636783 milliseconds absolute time, auto-delete this."
          "1620858636783": -2
        },
        "comment": "Some comment you should know about here.",
        "device_id": "id_MzA6QUU6QTM6OEY6RUM",
        "icon": "radar",
        "icon_font": "iotr",
        "id": "unique_identifier",
        "status": 0,
        "updated": 1620858516783,
        "url": "http://optional.externallink.com",
        "weight": 0
    }
}
```

## Outputs 

State Variable: `now`

### State Content
```
{
  "value": {
    "cards": [
      {
        "content": [

          # This is your pre-sorted list of content to display to the user.

          {
            "alarms": {
              "1620858636783": -2
            },
            "comment": "Some comment you should know about here.",
            "device_id": "id_MzA6QUU6QTM6OEY6RUM",
            "icon": "radar",
            "icon_font": "iotr",
            "id": "unique_identifier",
            "status": 0,
            "updated": 1620858516783,
            "url": "http://optional.externallink.com",
            "weight": 0
          }
        ],
        "title": "NOW",
        "type": 0,
        "weight": 0
      }
    ]
  }
}
```

## References
* `com.ppc.BotProprietary/signals/dashboard.py`
* `com.ppc.Microservices/intelligence/dashboard/location_dashboard_microservice.py`
