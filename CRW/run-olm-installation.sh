/home/mmusiien/tmp/crwctl/bin/crwctl server:start -n ${USER}-crw \
--che-operator-cr-patch-yaml=custom-resource-patch.yaml \
--catalog-source-name=codeready-workspaces-latest \
--catalog-source-namespace=openshift-marketplace \
--package-manifest-name=codeready-workspaces \
--olm-channel=latest
