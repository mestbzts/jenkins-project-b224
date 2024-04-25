resource "aws_ecr_repository" "nodejs" {
  name                 = "jenkins-ecr-nodejs"  
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "ECR-for-nodejs"
  }
}

resource "aws_ecr_repository" "react" {
  name                 = "jenkins-ecr-react"  
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "ECR-for-react"
  }
}

resource "aws_ecr_repository" "postgresgl" {
  name                 = "jenkins-ecr-postgresql"  
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "ECR-for-postgresql"
  }
}