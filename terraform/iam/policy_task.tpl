{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:*",
        "secretsmanager:*",
        "s3:*",
        "ecr:*",
        "ec2:*",
        "dynamodb:*",
        "ecs:*",
        "elasticloadbalancing:*",
        "xray:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}