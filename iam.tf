// NOTE https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-add-permissions-to-existing-profile.html
//  this instance profile allow ssm agent on instance to connect to AWS System Manager Service
resource "aws_iam_instance_profile" "ssm" {
  name = "ec_profile_with_ssm"
  role = aws_iam_role.ssm.name
}

resource "aws_iam_role" "ssm" {
  name = "ec2_ssm_instance_role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
  })
}


// required: policy AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "attach_policy_AmazonSSMManagedInstanceCore_ec2_ssm_isntace_role" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Follow these steps to embed Session Manager permissions in an existing AWS Identity and Access Management (IAM) role that doesn't rely on the AWS-provided default policy AmazonSSMManagedInstanceCore for instance permissions. This procedure assumes that your existing role already includes other Systems Manager ssm permissions for actions you want to allow access to. This policy alone isn't enough to use Session Manager.
resource "aws_iam_policy" "ssm" {
  name = "ec2_ssm_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetEncryptionConfiguration"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy_ssm_policy_ec2_ssm_isntace_role" {
  role       = aws_iam_role.ssm.name
  policy_arn = aws_iam_policy.ssm.arn
}


// Policy for IAM user to start an session
resource "aws_iam_policy" "connector" {
  name = "policy-connect-session-manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:StartSession",
          "ssm:TerminateSession"
        ],
        "Resource" : [
          format("arn:aws:ssm:%s:%s:session/%s-*", var.aws_region, var.account_id, aws_iam_user.connector.name),
          aws_instance.db.arn,
          format("arn:aws:ssm:%s:%s:document/SSM-SessionManagerRunShell", var.aws_region, var.account_id),
          "arn:aws:ssm:ap-southeast-1::document/AWS-StartPortForwardingSession"
        ]
      }
    ]
  })
}


resource "aws_iam_policy_attachment" "attach_connect_policy_to_connector" {
  name       = "attach_connect_policy_to_connector"
  policy_arn = aws_iam_policy.connector.arn
  users      = [aws_iam_user.connector.name]
}
