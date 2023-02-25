variable "vpc_cidr_block" {
  description = "The cidr block for my 3 tier vpc"
  default     = "10.10.0.0/16"
}

variable "pub1_3tier_cidr_block" {
  description = "The cidr block for my pub1_3tier"
  default     = "10.10.1.0/24"
}

variable "pub1_3tier_zone" {
  description = "The zone for my pub1_3tier"
  default     = "us-east-2a"
}
