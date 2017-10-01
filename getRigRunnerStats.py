#!/usr/bin/env python2.7

import xmltodict
import json
import subprocess
import requests
from requests.auth import HTTPBasicAuth


user="uvarc"
password="-----"
auth = HTTPBasicAuth(user, password)
url="http://172.20.121.210/status.xml"

xml = requests.get(url, auth=auth).text
doc=xmltodict.parse(xml)
newDoc = dict()
totalAmps = 0;
for f in doc["rr4005i"]:
    n = float(doc["rr4005i"][f])
    if "LOAD" in f:
        totalAmps += n
    newDoc[f] = n
newDoc["totalAmps"] = totalAmps
print json.dumps(newDoc)
