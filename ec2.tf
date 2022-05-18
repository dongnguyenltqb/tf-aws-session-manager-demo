// Private instance to test session manager
resource "aws_instance" "db" {
  // find ami id here for ubuntu
  // https://cloud-images.ubuntu.com/locator/
  // this ami come with preinstalled SSM agent
  ami                         = "ami-055d15d9cfddf7bd3"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.tf-1a-private.id
  vpc_security_group_ids      = [aws_security_group.db.id]
  associate_public_ip_address = true
  tags = merge(local.common_tags, {
    Name = "ec2-db"
  })
  key_name             = aws_key_pair.db.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm.id
  root_block_device {
    tags        = local.common_tags
    volume_size = 10
    volume_type = "gp3"
  }
}

resource "aws_key_pair" "db" {
  key_name   = "db"
  public_key = var.pubkey
}


