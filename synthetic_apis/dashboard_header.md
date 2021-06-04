# Synthetic API: Dashboard Header

The dashboard header presents at-a-glance information to the user, describing how well this home and its occupants are doing. When a problem occurs, the dashboard header also allows a user in the app to select options that interact with the bots underneath, for example to resolve a problem.

Under the hood inside the dashboard microservices, the dashboard header is directly tied to the "home health metrics" which help prioritize this home against other homes for human attention needed. These metrics contain a priority (category) and a number from 0-100% that identifies how "well" the home is doing. Lower numbers are bad, and like a weight, lower numbers will float up to the surface when prioritizing homes against each other in a specific category.


### Properties
| Property | Type | Description |
| -------- | ---- | ----------- |
| name | String | App-generated unique identifying name for this object, to later update or delete it. |
| priority | int | See the Priority table |
| title | String | Title at the top of the dashboard |
| comment | String | Comment to display under the title |
| icon | String | Icon name to show on the dashboard |
| icon_font | String | See the Icon Font list in the README.md |
| call | Boolean | True to show the Emergency Call button, which would allow a user to call people who have the alert texting permission 'I live here' or call the Emergency Call Center |
| ecc | Boolean | True to show the Emergency Call Center as an option to call inside the menu that comes up for the Emergency Call button |
| updated_ms | int | Timestamp in milliseconds when this dashboard header was updated. Use this absolute time to render UI information like "38 seconds ago" or "2 hours ago" on the dashboard of the app. |
| resolution | JSON Object | See the Resolution Data Structure table |
| feedback | JSON Object | See the Feedback Data Structure table |

### Priority
| Dashboard Priority | Definition         | Color Recommendation | Description |
| ------------------ | ------------------ | -------------------- | ------------------
| 0                  | Empty              | Light gray           | Generally ignore this location, this isn't a paying user and not where we should be spending our time. |
| 1                  | Okay               | Green                | Everything is running fine. People are good, infrastructure is good. Green, happy colors on the dashboard. |
| 2                  | Learning           | Green or Blue        | Everything is running, but don't expect everything to work 100% yet. We're still learning. |
| 3                  | Incomplete Install | Gray                 | This person has not fully set up their pack, pay a little more attention. |
| 4                  | System Problem     | Orange               | Attention is needed on the infrastructure of this home's installation, something is wrong with the devices. |
| 5                  | Subjective Warning | Orange               | Something seems off with the behavioral patterns or trends of the occupants of this home, human attention is needed to see if it is really a problem. |
| 6                  | Critical Alert     | Red                  | A critical alert is happening live in this home. Immediate attention needed. |

### Resolution Data Structure
If populated in the dashboard header, the `resolution` object allows the app to send user-selectable information back into the bot.

| Property | Type | Description |
| -------- | ---- | ----------- |
| button | String | Name of the button to show on the screen, like "RESOLVE >" |
| title | String | Title of the action sheet that pops up in the app after the user presses the button. |
| datastream_address | String | Name of the data stream address to send a message back into, with the app-assembled content based on the merger of `resolution.content` and `resolution.{response_option}.content` fields. |
| resolution.content | JSON Dictionary | Specifying `resolution.content` to avoid confusion with `resolution.{response_option}.content`. The `content` field in the base `resolution` object contains some static information that MUST be included in the data stream message sent back to the bots in this location. You will merge the `resolution.content` with additional content from the user's response option selection, and form a single dictionary of content to send back into the bot. |
| response_options | Ordered List | List of response options to show the user inside an action sheet. |
| {response_option}.text | String | Text to show on the pop-up action sheet button for this option. |
| {response_option}.ack | String | When the user selects this option, change the dashboard header's `comment` field to this text while the bot does its processing in the background to update the dashboard header in a moment. |
| {response_option}.icon | String | Icon to show on the dashboard when the user selects this option. |
| {response_option}.icon_font | String | Icon font for the icon on the dashboard when the user selects this option. |
| {response_option}.content | JSON Dictionary | When the user selects this option, merge this key/value dictionary content with the `resolution.content` content to form the content for a data stream message, to be delivered back to the location and its bots via data stream message to the `datastream_address` address. |

