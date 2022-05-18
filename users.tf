// Use this user to use aws ssm
resource "aws_iam_user" "connector" {
  name = "connector"
}

// AWS credential
resource "aws_iam_access_key" "key" {
  user = aws_iam_user.connector.name
}
