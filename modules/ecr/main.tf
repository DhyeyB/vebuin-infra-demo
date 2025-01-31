resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.app_name}-${var.env}"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name        = "${var.app_name}-ecr-repo-${var.env}"
    Environment = "${var.env}"
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.ecr_repo.name

  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 10 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 10
     }
   }]
  })
}

resource "null_resource" "upload_image" {
  depends_on = [aws_ecr_lifecycle_policy.main]

  count = var.upload_docker_image != null ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      cd ${var.dockerfile_path}
      aws ecr get-login-password --region ${var.region}  --profile ${var.profile} | docker login --username AWS --password-stdin $(dirname "${aws_ecr_repository.ecr_repo.repository_url}")
      docker build -t ${aws_ecr_repository.ecr_repo.repository_url}:latest .
      docker push ${aws_ecr_repository.ecr_repo.repository_url}:latest
    EOT
  }
}