### Feedback Data Structure
Asking for user feedback is optional, but very useful to see how our bots and services are doing. The bots decide whether they want the mobile app to ask for feedback after the user selects some response option in the app. Note that if an alert is handled via SMS or some other mechanism, the bots may ask for feedback independently over SMS, and this has its own probability associated with it.

If the `feedback` object exists in the dashboard header content, we only ask for feedback when the user selects a response option from the `resolution` object.

We collect both *quantified* and *qualified* feedback from the user.
* Quantified feedback : 0 = thumbs-down; 1 = thumbs-up
* Qualified feedback : This is also known as *verbatim* feedback.

Best practice is to show the question for the quantified feedback first with a thumbs-up or thumbs-down icon. After the user selects the thumbs-up or thumbs-down, then reveal the verbatim question and open-ended text field to provide feedback.

| Property | Type | Description |
| -------- | ---- | ----------- |
| quantified | String | Framed question to ask the user for quantified feedback, like "Did we do a good job handling the fall detection alert at 3:36 PM?" |
| verbatim | String | Framed question to ask the user for qualified feedback, like "What do you think caused the alert?" |
| datastream_address | String | Data stream address to deliver the feedback content back to |
| content | JSON Dictionary | This is the content you'll pass back as the content in the data stream message. Keep any existing key/value content that is already available here, and add to it the user captured values for `quantified`, `verbatim`, and the `user_id` so we know who provided this feedback. |


## Inputs

Data Stream Address : `update_dashboard_header`

The dashboard header is typically managed internally by bots, but allows an external data stream message so multiple bots can influence the content that is shown on the dashboard.

### Content
You can provide the content you see in the state variable below.
* Populating the data stream message content will create or update the dashboard. The highest priority dashboard header content will be selected for display.
* Leaving the data stream message content blank will refresh the dashboard, and do nothing else.
* Including the name but no additional content (except for the future_timestamp_ms) will delete the dashboard header content. If you specify a `future_timestamp_ms` field, then this dashboard header content will automatically be deleted at that absolute future timestamp.

## Outputs

State Variable : `dashboard_header`

#### Content
Anything marked "Internal Usage" is not meant to be used by the application UI's, but may exist in the object to help bots manage this content.
```
    {
        # Unique identifying name
        "name": name,

        # Priority of this dashboard header, which dictates color
        "priority": priority,

        # Title at the top of the dashboard
        "title": title,

        # Comment to display under the title
        "comment": comment,

        # Icon
        "icon": icon,

        # Icon font package
        "icon_font": icon_font,

        # Auto-Populated by a Conversation: True to show the emergency call button
        "call": False,

        # If the emergency call button is present, this flag allows the user to contact the emergency call center.
        "ecc": False,

        # Question ID for the resolution question
        "resolution": {
            "question": "CHANGE STATUS >",

            # Title at the top of the action sheet
            "title": "Change Status",

            # To answer this question, send a data stream message to this address ...
            "datastream_address": "conversation_resolved",

            # ... and include this content merged with the 'content' from the selected option
            "content": {
                "microservice_id": "26e636d2-c9e6-4caa-a2dc-a9738505c9f2",
                "conversation_id": "68554d0f-da4a-408c-80fb-0c8f60b0ebc3",
            }

            # The options are already ordered by virtue of being in a list.
            "response_options": [
                {
                    "text": "Resolved",
                    "ack": "Okay, resolving the notification...",
                    "icon": "thumbs-up",
                    "icon_font": "far",
                    "content": {
                        "answer": 0
                    },
                },
                {
                    "text": "False Alarm",
                    "ack": "Okay, marking this a false alarm...",
                    "icon": "thumbs-up",
                    "icon_font": "far",
                    "content": {
                        "answer": 1
                    },
                }
            ]
        },

        # Question IDs for feedback
        "feedback": {
            # Question for quantified thumbs-up / thumbs-down feedback
            "quantified": "Did we do a good job?",

            # Question for the open-ended text box
            "verbatim": "What do you think caused the alert?",

            # To answer this question, send a data stream message to this address ...
            "datastream_address": "conversation_feedback_quantified",

            # ... and include this content - you fill in the 'quantified', 'verbatim', and optional 'user_id' fields.
            "content": {
                "microservice_id": "26e636d2-c9e6-4caa-a2dc-a9738505c9f2",
                "conversation_id": "68554d0f-da4a-408c-80fb-0c8f60b0ebc3",

                # You'll fill these fields out in the app.
                "quantified": <0=bad; 1=good>,
                "verbatim": "Open-ended text field.",
                "user_id": 1234
            }
        },

        # Internal usage: Future timestamp to apply this header
        "future_timestamp_ms": <timestamp in milliseconds>

        # Internal usage only: Conversation object reference, so we don't keep a dashboard header around for a conversation that expired.
        "conversation_object": <conversation_object>,

        # Internal usage only: Percentage good, to help rank two identical priority headers against each other. Lower percentages get shown first because they're not good.
        "percent": <0-100 weight>
    }
```

