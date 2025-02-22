provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.1"


  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.3"

  name        = "public-subnet"
  environment = "test"
  label_order = ["name", "environment"]

  availability_zones = ["eu-west-1c"]
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

  source      = "../../"
  name        = "es"
  environment = "test"
  label_order = ["name", "environment"]

  #IAM
  enable_iam_service_linked_role = false
  iam_actions                    = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]


  #Networking

  vpc_enabled        = true
  security_group_ids = [module.security_group.security_group_ids]
  subnet_ids         = tolist(module.public_subnets.public_subnet_id)


  #Es

  elasticsearch_version = "7.8"
  instance_type         = "c5.large.elasticsearch"
  instance_count        = 1

  #Volume
  volume_size = 30
  volume_type = "gp2"

  #Logs
  log_publishing_application_enabled = true



  #Cognito
  cognito_enabled  = false
  user_pool_id     = ""
  identity_pool_id = ""

  #DNS
  kibana_hostname = "kibana"
  dns_zone_id     = "Z1XJD7SSBKXLC1"
  dns_enabled     = false
  es_hostname     = "es"


  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  enforce_https       = true
  tls_security_policy = "Policy-Min-TLS-1-0-2019-07"

}
