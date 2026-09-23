# Gitleaks
## Pre-commit hook secrets scanner

After doing a commit test on gitleaks, it only caught 1/2 of the fake generated keys I left inside a test.py.
Heuristic based, low entropy keys could fall through the  cracks.
Good as a safety net, but not a guarantee.