# Synthetic API: Multistream Messages

Instead of one data stream message at a time, a multistream message can contain multiple data stream messages at a time, each with an optional specified delivery date in the future.

Through the `multistream` state variable, it is possible to see what data stream messages have been scheduled with a multistream message, and edit/remove scheduled data stream messages from the queue.

| Property | Type | Description |
| -------- | ---- | ----------- |
| id       | String | Optional application-generated unique ID for scheduled multistream messages, to be able to edit/remove the multistream message in the future. If a multistream message is scheduled and an ID is not provided, then the multistream microservice will automatically generate a unique ID which the application layer can later reference to edit/remove the queued multistream message. |
| timestamp | int | Optional absolute timestamp in **milliseconds**, to schedule the delivery of the multistream message. |
| Data Stream Address | String | A multistream message can contain arbitrary key/value pairs, each interpreted with the *key* as a data stream address, and the *value* as the JSON content to be delivered internally to that data stream address. |


## Input

Data Stream Address : `multistream`

#### Content
```
 {
    "id": "hello",
    "timestamp": optional_time_in_the_future_in_milliseconds,
    "message": {
       "push_content": "Hello from a multistream message."
    },
    "narrate": {
       "title": "Multistream Message",
       "description": "This is from a multistream message",
       "priority": 2,
       "icon": "stream"
    
    }
}
```

## Output

State Variable Address : `multistream`

The output only contains multistream content (multiple data stream messages) that are in the queue and have not executed yet.

The output content is a dictionary of multistream messages, where the key for each object is the `id` that was originally passed in as the multistream message ID.

```
{
    "hello": {
        "id": "hello",
        "timestamp": optional_time_in_the_future_in_milliseconds,
        "message": {
           "push_content": "Hello from a multistream message."
        },
        "narrate": {
           "title": "Multistream Message",
           "description": "This is from a multistream message",
           "priority": 2,
           "icon": "stream"
        
        }
    }
}
```

## References
* `com.ppc.Microservices/intelligence/multistream/location_multistream_microservice.py`
