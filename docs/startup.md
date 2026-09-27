# Terraform startup test

1. Set AWS Profile as devsecops
    set AWS_PROFILE=devsecops

2. terraform init
    (Versioning only changes on init with the "-upgrade" flag)
    
3. terraform plan -o="filename.tfplan"
5. terraform apply "filename.tfplan"


## Verification Section

## Submissions
To verify if submissions made it into the RDS Instance, we will use a script baked into the app (show_submissions.py).
' kubectl exec deploy/contact-form -n ccontact-form -- python show_submissions.py '