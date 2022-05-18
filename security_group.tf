resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "sg for databse"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # cidr_blocks = [aws_vpc.tf-vpc.cidr_block]
    cidr_blocks = [aws_vpc.tf-vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.common_tags, {
    Name = "db-sg"
  })
}

