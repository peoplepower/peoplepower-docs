# Event Streaming

People Power's platform is capable of streaming events, subscription information, and insights into a partner's platform.
There are several mechanisms available to stream data into a partner's platform including tools like AWS SQS, AWS EventBridge, Kafka, and others.
This document will capture information about some of the data formats of information available to stream from the People Power platform.

| Data Type | Description |
| :-------: | ----------- |
| 1 | [Location Narrative](#narrative-event-streaming) |
| 2 | [Organization Narrative](#narrative-event-streaming) |
| 3 | [Location State](#location-state-streaming) |
| 4 | [Paid Services Event](#paid-events-streaming) |
| 5 | [Location Time-Series State](#location-state-streaming) |
| 6 | [Device Parameters](#device-parameters-streaming) |
| 7 | [Bot Error](#bot-errors-streaming) |

| Operation | Description |
| :-------: | ----------- |
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
  "locationExternalId": string, // Location external ID
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


## Narrative Event Streaming

Narratives are time-series information produced by bots. They can be machine-readable (such as analytics) or human-readable.

Note that Narratives can be updated (see the `data.operation` field). The narrative title is typically human-readable, except in the case of analytic narratives (priority=-1) where the title is intended to be machine-readable.

See additional Narrative documentation here: https://iotapps.docs.apiary.io/#reference/locations/narratives

| Priority | Description |
| :------: | ----------- |
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
  "locationExternalId": string, // Location external ID
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


## Location State Streaming

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
  "locationExternalId": string, // Location external ID
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


## Paid Events Streaming

| Event Type | Description |
| :--------: | ----------- |
| 1 | Subscription Created |
| 2 | Billing Attempt Success |
| 3 | Billing Attempt Failure |
| 4 | Subscription Canceled |
| 5 | Subscription Update |
| 6 | Subscription Expired |


#### General Structure for all paid events

```
{
  "timestamp" : long int,       // current time in milliseconds 
  "cloudname": string,          // 'SBOX', 'Prod' 
  "organizationId": int,        // Organization ID if available
  "parentOrganizationId": int,  // Parent Organization ID if available
  "data": { 
    "type": byte,               // 4 = paid event
    "operation": byte,          // 1 = create
    "paidEvent": {
        "eventType": byte,      // 1 = subscription created, 2 = billing attempt success, 3 = billing attempt failure, 4 = subscription canceled, 5 = subscription update, 6 = subscription expired
        "eventTime": long int,  // when the event created in the store in milliseconds
        "eventDate": string,    // ISO-8601 date time with UTC timezone, 2021-08-20T12:09:15Z
        "subscriptionId": string // subscription ID made as store subscription ID + store sub-domain name, e.g. "123@test-store"
        "startTime": long int,  // subscription billing period start time
        "startDate": string,    // ISO-8601 date time with UTC timezone, 2021-08-20T12:09:15Z
        "endTime": long int,    // subscription billing period end time
        "endDate": string,      // ISO-8601 date time with UTC timezone, 2021-08-20T12:09:15Z
        "transactionId": string, // financial transaction ID
        "orderId": string,      // store order ID
        "planId": int,          // service plan ID
        "planName": string,     // service plan name
        "priceId": int,         // plan price ID
        "userPlanId": int,      // assigned on location service plan instance ID
        "locationId": int,      // location ID
        "paymentType": byte,    // 5 = Shopify
        "subscriptionType": byte, // 1 = one time, 3 = monthly, 4 = annual, 5 = daily
        "customer": {           // user's data received from the store
            "email": string,
            "firstName" : string,
            "lastName" : string,
            "phone": string     // optional
        },
        "errorMessage": string, // Shopify error message
        "errorCode": string     // Shopify error code, see https://shopify.dev/api/admin/graphql/reference/orders/subscriptionbillingattempterrorcode
    }
}
```

#### Subscription created

```
{
  "timestamp" : 1619644463123,
  "cloudname": "SBOX",
  "data": { 
    "type": 4,
    "operation": 1,
    "paidEvent": {
        "eventType": 1,
        "eventTime": 1619644463123,
        "eventDate": "2021-08-20T12:09:15Z",
        "subscriptionId": "123@test-store",
        "startTime": 1625097600000,
        "startDate": "2021-08-20T12:09:15Z",
        "endTime": 1625097600000,
        "endDate": "2021-09-21T00:00:00Z",
        "transactionId": "4569847984375943853",
        "orderId": "12345645645645",
        "planId": 11,
        "planName": "Home",
        "priceId": 12,
        "paymentType": 5,
        "subscriptionType": 3,
        "customer": {
            "email": "test@test.test",
            "firstName" : "First",
            "lastName" : "Last",
            "phone": "1234567890"
        }
    }
}
```

#### Billing success

```
{ 
  "timestamp" : 1619644463123,
  "cloudname": "SBOX",
  "organizationId": 123,
  "parentOrganizationId": 456,
  "data": { 
    "type": 4,
    "operation": 1,
    "paidEvent": {
        "eventType": 2,
        "eventTime": 1619644463123,
        "eventDate": "2021-08-20T12:09:15Z",
        "subscriptionId": "123@test-store",
        "startTime": 1625097600000,
        "startDate": "2021-08-20T00:00:00Z",
        "endTime": 1625097600000,
        "endDate": "2021-09-21T00:00:00Z",
        "transactionId": "4569847984375943853",
        "planId": 11,
        "planName": "Home",
        "priceId": 12,
        "userPlanId": 56789,
        "paymentType": 5,
        "subscriptionType": 3,
        "locationId": 8901
    }
}
```

#### Billing attempt failure

```
{ 
  "timestamp" : 1619644463123,
  "cloudname": "SBOX",
  "organizationId": 123,
  "parentOrganizationId": 456,
  "data": { 
    "type": 4,
    "operation": 1,
    "paidEvent": {
        "eventType": 3,
        "eventTime": 1619644463123,
        "eventDate": "2021-08-20T12:09:15Z",
        "subscriptionId": "123@test-store",
        "planId": 11,
        "planName": "Home",
        "priceId": 12,
        "userPlanId": 56789,
        "locationId": 8901,
        "paymentType": 5,
        "subscriptionType": 3,
        "errorMessage": "Payment method is expired",
        "errorCode": "EXPIRED_PAYMENT_METHOD"
    }
}
```

#### Subscription canceled

```
{ 
  "timestamp" : 1619644463123,
  "cloudname": "SBOX",
  "organizationId": 123,
  "parentOrganizationId": 456,
  "data": { 
    "type": 4,
    "operation": 1,
    "paidEvent": {
        "eventType": 4,
        "eventTime": 1619644463123,
        "eventDate": "2021-08-20T12:09:15Z",
        "subscriptionId": "123@test-store",
        "planId": 11,
        "planName": "Home",
        "priceId": 12,
        "userPlanId": 56789,
        "locationId": 8901,
        "paymentType": 5,
        "subscriptionType": 3
    }
}
```

#### Subscription update

```
{ 
  "timestamp" : 1619644463123,
  "cloudname": "SBOX",
  "organizationId": 123,
  "parentOrganizationId": 456,
  "data": { 
    "type": 5,
    "operation": 1,
    "paidEvent": {
        "eventType": 5,
        "eventTime": 1619644463123,
        "eventDate": "2021-08-20T12:09:15Z",
        "subscriptionId": "123@test-store",
        "startTime": 1625097600000,
        "startDate": "2021-08-20T12:09:15Z",
        "endTime": 1625097600000,
        "endDate": "2021-09-21T00:00:00Z",
        "planId": 11, // new plan ID
        "planName": "Home",
        "priceId": 12, // new price ID
        "userPlanId": 56789,
        "locationId": 8901,
        "paymentType": 5,
        "subscriptionType": 3
    }
}
```

#### Subscription expired

```
{
  "timestamp" : 1619644463123,
  "cloudname": "SBOX",
  "organizationId": 123,
  "parentOrganizationId": 456,
  "data": { 
    "type": 6,
    "operation": 1,
    "paidEvent": {
        "eventType": 6,
        "eventTime": 1619644463123,
        "eventDate": "2021-08-20T12:09:15Z",
        "subscriptionId": "123@test-store",
        "startTime": 1625097600000,
        "startDate": "2021-07-13T00:00:00Z", // previous billing date of expired subscription
        "endTime": 1625097600000,
        "endDate": "2021-08-13T00:00:00Z",
        "planId": 11,
        "planName": "Quil Home",
        "priceId": 12,
        "userPlanId": 56789,
        "locationId": 8901,
        "paymentType": 5,
        "subscriptionType": 3
    }
}
```


## Device Parameters Streaming

Streaming device parameters can cause publishing significant amount of data.


#### Device Parameters JSON Formatting

```
{ 
  "timestamp": long int,        // current time in milliseconds
  "cloudname": string,          // 'SBOX', 'Prod'
  "organizationId": int,        // Organization ID
  "parentOrganizationId": int,  // Parent Organization ID
  "data" : { 
    "type": byte,               // 6 - device parameters
    "operation": byte,          // 1 – create
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


## Bot Errors Streaming

People Power's platform can stream error messages produced by bots during execution.


#### Bot Errors JSON Formatting

```
{ 
  "timestamp": long int,        // current time in milliseconds
  "cloudname": string,          // 'SBOX', 'Prod'
  "organizationId": int,        // Organization ID
  "parentOrganizationId": int,  // Parent Organization ID
  "data" : { 
    "type": byte,               // 7 - bot error
    "operation": byte,          // 1 – create
    "botError": {
      "bundle": string,         // bot bundle name
      "version": string,        // bot version
      "appInstanceId": int,     // bot instance ID
      "locationId": int,        // location ID for location bots
      "organizationId": int,    // organization ID for organization bots
      "error": string,          // error message
      "log": string             // bot execution log
    }
  }
}
```
