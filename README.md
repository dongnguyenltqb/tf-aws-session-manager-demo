### Demo aws ssm session manager

---

#### RESOURCE

1. EC2 Instance in private subnet
2. IAM instace profile for SSM agent runnning on (2)
3. IAM user, credential (use AWS SSM service)
4. IAM policy for user(3), limit access

#### INSTALL:

1. On client side, must install Session Manager plugin
   - https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux
   - for ubuntu run
     ```
     curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
     sudo dpkg -i session-manager-plugin.deb
     ```

#### SPIN UP INFRA:

1. Edit var file

   ```
   cp tfvars.example dev.tfvars
   ```

2. Get the AWS Credential in `terraform.tfstate`
3. Spin up test info
   ```
   tf apply -var-file=dev.tfvars
   ```
4. Login

   - to start a Session
     ```
     aws ssm start-session --target $INSTANCE_ID
     ```
   - to use ssh port forwarding

     ```
      aws ssm start-session --target $INSTANCE_ID  --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["80"],"localPortNumber":["9999"]}'
     ```
