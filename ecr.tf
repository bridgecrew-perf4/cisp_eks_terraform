##
## AWS ECR
##
resource "aws_ecr_repository" "main" {
  for_each             = toset(var.repo-name)
  name                 = each.key
  image_tag_mutability = var.image-mutability

  image_scanning_configuration {
    scan_on_push = var.image-scan
  }
}

##
## AWS ECR Lifecycle policy
## Irá remover as imagens sem tags do ECR
##

resource "aws_ecr_lifecycle_policy" "cleanup" {
  for_each   = toset(var.repo-name)
  repository = each.key
  policy     = <<EOF
  {
    "rules": [
       {
         "rulePriority": 1,
         "description": "Remove imagens sem tags",
         "selection": {
           "tagStatus": "untagged",
           "countType": "sinceImagePushed",
           "countUnit": "days",
           "countNumber": 5
         },
         "action": {
           "type": "expire"
         }
       }
    ]
  }
  EOF
}
