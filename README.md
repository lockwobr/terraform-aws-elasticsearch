<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AWS Elasticsearch
</h1>

<p align="center" style="font-size: 1.2rem;"> 
    Terraform module to create an Elasticsearch resource on AWS.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/terraform-v1.1.7-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>
<a href="https://github.com/clouddrove/terraform-aws-elasticsearch/actions/workflows/tfsec.yml">
  <img src="https://github.com/clouddrove/terraform-aws-elasticsearch/actions/workflows/tfsec.yml/badge.svg" alt="tfsec">
</a>
<a href="https://github.com/clouddrove/terraform-aws-elasticsearch/actions/workflows/terraform.yml">
  <img src="https://github.com/clouddrove/terraform-aws-elasticsearch/actions/workflows/terraform.yml/badge.svg" alt="static-checks">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-elasticsearch'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+Elasticsearch&url=https://github.com/clouddrove/terraform-aws-elasticsearch'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+Elasticsearch&url=https://github.com/clouddrove/terraform-aws-elasticsearch'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure. 

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies: 

- [Terraform 1.x.x](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-elasticsearch/releases).


Here are examples of how you can use this module in your inventory structure:
### Multi Node non vpc
```hcl
  module "elasticsearch" {
  source      = "clouddrove/elasticsearch/aws"
  
  name        = "es"
  environment = "test"
  label_order = ["name", "environment"]
  domain_name = "clouddrove"

  #IAM
  enable_iam_service_linked_role = false
  iam_actions                    = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]

  #Networking
  vpc_enabled             = false
  availability_zone_count = 2
  zone_awareness_enabled  = true
  allowed_cidr_blocks     = ["51.79.69.69"]


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
  }

```
### Multi Node  vpc
```hcl
    module "elasticsearch" {
    source      = "clouddrove/elasticsearch/aws"

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
```

### Single  Node Non vpc
```hcl
   source            = "clouddrove/elasticsearch/aws"

   name        = "es"
   environment = "test"
  label_order = ["name", "environment"]

  #IAM

  enable_iam_service_linked_role = false
  iam_actions                    = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]


  #Networking

  vpc_enabled         = false
  allowed_cidr_blocks = ["51.79.69.69"]


  #Es
  elasticsearch_version = "7.8"
  instance_type         = "c5.large.elasticsearch"
  instance_count        = 1

  #Volume
  volume_size = 30
  volume_type = "gp2"

  #Logs
  log_publishing_application_enabled             = true
  log_publishing_search_cloudwatch_log_group_arn = true
  log_publishing_index_cloudwatch_log_group_arn  = true



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
  public_enabled      = false

  }
```

### Single  Node  vpc

```hcl
   module "elasticsearch" {
  source            = "clouddrove/elasticsearch/aws"

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
  log_publishing_application_enabled             = true
  log_publishing_search_cloudwatch_log_group_arn = true
  log_publishing_index_cloudwatch_log_group_arn  = true



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
  public_enabled      = false

  }
```

