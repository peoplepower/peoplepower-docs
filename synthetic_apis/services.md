# Synthetic API: Services and Alerts

The "Services and Alerts" menu provides a list of available services to render for the user, allowing the user to turn those services on and off.

In our app design, we show the user a menu of services, and the ability to tap into a single service to learn more.

Services turn on and off through the [Questions API](https://iotapps.docs.apiary.io/reference/user-communications/questions), and not through a data stream message. Each service element references one or more Question objects that the mobile app can answer to configure the service.

### Properties
| Property | Type | Description |
| -------- | ---- | ----------- |
| id | String | Unique ID for this service element |
| title | String | Title of the service element |
| comment | String | Front-page comment about this service element |
| description | String | Really long description of the service to explain it to the user. May include characters like \n.
| icon | String | Icon name to apply |
| icon_font | String | Icon font package to use for the icon |
| weight | int | Lower weights float to the top. All ordered lists should be pre-sorted by weight before the apps receive the data, so the apps do not have to sort |
| updated | int | Timestamp in milliseconds of the last update to this element |
| active | Boolean | Describes whether or not this service is running or disabled. Recommendation is to set services that are not active to a gray color in the UI. |
| status | int | See the Status table |
| status_text | String | Recommended text to display for the current status of this service - for example "RUNNING" or "ACTIVE - PHONE CALLS ONLY". |
| percent | float | Deprecated - used to be used to describe how much this particular service has learned or trusts itself to run |
| question_id | String | Question ID to answer to toggle this service on or off. This is useful when a single question drives the service. |
| collection_id | String | String that represents a collection of questions (and the title of that collection). This is used when a service may be driven by multiple questions combined. |

### Status
| Status | Meaning  | Recommended Color |
| ------ | -------- | ----------------- |
| 0      | Good     | Green             |
| 1      | Learning | Blue              |
| 2      | Critical | Red               |

## Inputs

The `services` state provides Question IDs for the user to answer. Control these services through the Questions API. 

## Outputs

State Variable : `services`

#### Display recommendations
The `cards` are pre-sorted by the bots based on the weight of each element.

On the main "Services and Alerts" screen, we recommend showing these properties of each element in a table view:
* title
* icon / icon_font
* status_text
* question_id if available
* comment
* color based on whether or not this is active (gray or not), and then the status integer (green, blue, red).

Drilling into a single service / alert element, we show all the content available, including the long `description`.

#### Content
```
{
  "value": {
    "cards": [
      {
        "content": [
          {
            "active": true,
            "collection_id": "Social Connector Settings",
            "comment": "Reminding 7 people to reach out. Add more friends and family in the Trusted Circle tab.",
            "description": "THIS IS GOOD FOR YOUR HEALTH.\nDecades of research indicate that having quality social connections with other people is critical for good physical and mental health. In fact, the health benefit of having quality social connections is comparible to what you would obtain by stopping smoking or maintaining a healthy body weight. Studies have found that social support is linked to recovering faster from injuries and more effective immune system functioning.\n\nIT'S GOOD FOR FAMILY AND FRIENDS.\nRecent research indicates when people provide support and help for others, it improves their own well being. Importantly, the health benefits of giving to others seems to increase with age.\n\nTHE BIG PICTURE.\nThis service helps maintain social connections between people and the friends and family in their Trusted Circle, all of whom may experience health benefits from being socially connected and giving to others.\n\nHOW DO I SET UP THE TRUSTED CIRCLE?\nFirst, add people in the People Power Family app's Trusted Circle tab. Make sure at least one person's Alert Texting role is set to 'I Live Here'. Set other people's Alert Texting roles to either 'Family / Friend' or 'Social Reminders Only'. People Power Family will then intelligently coordinate family and friends in the Trusted Circle to reach out to the people who live here.\n\nHOW DOES IT WORK?\nEach participant will get randomly selected no more than once per week in a way that does not become a burden. On that person's day to reach out, they will receive a text message reminder in the morning. Finally, People Power Family will help recommend conversation topics to the next person in the Trusted Circle, and report on the Dashboard who reached out most recently.",
            "icon": "phone",
            "icon_font": "far",
            "id": "care.reminders",
            "percent": 100,
            "section_id": 1,
            "status": 0,
            "status_text": "RUNNING",
            "title": "Social Connector",
            "updated": 1620849972489,
            "weight": 0
          },
          {
            "active": true,
            "collection_id": "Care Settings",
            "comment": "Monitoring for abnormal inactivity and falls.",
            "description": "This service will look for signs of falls and abnormal amounts of inactivity in the home, including occupants not getting up in the morning.\n\nIf falls and inactivity are a concern, we strongly recommend adding a Motion Sensor to the bedroom to get alerts if occupants do not make it into the bedroom at night. This service will not detect falls while the occupant is expected to be sleeping unless a bed sensor is installed.",
            "icon": "user-clock",
            "icon_font": "far",
            "id": "care.generalinactivity",
            "percent": 100,
            "question_id": "care.generalinactivity",
            "status": 0,
            "status_text": "RUNNING",
            "title": "Fall & Inactivity Detection",
            "updated": 1620864467418,
            "weight": 20
          },
          {
            "active": true,
            "collection_id": "Medication Settings",
            "comment": "Monitoring the 'Medicine Cabinet' for access to medication.",
            "description": "Activate the times of day you would like to get reminded to take medication.\n\nThere are several devices that can track medication, including:\n\n+ ENTRY SENSOR with the behavior 'Medicine Cabinet'. Place the Entry Sensor on a medicine cabinet. Access to medication is recorded when the cabinet opens.\n\n+ BUTTON with the behavior 'Signal: I took my medicine'. Place the button on the counter next to the medication. Simply push the button to record when you've taken your medicine.\n\n+ VIBRATION SENSOR with the behavior 'Medicine Container'. Attach the Vibration Sensor to your medicine container or pill box. Access to medication is recorded when the container physically moves.\n\nThe app will first remind people marked 'I live here' to take medication. Later, it will alert 'Family / Friends' in the Trusted Circle if medication was not accessed by the expected times throughout the day.\n\nAccess to medication is recorded in the Daily Report and Detailed History for review.",
            "icon": "pills",
            "icon_font": "far",
            "id": "meds",
            "percent": 100,
            "section_id": 60,
            "status": 0,
            "status_text": "RUNNING",
            "title": "Medication",
            "updated": 1620849972489,
            "weight": 25
          },
          {
            "active": true,
            "collection_id": "Care Settings",
            "comment": "Tracking and reporting bathroom activity.",
            "description": "This service will monitor and report bathroom visits in the History, day and night. A bathroom motion sensor will also add more aggressive fall and inactivity detection inside the bathroom, making the bathroom a safer place to be.\n\nMotion sensors are not cameras, and maintain privacy while simply identifying whether a person is in the room.",
            "icon": "toilet-paper",
            "icon_font": "far",
            "id": "care.bathroomactivity",
            "percent": 100,
            "question_id": "care.bathroomactivity",
            "status": 0,
            "status_text": "RUNNING",
            "title": "Bathroom Monitoring",
            "updated": 1620849972489,
            "weight": 30
          },
          {
            "active": false,
            "collection_id": "Care Settings",
            "comment": "Alerts when perimeter doors open.",
            "description": "This service will send alerts to people who live inside the home when perimeter doors open. It is useful for families with children, or for caregivers of people with dementia or Alzheimer's.",
            "icon": "shoe-prints",
            "icon_font": "far",
            "id": "care.wandering",
            "percent": 100,
            "question_id": "care.wandering",
            "status": 0,
            "status_text": "DISABLED",
            "title": "Wandering Away",
            "updated": 1620849972489,
            "weight": 40
          },
          {
            "active": true,
            "collection_id": "Security Settings",
            "comment": "Remind occupants to arm the security system.",
            "description": "When the house appears to be empty and the security system was left disarmed, this service will text SMS reminders to people who live here to remind them to arm the home. Recipients can reply back over SMS to easily manage the People Power Family security system over text messaging. Never forget to leave your home disarmed again.",
            "icon": "shield-check",
            "icon_font": "far",
            "id": "security.sms_reminder",
            "percent": 100,
            "question_id": "security.sms_reminder",
            "status": 0,
            "status_text": "RUNNING",
            "title": "Security Text Reminders to Arm",
            "updated": 1620849972489,
            "weight": 45
          },
          {
            "active": true,
            "collection_id": "Care Settings",
            "comment": "Will alert if occupants don't come back home by a usual time.",
            "description": "This service predicts what time occupants will be back home and will deliver alerts if nobody came home at an expected time.",
            "icon": "map-marker-question",
            "icon_font": "far",
            "id": "care.notbackhome",
            "percent": 100,
            "question_id": "care.notbackhome",
            "status": 0,
            "status_text": "RUNNING",
            "title": "Not Back Home Monitoring",
            "updated": 1620849972489,
            "weight": 50
          },
          {
            "active": true,
            "collection_id": "Care Settings",
            "comment": "Alerts if occupants are up late.",
            "description": "This service will learn the normal bedtime, and alert if occupants appear to be awake too late. Although a bedroom motion sensor is not required, this service is enhanced by including a motion sensor in the bedroom to ensure occupants entered the bedroom at night.",
            "icon": "bed",
            "icon_font": "far",
            "id": "care.latenight",
            "percent": 100,
            "question_id": "care.latenight",
            "status": 0,
            "status_text": "RUNNING",
            "title": "Awake too late",
            "updated": 1620849972489,
            "weight": 70
          },
          {
            "active": true,
            "collection_id": "Care Settings",
            "comment": "Will alert people who live here if someone is active at night.",
            "description": "This service will send alerts to people who live in the home when activity is detected after occupants were expected to be asleep. This is useful for families with children, and for caregivers of people with dementia or Alzheimer's.",
            "icon": "moon",
            "icon_font": "far",
            "id": "care.midnightsnack",
            "percent": 100,
            "question_id": "care.midnightsnack",
            "status": 0,
            "status_text": "RUNNING",
            "title": "Late Night Activity",
            "updated": 1620849972489,
            "weight": 80
          },
          {
            "active": true,
            "collection_id": "Emergency Call Center Settings",
            "comment": "The Emergency Call Center will make phone calls.",
            "description": "Control whether the Emergency Call Center should get involved when nobody else is responding to a critical alert.\n\nThe Emergency Call Center will only try calling people on the call tree, and WILL NOT dispatch emergency services. You can set up the Emergency Call Center call tree in the Trusted Circle tab.",
            "icon": "user-headset",
            "icon_font": "far",
            "id": "ecc.is_active",
            "percent": 100,
            "section_id": 0,
            "status": 0,
            "status_text": "ACTIVE - PHONE CALLS ONLY",
            "title": "Emergency Call Center",
            "updated": 1620849972489,
            "weight": 99
          }
        ],
        "title": "ALERTS",
        "type": 1,
        "weight": 10
      }
    ]
  }
}
```

## Recommendations
This is one of the earlier Synthetic APIs. If we were to do it again, we would: 
* Flatten out the hierarchy
* Remove dependencies on the server's Questions API and build our own into the Synthetic API, following the design of the `resolution` or `feedback` architecture inside the `dashboard_header` state variable.
* Provide a list of these questions when necessary, instead of a Collection.

## References
* `com.ppc.BotProprietary/signals/dashboard.py`
* `com.ppc.Microservices/intelligence/dashboard/location_dashboardheader_microservice.py`
