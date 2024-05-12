# Create a CodeCommit repository.
resource "aws_codecommit_repository" "main" {
  repository_name = "repo-${var.system_identifier}"
}