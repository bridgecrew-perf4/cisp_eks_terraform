resource "aws_ecr_repository" "main" {
  for_each = toset(var.repo-name)
  name                 = each.key
  image_tag_mutability = var.image-mutability

  image_scanning_configuration {
    scan_on_push = var.image-scan
  }
}

