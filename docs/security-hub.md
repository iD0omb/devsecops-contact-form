## Security Hub
* The checker.
* aws_securityhub_account turns Security Hub On.
* It checks against FSBP and CIS v5.0.0.

## AWS Config
* The Records.
* Security Hub inspects and evaluates the resources from the records.
    * recorder: What to record? (all supported resources)
    * recorder_status: Turns on recording
    * delivery_channel: Where to store the history? (The S3 Bucket)
    * service-linked role: The Identity the conofig runs as.

## S3 Bucket policy
* Private (Public access is blocked), writable only by the Config service and HTTPS-only (Deny statement)
* The Security Hub will check the bucket itself, hence the need to lock it down.


