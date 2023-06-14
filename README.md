# learn-vault-agent-envconsul

Tutorial files used by the [_Vault Agent - secrets as environment variables_](https://developer.hashicorp.com/vault/tutorials/vault-agent) tutorial.

- `kv-demo.sh` - a mock app leverages secrets fetched by Vault Agent (static secrets)
- `pki-demo.sh` - a mock app leverages serets fetched by Vault Agent (dynamic secrets)
- `pki-agent-config.hcl` - partial Vault Agent config file containing the `env_template` for PKI secrets engine
- `setup-secrets.sh` - this script sets up the secrets engines used by the tutorial (teaching the kv-v2 and pki secrets engines are beyond the scope of this tutorial)
