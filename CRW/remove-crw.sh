set -ex
export codereadyNamespace=$S1

if [ $# -eq 0 ]
then echo -e '\e[31mThe workspace name is not passed. Please set up wsname'
exit 1
fi

export KEYCLOAK_URL=$(oc get route/keycloak -n ${codereadyNamespace} -o jsonpath='{.spec.host}')
export KEYCLOAK_BASE_URL="http://${KEYCLOAK_URL}/auth"
export USER_ACCESS_TOKEN=$(curl -X POST $KEYCLOAK_BASE_URL/realms/codeready/protocol/openid-connect/token \
                       -H "Content-Type: application/x-www-form-urlencoded" \
                       -d "username=admin" \
                       -d "password=admin" \
                       -d "grant_type=password" \
                       -d "client_id=codeready-public" | jq -r .access_token)

/home/mmusiien/tmp/crwctl/bin/crwctl server:stop -n ${codereadyNamespace} --access-token=$USER_ACCESS_TOKEN
oc project ${codereadyNamespace}
oc delete deployment codeready-operator
oc delete checluster codeready-workspaces
oc delete project ${codereadyNamespace}
