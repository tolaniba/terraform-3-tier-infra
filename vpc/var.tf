variable "vpc_cidr_block" {                      #Chatgbpt created this variable codes
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet1_cidr_block" {
  description = "CIDR block for the public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet2_cidr_block" {
  description = "CIDR block for the public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet1_cidr_block" {
  description = "CIDR block for the private subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet2_cidr_block" {
  description = "CIDR block for the private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone" {
    type = list (string)     #As you put your type as list of string
    description = "(optional) describe your variable"
    default = [ "us-east-1a", "us-east-1b" ]    #Here is the values for it
}

variable "tags" {          # Look for tags here
    type = map
    description = "tags"
}