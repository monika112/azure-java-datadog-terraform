# Security Notes
Implemented: validation, safe error bodies, non-root container, no password logging.
Not yet implemented: real auth, Key Vault, Managed Identity, private networking, WAF, TLS policy, image scanning.
Review whether `clinic_id` is sensitive before production use and apply appropriate retention/masking/access controls.
