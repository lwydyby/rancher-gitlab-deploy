#!/bin/bash

programName=$1
workspace=$2
namespace=$3
ip=$4
token=$5

function update()
{
    url='https://'${ip}'/v3/project/'${workspace}'/workloads/deployment:'${namespace}':'${programName}''
    #curl 请求
    pod_upgrade_body=$(curl -s "$url" -X GET -u "$token" -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'content-type: application/json' -H 'accept: application/json'  --insecure 2>&1 | sed  "s/\"cattle\.io\/timestamp\"\:\"[0-9T:Z-]*\"/\"cattle\.io\/timestamp\":\"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"/g")

    echo "$pod_upgrade_body"
    curl 'https://'${ip}'/v3/project/'${workspace}'/workloads/deployment:'${namespace}':'${programName}'' -X PUT -u "$token"  -H 'Accept-Encoding: gzip, deflate, br' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'content-type: application/json' -H 'accept: application/json' --data-binary "$pod_upgrade_body" --compressed --insecure
}

update
