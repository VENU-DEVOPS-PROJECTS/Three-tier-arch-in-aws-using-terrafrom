variable "region" {
  description = "Region of AWS instance"
  default     = "us-east-2"
}

variable "vpc_cidr_block" {
  description = "The cidr block for my 3 tier vpc"
  default     = "10.10.0.0/16"
}

variable "sub_3tier_zonea" {
  description = "The zonea for my pub1_3tier"
  default     = "us-east-2a"
}

variable "sub_3tier_zoneb" {
  description = "The zoneb for my pub1_3tier"
  default     = "us-east-2b"
}

variable "pub1_3tier_cidr_block" {
  description = "The cidr block for my pub1_3tier"
  default     = "10.10.1.0/24"
}

variable "pub2_3tier_cidr_block" {
  description = "The cidr block for my pub2_3tier"
  default     = "10.10.2.0/24"
}

variable "priv3_3tier_cidr_block" {
  description = "The cidr block for my priv3_3tier"
  default     = "10.10.3.0/24"
}

variable "priv4_3tier_cidr_block" {
  description = "The cidr block for my priv4_3tier"
  default     = "10.10.4.0/24"
}

variable "priv5_3tier_cidr_block" {
  description = "The cidr block for my priv5_3tier"
  default     = "10.10.5.0/24"
}

variable "priv6_3tier_cidr_block" {
  description = "The cidr block for my priv6_3tier"
  default     = "10.10.6.0/24"
}

variable "image_id" {
  description = "The image to be used in launch configuration"
  default     = "ami-0cc87e5027adcdca8"
}

variable "instance_type" {
  description = "The type of instance to be used in launch configuration"
  default     = "t2.micro"
}
