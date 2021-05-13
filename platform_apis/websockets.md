# WebSocket Application API

## Get the WebSocket URL

Each time the client starts a new WebSocket session, it must obtain its WebSocket API server connection settings and URL by calling the [Get Server Instance API](https://iotapps.docs.apiary.io/#reference/cloud-connectivity/server-instances/get-server) with `type=wsapi`.

## Ping / Pong

Ping / pongs are used to keep the WebSocket connection alive.

* **Ping** is the one-character text message "?"
* **Pong** is the one-character text message "!"

Both the client and the server are responsible for pinging and ponging:
* The client should ping the server with a 15-30 second periodicity. If no pong is received, the client should recreate the WebSocket connection, possibly with another server.
* The server will ping the client, and you are responsible for sending back a pong. If the server does not hear a pong, it will close the connection.

Note that the ping and pong characters are not wrapped in a JSON format - they are simply one-character messages sent over the WebSocket.


## Data Structure Architecture

JSON is used for all requests and responses.

#### Common Properties
| Property | Type | Description |
| -------- | ---- | ----------- |
| id       | String | Mandatory. Every request or subscription has a unique 'id' field. The server will return the same `id` value in each response related to this subscription so the client will be able to identify what to do with the data. |
| goal     | int | Mandatory. The type of request or response. See the Goals table. |
| key      | String | API key used during authentication. |
| resultCode | int | Response from the server. See the Application API [Result Codes](https://iotapps.docs.apiary.io/introduction/result-codes-and-error-messages/result-codes). |
| resultCodeMessage | String | Describes any error that occurred. |

#### Goals
Setting a `goal` for each WebSocket JSON message tells the server or client what to do.

| `goal` value | Name | Description |
| ------------ | ---- | ----------- |
| 1 | auth | WebSocket session authentication |
| 2 | presence | Check the availability of WebSocket data subscriptions |
| 3 | subscribe | Subscribe to specific WebSocket data |
| 4 | unsubscribe | Unsubscribe from a single WebSocket data subscription |
| 5 | status | Get the status of the session, including the current WebSocket data subscriptions |
| 6 | data | New data from the server related to one of your current WebSocket data subscriptions |

#### Types

These are the supported WebSocket subscription types

| `type` value | Description |
| ------------ | ----------- |
| 1 | Location narrative updates (history being added by bots) |
| 2 | Organization narrative updates (admin-visible alerts and community history added by bots) |
| 3 | Location `state` variable updates from [Synthetic APIs](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis) |

#### Operations

The client can subscribe on specific actions being performed to the data object. The operation field is a *bitmask* of possible actions between 1 to 7.

| `operation` int value | `operation` hex value | Description |
| --------------------- | --------------------- | ----------- |
| 1 | 0x1 | Create |
| 2 | 0x2 | Update |
| 4 | 0x4 | Delete |

### Request example:
```
{
    "goal": 1,
    "id": "unique request ID",
    ...
}
```

### Response example:
```
{
    "goal": 1,
    "id": "replied request ID",
    "resultCode": 0,
    "resultCodeMessage": "Error Message",
    ...
}
```

## Authenticate

The initial authentication request must include the `"key"` field, which contains the `API_KEY` of the user. The client must already be authenticated and retrieve the API key using the [Login API](https://iotapps.docs.apiary.io/#reference/login-and-logout/login).

When the server authenticates the user, it will define the scope of the session based on the API key type and return success or an error response.

#### Authentication request example
```
{
  "goal": 1,
  "key": "API_KEY",
  "id": "1",
}
```

#### Authentication response example
Successful response:
```
{
  "resultCode": 0,
  "id": "1",
  "goal": 1   
}
```

Unsuccessful response:
```
{
  "resultCode": 2,
  "resultCodeMessage": "Wrong API key",
  "id": "1",
  "goal": 1
}
```

## Presence

*What WebSocket data subscriptions are available?*

The server will return supported subscription types based on the session scope.

#### Presence response example

```
{
  "goal": 2,
  "id": "2",
  "resultCode": 0,
  "types": [
    1,
    2
  ]
}
```

## Status

*What is the current status of my WebSocket data subscriptions?*

The server will return information about the current session.

#### Status response example
```
{
  "goal": 5,
  "id": "5",
  "resultCode": 0,
  "subscriptions": [
    {
      "requestId": "request ID, which made this subscription",
      "id": 123,
      "type": 1,
      "operation": 7,
      "locationId": 456,
      "priority": 1
    }
  ]
}
```

## Subscribe

*How can I subscribe to events and changes being made to data on the server?*

The client can subscribe to events and data changes (create, update, delete) happening on the server.

The client can have only one subscription with similar parameters. A new subscription request can logically absorb the previously created subscriptions if it subscribes to a wider range of data of the same kind. In this case, the old subscription will be replaced.

To subscribe to a data model, the client sends a request with the goal "subscribe" and the subscription options. After approval, the server starts sending messages to the client containing data objects matching the subscription options. Both the `type` and `operation` are sent to the client in the data object when an event occurs.

See the 'Types' and 'Operations' tables at the top of this document for more information about specific values. 


#### Example: Subscribe to Narratives

Read about the subscription parameters in the [GET Narratives API](https://iotapps.docs.apiary.io/#reference/locations/narratives/get-narratives) documentation.

```
{
  "goal": 3,
  "id": "3",
  "subscription": {
    "type": 2,
    "operation": 7,
    "organizationId": 316, // required for organization narratives
    "locationId": 123,     // required for location narratives, optional for organization narratives
    // optional fields
    "groupId": 12,
    "priority": 0,
    "priorityTo": 2
  }
}
```

#### Example: Subscribe to Synthetic API state variables

Request:
```
{
  "goal": 3,
  "id": "3",
  "subscription": {
    "type": 3,
    "operation": 3,
    "locationId": 123,
    "name": "dashboard_header"
  }
}
```

Successful Response:
```
{
  "resultCode": 0,
  "goal": 3,
  "id": "3",
  "subscriptionId": 2
}
```

## Unsubscribe

*The user tapped into a different part of the app, how do I stop receiving data?*

#### Unsubscribe example

```
{
  "goal": 4,
  "id": "4",
  "subscription": {
    "id": 2
  }
}
```

## Receiving Data

When the server receives any changes in data that a client is subscribed to, the server will send a WebSocket message to the client. A message always contains a single type of data that was created, updated, or deleted.

The received message will contain the same "id" as at initial subscription request. The data field contains a data structure corresponding to the data type. Internal JSON data fields are flexible and include sub-objects and arrays.

#### Example: Narrative (history) updated

```
{
  "resultCode": 0,
  "id": "subscription request ID",
  "goal": 6,
  "data": {
    "type": 1,
    "operation": 1,
    "narrative": {
      "id": 123,
      "locationId": 1,
      "organizationId": 2,
      "narrativeDateMs": 1537692964000,
      "creationDateMs": 1537692964000,
      "appInstanceId": 123,
      "priority": 1,
      "status": 1,
      "icon": "alert",
      "title": "Water Leak",
      "description": "Water leak in the bathroom",
      "target": {
        "field": "value"
      }
    }
  }
}
```

#### Example: Synthetic API state variable updated

```
{
  "resultCode": 0,
  "id": "subscription request ID",
  "goal": 6,
  "data": {
    "type": 3,
    "operation": 1,
    "locationState": {
      "locationId": 123,
      "name": "dashboard_header",
      "value":   "value": {
        "comment": "Occupants appear to be asleep.",
        "icon": "bed",
        "icon_font": "far",
        "name": "occupancy",
        "priority": 1,
        "title": "Likely Sleeping",
        "updated_ms": 1620630427464
      }
    }
  }
}
```

