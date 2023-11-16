terraform {
  backend "s3" {
    bucket = "jjtech-netflix-tf-project-2451"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
    workspace_key_prefix = "env" #Isolate state file and create a folder with current/respective workspace "dev" "prod" for  state file
  }
}