Note: There are some type of instances which not support encryption and EBS option, Please read about this [here](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/aes-supported-instance-types.html). Also, there are some limitation for instance type, Please read [here](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/aes-limits.html)






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| advanced\_options | Key-value string pairs to specify advanced configuration options. | `map(string)` | `{}` | no |
| advanced\_security\_options\_enabled | AWS Elasticsearch Kibana enchanced security plugin enabling (forces new resource) | `bool` | `false` | no |
| advanced\_security\_options\_internal\_user\_database\_enabled | Whether to enable or not internal Kibana user database for ELK OpenDistro security plugin | `bool` | `false` | no |
| advanced\_security\_options\_master\_user\_arn | ARN of IAM user who is to be mapped to be Kibana master user (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to false) | `string` | `""` | no |
| advanced\_security\_options\_master\_user\_name | Master user username (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to true) | `string` | `""` | no |
| advanced\_security\_options\_master\_user\_password | Master user password (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to true) | `string` | `""` | no |
| allowed\_cidr\_blocks | List of CIDR blocks to be allowed to connect to the cluster | `list(string)` | `[]` | no |
| attributes | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| automated\_snapshot\_start\_hour | Hour at which automated snapshots are taken, in UTC. | `number` | `0` | no |
| availability\_zone\_count | Number of Availability Zones for the domain to use. | `number` | `2` | no |
| cloudwatch\_kms\_key\_id | The KMS key ID to encrypt the Cloudwatch logs. | `string` | `""` | no |
| cognito\_enabled | Set to false to prevent enable cognito. | `bool` | `true` | no |
| custom\_endpoint | Fully qualified domain for custom endpoint. | `string` | `""` | no |
| custom\_endpoint\_certificate\_arn | ACM certificate ARN for custom endpoint. | `string` | `""` | no |
| custom\_endpoint\_enabled | Whether to enable custom endpoint for the Elasticsearch domain. | `bool` | `false` | no |
| dedicated\_master\_count | Number of dedicated master nodes in the cluster. | `number` | `0` | no |
| dedicated\_master\_enabled | Indicates whether dedicated master nodes are enabled for the cluster. | `bool` | `false` | no |
| dedicated\_master\_type | Instance type of the dedicated master nodes in the cluster. | `string` | `"t2.small.elasticsearch"` | no |
| delimiter | Delimiter to be used between `organization`, `environment`, `name` and `attributes`. | `string` | `"-"` | no |
| dns\_enabled | Flag to control the dns\_enable. | `bool` | `false` | no |
| dns\_zone\_id | Route53 DNS Zone ID to add hostname records for Elasticsearch domain and Kibana. | `string` | `""` | no |
| domain\_name | Domain name. | `string` | `""` | no |
| elasticsearch\_version | Version of Elasticsearch to deploy. | `string` | `"6.5"` | no |
| enable\_iam\_service\_linked\_role | Whether to enabled service linked with role. | `bool` | `false` | no |
| enable\_logs | enable logs | `bool` | `true` | no |
| enabled | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| encrypt\_at\_rest\_enabled | Whether to enable encryption at rest. | `bool` | `true` | no |
| encryption\_enabled | Whether to enable node-to-node encryption. | `bool` | `true` | no |
| enforce\_https | Whether or not to require HTTPS. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| es\_hostname | The Host name of elasticserch. | `string` | `""` | no |
| iam\_actions | List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost`. | `list(string)` | `[]` | no |
| identity\_pool\_id | ID of the Cognito Identity Pool to use. | `string` | `""` | no |
| instance\_count | Number of data nodes in the cluster. | `number` | `4` | no |
| instance\_type | Elasticsearch instance type for data nodes in the cluster. | `string` | `"t2.small.elasticsearch"` | no |
| iops | The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type. | `number` | `0` | no |
| kibana\_hostname | The Host name of kibana. | `string` | `""` | no |
| kms\_key\_id | The KMS key ID to encrypt the Elasticsearch domain with. If not specified, then it defaults to using the AWS/Elasticsearch service KMS key. | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| log\_publishing\_application\_enabled | Specifies whether log publishing option for ES\_APPLICATION\_LOGS is enabled or not. | `bool` | `false` | no |
| log\_publishing\_audit\_enabled | Specifies whether log publishing option for AUDIT\_LOGS is enabled or not. | `bool` | `false` | no |
| log\_publishing\_index\_enabled | Specifies whether log publishing option for INDEX\_SLOW\_LOGS is enabled or not. | `bool` | `false` | no |
| log\_publishing\_search\_enabled | Specifies whether log publishing option for SEARCH\_SLOW\_LOGS is enabled or not. | `bool` | `false` | no |
| managed\_policy\_arns | Set of exclusive IAM managed policy ARNs to attach to the IAM role | `list(any)` | `[]` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| name\_prefix | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-elasticsearch"` | no |
| retention\_in\_days | Days of retention of cloudwatch. | `number` | `90` | no |
| security\_group\_ids | Security Group IDs. | `list(string)` | `[]` | no |
| subnet\_ids | Subnet IDs. | `list(string)` | `[]` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(any)` | `{}` | no |
| tls\_security\_policy | The name of the TLS security policy that needs to be applied to the HTTPS endpoint. | `string` | `"Policy-Min-TLS-1-0-2019-07"` | no |
| ttl | The TTL of the record to add to the DNS zone to complete certificate validation. | `string` | `"300"` | no |
| type | Type of DNS records to create. | `string` | `"CNAME"` | no |
| user\_pool\_id | ID of the Cognito User Pool to use. | `string` | `""` | no |
| volume\_size | EBS volumes for data storage in GB. | `number` | `0` | no |
| volume\_type | Storage type of EBS volumes. | `string` | `"gp2"` | no |
| vpc\_enabled | Set to false if ES should be deployed outside of VPC. | `bool` | `true` | no |
| warm\_count | Number of UltraWarm nodes | `number` | `2` | no |
| warm\_enabled | Whether AWS UltraWarm is enabled | `bool` | `false` | no |
| warm\_type | Type of UltraWarm nodes | `string` | `"ultrawarm1.medium.elasticsearch"` | no |
| zone\_awareness\_enabled | Enable zone awareness for Elasticsearch cluster. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain\_arn | ARN of the Elasticsearch domain. |
| tags | A mapping of tags to assign to the resource. |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system. 

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback 
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-elasticsearch/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-elasticsearch)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
