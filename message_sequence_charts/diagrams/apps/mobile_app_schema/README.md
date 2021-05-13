# Mobile App Schema

The client API interface allows for presenting specific screens from a url, provided either by this app or a separate app.

## Table of contents

* [Global Variables](#global-variables)
* [Dynamic Variables](#dynamic-variables)
* [Main](#main)
    * [Devices](#devices)
        * [Add Devices](#add-devices)
    * [History](#history)
    * [Dashboard](#dashboard)
    * [People](#people)
        * [Add Person](#add-person)
    * [Community](#community)
* [Account](#account)
* [Settings](#settings)
* [About](#about)
* [Support](#support)
* [Locations](#locations)
* [User Agreements](#user-agreements)
* [Faqs](#faqs)
* [Augmented Reality](#ar)
* [Bundle](#bundle)
    * [OOBE](#oobe)
* [User Codes](#user-codes)
* [Wi-Fi](#wi-fi)
* [OS](#os)
    * [Add Contact](#add-contact)

## Global Variables

These may be used with any client API.

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| api_key  | String | _Optional_ Designate user account by key.  If none provided, current user is used, if any. |
| location_id | Int | _Optional_ Designate location. If none provided, current or first location ID is used |


## Dynamic Query Variables

Some query variables may be set as placeholders, and require the application to provide the correct context in their place.  For example, you may see a url like `${appUrlScheme}://main/devices?device_id=${deviceId}`.  The application layer should replace both the ${appUrlScheme} and ${deviceId} to the appropriate values (like `presencefamily://main/devices?device_id=ABC123`).

Dynamic Query Variables may be nested, and replacement prioritization should follow the sequence of the list of available variables below.  For example, you may see a url like `https://skills-store.amazon.com/deeplink/dp/${system.${appName}-ask_smart_home}`.  The application layer should first replace `${appName}` and then replace `${system.presencefamily-ask_smart_home}` to from the final url (like `https://skills-store.amazon.com/deeplink/dp/B01HISB2SU`).

Below is a list of our current dynamic query variables:

| Property | Type | Description |
| -------- | ---- | ----------- |
| appUrlScheme | String | Replaced with app scheme like "presencefamily" |
| appName | String | Replaced with app name like “presencefamily” |
| webappUrl | String | Replaced with web app url like "https://app.peoplepowerfamily.com" |
| tempKey | String | Replaced with user's temp key.  The app should refresh the temp key before replacement. |
| appStoreUrl | String | Replaced by the applications app store / place store url (iOS/Android platforms should provided different endpoints) |
| locationId | Int | Replaced with user's current location id. Used within the context of navigating from our mobile app to the web app. Used within the context of adding contacts to the OS, the app should incorporate the location’s name, smsPhone, and the location’s organization name. |
| deviceId | String | Used within the context of our storybook OOBEs, the app should replace with the current device id being set up. |
| userId | Int | Used within the context of adding contacts to the OS, the app should incorporate the user’s firstName, lastName, phone, and email. |
| organizationId | Int | Used within the context of adding contacts to the OS, the app should incorporate the organization’s name, contactName1, contactPhone1, and contactEmail1. |
| system.property_name | String | Allows inclusion of any system property value.  For example, `${system.mms_number}` is replaced by the value of the system property named `mms_number`. If no value is available then the path parameter is ignored. |

## Diagrams

### Main

![png](./main.png)

*Path*

`main`

#### Devices

*Path*

`devices`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| device_d | String | Segue to device UI |

#### Add Device

*Path*

`main/devices/addDevice`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| model_id | String | Segue to installation story for this model |
| story_id | String | Segue to specific story |
| page_index | Int | Segue to specific page within story |

#### History

*Path*

`main/history`

#### Dashboard

*Path*

`main/dashboard`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| service | String | Service name provided by Synthetic API [Services](synthetic_apis/services.md)] |
| question_id | String | _Optional_ Segue to a specific question |
| collection_id | String | _Optional_ Segue to a collection of questions |

#### People

*Path*

`main/people`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| user_id  | Int  | Segue to specific location user |

#### Add Person

*Path*

`main/people/addPerson`

#### Community

*Path*

`main/community`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| post_id  | String | Segue to specific post |
| location_id | String | Segue to specific location |
| community_id | String | Segue to specific community |

### Account

![png](./account.png)

*Path*

`account`

### Settings

![png](./settings.png)

*Path*

`settings`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| question_id | String | Segue to a specific question |
| collection_id | String | Segue to a collection of questions |

### About

![png](./about.png)

*Path*

`about`

### Support

![png](./support.png)

*Path*

`support`

### Locations

![png](./locations.png)

*Path*

`locations`

### User Agreements

![png](./user_agreements.png)

*Path*

`userAgreements`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| story_id | String | Segue to a specific story ID |
| signature | String | Require user to "sign" agreement |

### Faqs

![png](./faqs.png)

*Path*

`faqs`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| story_id | String | Segue to a specific story ID |

### Augmented Reality

![png](./ar.png)

*Path*

`ar`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| model_id | String | Segue to AR UI for specified device model |

### Bundle

![png](./bundle.png)

*Path*

`bundle`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| model_id | String | Model ID of this device bundle or accessory |
| status   | String | Status of this device bundle or accessory |

#### OOBE

![png](./bundle.png)

*Path*

`bundle`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| story_id | String | _Optional_ Specific Bundle story ID |

### User Codes

![png](./user_codes.png)

*Path*

`user_codes`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |

### Wi-Fi

Open common Wi-Fi configuration page that lists Wi-Fi access points and allows for password input.

![png](./wifi.png)

*Path*

`wifi`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| device_id | String | Configure specific device |

*Output*

| Property | Type | Description |
| -------- | ---- | ----------- |
| ssid | String | Wi-Fi SSID |
| password | String | Wi-Fi Password |
| secureityType | String | Wi-Fi Security |

### OS

![png](./os.png)

#### Add Contact

*Path*

`os/addContact`

*Query Parameters*

| Property | Type | Description |
| -------- | ---- | ----------- |
| given_name | String | _Optional_ Overrides location, organization, or user contact information |
| family_name | String | _Optional_ Overrides location, organization, or user contact information |
| company_name | String | _Optional_ Overrides location, organization, or user contact information |
| phone_number | String | _Optional_ Overrides location, organization, or user contact information |
| email    | String | _Optional_ Overrides location, organization, or user contact information |
| location_id | Int | _Optional_ Assigns location information as contact |
| organization_id | Int | _Optional_ Assigns organization information as contact |
| user_id  | Int  | _Optional_ Assigns user information as contact |
