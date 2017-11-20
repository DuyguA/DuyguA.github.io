#!/bin/bash

while read name; do
    grep "$name" business.json
done < city_list.txt | jq .business_id | sort | uniq > ids.txt
