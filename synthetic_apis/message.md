# Synthetic API: Message

Communicate with users over push notification, SMS, and email.

This essentially implements the `notify()` method available to bots.

#### Properties
| Property | Type | Description |
| -------- | ---- | ----------- |
| push_content | String | Text to inject into a push notification |
| push_sound | String | Push notification sound |
| push_sms_fallback_content | String | When a push notification cannot be delivered because the user is not signed into the app, we can fail over to sending an SMS message and the SMS message content can be different than what we would have sent for a push notification. |
| email_subject | String | Subject line for an email | 
| email_content | String | Email content |
| email_html | Boolean | True if this is an HTML-formatted email |
| email_template_filename | String | Filename of the email template to send - must be uploaded to the server in advance. |
| email_template_model | JSON Content | Key/value pairs of information to replace elements inside the email template with content in the model. |
| sms_content | String | SMS content to deliver |
| sms_group_chat | Boolean | True to enable a group chat with all participants who will receive this message; False to not form a group chat and send this message individually to targeted participants (default is True). |
| brand | String | Brand name identifier to apply for email templates |
| user_id | int | Send this communication to the specified user ID |
| user_id_list | List | Send this communication to the list of user ID's [user_id_1, user_id_2, user_id_3]. Users must be in the Trusted Circle and have permissions to receive messages of this type. |
| to_residents | Boolean | True to send to residents who live in the home (default is True) |
| to_supporters | Boolean | True to send to family/friends outside of the home (default is False) |


#### Push notification sounds
Sound files must be pre-baked into the mobile app or siren. Use the full string as the sound, like "alarm.wav".

| Name | push_sound string |
| ---- | ---------- |
| Alarm | alarm.wav |
| Beep | beep.wav |
| Bell | bell.wav |
| Bird | bird.wav |
| Bling | bling.wav |
| Camera | camera_shutter.wav |
| Click | click.wav |
| Dog | dog.wav |
| Droid | droid.wav |
| Entry Delay | entry_delay.wav |
| Fully Armed | fullarmed.wav |
| Gun Cock | guncock.wav |
| Gun Shot | gunshot.wav |
| Lock | lock.wav |
| Phaser | phaser.wav |
| Pong | pong.wav |
| Silence | silence.wav |
| Toggle | toggle.wav |
| Trumpet | trumpet.wav |
| Warning | warning.wav |
| Whistle | whistle.wav |
| Whoops | whoops.wav |

## Inputs

Data Stream Address : `message`

#### Content

The content of this data stream message is any combination of the **Properties** above, as if you are calling the `notify()` method in our bot architecture and passing in arguments.

## References
* `com.ppc.Microservices/intelligence/messaging/location_messaging_microservice.py`
