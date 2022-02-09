# Event Streaming

People Power's platform is capable of streaming events, subscription information, and insights into a partner's platform.
There are several mechanisms available to stream data into a partner's platform including tools like AWS SQS, AWS EventBridge, Kafka, and others.
This document will capture information about some of the data formats of information available to stream from the People Power platform.

| Data Type | Description |
| :-------: | ----------- |
| 1 | Location Narrative |
| 2 | Organization Narrative |
| 3 | Location State |
| 4 | Paid Services Event |
| 5 | Location Time-Series State |
| 6 | Device Parameters |
| 7 | Bot Error |

| Event Streaming Operation | Description |
| :-----------------------: | ----------- |
| 1 | Create |
| 2 | Update |
| 4 | Delete |


#### General Data Structure

```
{ 
  "timestamp": long int,        // current time in milliseconds
  "cloudname": string,          // 'SBOX', 'Prod'
  "organizationId": int,        // Organization ID
  "parentOrganizationId": int,  // Parent Organization ID
  "data" : { 
    "type": byte,               // data type
    "operation": byte,          // 1 – create, 2 – update, 4 – delete
    "locationId": int,          // Optional location ID if not included to specific object data field
    "narrative": {},            // Narrative data
    "locationState": {},        // Location state data
    "paidEvent": {},            // Paid services event data
    "params": [],               // Device parameters
    "botError": {}              // Bot error
  }
}
```


### Narrative Event Streaming

Narratives are time-series information produced by bots. They can be machine-readable (such as analytics) or human-readable.

Note that Narratives can be updated (see the `data.operation` field). The narrative title is typically human-readable, except in the case of analytic narratives (priority=-1) where the title is intended to be machine-readable.

See additional Narrative documentation here: https://iotapps.docs.apiary.io/#reference/locations/narratives

| Priority | Description |
| -------- | ----------- |
| -1 | Analytic, machine-readable narrative / analytic |
| 0 | Detail-level logging, human-readable narrative, usually with machine-readable `target` properties. |
| 1 | Info-level logging, human-readable narrative. Default for human-readable information. |
| 2 | Warning-level logging. |
| 3 | Critical-level logging. |


#### Narrative JSON Formatting

```
{ 
  "timestamp": long int,        // current time in milliseconds
  "cloudname": string,          // 'SBOX', 'Prod'
  "organizationId": int,        // Organization ID
  "parentOrganizationId": int,  // Parent Organization ID
  "data" : { 
    "type": byte,               // 1 - location narrative, 2 - organization narrative
    "operation": byte,          // 1 – create, 2 – update, 4 – delete
    "narrative": { 
      // narrative fields, many are optional 
      "narrativeId": int,       // auto generated ID, PK 
      "narrativeDate": long int, // part of a PK, can be different from creationDate, e.g. in the future
      "creationDate": long int, // creation time
      "locationId": int,        // location ID 
      "narrativeType": byte,    // 0 - default, 1 - deleted user, 2 - deleted location, 3 - location moved to another organization 
      "priority": byte,
      "status": byte,           // 0 - initial, 1 - deleted, 2 - resolved, 3 - reopened 
      "eventType": string,      // event type
      "appInstanceId": int,     // bot instance ID created this record, optional 
      "icon": string,           // 50 characters max 
      "iconFont": string,       // 50 characters max 
      "title": string,          // 250 characters max 
      "description": string,    // 1000 characters max 
      "target": {},             // flexible JSON structure with maximum serialized size of 10K characters 
      "organizationId": int,    // organization ID for organization narratives 
      "userId": int             // deleted user ID, populated when user is removed and downstream consumers should also purge user data 
    }
  }
}
```


### Location State Streaming

Location State variables are named objects with flexible structure set by bots or user apps for specific location.

Location Time-Series States are location states saved for specific timestamp.

See [Synthetic APIs](../synthetic_apis/README.md) for details.



#### Location State JSON Formatting

```
{ 
  "timestamp": long int,        // current time in milliseconds
  "cloudname": string,          // 'SBOX', 'Prod'
  "organizationId": int,        // Organization ID
  "parentOrganizationId": int,  // Parent Organization ID
  "data" : { 
    "type": byte,               // 3 - Location State, 5 - Location Time-Series State
    "operation": byte,          // 1 – create, 2 – update, 4 – delete
    "locationState": { 
      "locationId": int,        // location ID 
      "name": string,           // variable's name
      "stateDateMs": long int,  // timestamp of time-series state
      "value": {}               // flexible JSON structure
    }
  }
}
```


### Device Parameters Streaming

Streaming device parameters can cause publishing significant amount of data.


#### Device Parameters JSON Formatting

```
{ 
  "timestamp": long int,        // current time in milliseconds
  "cloudname": string,          // 'SBOX', 'Prod'
  "organizationId": int,        // Organization ID
  "parentOrganizationId": int,  // Parent Organization ID
  "data" : { 
    "type": byte,               // 3 - Location State, 5 - Location Time-Series State
    "operation": byte,          // 1 – create, 2 – update, 4 – delete
    "locationId": int,          // location ID 
    "params": [
      {
        "deviceId": string,     // device ID
        "name": string,         // parameter's name
        "index": string,        // optional index
        "group": string,        // optional parameter's group
        "value": string,        // measured or processed value
        "time": long int,       // measuring timestamp
        "updated": boolean      // flag if the value has been updated
      }
    ]
  }
}
```
