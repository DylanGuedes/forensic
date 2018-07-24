# Run Linear Regression in a Capability

```python
  url = "http://localhost:4545/api/run_job"
  requests.post(url, json={
    'job': 'linear_regression',
    'others': ['tick', 'nodeID'],
    'current_location_schema': ['tick', 'integer','date', 'string','nodeID', 'double'],
    'capabilities': ['current_location']})
 ```
