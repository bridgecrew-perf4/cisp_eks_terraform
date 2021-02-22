variable "region" {
  default     = "sa-east-1"
  description = "AWS São Paulo Region"
}

variable "aws_bucket_name" {
  default     = "cisp-tf-state"
  description = "AWS S3 Bucket for Terraform State"
}

variable "aws_dynamodb_table_name" {
  default     = "cips-tf-lock"
  description = "AWS DynamoDB table for Terraform Lock"
}

##
## EKS Variables
##
variable "eks_k8s_version" {
  default     = "1.18"
  description = "AWS EKS's Kubernetes version"
}

variable "eks_cluster_name" {
  default     = "cisp_eks"
  description = "AWS EKS Cluster Name"
}
#
variable "eks_node_group_name" {
  default     = "cisp_eks_node_group"
  description = "AWS EKS Node Group Name"
}

variable "eks_instance_types" {
  default     = ["t3.medium"]
  description = "AWS EC2 Instance Type to be used on EKS cluster"
}

variable "eks_instance_disk_size" {
  default     = 40
  description = "AWS EC2 Instance Disk Size in GiB"
}

#
# RDS Variables
#

variable "rds_storage" {
  default     = "20"
  description = "RDS minimum storage size"
}
variable "rds_max_storage" {
  default     = "10000"
  description = "RDS minimum storage size"
}

variable "rds_type" {
  default     = "gp2"
  description = "RDS type"
}

variable "rds_apps_name" {
  default     = "cisp_rds_mariadb"
  description = "RDS Name"
}

variable "rds_apps_identifier" {
  default     = "cisp-rds-mariadb"
  description = "RDS Identifier"
}

variable "rds_instance_class" {
  default     = "db.m5.large"
  description = "RDS Instance Class. The m5.large is the latest model (01/2021) with 2vCPUS and 8GiB RAM"
}

variable "rds_apps_engine" {
  default     = "mariadb"
  description = "RDS Engine used"
}

variable "rds_apps_engine_version" {
  default     = "10.5"
  description = "RDS Engine version to be used"
}

variable "rds_username" {
  type        = string
  sensitive   = true
  description = "RDS access user."
}

variable "rds_pass" {
  type        = string
  sensitive   = true
  description = "RDS password."
}

variable "rds_backup_retention_period" {
  default     = 30
  description = "RDS Database backup retention in days"
}

variable "rds_backup_window" {
  default     = "00:00-01:00"
  description = "RDS Backup window"
}

##
## AWS RDS PostgreSQL
##
variable "rds_api_name" {
  default = "cisp_api_kong"
  description = "RDS Name"
}
variable "rds_api_engine" {
  default     = "postgres"
  description = "RDS Engine used for Kong API"
}

variable "rds_api_engine_version" {
  default     = "11"
  description = "RDS Engine version to be used"
}
variable "rds_api_identifier" {
  default     = "cisp-rds-api-postgresql"
  description = "RDS Identifier"
}
variable "rds_api_username" {
  type        = string
  sensitive   = true
  description = "RDS access user."
}

variable "rds_api_pass" {
  type        = string
  sensitive   = true
  description = "RDS password."
}

##
## VPC Variables
##
variable "vpc_id" {
  default     = "vpc-4dbce728"
  description = "AWS VPC default id value for CISP account"
}
#
variable "public_subnets" {
  default     = ["172.31.200.0/24", "172.31.201.0/24", "172.31.202.0/24"]
  description = "AWS EKS public networks"
}

variable "private_subnets" {
  default     = ["172.31.203.0/24", "172.31.204.0/24", "172.31.205.0/24"]
  description = "AWS EKS private networks"
}


## ECR Variables
variable "repo-name" {
  default     = ["cisp-associada", "cisp-departamento", "cisp-gateway", "cisp-segmento"]
  description = "The repos that will be created."
}

variable "image-mutability" {
  default     = "MUTABLE"
  description = "If the tags can be changed. Options can be 'MUTABLE' or 'IMMUTABLE'"
}

variable "image-scan" {
  default     = "true"
  description = "If the images should be scanned when pushed"
}
