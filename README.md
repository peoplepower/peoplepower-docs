# People Power Documentation

This repository contains documents and references to documents that will help developers create new apps, devices, and services on the People Power AI+IoT Platform.

### [Platform APIs](platform_apis/README.md)

These APIs are provided by the AI+IoT platform itself, including APIs for applications, devices, and administrators. The AI+IoT Platform is capable of responding to role-based access API calls as well as streaming events and observations to partner clouds.

### [Synthetic APIs](synthetic_apis/README.md)

Synthetic APIs are provided by the *bot application layer*, on top of the platform. Synthetic APIs effectively allow bot and UI developers to invent new application features beyond what the AI+IoT platform offers alone. You can create your own application APIs on this platform, with bots.

These asynchronous APIs offered by bot application developers leverage `data stream messages` to communicate data into the bot, and `state` variables to communicate responses back from the bot. 

The Synthetic APIs we document here are for our most popular bot microservice packages that drive user interfaces.

### [Message Sequence Charts](message_sequence_charts/README.md)

Message Sequence Charts include documentation on how clients work, including mobile apps. These may include voice UI's, web consoles, and other complex interactions in the future.
