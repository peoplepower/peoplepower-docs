# Synthetic API: Request Assistance

Enable mobile apps and smart speakers to request assistance for the user.

#### Properties

| Property | Type | Description |
| -------- | ---- | ----------- |
| type | int | Required. Type of assistance request, see the Types table. |
| agent | int | Preferred. Type of device that is making this request, so we can make a comment about the method used. |
| user_id | int | Optional. User ID that is making the request, if available. |

#### Types

| `type` value | Description |
| ------------ | ----------- |
| 0 | Emergency, like pressing a PERS button |
| 1 | Request assistance from people who live here. |
| 2 | Request assistance from anyone in the Trusted Circle. |

#### Agents

| `agent` value | Description |
| ------------- | ----------- |
| 0 | Request made from a mobile app. |
| 1 | Request made from a smart speaker. |

## Inputs

Data Stream Address: `request_assistance`

#### Example content

```
{
  "type": 0,
  "agent": 0,
  "user_id": 123456789
}
```

## References
* `com.ppc.BotProprietary/signals/request_assistance.py`
* `com.ppc.Microservices/intelligence/care/pers`

