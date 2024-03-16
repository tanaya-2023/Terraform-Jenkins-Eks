terraform {
  backend "s3" {
    bucket = "terraform-jenkins-eks-bucket"  ### bucket name
    key    = "jenkins/eks/terraform.tfstate" ### Key is where I want to store my tfstate files
    region = "us-east-1"
  }
}

