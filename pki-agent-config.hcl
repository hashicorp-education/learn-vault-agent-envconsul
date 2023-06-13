env_template "CERT" {
	contents = "{{ with pkiCert \"pki_int/issue/example-dot-com\" \"common_name=test.example.com\" \"ttl=24h\"}}{{ .Data.Cert }}{{ end }}"
	error_on_missing_key = true
}

exec {
	command = ["./pki-demo.sh"]
	restart_on_secret_changes = "always"
    restart_stop_signal       = "SIGTERM"
}