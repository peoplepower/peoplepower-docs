# Event Streaming

People Power's platform is capable of streaming events, subscription information, and insights into a partner's platform. There are several mechanisms available to stream data into a partner's platform including tools like AWS EventBridge, Kafka, and others. This document will capture information about some of the data formats of information available to stream from the People Power platform.


### Narrative Event Streaming

Narratives are time-series information produced by bots. They can be machine-readable (such as analytics) or human-readable.

Note that Narratives can be updated (see the `data.operation` field). The narrative title is typically human-readable, except in the case of analytic narratives (priority=-1) where the title is intended to be machine-readable.

See additional Narrative documentation here: https://iotapps.docs.apiary.io/#reference/locations/narratives


| Event Streaming Type | Description |
| -------------------- | ----------- |
| 1 | Location Narrative |
| 2 | Organization Narrative |

| Event Streaming Operation | Description |
| ------------------------- | ----------- |
| 1 | Create |
| 2 | Update |
| 4 | Delete |

| Priority | Description |
| -------- | ----------- |
| -1 | Analytic, machine-readable narrative / analytic |
| 0 | Detail-level logging, human-readable narrative, usually with machine-readable `target` properties. |
| 1 | Info-level logging, human-readable narrative. Default for human-readable information. |
| 2 | Warning-level logging. |
| 3 | Critical-level logging. |


#### Example JSON Formatting

```
{ 

  timestamp : 1619644463123, // current time msecs 

  cloudname : "",            // 'SBOX', 'Prod' 

  data : { 

    type: 1, // data type: 1 – location narrative, 2 – organization narrative 

    operation: 1, // 1 – create, 2 – update, 4 – delete 

    narrative : { 

      // narrative fields, many are optional 

      narrativeId : 123,          // auto generated ID, PK 

      narrativeDate : "timestamp",// part of a PK, can be different from creationDate, serialized as long 

      eventType : “”,            // new field  

      creationDate : "timestamp",    

      appInstanceId : 0,         // bot instance ID created this record, optional 

      locationId : 0,            // location ID 

      narrativeType : 0,         // 0 - default, 1 - deleted user, 2 - deleted location, 3 - location moved to another organization 

      priority : 0,              // -1 : analytics , 0 debug , 1 info, 2 warning, 3 critical 

      status : 0,                // 0 - initial, 1 - deleted, 2 - resolved, 3 - reopened 

      icon : "",                 // 50 characters max 

      iconFont : "",             // 50 characters max 

      title : "",                // 250 characters max 

      description : "",          // 1000 characters max 

      target : {  }              // flexible JSON structure with maximum serialized size of 10K characters 

      organizationId : 0,        // organization ID for organization narratives 

      userId : 0                 // deleted user ID, populated when user is removed and downstream consumers should also purge user data 
    } 
  } 
} 
```