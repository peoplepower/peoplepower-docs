# Synthetic API: Narrate

Capture history into the Narratives. Useful with multistream messages and communications to end-users.

Follows most of the `narrate()` method arguments provided by the botengine.

#### Properties
| Property | Type | Description |
| -------- | ---- | ----------- |
| title | String | Title of the narrative |
| description | String | Narrative body |
| priority | int | -1 = analytic; 0 = detail; 1 = info; 2 = warning; 3 = critical |
| icon | String | Icon name |
| icon_font | String | Icon font package |
| extra_json_dict | JSON Content | Extra JSON content to log in the narrative with key/value pairs. |
| to_user | Boolean | True to log this narrative for the location itself, viewable by end-users. |
| to_admin | Boolean | True to log this narrative into the organization, viewable by administrators. |

These `extra_json_dict` keys are typically recognized by the application layer:
* device_id
* goal_id (behavior ID)
* rule_id

## Inputs

Data Stream Address : `narrate`

#### Content

The content of this data stream message is any combination of the **Properties** above, as if you are calling the `narrate()` method in our bot architecture and passing in arguments.

