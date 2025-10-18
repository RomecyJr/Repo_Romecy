#!/usr/bin/env python3
import json
disks = [{"{#MOUNT}": "/"}, {"{#MOUNT}": "/data"}]
print(json.dumps({"data": disks}))
