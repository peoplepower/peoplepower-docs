# Synthetic API: User Activity

The mobile app can inform the bots about what a user is doing in the app right now, so that the bot can help track engagement and activities that may improve the user experience for this person.

The `event` field is required, and becomes the title of an analytic narrative. The `user_id` field is strongly recommended. The rest of the JSON content is arbitrary in nature, agreed upon by mobile app and bot developers to provide insights about what the user is doing and the type of device they're using.
 
Bots can use this information to identify the most engaged people in the Trusted Circle, identify problem areas in the app, debug issues, and prompt customer care to reach out and help.

## Input

Data Stream Address : `user_activity`

#### Feed Content Example
```
{
    'event': 'Exiting OOBE story',
    'user_id': '37146',
    'event_properties': {
        'modelId': 'devKeypad',
        'storyId': 'devKeypadConnection',
        'pageIndex': 0,
        'Data Categories': ['User', 'Location'],
        'Event Type': 'OOBE'
    },
    'platform': 'android',
    'device_id': '40a71f8f-5eac-4435-a231-fa8ea6606e39',
    'device_type': 'samsung SM-G981U1',
    'version': 'null',
    'library': 'Peoplepower-Analytics/1.0.0',
    'os': '11'
}
```

## References
* `com.ppc.Microservices/intelligence/user_activity/location_useractivity_microservice.py`
