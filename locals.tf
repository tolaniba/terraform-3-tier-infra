locals {
  project_tags = {
    contact      = "devops@jjtech.com"
    application  = "payments"
    project      = "jjtech"
    environment  = "${terraform.workspace}"                         #To get current work space
    creationTime = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp()) # Take the time and format it
  }
}