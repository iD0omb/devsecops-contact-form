# Security Hardening Documentation
|                           |                                                                 |
| ------------------------- | --------------------------------------------------------------- |
| Non-root containers       | Dockerfile: USER appuser                                        |
| No Hard-coded Credentials | Config via environment variables, and gitleaks pre-commit hook. |
| Exceptions                | TerraformAdmin has AdministratorAccess for IAM user creation.   |
|                           |                                                                 |
