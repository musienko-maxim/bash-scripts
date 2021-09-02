function setupSelfSignedCertificate() {
  # Docs: https://www.eclipse.org/coderedyworkspaces/docs/coderedyworkspaces-7/installing-coderedyworkspaces-in-tls-mode-with-self-signed-certificates/#deploying-coderedyworkspaces-with-self-signed-tls-on-openshift3-using-operator_installing-coderedyworkspaces-in-tls-mode-with-self-signed-certificates

  # 1. Generate self-signed certificate

  ## Declare CN
  export CA_CN=eclipse-coderedyworkspaces-signer

  export DOMAIN=*.$(minishift ip).nip.io

  ## Create Root Key
  openssl genrsa -out rootCA.key 4096

  ## Create and self sign the Root Certificate
  openssl req -x509 -new -nodes -key rootCA.key -subj /CN=${CA_CN} -sha256 -days 1024 -out rootCA.crt

  ## Create the certificate key
  openssl genrsa -out domain.key 2048

  ## Create the signing (csr)
  openssl req -new -sha256 -key domain.key -subj "/C=US/ST=CK/O=RedHat/CN=${DOMAIN}" -out domain.csr

  ## Verify Csr
  openssl req -in domain.csr -noout -text

  ## Generate the certificate using the domain csr and key along with the CA Root key
  openssl x509 -req -in domain.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out domain.crt -days 500 -sha256

  ## Verify the certificate's content
  openssl x509 -in domain.crt -text -noout

  # 2. Configure coderedyworkspaces namespace to use self-signed certificate

  ## Re-configure the router with the generated certificate
  oc project default
  oc delete secret router-certs
  cat domain.crt domain.key > minishift.crt
  oc create secret tls router-certs --key=domain.key --cert=minishift.crt
  oc rollout status dc router
  oc rollout latest router
  oc rollout status dc router

  ## Pre-create a namespace for coderedyworkspaces
  oc create namespace coderedyworkspaces

  ## Create a secret from the CA certificate
  cp rootCA.crt ca.crt
  oc create secret generic self-signed-certificate --from-file=ca.crt -n=coderedyworkspaces
  oc project coderedyworkspaces
}
setupSelfSignedCertificate
