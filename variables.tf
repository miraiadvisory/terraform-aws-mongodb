variable "ami" {
  description = "The AMI to use for the instance"
  default     = ""
  type        = string
}

variable "instance_type_data" {
  description = "The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance."
  default     = ""
  type        = string
}

variable "instance_type_arbiter" {
  description = "The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance."
  default     = ""
  type        = string
}

variable "key_name" {
  description = "The key name of the Key Pair to use for the instance."
  default     = ""
  type        = string
}

variable "subnet_id_1" {
  description = "The VPC Subnet ID to launch the primary instance in."
  default     = ""
  type        = string
}

variable "subnet_id_2" {
  description = "The VPC Subnet ID to launch the secondary instance in."
  default     = ""
  type        = string
}

variable "subnet_id_3" {
  description = "The VPC Subnet ID to launch the arbiter instance in."
  default     = ""
  type        = string
}

variable "dns_name" {
  description = "This is the name of the hosted zone."
  default     = ""
  type        = string
}

variable "private_ip_1" {
  description = "The private IP address assigned to the primary instance"
  default     = ""
  type        = string
}

variable "private_ip_2" {
  description = "The private IP address assigned to the secondary instance"
  default     = ""
  type        = string
}

variable "private_ip_3" {
  description = "The private IP address assigned to the arbiter instance"
  default     = ""
  type        = string
}

variable "instance_profile" {
  description = "The IAM Instance Profile to associate the instance with. Specified as the name of the Instance Profile"
  default     = ""
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The associated security groups in non-default VPC"
  default     = [""]
  type        = list(string)
}

variable "ebs_device_name" {
  description = "The name of the device to mount."
  default     = "/dev/xvdz"
  type        = string
}

variable "ebs_volume_type" {
  description = "The type of volume. Can be 'standard', 'gp2', 'io1', 'sc1', or 'st1'."
  default     = "gp2"
  type        = string
}

variable "ebs_volume_size" {
  description = "The size of the volume in gibibytes (GiB)."
  default     = 100
  type        = number
}

variable "deletes_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
  type        = bool
}

variable "vpc_id" {
  description = "(Forces new resource) The VPC ID."
  default     = ""
  type        = string
}

variable "ingress_ssh_sg" {
  description = "List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC."
  default     = [""]
  type        = list(string)
}

variable "ingress_mongodb_sg" {
  description = "List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC."
  default     = [""]
  type        = list(string)
}

variable "environment" {
  description = ""
  default     = ""
  type        = string
}

variable "projectname" {
  description = ""
  default     = ""
  type        = string
}