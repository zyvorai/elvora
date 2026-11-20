# Security

Elvora is a **v0.4 developer preview**. It is production-shaped for a trusted lab or private network, but it is **not** yet a hardened multi-tenant security boundary.

- Keep the control plane off the public Internet unless you have TLS, strong operator credentials and a threat review.
- Agent and operator credentials are separate; prefer short-lived enrollment tokens and project-scoped tokens.
- Assignments are signed (HMAC or Ed25519); treat a compromised Mac as able to act only as itself.
- Report vulnerabilities privately to **security@zyvor.dev**.

Source and deeper threat notes live in the private development repository; this public repository publishes builds and docs only.
