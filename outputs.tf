output "nat_ip" {
  value = aws_eip.tf-nat-ip.public_ip
}

output "ssm_iam_profile_arn" {
  value = aws_iam_instance_profile.ssm.arn
}

output "db_instance_id" {
  value = aws_instance.db.id
}

output "db_instance_private_ip" {
  value = aws_instance.db.private_ip
}

output "db_instance_arn" {
  value = aws_instance.db.arn
}

output "user_connector_arn" {
  value = aws_iam_user.connector.arn
}


output "account_id" {
  value     = aws_iam_user.connector
  sensitive = true
}

output "user_connector_key" {
  value     = aws_iam_access_key.key.id
  sensitive = true
}

output "user_connector_secret" {
  value     = aws_iam_access_key.key.secret
  sensitive = true
}
