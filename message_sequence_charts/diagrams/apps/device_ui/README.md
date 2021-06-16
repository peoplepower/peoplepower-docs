# Device UI

## Table of contents

* [Table of contents]()
* [Device Model UX](#device-model-ux)
    * [APIS](#apis)
    * [How it should work](#how-it-should-work)
        * [Associating Device Models with Device Types](#models-types)
        * [Device Parameters](#device-parameters)
    * [Device List Attributes](#device-list-attributes)
        * [Position Types](#position-types)
    * [Display Information](#display-information)
        * [Device Parameter](#device-parameter)
        * [Device Model](#device-model)
        * [Device List Bindings](#device-list-bindings)
        * [Location Spaces](#location-spaces)
* [Diagrams](#diagrams)
    * [Smart Home Center](#smart-home-center)


## Device Model UX

Cloud API and high-level logic prototypes for Presence Evolution. Includes multiple improvements to PPC IoT Cloud services.

### APIS

- [GET Device Models](https://iotapps.docs.apiary.io/#reference/creating-products/device-models/get-device-models)
- [GET Device Types](https://iotapps.docs.apiary.io/#reference/creating-products/supported-products)
- [GET Supported Attributes](https://iotapps.docs.apiary.io/#reference/creating-products/supported-product-attributes)
- [GET Parameters](https://iotapps.docs.apiary.io/#reference/creating-products/manage-parameters)

Device UX Model is a universal reference for App to describe every Device Type and Device Mode supported, with all parameters and attributes App can manage and use. As well as some template reference for UIs at user-facing apps.

1. We'll know available device types and models
2. We'll know the parameters supported by device type/model
3. We'll know attributes for device type configuration (admin-level settings)
4. We'll know the available options for each parameter, logic for operating device and it's history
5. We'll know how to draw UI and link parameters to template

Main concepts:

- *Device Type* - Numeric value, uses at Server-side to determine the product. Device type have an attributes and own configuration.
- *Device Models* - Structure to describe the models of different device types we're supported, structured to categories and sub-categories for front-end.
- *Parameters* - The only entities that comes from/to device itself, parameters is only to get device state and operate device itself.
- *Attributes* - Device type configuration, like "indexes", "offlineTimeOut", etc.
- *Templates* - The part of logic that only describes parameters mapping to UI.


### How it should work

Call these APIs and store in cache once (e.g. when launching the App): 
- [GET Parameters](https://iotapps.docs.apiary.io/#reference/creating-products/manage-parameters) API - all possible parameters with full reference of options.
- [GET Device Types](https://iotapps.docs.apiary.io/#reference/creating-products/supported-products) API - all possible device types and default mapping of parameters.
- [GET Device Models](https://iotapps.docs.apiary.io/#reference/creating-products/device-models/get-device-models) API - all supported and available models (branded) with a mapping to "deviceType" and differences from defaults.

Then just use standard:

- [GET List of Devices](https://iotapps.docs.apiary.io/#reference/devices/manage-devices/get-a-list-of-devices) API - all devices on account/location and current state with part of parameters returned by "deviceListParameters" attribute.
- [GET Device by ID](https://iotapps.docs.apiary.io/#reference/devices/manage-single-device/get-device-by-id) API - full device information including current state and all parameter values.

<a id="models-types"></a>
#### Associating Device Models with Device Types

Models may be linked to 1 or more device types described in [GET Device Types](https://iotapps.docs.apiary.io/#reference/creating-products/supported-products) API.  Linking is described by the [Device Model](https://iotapps.docs.apiary.io/reference/creating-products/device-models)'s `lookupParam` property.

#### Device Parameters

[GET Device Models](https://iotapps.docs.apiary.io/#reference/creating-products/device-models/get-device-models) API optionally may provide each Device Model with a `displayInfo` property that includes the key `parameters`, which that can be used to describe parameters that *distinguish this particular model* from other models of the same type or/and parameters are *different from the initial reference* described in [GET Parameters](https://iotapps.docs.apiary.io/#reference/creating-products/manage-parameters) API. 

To show device parameters:
- numeric, systemUnit, scale and systemMultiplier - which unit to show for the numeric parameter.
- historical - {boolean} if true, use that parameter in History UIs

To control device:
- configured - {boolean} if true, then we can send that parameter back to device to control it

### Device List Attributes

Optionally we may have configuration at the displayInfo in specific model at Device Models API data for device list:
- controllable - {boolean} general statement of the device model (is that device controllable by user or not)
- deviceListBindings array there to configure displacement and representation type for device parameter.
    - name - {string} parameter name
    - position - {number} position ID in the list item UI element
    - displayType (optional) - {number} ID of the UI element (optional), see types at next paragraph. If not set, then parameter value and unit shows up as described by default at font-end (it could be just "value + unit", e.g. "85%" for batteryLevel parameter).

#### Position Types

Describes in which position we should pin specific parameter:
- 0 - Right aligned position at the device list item
- 1 - Second part of right aligned position divided by some symbol (depends of design) at the device list item
- 2 - Subtitle (or description) below the device list item title

Icon of the specific model should be retrieved from [GET List of Devices](https://iotapps.docs.apiary.io/#reference/devices/manage-devices/get-a-list-of-devices) API `deviceListIcon` value or optionally _overwritten_ by brand-specific icon from [GET Device Models](https://iotapps.docs.apiary.io/#reference/creating-products/device-models/get-device-models) API Category icon value (category of current device model).

*IMPORTANT: modelId may be missed or wrong for the newly added devices as Server need to get calibrationParams first, so please be careful with deviceListParameters configuration at Device Models API.*

### Display Information

The `displayInfo` property provides a flexible option for providing UI specific details and requirements.

#### Device Parameter

Display information specific to device parameters and common across all devices and brands.

| Property | Type | Description |
| -------- | ---- | ----------- |
| options  | Array | _Optional_ For each parameter if it's not numeric - notation of all supported options we can use across devices. |
| defaultOption | Int | _Optional and only if `options` array is set_ - Number to set the default value ID, otherwise use the fist option in options array. |
| mlName | Key:Value | Describes multi-language naming for that parameter. |
| displayType | Int | _Only if `configured=true`_ Number to describe how parameter would be presented at UI to control device. |
| linkedParams | Array | _Optional_ Set the linked parameters that should go together in command to device, that's related only to Models API and depends of exact model configuration. |
| valueType | Int | ID of value types (for front-end logic) to describe the type of value, that's because `numeric` attribute of parameter doesn't represent truly type. |
| minValue | Int | _Optional_ For ranged `displayType=7` and when `valueType=2`, to describe min for ranges. |
| maxValue | Int | _Optional_ For ranged `displayType=7` and when `valueType=2`, to describe max for ranges. |
| step     | Int | _Optional_ For ranged `displayType=7` and when `valueType=2`, to describe step for ranges. |


`displayType`

Uses the same structure as at [Questions](https://iotapps.docs.apiary.io/#reference/user-communications/questions/get-device-by-id) API (exception is a text box). It's combination of the IDs for general type of the element and it's sub-function. Example: "10" (same as "1") - on/off switch, "91" - single date picker...

`valueType`

Only for frontend specific logic to give an idea how that parameter values should be calculated/processed at UI level:

- 1 - Any
- 2 - Number
- 3 - Boolean
- 4 - String
- 5 - Array of any, e.g. [1, "string", 45, true ]
- 6 - Array of numbers, e.g. [1, 3, 77]
- 7 - Array of strings, e.g. ["horn", "bull", "rose"]
- 8 - Object

#### Device Model

Display information specific to this described Device Model.  All fields are optional.

| Property | Type | Description |
| -------- | ---- | ----------- |
| controllable | Bool | This device receives commands. Default `False`. |
| bluetoothManager | String | Identifier for App's BLE manager to interface with this device. |
| serialNumberPrefix | String | Used to identify input strings (e.g. QR Scanning) and map specific logic |
| deviceListBindings | Array | Configure displacement and representation type for device parameter. See [Device List Bindings](#device-list-bindings) |
| parameters | Array | Device Parameter display information. Precedes Device Parameter `displayInfo` properties. See [Device Model Parameter](#device-model-parameter) |
| customRules | Bool | Supports custom rules. Default `True`. |
| Location Spaces | Array | Describe if this model supports spaces and what spaces are supported. See [Location Spaces](#location-spaces) |
| supportsAR | Bool | Describes if this model includes an 3d-model and allows for AR capabilities. See [Augmented Reality](#augmented-reality) |
| calibrationParams | Array | Key-value pairs, where key equals parameter name and value equals the value to check for. Devices that require a calibration step the device model should provide the required parameter name. |
| customRules | Bool | Describe if this model should allow creation/management custom rules in Device UI. Default `True` |
| codes | Bool | Describe if this model should allow creation/management custom rules in Device UI. Default `False` |
| icon | String | String value to describe the font icon name. |
| iconFont | String | String value to describe the font icon font name (e.g. "far", "iotr", etc.). |
| ranged | Bool | Describe if the options icon should be gathered for values within a range of the designated option. Icons are gathered based on the next available option.  Values range to the next greatest value. For instance, a "wifiSignal" value of "-70" would retrieve the icon for the option of value "-56" because it is less then the next option value of "-56" but greater then "-71.  And a "brightness" value of "70" would retrieve the icon for the option value to "75" because it is greater then the previous option value of "50" but less then "75". Default `False` |
| videoProfiles | Array | Describes the video profile url and name of specific camera device models. |
| appRequiresWiFi | Bool | Require device onboarding and configuration to be done while the App is connected to Wi-Fi. Default `False` |
| baseModelPrefix | String | Describe the association between similar device models that have the same model id prefix. Used on new device discovery if a new device was found with a similar model ID then we automatically move forward in our OOBE and do not notify the user.

##### Device List Bindings

Configure displacement and representation type for device parameter. Describe how parameters returned for each device in Device List should be bonded into the list items

| Property | Type | Description |
| -------- | ---- | ----------- |
| name | String | Parameter name |
| position | Int | As a binding displacement. |
| displayType | Int | Notify App allow control of this parameter from Device List UI. Included only if `controllable` set to true. |

*Position*

Describes in which position we should pin specific parameter:
- 0 - Right aligned position at the device list item
- 1 - Second part of right aligned position divided by some symbol (depends of design) at the device list item
- 2 - Subtitle (or description) below the device list item title

##### Device Model Parameters

String encoded JSON array of parameters to be displayed or managed. Precedes Parameter Display Info settings.

| Property | Type | Description |
| -------- | ---- | ----------- |
| name | String | Described mapped parameter. |
| defaultOption | Int | _Optional_ Set the default option ID (if not set, then use first option in the array as default). |
| availableOptions | Array | array to describe available values for specific parameter if it differs from default values. See [Device Parameter Display Information](#device-parameter). |
| linkedParams | Array | Parameter names only if current parameter need to be passed to [PUT Send a Command](https://iotapps.docs.apiary.io/#reference/device-measurements/parameters-for-a-specific-device/send-a-command) API along with some other params. |
| refresh | Bool | _Optional_ Declare this parameter to be included in [PUT Send a Command](https://iotapps.docs.apiary.io/#reference/device-measurements/parameters-for-a-specific-device/send-a-command) API when requesting specific parameters to be updated. Defualt `False` |

- Parameter values from "availableOptions", and "defaultOption" with an option.id from full parameters notation at [GET Device Parameters](https://iotapps.docs.apiary.io/#reference/creating-products/manage-parameters/get-parameters) API
- This parameter settings notation should be used prior the Parameters API full notation.
- Same across all brands
- Our system allows us to manually request our cloud to refresh parameters from certain devices.  For example, sending a command with "commandType=4" and including parameter name "ccidIndex" will request that our server refresh the current ccidIndex of our develco gateway's apn.  Ref CLOUD-2004.

##### Location Spaces

Describe if this model supports spaces and what spaces are supported.

- Array of objects with space types and names
- If the `locationSpaces` array is not included, then the device should not allow setting/editing location spaces (or have full list of spaces to choose from)
- Also part of Device Onboarding
- Types are defined by Stories API / Bots themselves. See the [Get Spaces API](https://iotapps.docs.apiary.io/#reference/locations/location-spaces/get-spaces) for a list of spaces to render in the App.

##### Video Profiles

Describes the video profile url and name of specific camera device models.

| Property | Type | Description |
| -------- | ---- | ----------- |
| name     | String | Video profile name. May be displayed to the user as needed. |
| path     | String | Video profile path used for video streaming playback. |

## Diagrams

### Smart Home Center

![png](./smart_home_center.png)

#### APIs

##### [GET List of Devices](https://iotapps.docs.apiary.io/#reference/devices/manage-devices/get-a-list-of-devices)

*Refresh devices*

Params:
- locationId: $locationId
- checkPersistent: true

##### [GET Current Measurements](https://iotapps.docs.apiary.io/#reference/device-measurements/parameters-for-a-specific-device/get-current-measurements)

*Refresh device parameters*

Params:
- deviceId: $deviceId
- locationId: $locationId

##### [GET Device Properties](https://iotapps.docs.apiary.io/#reference/devices/device-properties/get-device-properties)

*Refresh device properites*

Params:
- deviceId: $deviceId
- locationId: $locationId

##### [PUT Send Commands](https://iotapps.docs.apiary.io/#reference/device-measurements/parameters-for-a-specific-device/send-a-command)

*Notify device to refresh parameters*

_Note: The device model's `displayInfo` property describes what parameter names to include_

Params:
- locationId: $locationId
- data: `{'devices': [{'deviceId': $deviceId, 'commandType': 4, 'commandTimeout': 60, 'params': $DeviceModel.refreshParameters}]}`
