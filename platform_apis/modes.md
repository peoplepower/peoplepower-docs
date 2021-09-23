# Security Modes and Occupancy Status

This document describes the security system modes and occupancy status as recognized by People Power's application layers, including existing bots.

## History
People Power's modes has evolved a lot over the years, but consistently remained backwards compatible with previous versions. The field is essentially a single string that is associated with a location - you can find it in the [Location Scene API Documentation](https://iotapps.docs.apiary.io/#reference/locations/set-location-scene/change-the-scene-at-a-location). 

It started out controlling scenes for home automation and energy savings, then evolved into the security system mode, grew an extension to handle occupancy status, and further evolved to describe what was responsible for the last updates.

Today, we've settled on the following vocabulary:

* **Mode** or **Security Mode** is the security system mode.
* **Occupancy Status** is whether occupants are present, absent, sleeping, and all the transitional states in between. This is typically not user-configurable, except through ambient sensing and machine learning services.

## Setting the mode

When the app wants to change the mode, it simply sets the [Location Scene API](https://iotapps.docs.apiary.io/#reference/locations/set-location-scene/change-the-scene-at-a-location) to "HOME", "AWAY", "STAY", or "TEST". 


## Getting the mode

If you get the mode for a location, you may see extra fields appear. These fields and formatting may be set by a bot. This is the format we use for the "Location Scene" string at our application layers.

{Security Mode}.:.{Occupany Status}

There may be other identifiers associated with the Security Mode or Occupancy Status, such as "AI" or "USER". If other identifiers exist, we use a period as a separation character. For example:  `HOME.:.PRESENT.AI`

Your application should check for the existance of a specific string inside this string to identify the mode you're interested in.

```
if "HOME" in mode:
   pass
```


## Valid Security Modes

Modes are case-sensitive. These are the only ones recognized by existing bots.

| Mode | Description |
| ---- | ----------- |
| HOME | Security system is disarmed, everything is running normally. |
| AWAY | Fully arm the security system, including motion sensors. |
| STAY | Arm the perimeter of the security system, ignoring motion sensors. |
| TEST | Disarm everything and stop services for interactive automated testing of the system and its sensors. |


## Valid Occupancy Status

Occupancy status is driven exclusively by a menu of machine learning algorithms. These are the only occupancy states recognized by existing bots.

| Occupancy Status | Description |
| ---------------- | ----------- |
| PRESENT | At least one person is home. |
| ABSENT | Nobody is home. |
| SLEEP | Occupants should be asleep. |
| VACATION | Occupants have been gone for so long that this location is now in an automated vacation mode. |
| H2A | Home-to-absent - occupants may be going away. |
| A2H | Absent-to-home - occupants are expected to be back anytime now. |
| H2S | Home-to-sleep - occupants are expected to go to sleep soon. |
| S2H | Sleep-to-home - occupants are expected to wake up soon. |
