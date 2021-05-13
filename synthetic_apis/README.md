# Synthetic APIs

## Synthetic API Libraries

#### User Interfaces
+ [Dashboard Header](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/dashboard_header.md)
+ [Dashboard Status](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/dashboard_status.md)
+ [Services and Alerts](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/services.md)
+ [Daily Report](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/dailyreport.md)
+ [Trends](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/trends.md)
+ [Tasks](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/tasks.md)
+ [Emergencies](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/emergencies.md)

#### User Communications
+ [Multistream Messages](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/multistream.md)
+ [Message](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/message.md)
+ [Narrate](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/narrate.md)

#### Devices and Automations
+ [Behaviors](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/behaviors.md)
+ [Bot-driven Rules](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/rules.md)
+ [Vayyar Home](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/vayyar.md)

#### Energy Management
+ [Demand Response](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/demandresponse.md)
+ [Time-of-Use Pricing](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/toupricing.md)

## About
Synthetic APIs are provided by the *bot application layer*, on top of the platform. Synthetic APIs effectively allow bot and UI developers to invent new application features beyond what the AI+IoT platform offers alone. You can create your own application APIs on this platform, with bots.

These asynchronous APIs offered by bot application developers leverage `data stream messages` to communicate data into the bot, and `state` variables to communicate responses back from the bot. 

The Synthetic APIs we document here are for our most popular bot microservice packages that drive user interfaces. Not all Synthetic APIs have both inputs and outputs, but all offer some interaction with the bots.

## Inputs: Data Stream Messages

Bots receive messages from the outside world (and between microservices running inside the bot) via `data stream messages`. These messages have an address and arbitrary JSON content.

[Data Stream Message API Documentation](https://iotapps.docs.apiary.io/reference/synthetic-apis/data-stream-messages/send-message)

#### Properties of Data Stream Messages
* Bots and apps and other tools capable of making RESTful API calls can send data stream messages.
* Each data stream message contains an address and arbitrary JSON content.
* Each bot has to specify which data stream addresses it can receive messages for. Addresses can be populated in the bot's `runtime.json` files.
* Most data stream messages are distributed in the context of an individual location (`scope=1` if you're reading the API docs). 
* Bots within a location can communicate bi-directionally with organization bots operating at an administrative level (`scope=2` to send messages to the organization bots). 
* When messages are sent from an administrator or from an organization bot, they can be further addressed to be delivered to specific bot instance ID's or to specific location ID's.
* Data stream messages cannot send data or responses back instantaneously - they operate asynchronously. That's why we have a separate mechanism, `state` variables, to get data back out again.
* JSON content is arbitrary and agreed upon by app developers.

Mobile app developers can [get a list of data stream addresses](https://iotapps.docs.apiary.io/#reference/synthetic-apis/summary-of-capabilities/get-summary) to understand if the bots and services offer some set of capabilities.

#### Best practices for managing objects

In an implementation of a synchronous platform API for POST operations where the app would create an object on the server, developers would normally expect the platform to reply back with an ID of the object that was created. This, of course, allows you to edit or delete the content later.

But this kind of synchronous response isn't possible with a data stream message. Therefore, when object management is needed, a best practice is to have the app generate a unique ID for its own object and pass in this ID with the content. A UUID is an obvious choice for an app-generated unique ID for objects created and stored via Synthetic API.


## Outputs: State Variables

Bots can create `state` variables to provide data back out to applications or voice UI's. These state variables are stored in a way that can be accessed at any time through a RESTful API call or WebSocket.

[State Variable API Documentation](https://iotapps.docs.apiary.io/#reference/synthetic-apis/states/get-state)

#### Properties of State Variables
* Like data stream messages, state variables have an address and arbitrary JSON content.
* State variables are stored in the context of a location.
* A state variable can optionally have timestamps associated with its data, in the form of a `time-series state variable`.
* State variables are considered non-volatile memory and persist within the location, even if the bot that created it is destroyed. This can help the bot remember settings and configurations that happened in the past, without relying on the bot's internal memory which is tied to the existence of the bot.
* Apps can subscribe to multiple state variables simultaneously with WebSockets and get updated immediately as bots update the state variable content.
* JSON content is arbitrary and agreed upon by app developers.

Many times, state variables may contain extra JSON information that simply helps bots manage the objects contained within those variables.


## Icons

Both `icon` and `icon_font` are fields used throughout Synthetic APIs.

+ [FontAwesome icon fonts](https://fontawesome.com)
+ [People Power icon fonts](https://webmedia.peoplepowerco.com/icons/index.html)

| icon_font value | Description |
| --------------- | ----------- |
| far             | FontAwesome - Regular |
| fab             | FontAwesome - Bold |
| fal             | FontAwesome - Light |
| fas             | FontAwesome - Solid |
| iotr            | People Power - Regular |
| iotl            | People Power - Light |
| wir             | People Power Weather - Regular |
| wil             | People Power Weather - Light |



