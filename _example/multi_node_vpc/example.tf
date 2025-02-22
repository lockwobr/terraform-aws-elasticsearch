provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.1"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]
  cidr_block  = "172.16.0.0/16"
}

module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.3"

  name        = "public-subnet"
  environment = "test"
  label_order = ["name", "environment"]

  availability_zones = ["eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
}

module "security_group" {
  source  = "clouddrove/security-group/aws"
  version = "1.0.1"

  name        = "ingress_security_groups"
  environment = "test"
  label_order = ["name", "environment"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443, 9200]
}

module "elasticsearch" {
  source = "../../"

  name        = "es"
  environment = "test"
  label_order = ["name", "environment"]
  domain_name = "clouddrove"

  #IAM
  enable_iam_service_linked_role = false
  iam_actions                    = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]

  #Networking
  vpc_enabled             = true
  security_group_ids      = [module.security_group.security_group_ids]
  subnet_ids              = tolist(module.public_subnets.public_subnet_id)
  availability_zone_count = length(module.public_subnets.public_subnet_id)
  zone_awareness_enabled  = true


  #ES
  elasticsearch_version = "7.8"
  instance_type         = "c5.large.elasticsearch"
  instance_count        = 2

  # Volumes
  volume_size = 30
  volume_type = "gp2"

  #DNS
  dns_enabled     = false
  es_hostname     = "es"
  kibana_hostname = "kibana"
  dns_zone_id     = false

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  #Cognito
  cognito_enabled  = false
  user_pool_id     = ""
  identity_pool_id = ""

  #logs
  log_publishing_index_enabled       = true
  log_publishing_search_enabled      = true
  log_publishing_application_enabled = true
  log_publishing_audit_enabled       = false
}
