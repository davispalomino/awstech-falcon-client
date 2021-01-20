[
  {
    "name": "${name}",
    "image": "${image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "${name}",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "aws-logs-${name}"
                }
      }
  }
]