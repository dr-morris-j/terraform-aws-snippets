terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "training-bucket-demo-4345"
    key    = "demo"
    region = "us-east-1"
  }
}

/* Cannot have both cloud and backend configuration simultaneously */
/* terraform {
  cloud {
    organization = "aws_quintrix_training"

    workspaces {
      name = "quinxtrix-aws-eng"
    }
  }
} */