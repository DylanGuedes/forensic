# Considerations
- In every request you should pass a `capabilities` param and a schema
for each capability (named `#{capability_name}_schema`, such as
`car_mobility_schema` for the capability `car_mobility`).

## Run Linear Regression in a Capability

```python
  url = "http://localhost:4545/api/run_job"
  requests.post(url, json={
    'job': 'linear_regression',
    'others': ['tick', 'nodeID'],
    'current_location_schema': ['tick', 'integer','date', 'string','nodeID', 'double'],
    'capabilities': ['current_location']})
 ```
