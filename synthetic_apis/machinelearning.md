# Synthetic API: Machine Learning

Request all machine learning models to recalculate. 

Useful primarily for bot developer activities.

#### Properties
| Property | Type | Description |
| -------- | ---- | ----------- |
| force    | Boolean | True to force the recalculation of machine learning models |
| reference | String | Reference for internal microservices to understand what data is provided from the server, use "all" to capture all data from the user's account and properly recalculate all models that rely upon all data. |

## Inputs

Data Stream Address : `download_data`

#### Content

```
{
    "force": True,
    "reference": "all"
}
```

## References
* `com.ppc.Microservices/intelligence/data_request/location_datarequest_microservice.py`
