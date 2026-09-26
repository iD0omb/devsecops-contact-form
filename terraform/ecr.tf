resource "aws_ecr_repository" "app" {
  name                 = "dso-contact-form"
  image_tag_mutability = "IMMUTABLE" # a tag can never be overwritten (Versioning tags)

  image_scanning_configuration {
    scan_on_push = true # vulnerability scan on every push
  }

  force_delete = true # lets terraform destroy remove it with images inside
}