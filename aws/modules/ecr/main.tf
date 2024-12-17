resource "aws_ecr_repository" "ecr_repository" {
  name = "dgyoon/springboot"
  force_delete = true
}