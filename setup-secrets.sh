#!/bin/sh

echo "**** Enable kv-v2 at web-team/ ****"
vault secrets enable -path=web-team kv-v2
echo
echo "**** Enable kv-v2 at dev-app/ ****"
vault secrets enable -path=dev-app kv-v2
echo

echo "**** Populate secrets ****"
vault kv put -mount=web-team api-keys key1="4984h33sd" key2="o48r3eqf"
vault kv put -mount=dev-app creds user=tester1 password="my-long-password"
vault kv put -mount=dev-app creds/database/db-admin username=admin password="o3ir23ir"

echo
echo "**** Create a client token & login ****"
vault token create -field=token > token.txt
vault login $(cat token.txt)


echo "============================="
echo "Setup PKI secrets engine"
echo "============================="

# Root CA
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault write -field=certificate pki/root/generate/internal \
     common_name="example.com" \
     issuer_name="root-2022" \
     ttl=87600h > root_2022_ca.crt

vault write pki/roles/2022-servers allow_any_name=true

vault write pki/config/urls \
     issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
     crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

# Intermediate CA
vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int

vault write -format=json pki_int/intermediate/generate/internal \
     common_name="example.com Intermediate Authority" \
     issuer_name="example-dot-com-intermediate" \
     | jq -r '.data.csr' > pki_intermediate.csr

vault write -format=json pki/root/sign-intermediate \
     issuer_ref="root-2022" \
     csr=@pki_intermediate.csr \
     format=pem_bundle ttl="43800h" \
     | jq -r '.data.certificate' > intermediate.cert.pem

vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem

vault write pki_int/roles/example-dot-com \
     issuer_ref="$(vault read -field=default pki_int/config/issuers)" \
     allowed_domains="example.com" \
     allow_subdomains=true \
     max_ttl="720h"








