# Synthetic API: Behaviors

Behaviors provide **context** in each device to assist with automations and intelligence.

For example, a `Temperature and Humidity Sensor` may be used to detect a mold or mildew, or identify someone is taking a shower, or help ensure your refrigerator is operating properly. An `Entry Sensor` may be installed on an exit door on the perimeter of the home, or attached to a medicine cabinet. Each of these options are defined by the behaviors offered by bot microservices that add intelligence to the everyday operation of each device.

Historically, the server originally had a concept of "goals" and objectives for each device, allowing the mobile app to specify a `goalId` which would dictate the set of if-then rules that were automatically created for a device. You can see this [Legacy Goals API Documentation Here](https://iotapps.docs.apiary.io/#reference/creating-products/device-goals/get-device-goals-by-type) if you're interested.

As we moved beyond the server-driven rules engine and into the world of bots for automation, we maintained the same `goalId` value for device instances but mapped them to behaviors offered by bots. This allows the context of the device to remain with the device instance itself, and not be lost if a bot disappears.

It is possible for bot developers to add their own behaviors to a device type, which will in turn make those behaviors available through the mobile app through the `behaviors` state variable.

Advantages of Behaviors:
* Completely bot-driven
* Easily updatable based on the current capabilities of the bot without performing SQL operations on the database
* Localizable
* Easily brandable
* Organized inside a dictionary by device type

## **Input** : Update Device API

[Update a Device](https://iotapps.docs.apiary.io/#reference/devices/manage-single-device/update-a-device) and specify its `goalId` to declare the behavior ID you wish for this device to take on. 

Bots will be notified with a `device_metadata_updated(...)` event that cause the bot to treat this device differently when its behavior or context changes. It is up to the bots running inside this location to apply the behavior at runtime.

## Output

State Variable : `behaviors`

#### Properties

| Property    | Description |
| ----------- | ----------- |
| Device Type | Each object is referenced by device type. When you add a new type of device, the bot will ensure behaviors are defined for it, and you can pull those behaviors out of the `behaviors` state variable based on the device type. |
| id          | This is the integer to inject into the device instance's `goalId` as the user applies this behavior to this device. See the Icon Font list in the README.md |
| icon_font   | The default font is from fontawesome.com 'regular' unless otherwise specified in an optional "icon_font" field |
| description | The text description of this behavior for this device. |
| name        | The title of this behavior |
| suggestions | Prioritized list of suggested names for each new device that selects this behavior. For example, when installing an Entry Sensor on an exit door, it is suggested that the first one be called 'Front Door', while the second Entry Sensor on an exit door be called 'Back/Side Door'. |
| weight      | Lower weights float to the top of the list. |
| spaces      | Prioritized list of multi-choice multi-select spaces to auto-select for each new sensor. For example, the first motion sensor should be installed in the Kitchen, so it is recommended that the app auto-select the 'Kitchen' space for this motion sensor. Note that a motion sensor can sometimes see multiple spaces, which is why that one is multi-choice multi-select. See the [Get Spaces API](https://iotapps.docs.apiary.io/#reference/locations/location-spaces/get-spaces) for a list of spaces to render in the app. |
| force_nickname | Optional. Default is False. If True, this tells the app to skip allowing the user to nickname the device and just force the next nickname in the list of suggestions. |
| subregions | List of compatible and recommended subregions for Vayyar Home behaviors. Defines a list of recommended subregions to create when a person selects this room for Vayyar Home. |

#### Subregion Object

The subregion object is added to the behaviors for Vayyar Home. As the behaviors for Vayyar Home specify the room to install in, the subregions recommend what subregions should be created if the user selects that room. 

After selecting a behavior, the user can be prompted to add a subregion. The subregion object describes the title and icon to show the user on the list of subregions to define, and links to a list of compatible subregion contexts to fulfill that subregion's objective.

| Property | Description |
| -------- | ----------- |
| title | Title to suggest to the user to add a subregion, like "Add a bed" |
| icon | Suggested icon to show nearby the title when prompting a user to add a subregion, like "bed". |
| icon_font | Icon font package to use, usually 'far' (fontawesome.com regular). |
| context_id_list | List of compatible context ID's for Vayyar Home that would fulfill this subregion's objectives. See the [Vayyar Home Documentation](https://github.com/peoplepower/peoplepower-docs/blob/master/synthetic_apis/vayyar.md) `vayyar_subregion_behaviors` for more details.

#### JSON Content

```
{
  "value": {
    "10014": [
      {
        "description": "Install this entry sensor on an exit door on the perimeter of the home to protect the home and help save energy. A security alarm can trigger when the door opens.",
        "icon": "home",
        "id": 0,
        "name": "Exit Door on the perimeter (default)",
        "suggestions": [
          "Front Door",
          "Back/Side Door",
          "Exit Door"
        ],
        "weight": 0
      },
      {
        "description": "Install the sensor on a medicine cabinet, drawer, or a container where medicine is stored. The History will record when this compartment was opened, helping track medication adherence.",
        "icon": "pills",
        "id": 8,
        "name": "Medicine Storage",
        "suggestions": [
          "Medicine Cabinet"
        ],
        "weight": 2
      },
      {
        "description": "Install the sensor on a refrigerator door. The History will record when the refrigerator was opened, helping track meal time activities.",
        "icon": "utensils",
        "id": 9,
        "name": "Refrigerator",
        "suggestions": [
          "Refrigerator"
        ],
        "weight": 3
      },
      {
        "description": "Install this entry sensor anywhere inside or outside of the home, but not on the perimeter. You can create your own rules. This will not automatically help save energy or protect the home. This will NOT trigger a security alarm if your door opens.",
        "icon": "mailbox",
        "id": 4,
        "name": "Install somewhere else",
        "suggestions": [],
        "weight": 4
      }
    ],
    "10019": [
      {
        "description": "Get mobile alerts anytime your Vibration Detect Sensor detects movement. Perfect for safes and valuables.",
        "icon": "hand-point-right",
        "icon_font": "far",
        "id": 20,
        "name": "Alert on every touch (default)",
        "suggestions": [
          "Vibration Sensor"
        ],
        "weight": 0
      },
      {
        "description": "Get mobile alerts anytime your Vibration Detect Sensor moves while you are AWAY, or when your home appears unoccupied.",
        "icon": "shield-check",
        "icon_font": "far",
        "id": 21,
        "name": "Alert if it moves while I'm away",
        "suggestions": [
          "Vibration Sensor"
        ],
        "weight": 1
      },
      {
        "description": "Attach the sensor to a window. Get mobile alerts anytime your Vibration Detect Sensor detects glass break while you are AWAY, or when your home appears unoccupied.",
        "icon": "window-frame",
        "icon_font": "far",
        "id": 5,
        "name": "Glass Break",
        "suggestions": [
          "Glass Break Sensor"
        ],
        "weight": 2
      },
      {
        "description": "Monitoring toileting behavior is important to caregivers of people at risk of dehydration, UTI's, diabetes issues, and more. Start by placing the Vibration Detect Sensor into a small plastic waterproof container or jar. If you're not certain about the reliability of the waterproof container, consider placing the Vibration Detect Sensor inside a re-sealable zipper platic bag and then into the waterproof container. Float the container in the upper water tank of the toilet. We find placing it near the handle area inside the tank works best, but you will need to experiment. If the floating container may interfere with the flap, consider attaching a string to the container and tying the other end of that string to something inside the tank to prevent the container from getting near the flap. When the toilet flushes, the drainage and movement of the water from the tank will be detected by the Touch Sensor and will register as a toilet flush.",
        "icon": "toilet",
        "icon_font": "far",
        "id": 22,
        "name": "Toilet Sensing (beta)",
        "suggestions": [
          "Toilet Sensor"
        ],
        "weight": 30
      }
    ],
    "10033": [
      {
        "description": "Place the temperature sensor in your house, or even your second home. Get alerted if your pipes are about to freeze or if your home is getting very hot.",
        "icon": "home",
        "id": 30,
        "name": "Monitor my home (default)",
        "suggestions": [
          "Temperature/Humidity Sensor"
        ],
        "weight": 0
      },
      {
        "description": "Place the temperature sensor in the refrigerator. It is said that the ideal temperature range for a refrigerator is 35-38\u00b0F / 2-4\u00b0C, but we know your refrigerator goes up and down a bit.  Get an alert if the fridge goes above 45\u00b0F / 7\u00b0C.  Maybe you left the door open for too long, or maybe you need to adjust that temperature dial in the fridge.",
        "icon": "temperature-low",
        "id": 32,
        "name": "Refrigerator",
        "suggestions": [
          "Refrigerator Temperature"
        ],
        "weight": 2
      },
      {
        "description": "Place the temperature sensor in the freezer. If the temperature goes above 32\u00b0F / 0\u00b0C, get a mobile alert on your phone.",
        "icon": "temperature-frigid",
        "id": 33,
        "name": "Freezer",
        "suggestions": [
          "Freezer Temperature"
        ],
        "weight": 3
      },
      {
        "description": "Place the temperature sensor near your wine collection. Many experts say wine should be stored at around 55\u00b0F / 13\u00b0C.  Wine can be stored as high as 69\u00b0F / 21\u00b0C without any long-term negative effects. Get alerts automatically if the temperature goes above 69\u00b0F / 21\u00b0C or below 50\u00b0F / 10\u00b0C.",
        "icon": "wine-bottle",
        "id": 31,
        "name": "Wine rack",
        "suggestions": [
          "Wine Sensor"
        ],
        "weight": 4
      },
      {
        "description": "Steinway & Sons recommends pianos be kept at a constant 68\u00b0F / 20\u00b0C.  Place the temperature sensor in a musical instrument, and get alerted if the temperature gets hotter than 77\u00b0F / 25\u00b0C, or colder than 59\u00b0F / 15\u00b0C. Sudden fluctuations in temperature should be avoided to prevent problems with tuning and regulation.",
        "icon": "music",
        "id": 35,
        "name": "Musical Instrument",
        "suggestions": [
          "Musical Instrument Sensor"
        ],
        "weight": 5
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 39,
        "name": "Skip",
        "suggestions": [],
        "weight": 9
      }
    ],
    "10034": [
      {
        "description": "Place the temperature sensor in your house, or even your second home. Get alerted if your pipes are about to freeze or if your home is getting very hot.",
        "icon": "home",
        "id": 30,
        "name": "Monitor my home (default)",
        "suggestions": [
          "Temperature/Humidity Sensor"
        ],
        "weight": 0
      },
      {
        "description": "Many medicines become ineffective at high temperatures and humidities. Continuously monitor medicine to be stored in a \"cool and dry\" place by installing this Temperature and Humidity sensor near the medication. Get alerted if the temperature, humidity, and water vapor pressure is too high and may weaken the medication.",
        "icon": "pills",
        "id": 36,
        "name": "\"Cool & Dry\" Medicine Storage",
        "suggestions": [
          "Cool & Dry Medicine Sensor"
        ],
        "weight": 1
      },
      {
        "description": "Place the temperature sensor in the refrigerator. It is said that the ideal temperature range for a refrigerator is 35-38\u00b0F / 2-4\u00b0C, but we know your refrigerator goes up and down a bit.  Get an alert if the fridge goes above 45\u00b0F / 7\u00b0C.  Maybe you left the door open for too long, or maybe you need to adjust that temperature dial in the fridge.",
        "icon": "temperature-low",
        "id": 32,
        "name": "Refrigerator",
        "suggestions": [
          "Refrigerator Temperature"
        ],
        "weight": 2
      },
      {
        "description": "Place the temperature sensor in the freezer. If the temperature goes above 32\u00b0F / 0\u00b0C, get a mobile alert on your phone.",
        "icon": "temperature-frigid",
        "id": 33,
        "name": "Freezer",
        "suggestions": [
          "Freezer Temperature"
        ],
        "weight": 3
      },
      {
        "description": "Place the temperature sensor near your wine collection. Many experts say wine should be stored at around 55\u00b0F / 13\u00b0C.  Wine can be stored as high as 69\u00b0F / 21\u00b0C without any long-term negative effects. Get alerts automatically if the temperature goes above 69\u00b0F / 21\u00b0C or below 50\u00b0F / 10\u00b0C.",
        "icon": "wine-bottle",
        "id": 31,
        "name": "Wine rack",
        "suggestions": [
          "Wine Sensor"
        ],
        "weight": 4
      },
      {
        "description": "Steinway & Sons recommends pianos be kept at a constant 68\u00b0F / 20\u00b0C.  Place the temperature sensor in a musical instrument, and get alerted if the temperature gets hotter than 77\u00b0F / 25\u00b0C, or colder than 59\u00b0F / 15\u00b0C. Sudden fluctuations in temperature should be avoided to prevent problems with tuning and regulation.",
        "icon": "music",
        "id": 35,
        "name": "Musical Instrument",
        "suggestions": [
          "Musical Instrument Sensor"
        ],
        "weight": 5
      },
      {
        "description": "Place the sensor close to the ceiling near the shower. It will monitor humidity levels in the bathroom and indicate on the dashboard when occupants last took a shower.",
        "icon": "shower",
        "id": 42,
        "name": "Track showers",
        "suggestions": [
          "Shower Sensor"
        ],
        "weight": 8
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 39,
        "name": "Skip",
        "suggestions": [],
        "weight": 9
      }
    ],
    "10035": [
      {
        "description": "Turn off the lights automatically when everyone leaves the home or you toggle out of HOME mode.  If you come home or toggle into HOME mode in the evening, the lights will turn on for you automatically.",
        "icon": "lightbulb-dollar",
        "id": 80,
        "name": "Save energy (default)",
        "weight": 0
      },
      {
        "description": "When you leave the home and it's after sunset or before sunrise, the lights will remain on for your pets.",
        "icon": "paw",
        "id": 81,
        "name": "Leave the lights on for the pets",
        "suggestions": [
          "Lamp"
        ],
        "weight": 1
      },
      {
        "description": "Your lights will make it look like you're home, even when you're not.",
        "icon": "user-check",
        "id": 82,
        "name": "It looks like I'm home when I'm not",
        "suggestions": [
          "Lamp"
        ],
        "weight": 2
      },
      {
        "description": "Using your smart plug on an appliance that should remain on all the time, like a refrigerator or a fish tank? This scenario will protect the smart plug from accidentally switching off, as long as it's powered up and connected to the Internet.",
        "icon": "bolt",
        "id": 84,
        "name": "Always On",
        "suggestions": [
          "Always-on Smart Plug"
        ],
        "weight": 3
      },
      {
        "description": "Connect a dehumidifier to this smart plug.",
        "icon": "humidity",
        "id": 85,
        "name": "Dehumidifier",
        "suggestions": [
          "Dehumidifier"
        ],
        "weight": 4
      },
      {
        "description": "Connect a fan to this smart plug.",
        "icon": "fan",
        "id": 86,
        "name": "Fan",
        "suggestions": [
          "Fan"
        ],
        "weight": 5
      },
      {
        "description": "Connect a space heater to this smart plug.",
        "icon": "fireplace",
        "id": 87,
        "name": "Space Heater",
        "suggestions": [
          "Space Heater"
        ],
        "weight": 6
      },
      {
        "description": "Connect a window air conditioner to this smart plug. Note that some digitally controlled air conditionings may not turn back on automatically after power is restored by the smart plug. Please verify how yours reacts before selecting this behavior.",
        "icon": "snowflake",
        "id": 88,
        "name": "Window Air Conditioner",
        "suggestions": [
          "Air Conditioner"
        ],
        "weight": 7
      },
      {
        "description": "Plug a coffee maker or hot water kettle into the smart plug. The smart plug will power off in the evening or when occupants leave so you can manually prepare the coffee maker or hot water kettle for the next day. In the morning, it will automatically turn on power when motion is detected anywhere outside the bedroom or bathroom. The smart plug will turn off power automatically if it appears it's been powered on for longer than 4 hours. The dashboard will log what time coffee appears to have been made.  WARNING: Digital coffee pots do not turn on automatically when power is applied, so this service is only compatible with coffee pots and hot water kettles that can be manually switched on.",
        "icon": "coffee",
        "id": 90,
        "name": "Make coffee when I wake up",
        "suggestions": [
          "Coffee"
        ],
        "weight": 8
      },
      {
        "description": "Plug a microwave into the smart plug. This behavior will track when food is cooked and make a record of meal time activities. If the door to the microwave does not appear to open within 2 minutes after cooking is complete, a reminder text notification will be delivered to people who have the alert texting role 'I live here'.",
        "icon": "microwave",
        "id": 92,
        "name": "Microwave",
        "suggestions": [
          "Microwave"
        ],
        "weight": 9
      },
      {
        "description": "Plug an appliance (TV, digital coffee maker, hot water kettle, etc.) into the smart plug. The smart plug will only turn off power if you tell it to - either manually, through the app, or based on custom rules - and will report to the dashboard when the appliance turned on as indicated by power consumption. This behavior is useful for monitoring daily activities that involve electronic appliances.",
        "icon": "plug",
        "id": 91,
        "name": "Track when an appliance turns on",
        "suggestions": [
          "Appliance Smart Plug"
        ],
        "weight": 10
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 89,
        "name": "Skip",
        "weight": 15
      }
    ],
    "10036": [
      {
        "description": "Turn off the lights automatically when everyone leaves the home or you toggle out of HOME mode.  If you come home or toggle into HOME mode in the evening, the lights will turn on for you automatically.",
        "icon": "lightbulb-dollar",
        "id": 60,
        "name": "Save energy (default)",
        "weight": 0
      },
      {
        "description": "When you leave the home and it's after sunset or before sunrise, the lights will remain on for your pets.",
        "icon": "paw",
        "id": 61,
        "name": "Leave the lights on for the pets",
        "weight": 1
      },
      {
        "description": "Your lights will make it look like you're home, even when you're not.",
        "icon": "user-check",
        "id": 62,
        "name": "It looks like I'm home when I'm not",
        "weight": 2
      },
      {
        "description": "Automatically turn on lights for security every night, and turn them off in the morning.",
        "icon": "lights-holiday",
        "id": 64,
        "name": "Outdoor security lighting",
        "suggestions": [
          "Outdoor Security Lights"
        ],
        "weight": 3
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 69,
        "name": "Skip",
        "weight": 4
      }
    ],
    "10038": [
      {
        "description": "The motion sensor will recognize movement patterns to help increase safety, protect your home, and reduce energy consumption. You will receive alerts if motion is detected while you are in away mode. A security alarm will trigger if motion is detected.",
        "icon": "home",
        "id": 50,
        "name": "Inside the home (default)",
        "spaces": [
          [
            1
          ],
          [
            4
          ],
          [
            5
          ],
          [
            2
          ],
          [
            3
          ]
        ],
        "suggestions": [
          "Kitchen Motion Sensor",
          "Hallway Motion Sensor",
          "Living Room Motion Sensor",
          "Bedroom Motion Sensor",
          "Bathroom Motion Sensor"
        ],
        "weight": 0
      },
      {
        "description": "Install this motion sensor anywhere indoors and manage it with your own custom rules. This will not automatically help increase safety, save energy, or secure the home. This will NOT trigger a security alarm when motion is detected.",
        "icon": "shapes",
        "id": 52,
        "name": "Install somewhere else",
        "suggestions": [],
        "weight": 1
      }
    ],
    "10071": [
      {
        "description": "Turn off the lights automatically when everyone leaves the home or you toggle out of HOME mode.  If you come home or toggle into HOME mode in the evening, the lights will turn on for you automatically.",
        "icon": "lightbulb-dollar",
        "id": 60,
        "name": "Save energy (default)",
        "weight": 0
      },
      {
        "description": "When you leave the home and it's after sunset or before sunrise, the lights will remain on for your pets.",
        "icon": "paw",
        "id": 61,
        "name": "Leave the lights on for the pets",
        "weight": 1
      },
      {
        "description": "Your lights will make it look like you're home, even when you're not.",
        "icon": "user-check",
        "id": 62,
        "name": "It looks like I'm home when I'm not",
        "weight": 2
      },
      {
        "description": "Automatically turn on lights for security every night, and turn them off in the morning.",
        "icon": "lights-holiday",
        "id": 64,
        "name": "Outdoor security lighting",
        "suggestions": [
          "Outdoor Security Lights"
        ],
        "weight": 3
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 69,
        "name": "Skip",
        "weight": 4
      }
    ],
    "10072": [
      {
        "description": "Turn off the lights automatically when everyone leaves the home or you toggle out of HOME mode.  If you come home or toggle into HOME mode in the evening, the lights will turn on for you automatically.",
        "icon": "lightbulb-dollar",
        "id": 60,
        "name": "Save energy (default)",
        "weight": 0
      },
      {
        "description": "When you leave the home and it's after sunset or before sunrise, the lights will remain on for your pets.",
        "icon": "paw",
        "id": 61,
        "name": "Leave the lights on for the pets",
        "weight": 1
      },
      {
        "description": "Your lights will make it look like you're home, even when you're not.",
        "icon": "user-check",
        "id": 62,
        "name": "It looks like I'm home when I'm not",
        "weight": 2
      },
      {
        "description": "Automatically turn on lights for security every night, and turn them off in the morning.",
        "icon": "lights-holiday",
        "id": 64,
        "name": "Outdoor security lighting",
        "suggestions": [
          "Outdoor Security Lights"
        ],
        "weight": 3
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 69,
        "name": "Skip",
        "weight": 4
      }
    ],
    "10074": [
      {
        "description": "Install this entry sensor on an exit door on the perimeter of the home to protect the home and help save energy. A security alarm can trigger when the door opens.",
        "icon": "home",
        "id": 0,
        "name": "Exit Door on the perimeter (default)",
        "suggestions": [
          "Front Door",
          "Back/Side Door",
          "Exit Door"
        ],
        "weight": 0
      },
      {
        "description": "Install the sensor on a medicine cabinet, drawer, or a container where medicine is stored. The History will record when this compartment was opened, helping track medication adherence.",
        "icon": "pills",
        "id": 8,
        "name": "Medicine Storage",
        "suggestions": [
          "Medicine Cabinet"
        ],
        "weight": 2
      },
      {
        "description": "Install the sensor on a refrigerator door. The History will record when the refrigerator was opened, helping track meal time activities.",
        "icon": "utensils",
        "id": 9,
        "name": "Refrigerator",
        "suggestions": [
          "Refrigerator"
        ],
        "weight": 3
      },
      {
        "description": "Install this entry sensor anywhere inside or outside of the home, but not on the perimeter. You can create your own rules. This will not automatically help save energy or protect the home. This will NOT trigger a security alarm if your door opens.",
        "icon": "mailbox",
        "id": 4,
        "name": "Install somewhere else",
        "suggestions": [],
        "weight": 4
      }
    ],
    "2000": [
      {
        "description": "Place the Vayyar Home in a bathroom. Install the center of the device 5 feet off the ground, and at least 1 foot away from objects on the wall like a towel rack. Do not point the Vayyar Home directly at a mirror across the room.",
        "force_nickname": true,
        "icon": "restroom",
        "icon_font": "far",
        "id": 1,
        "name": "Bathroom",
        "subregions": [
          {
            "context_id_list": [
              10
            ],
            "icon": "toilet",
            "icon_font": "far",
            "title": "Add a toilet"
          },
          {
            "context_id_list": [
              11,
              12
            ],
            "icon": "shower",
            "icon_font": "far",
            "title": "Add a shower"
          },
          {
            "context_id_list": [
              13
            ],
            "icon": "sink",
            "icon_font": "far",
            "title": "Add a sink"
          }
        ],
        "suggestions": [
          "Bathroom"
        ],
        "weight": 0
      },
      {
        "description": "Place the Vayyar Home in a bedroom. Install the center of the device 5 feet off the ground, and at least 1 foot away from objects on the wall.",
        "force_nickname": true,
        "icon": "bed",
        "icon_font": "far",
        "id": 0,
        "name": "Bedroom",
        "subregions": [
          {
            "context_id_list": [
              1,
              2,
              3,
              4,
              5,
              6,
              7
            ],
            "icon": "bed-alt",
            "icon_font": "far",
            "title": "Add a bed"
          }
        ],
        "suggestions": [
          "Bedroom"
        ],
        "weight": 5
      },
      {
        "description": "Place the Vayyar Home in the living room. Install the center of the device 5 feet off the ground, and at least 1 foot away from objects on the wall.",
        "force_nickname": true,
        "icon": "couch",
        "icon_font": "far",
        "id": 2,
        "name": "Living Room",
        "subregions": [
          {
            "context_id_list": [
              22,
              20,
              21
            ],
            "icon": "couch",
            "icon_font": "far",
            "title": "Add a couch or chair"
          }
        ],
        "suggestions": [
          "Living Room"
        ],
        "weight": 10
      },
      {
        "description": "Place the Vayyar Home in the kitchen. Install the center of the device 5 feet off the ground, and at least 1 foot away from objects on the wall.",
        "force_nickname": true,
        "icon": "refrigerator",
        "icon_font": "far",
        "id": 3,
        "name": "Kitchen",
        "subregions": [
          {
            "context_id_list": [
              22,
              20,
              21
            ],
            "icon": "couch",
            "icon_font": "far",
            "title": "Add a couch or chair"
          }
        ],
        "suggestions": [
          "Kitchen"
        ],
        "weight": 15
      },
      {
        "description": "Place the Vayyar Home in a room or hallway. Install the center of the device 5 feet off the ground, and at least 1 foot away from objects on the wall.",
        "force_nickname": false,
        "icon": "home-heart",
        "icon_font": "far",
        "id": 4,
        "name": "Some Other Room...",
        "suggestions": [
          "Room"
        ],
        "weight": 20
      }
    ],
    "9001": [
      {
        "description": "Turn off the lights automatically when everyone leaves the home or you toggle out of HOME mode.  If you come home or toggle into HOME mode in the evening, the lights will turn on for you automatically.",
        "icon": "lightbulb-dollar",
        "id": 60,
        "name": "Save energy (default)",
        "weight": 0
      },
      {
        "description": "When you leave the home and it's after sunset or before sunrise, the lights will remain on for your pets.",
        "icon": "paw",
        "id": 61,
        "name": "Leave the lights on for the pets",
        "weight": 1
      },
      {
        "description": "Your lights will make it look like you're home, even when you're not.",
        "icon": "user-check",
        "id": 62,
        "name": "It looks like I'm home when I'm not",
        "weight": 2
      },
      {
        "description": "Automatically turn on lights for security every night, and turn them off in the morning.",
        "icon": "lights-holiday",
        "id": 64,
        "name": "Outdoor security lighting",
        "suggestions": [
          "Outdoor Security Lights"
        ],
        "weight": 3
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 69,
        "name": "Skip",
        "weight": 4
      }
    ],
    "9010": [
      {
        "description": "Your smart lock will automatically lock itself when your home detects that you've gone away, went to sleep, or have armed your security system.",
        "icon": "lock",
        "icon_font": "far",
        "id": 101,
        "name": "AI Auto-Lock",
        "weight": 0
      },
      {
        "description": "Your keypad is waterproof and can optionally be placed outside your home. When you disarm the security system by badging in or typing in a code, this smart lock will unlock too. The smart lock will automatically lock itself when your home thinks it should be secured.",
        "icon": "key",
        "icon_font": "far",
        "id": 103,
        "name": "AI Auto-Lock + Keypad Unlock",
        "weight": 1
      }
    ],
    "9014": [
      {
        "description": "Press the button more than 3 seconds to call for medical emergency help. An SMS text message will be sent to family and friends associated with your home before contacting the emergency call center with a medical alarm.",
        "icon": "ambulance",
        "id": 111,
        "name": "Emergency Medical Alert (default)",
        "suggestions": [
          "Medical Emergency Button"
        ],
        "weight": 0
      },
      {
        "description": "Press the button more than 3 seconds to send a text message that requests assistance from people in the Trusted Circle who have the alert texting role 'I Live Here'. This behavior will not signal the Emergency Call Center.",
        "icon": "user-friends",
        "id": 100,
        "name": "Signal: I need help from people who live with me",
        "suggestions": [
          "I Need Help Button"
        ],
        "weight": 1
      },
      {
        "description": "Press the button more than 3 seconds to send a text message that requests assistance from people in the Trusted Circle who have the alert texting roles 'I Live Here' or 'Family/Friend'. This behavior will not signal the Emergency Call Center.",
        "icon": "users-class",
        "id": 105,
        "name": "Signal: I need help from anyone",
        "suggestions": [
          "I Need Help Button"
        ],
        "weight": 2
      },
      {
        "description": "Press the button to record you took your medicine.",
        "icon": "pills",
        "id": 109,
        "name": "Signal: I took my medicine",
        "suggestions": [
          "Took My Medicine Button"
        ],
        "weight": 4
      },
      {
        "description": "Place your button in a secret location that only you and trusted people know about, like hidden under a shelf or in a kitchen drawer. If your security system is currently disarmed, press and hold the button for about 5 seconds to toggle into AWAY mode. If the security system is armed, tap and release the button to disarm back into OFF mode. Any connected siren will audibly remind you whether the security system has been armed or disarmed.",
        "icon": "shield-check",
        "id": 110,
        "name": "Security Arm/Disarm in Away Mode",
        "suggestions": [
          "Secret Arm/Disarm Button"
        ],
        "weight": 6
      },
      {
        "description": "Place your button in a secret location that only you and trusted people know about, like hidden under a shelf or in a kitchen drawer. If your security system is currently disarmed, press and hold the button about 5 seconds to toggle into STAY mode. If the security system is armed, tap and release the button to disarm back into OFF mode. Any connected siren will audibly remind you whether the security system has been armed or disarmed.",
        "icon": "lock-alt",
        "id": 116,
        "name": "Security Arm/Disarm in Stay Mode",
        "suggestions": [
          "Secret Arm/Disarm Button"
        ],
        "weight": 7
      },
      {
        "description": "Use the button as a doorbell. This requires a siren in your account.",
        "icon": "concierge-bell",
        "id": 115,
        "name": "Doorbell",
        "suggestions": [
          "Doorbell Button"
        ],
        "weight": 12
      }
    ],
    "9017": [
      {
        "description": "Intelligently manage your electric hot water heater to save energy.",
        "icon": "bath",
        "id": 120,
        "name": "Hot Water Heater",
        "weight": 0
      },
      {
        "description": "Intelligently manage power to a pool pump timer to save energy during high electricity prices or demand response events.",
        "icon": "swimming-pool",
        "id": 121,
        "name": "Pool Pump",
        "weight": 1
      },
      {
        "description": "Intelligently manage an electric vehicle charging station to save energy during high electricity prices or demand response events.",
        "icon": "charging-station",
        "id": 122,
        "name": "Electric Vehicle",
        "weight": 2
      },
      {
        "description": "Plug a dryer into the large load controller. If the dryer is not running and a demand response event begins, the large load controller will turn the dryer off for the duration of the event to remind you to save money.",
        "icon": "dryer",
        "id": 123,
        "name": "Dryer",
        "weight": 3
      }
    ],
    "9039": [
      {
        "description": "Place the pressure pad under the fitted sheet or mattress cover to detect someone lying down on the bed. Do not place it under the mattress itself. Try to keep the plastic sensor box off the ground for maximum wireless coverage. This will add fall detection services at night, help with occupancy sensing, and more accurately quantify sleep.",
        "icon": "bed",
        "id": 0,
        "name": "Install on a Bed (default)",
        "suggestions": [
          "Bed Sensor"
        ],
        "weight": 0
      },
      {
        "description": "Place the pressure pad under a cushion on a chair. Some testing may be required to ensure the cushion itself does not get recognized like a person sitting in the chair. Try to keep the plastic sensor box off the ground for maximum wireless coverage. This will help detect occupancy and make fall detection services more aggressive around chairs.",
        "icon": "loveseat",
        "id": 1,
        "name": "Install on a Chair",
        "suggestions": [
          "Chair Sensor"
        ],
        "weight": 1
      },
      {
        "description": "Install the pressure pad under a floor mat, such as in the bathroom or kitchen. Try to keep the plastic sensor box off the ground for maximum wireless coverage. This can serve in place of a motion sensor in sensitive areas like the bathroom, allowing fall detection algorithms to perform more aggressively in those locations. Please keep in mind that pets will be recognized as humans when they step on the mat.",
        "icon": "shoe-prints",
        "id": 2,
        "name": "Install under a Floor Mat",
        "suggestions": [
          "Floor Mat Sensor"
        ],
        "weight": 2
      }
    ],
    "9101": [
      {
        "description": "Press the button once to call for medical emergency help. An SMS text message will be sent to family and friends associated with your home before contacting the emergency call center with a medical alarm.",
        "icon": "ambulance",
        "id": 111,
        "name": "Emergency Medical Alert (default)",
        "suggestions": [
          "Medical Emergency Button"
        ],
        "weight": 0
      },
      {
        "description": "Press the button to send a text message that requests assistance from people in the Trusted Circle who have the alert texting role 'I Live Here'. This behavior will not signal the Emergency Call Center.",
        "icon": "user-friends",
        "id": 100,
        "name": "Signal: I need help from people who live with me",
        "suggestions": [
          "I Need Help Button"
        ],
        "weight": 1
      },
      {
        "description": "Press the button to send a text message that requests assistance from people in the Trusted Circle who have the alert texting roles 'I Live Here' or 'Family/Friend'. This behavior will not signal the Emergency Call Center.",
        "icon": "users-class",
        "id": 105,
        "name": "Signal: I need help from anyone",
        "suggestions": [
          "I Need Help Button"
        ],
        "weight": 2
      }
    ],
    "9105": [
      {
        "description": "Turn off the lights automatically when everyone leaves the home or you toggle out of HOME mode.  If you come home or toggle into HOME mode in the evening, the lights will turn on for you automatically.",
        "icon": "lightbulb-dollar",
        "id": 80,
        "name": "Save energy (default)",
        "weight": 0
      },
      {
        "description": "When you leave the home and it's after sunset or before sunrise, the lights will remain on for your pets.",
        "icon": "paw",
        "id": 81,
        "name": "Leave the lights on for the pets",
        "suggestions": [
          "Lamp"
        ],
        "weight": 1
      },
      {
        "description": "Your lights will make it look like you're home, even when you're not.",
        "icon": "user-check",
        "id": 82,
        "name": "It looks like I'm home when I'm not",
        "suggestions": [
          "Lamp"
        ],
        "weight": 2
      },
      {
        "description": "Using your smart plug on an appliance that should remain on all the time, like a refrigerator or a fish tank? This scenario will protect the smart plug from accidentally switching off, as long as it's powered up and connected to the Internet.",
        "icon": "bolt",
        "id": 84,
        "name": "Always On",
        "suggestions": [
          "Always-on Smart Plug"
        ],
        "weight": 3
      },
      {
        "description": "Connect a dehumidifier to this smart plug.",
        "icon": "humidity",
        "id": 85,
        "name": "Dehumidifier",
        "suggestions": [
          "Dehumidifier"
        ],
        "weight": 4
      },
      {
        "description": "Connect a fan to this smart plug.",
        "icon": "fan",
        "id": 86,
        "name": "Fan",
        "suggestions": [
          "Fan"
        ],
        "weight": 5
      },
      {
        "description": "Connect a space heater to this smart plug.",
        "icon": "fireplace",
        "id": 87,
        "name": "Space Heater",
        "suggestions": [
          "Space Heater"
        ],
        "weight": 6
      },
      {
        "description": "Connect a window air conditioner to this smart plug. Note that some digitally controlled air conditionings may not turn back on automatically after power is restored by the smart plug. Please verify how yours reacts before selecting this behavior.",
        "icon": "snowflake",
        "id": 88,
        "name": "Window Air Conditioner",
        "suggestions": [
          "Air Conditioner"
        ],
        "weight": 7
      },
      {
        "description": "Plug a coffee maker or hot water kettle into the smart plug. The smart plug will power off in the evening or when occupants leave so you can manually prepare the coffee maker or hot water kettle for the next day. In the morning, it will automatically turn on power when motion is detected anywhere outside the bedroom or bathroom. The smart plug will turn off power automatically if it appears it's been powered on for longer than 4 hours. The dashboard will log what time coffee appears to have been made.  WARNING: Digital coffee pots do not turn on automatically when power is applied, so this service is only compatible with coffee pots and hot water kettles that can be manually switched on.",
        "icon": "coffee",
        "id": 90,
        "name": "Make coffee when I wake up",
        "suggestions": [
          "Coffee"
        ],
        "weight": 8
      },
      {
        "description": "Plug a microwave into the smart plug. This behavior will track when food is cooked and make a record of meal time activities. If the door to the microwave does not appear to open within 2 minutes after cooking is complete, a reminder text notification will be delivered to people who have the alert texting role 'I live here'.",
        "icon": "microwave",
        "id": 92,
        "name": "Microwave",
        "suggestions": [
          "Microwave"
        ],
        "weight": 9
      },
      {
        "description": "Plug an appliance (TV, digital coffee maker, hot water kettle, etc.) into the smart plug. The smart plug will only turn off power if you tell it to - either manually, through the app, or based on custom rules - and will report to the dashboard when the appliance turned on as indicated by power consumption. This behavior is useful for monitoring daily activities that involve electronic appliances.",
        "icon": "plug",
        "id": 91,
        "name": "Track when an appliance turns on",
        "suggestions": [
          "Appliance Smart Plug"
        ],
        "weight": 10
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 89,
        "name": "Skip",
        "weight": 15
      }
    ],
    "9106": [
      {
        "description": "Press the button more than 3 seconds to call for medical emergency help. An SMS text message will be sent to family and friends associated with your home before contacting the emergency call center with a medical alarm.",
        "icon": "ambulance",
        "id": 111,
        "name": "Emergency Medical Alert (default)",
        "suggestions": [
          "Medical Emergency Button"
        ],
        "weight": 0
      },
      {
        "description": "Press the button more than 3 seconds to send a text message that requests assistance from people in the Trusted Circle who have the alert texting role 'I Live Here'. This behavior will not signal the Emergency Call Center.",
        "icon": "user-friends",
        "id": 100,
        "name": "Signal: I need help from people who live with me",
        "suggestions": [
          "I Need Help Button"
        ],
        "weight": 1
      },
      {
        "description": "Press the button more than 3 seconds to send a text message that requests assistance from people in the Trusted Circle who have the alert texting roles 'I Live Here' or 'Family/Friend'. This behavior will not signal the Emergency Call Center.",
        "icon": "users-class",
        "id": 105,
        "name": "Signal: I need help from anyone",
        "suggestions": [
          "I Need Help Button"
        ],
        "weight": 2
      },
      {
        "description": "Press the button to record you took your medicine.",
        "icon": "pills",
        "id": 109,
        "name": "Signal: I took my medicine",
        "suggestions": [
          "Took My Medicine Button"
        ],
        "weight": 4
      },
      {
        "description": "Place your button in a secret location that only you and trusted people know about, like hidden under a shelf or in a kitchen drawer. If your security system is currently disarmed, press and hold the button for about 5 seconds to toggle into AWAY mode. If the security system is armed, tap and release the button to disarm back into OFF mode. Any connected siren will audibly remind you whether the security system has been armed or disarmed.",
        "icon": "shield-check",
        "id": 110,
        "name": "Security Arm/Disarm in Away Mode",
        "suggestions": [
          "Secret Arm/Disarm Button"
        ],
        "weight": 6
      },
      {
        "description": "Place your button in a secret location that only you and trusted people know about, like hidden under a shelf or in a kitchen drawer. If your security system is currently disarmed, press and hold the button about 5 seconds to toggle into STAY mode. If the security system is armed, tap and release the button to disarm back into OFF mode. Any connected siren will audibly remind you whether the security system has been armed or disarmed.",
        "icon": "lock-alt",
        "id": 116,
        "name": "Security Arm/Disarm in Stay Mode",
        "suggestions": [
          "Secret Arm/Disarm Button"
        ],
        "weight": 7
      },
      {
        "description": "Use the button as a doorbell. This requires a siren in your account.",
        "icon": "concierge-bell",
        "id": 115,
        "name": "Doorbell",
        "suggestions": [
          "Doorbell Button"
        ],
        "weight": 12
      }
    ],
    "9114": [
      {
        "description": "Install this entry sensor on an exit door on the perimeter of the home to protect the home and help save energy. A security alarm can trigger when the door opens.",
        "icon": "home",
        "id": 0,
        "name": "Exit Door on the perimeter (default)",
        "suggestions": [
          "Front Door",
          "Back/Side Door",
          "Exit Door"
        ],
        "weight": 0
      },
      {
        "description": "Install the sensor on a medicine cabinet, drawer, or a container where medicine is stored. The History will record when this compartment was opened, helping track medication adherence.",
        "icon": "pills",
        "id": 8,
        "name": "Medicine Storage",
        "suggestions": [
          "Medicine Cabinet"
        ],
        "weight": 2
      },
      {
        "description": "Install the sensor on a refrigerator door. The History will record when the refrigerator was opened, helping track meal time activities.",
        "icon": "utensils",
        "id": 9,
        "name": "Refrigerator",
        "suggestions": [
          "Refrigerator"
        ],
        "weight": 3
      },
      {
        "description": "Install this entry sensor anywhere inside or outside of the home, but not on the perimeter. You can create your own rules. This will not automatically help save energy or protect the home. This will NOT trigger a security alarm if your door opens.",
        "icon": "mailbox",
        "id": 4,
        "name": "Install somewhere else",
        "suggestions": [],
        "weight": 4
      }
    ],
    "9119": [
      {
        "description": "Get mobile alerts anytime your Vibration Detect Sensor detects movement. Perfect for safes and valuables.",
        "icon": "hand-point-right",
        "icon_font": "far",
        "id": 20,
        "name": "Alert on every touch (default)",
        "suggestions": [
          "Vibration Sensor"
        ],
        "weight": 0
      },
      {
        "description": "Get mobile alerts anytime your Vibration Detect Sensor moves while you are AWAY, or when your home appears unoccupied.",
        "icon": "shield-check",
        "icon_font": "far",
        "id": 21,
        "name": "Alert if it moves while I'm away",
        "suggestions": [
          "Vibration Sensor"
        ],
        "weight": 1
      },
      {
        "description": "Attach the sensor to a window. Get mobile alerts anytime your Vibration Detect Sensor detects glass break while you are AWAY, or when your home appears unoccupied.",
        "icon": "window-frame",
        "icon_font": "far",
        "id": 5,
        "name": "Glass Break",
        "suggestions": [
          "Glass Break Sensor"
        ],
        "weight": 2
      },
      {
        "description": "Monitoring toileting behavior is important to caregivers of people at risk of dehydration, UTI's, diabetes issues, and more. Start by placing the Vibration Detect Sensor into a small plastic waterproof container or jar. If you're not certain about the reliability of the waterproof container, consider placing the Vibration Detect Sensor inside a re-sealable zipper platic bag and then into the waterproof container. Float the container in the upper water tank of the toilet. We find placing it near the handle area inside the tank works best, but you will need to experiment. If the floating container may interfere with the flap, consider attaching a string to the container and tying the other end of that string to something inside the tank to prevent the container from getting near the flap. When the toilet flushes, the drainage and movement of the water from the tank will be detected by the Touch Sensor and will register as a toilet flush.",
        "icon": "toilet",
        "icon_font": "far",
        "id": 22,
        "name": "Toilet Sensing (beta)",
        "suggestions": [
          "Toilet Sensor"
        ],
        "weight": 30
      }
    ],
    "9134": [
      {
        "description": "Place the temperature sensor in your house, or even your second home. Get alerted if your pipes are about to freeze or if your home is getting very hot.",
        "icon": "home",
        "id": 30,
        "name": "Monitor my home (default)",
        "suggestions": [
          "Temperature/Humidity Sensor"
        ],
        "weight": 0
      },
      {
        "description": "Many medicines become ineffective at high temperatures and humidities. Continuously monitor medicine to be stored in a \"cool and dry\" place by installing this Temperature and Humidity sensor near the medication. Get alerted if the temperature, humidity, and water vapor pressure is too high and may weaken the medication.",
        "icon": "pills",
        "id": 36,
        "name": "\"Cool & Dry\" Medicine Storage",
        "suggestions": [
          "Cool & Dry Medicine Sensor"
        ],
        "weight": 1
      },
      {
        "description": "Place the temperature sensor in the refrigerator. It is said that the ideal temperature range for a refrigerator is 35-38\u00b0F / 2-4\u00b0C, but we know your refrigerator goes up and down a bit.  Get an alert if the fridge goes above 45\u00b0F / 7\u00b0C.  Maybe you left the door open for too long, or maybe you need to adjust that temperature dial in the fridge.",
        "icon": "temperature-low",
        "id": 32,
        "name": "Refrigerator",
        "suggestions": [
          "Refrigerator Temperature"
        ],
        "weight": 2
      },
      {
        "description": "Place the temperature sensor in the freezer. If the temperature goes above 32\u00b0F / 0\u00b0C, get a mobile alert on your phone.",
        "icon": "temperature-frigid",
        "id": 33,
        "name": "Freezer",
        "suggestions": [
          "Freezer Temperature"
        ],
        "weight": 3
      },
      {
        "description": "Place the temperature sensor near your wine collection. Many experts say wine should be stored at around 55\u00b0F / 13\u00b0C.  Wine can be stored as high as 69\u00b0F / 21\u00b0C without any long-term negative effects. Get alerts automatically if the temperature goes above 69\u00b0F / 21\u00b0C or below 50\u00b0F / 10\u00b0C.",
        "icon": "wine-bottle",
        "id": 31,
        "name": "Wine rack",
        "suggestions": [
          "Wine Sensor"
        ],
        "weight": 4
      },
      {
        "description": "Steinway & Sons recommends pianos be kept at a constant 68\u00b0F / 20\u00b0C.  Place the temperature sensor in a musical instrument, and get alerted if the temperature gets hotter than 77\u00b0F / 25\u00b0C, or colder than 59\u00b0F / 15\u00b0C. Sudden fluctuations in temperature should be avoided to prevent problems with tuning and regulation.",
        "icon": "music",
        "id": 35,
        "name": "Musical Instrument",
        "suggestions": [
          "Musical Instrument Sensor"
        ],
        "weight": 5
      },
      {
        "description": "Place the sensor close to the ceiling near the shower. It will monitor humidity levels in the bathroom and indicate on the dashboard when occupants last took a shower.",
        "icon": "shower",
        "id": 42,
        "name": "Track showers",
        "suggestions": [
          "Shower Sensor"
        ],
        "weight": 8
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 39,
        "name": "Skip",
        "suggestions": [],
        "weight": 9
      }
    ],
    "9135": [
      {
        "description": "Turn off the lights automatically when everyone leaves the home or you toggle out of HOME mode.  If you come home or toggle into HOME mode in the evening, the lights will turn on for you automatically.",
        "icon": "lightbulb-dollar",
        "id": 80,
        "name": "Save energy (default)",
        "weight": 0
      },
      {
        "description": "When you leave the home and it's after sunset or before sunrise, the lights will remain on for your pets.",
        "icon": "paw",
        "id": 81,
        "name": "Leave the lights on for the pets",
        "suggestions": [
          "Lamp"
        ],
        "weight": 1
      },
      {
        "description": "Your lights will make it look like you're home, even when you're not.",
        "icon": "user-check",
        "id": 82,
        "name": "It looks like I'm home when I'm not",
        "suggestions": [
          "Lamp"
        ],
        "weight": 2
      },
      {
        "description": "Using your smart plug on an appliance that should remain on all the time, like a refrigerator or a fish tank? This scenario will protect the smart plug from accidentally switching off, as long as it's powered up and connected to the Internet.",
        "icon": "bolt",
        "id": 84,
        "name": "Always On",
        "suggestions": [
          "Always-on Smart Plug"
        ],
        "weight": 3
      },
      {
        "description": "Connect a dehumidifier to this smart plug.",
        "icon": "humidity",
        "id": 85,
        "name": "Dehumidifier",
        "suggestions": [
          "Dehumidifier"
        ],
        "weight": 4
      },
      {
        "description": "Connect a fan to this smart plug.",
        "icon": "fan",
        "id": 86,
        "name": "Fan",
        "suggestions": [
          "Fan"
        ],
        "weight": 5
      },
      {
        "description": "Connect a space heater to this smart plug.",
        "icon": "fireplace",
        "id": 87,
        "name": "Space Heater",
        "suggestions": [
          "Space Heater"
        ],
        "weight": 6
      },
      {
        "description": "Connect a window air conditioner to this smart plug. Note that some digitally controlled air conditionings may not turn back on automatically after power is restored by the smart plug. Please verify how yours reacts before selecting this behavior.",
        "icon": "snowflake",
        "id": 88,
        "name": "Window Air Conditioner",
        "suggestions": [
          "Air Conditioner"
        ],
        "weight": 7
      },
      {
        "description": "Plug a coffee maker or hot water kettle into the smart plug. The smart plug will power off in the evening or when occupants leave so you can manually prepare the coffee maker or hot water kettle for the next day. In the morning, it will automatically turn on power when motion is detected anywhere outside the bedroom or bathroom. The smart plug will turn off power automatically if it appears it's been powered on for longer than 4 hours. The dashboard will log what time coffee appears to have been made.  WARNING: Digital coffee pots do not turn on automatically when power is applied, so this service is only compatible with coffee pots and hot water kettles that can be manually switched on.",
        "icon": "coffee",
        "id": 90,
        "name": "Make coffee when I wake up",
        "suggestions": [
          "Coffee"
        ],
        "weight": 8
      },
      {
        "description": "Plug a microwave into the smart plug. This behavior will track when food is cooked and make a record of meal time activities. If the door to the microwave does not appear to open within 2 minutes after cooking is complete, a reminder text notification will be delivered to people who have the alert texting role 'I live here'.",
        "icon": "microwave",
        "id": 92,
        "name": "Microwave",
        "suggestions": [
          "Microwave"
        ],
        "weight": 9
      },
      {
        "description": "Plug an appliance (TV, digital coffee maker, hot water kettle, etc.) into the smart plug. The smart plug will only turn off power if you tell it to - either manually, through the app, or based on custom rules - and will report to the dashboard when the appliance turned on as indicated by power consumption. This behavior is useful for monitoring daily activities that involve electronic appliances.",
        "icon": "plug",
        "id": 91,
        "name": "Track when an appliance turns on",
        "suggestions": [
          "Appliance Smart Plug"
        ],
        "weight": 10
      },
      {
        "description": "Skip for now and define your own rules later.",
        "icon": "forward",
        "id": 89,
        "name": "Skip",
        "weight": 15
      }
    ],
    "9138": [
      {
        "description": "The motion sensor will recognize movement patterns to help increase safety, protect your home, and reduce energy consumption. You will receive alerts if motion is detected while you are in away mode. A security alarm will trigger if motion is detected.",
        "icon": "home",
        "id": 50,
        "name": "Inside the home (default)",
        "spaces": [
          [
            1
          ],
          [
            4
          ],
          [
            5
          ],
          [
            2
          ],
          [
            3
          ]
        ],
        "suggestions": [
          "Kitchen Motion Sensor",
          "Hallway Motion Sensor",
          "Living Room Motion Sensor",
          "Bedroom Motion Sensor",
          "Bathroom Motion Sensor"
        ],
        "weight": 0
      },
      {
        "description": "Install this motion sensor anywhere indoors and manage it with your own custom rules. This will not automatically help increase safety, save energy, or secure the home. This will NOT trigger a security alarm when motion is detected.",
        "icon": "shapes",
        "id": 52,
        "name": "Install somewhere else",
        "suggestions": [],
        "weight": 1
      }
    ]
  }
}
```