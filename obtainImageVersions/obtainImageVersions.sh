#!/bin/bash

NAMESPACE=$1

function obtainPodName(){
    local podPartialName=$1

    echo "$(oc get pods -n $NAMESPACE | grep $podPartialName | awk '{print $1;}' | awk 'NR==1{print $1}')"
}

function obtainImageVersion(){
    local podName=$1

    echo "$(oc get pod $podName -o json -n $NAMESPACE | jq  .status.containerStatuses[].imageID)"
}


SERVER_POD_NAME=$(obtainPodName codeready)
DEVFILE_REGISTRY_POD_NAME=$(obtainPodName devfile-registry)
PLUGIN_REGISTRY_POD_NAME=$(obtainPodName plugin-registry)


SERVER_IMAGE=$(obtainImageVersion $SERVER_POD_NAME)
DEVFILE_REGISTRY_IMAGE=$(obtainImageVersion $DEVFILE_REGISTRY_POD_NAME)
PLUGIN_REGISTRY_IMAGE=$(obtainImageVersion $PLUGIN_REGISTRY_POD_NAME)

echo ""
echo "############ Used images ##########################"
echo ""
echo "Server image"
echo "    $SERVER_IMAGE"
echo ""
echo "Devfile registry image"
echo "    $DEVFILE_REGISTRY_IMAGE"
echo ""
echo "Plugin registry image"
echo "    $PLUGIN_REGISTRY_IMAGE"
echo ""
echo "###################################################"
echo ""
echo ""
echo ""


echo "########    Compare this values with latest #######"

echo ""
echo "Server"
echo "    https://quay.io/repository/crw/server-rhel8?tab=tags"
echo ""
echo "Devfile registry"
echo "    https://quay.io/repository/crw/devfileregistry-rhel8?tab=tags"
echo ""
echo "Plugin registry"
echo "    https://quay.io/repository/crw/pluginregistry-rhel8?tab=tags"
echo ""