### Working Example

A fall is detected. The `dashboard_header` state variable is updated with the JSON content below. As the conversation plays out, this `dashboard_header` state variable will continue to get refreshed with the latest updates.

The app should use [WebSocket APIs](https://github.com/peoplepower/peoplepower-docs/blob/master/platform_apis/websockets.md) to subscribe to receive updates to the `dashboard_header` state variable. A more primitive method for testing or early development would be to periodically (poll for the state variable)[https://iotapps.docs.apiary.io/reference/synthetic-apis/states/get-state].

```
{
  "value": {
    "call": true,
    "comment": "'Office' detected a fall.",
    "ecc": true,
    "feedback": {
      "content": {
        "microservice_id": "61ab3699-6fce-41d3-9bf5-4e98ce054ddf"
      },
      "datastream_address": "conversation_feedback",
      "quantified": "Did People Power Family do a good job?",
      "verbatim": "What do you think caused the alert?"
    },
    "icon": "exclamation-circle",
    "icon_font": "far",
    "name": "fall_detection",
    "priority": 6,
    "resolution": {
      "button": "UPDATE STATUS >",
      "content": {
        "conversation_id": "59f7de56-8d86-4060-a7ac-2be6996a1199",
        "microservice_id": "61ab3699-6fce-41d3-9bf5-4e98ce054ddf"
      },
      "datastream_address": "conversation_resolved",
      "response_options": [
        {
          "ack": "Thanks! Marking this problem resolved...",
          "content": {
            "answer": 0
          },
          "icon": "check-circle",
          "icon_font": "far",
          "text": "Resolved"
        },
        {
          "ack": "Marking this a false alarm.\nSorry about that.",
          "content": {
            "answer": 1
          },
          "icon": "comment-times",
          "icon_font": "far",
          "text": "False Alarm"
        }
      ],
      "title": "Update Status"
    },
    "title": "Help needed!",
    "updated_ms": 1622824386686
  }
}

```

* `title` = "Help needed!"
* `comment` = Detailed text under the title, "'Office' detected a fall."
* `icon` = "exclamation-circle" using FontAwesome Regular (far), in red because priority = 6 which indicates critical (see the [Priority](#priority) color recommendations table above).

#### Call

The field `call` is set to True. Therefore, the app should show a button that brings up an action sheet (or some UI method) with a list of people in the Trusted Circle who live at this location. Selecting one of these contacts should place a phone call on this user's phone.

We also see `ecc` is True, so we can also recommend triggering the emergency call center as one of the contacts. This will not call the emergency call center directly from your phone, so it is recommended that the app update its own dashboard or provide a confirmation about what will happen next: the emergency call center will back, in the order of the people listed on the predefined call tree in the app. The app must send a data stream message to the address `contact_ecc`. The feed content in the data stream message should contain the `user_id`.

This data stream message to trigger the emergency call center only works during an active problem / conversation, so it is not documented as a general Synthetic API to trigger emergency help. (If you want to request help at any random time from an app or voice UI, check out [Request Assistance](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/request_assistance.md)).

Data Stream Address: `contact_ecc`

Data Stream Content:
```
{
  "feed": {
    "user_id": 12345
  }
}
```


#### Resolution

The `resolution` object is populated in the example above, so we show a button in the app that says "UPDATE STATUS >" (as defined by the `button` field in the resolution object). Pressing this button should bring up an action sheet titled 'Update Status' (`title` field) containing two options defined in the `response_options` ordered list from the example above: "Resolved" and "False Alarm".

When a user selects a response option, the app does two things:
1. Craft a data stream message back to the location, which gets picked up by a bot.
2. Acknowledge the selection to the user.

The data stream message is sent to the address defined in the `resolution.datastream_address` field. In this example, the address is "conversation_resolved".

The feed content of the data stream message must be assembled by the app. It is a union of the `resolution.content` dictionary with the `resolution.response_options[#].content` dictionary. Even though it is not asked for explicitly in the dashboard_header JSON content, it's strongly recommended to include a `user_id` field in all of these dynamic data stream messages as well.

If the user selected "Resolved", then the app would send this data stream message:

Data Stream Address: "conversation_resolved" (as defined in the `resolution.datastream_address` field)

Data Stream Content (exclude comments of course):
```
{
  "feed": {
     # Resolution static content in resolution.content
     "conversation_id": "59f7de56-8d86-4060-a7ac-2be6996a1199",
     "microservice_id": "61ab3699-6fce-41d3-9bf5-4e98ce054ddf",
     
     # All of the response object dynamic content in resolution.response_options[#].content
     "answer": 0,
     
     # Recommended user ID field
     "user_id": 12345
  }
}
```

It will take a moment for the API call to deliver the data stream message, and for the bot to respond with an update to the `dashboard_header` via WebSocket. In the meantime, we need to provide the user with an acknowledgment that their response was captured. The app should update its local dashboard to show the acknowledgment details provided in the selected response option:
* `icon` = "check-circle" using FontAwesome Regular (far)
* We recommend replacing the previous title with the content in the `ack`, and deleting the detailed text comment.


#### Feedback

The `feedback` object is populated in the example above, so the app should request feedback from the user after the user resolves the problem inside the app. Best practice is to pop up a nice dialog which the user can probably tap outside of to make it go away. Show the `quantified` question first with a thumbs-up / thumbs-down icon. When the user selects a thumbs-up / thumbs-down, then reveal the `verbatim` question with an open-ended text field and Done button to submit.

The design and data stream interaction for the `feedback` object is similar to the `resolution` object. We are going to capture user feedback and craft a dynamic data stream message back to the location and its bots. Since the JSON content does not explicitly request it, the app developer needs to manually assemble the correct fields for the feedback data stream message.

This data stream message is only available while a problem / conversation is active, so this feedback data stream message is not documented as a formal always-available Synthetic API.

Data Stream Address: "conversation_feedback" (as defined by the `feedback.datastream_address` field)

Data Stream Content (exclude comments of course):

```
{
  "feed": {
     # Echo back everything found in `feedback.content`
     "microservice_id": "61ab3699-6fce-41d3-9bf5-4e98ce054ddf",

     # 0 = thumbs-down; 1 = thumbs-up
     "quantified": 1,

     # Open-ended text content from verbatim feedback
     "verbatim": "Great job. Thanks!",

     # Recommended User ID
     "user_id": 12345
  }
}
```


## References
* `com.ppc.BotProprietary/signals/dashboard.py`
* `com.ppc.Microservices/intelligence/dashboard/location_dashboardheader_microservice.py`
