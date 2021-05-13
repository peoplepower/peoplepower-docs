# People Power AI+IoT Platform Documentation

All of the interactive *platform* documentation is updated and managed online. Please follow these links for more details.

## Application API
http://iotapps.docs.apiary.io

This documentation describes available APIs for mobile apps and web consoles. 

These Application APIs are primarily synchronous RESTful APIs, and WebSocket alternatives do exist for some APIs. The Application API primarily focuses on APIs for end-user applications, although some APIs can be called with an `ADMIN_API_KEY` to execute as an administrator of an organization.

In addition, there are several APIs toward the beginning of the documentation for devices, allowing them to understand which of the device servers they should communicate with in a cloud deployment composed of multiple device servers.

## WebSockets API

[WebSockets API Documentation](https://github.com/peoplepower/peoplepower-docs/blob/master/platform_apis/websockets.md)

Use WebSockets in some time-critical experiences (such as updating the UI with bot-driven [Synthetic APIs](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis) or displaying alerts on an administrative console), instead of polling with RESTful APIs.

## Administrative API
http://iotadmins.docs.apiary.io

This document captures admin-specific APIs that were not documented in the Application API. These APIs are primarily used by administrative command centers to manage people, places, and things.

## Device API
http://iotdevices.docs.apiary.io

This Device API is a set of asynchronous RESTful and WebSocket APIs that allow devices to communicate data to the server. Devices, identified by their globally unique IDs, first need to be understood through the definition of a *device type* on the server, and then need to be registered to a specific location before they can start communicating. 

In addition to People Power's Device API, the server also supports MQTT connections through AWS IoT Core. 

## Bot API
http://iotbots.docs.apiary.io

This is private bot API documentation for bot infrastructure developers. The APIs documented in this private area are implemented as software APIs inside the `botengine`. The documentation also describes the management and lifecycles of a bot.

Today, we link bots to subscriptions manually on the backend, and there are no APIs publicly or privately exposed to manage the definitions of these subscriptions. We rely on communications with our server team to define and manage the available subscription services in each organization.

