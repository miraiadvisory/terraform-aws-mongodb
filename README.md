# Terraform MongoDB provisioner using AWS EC2

This module provision a MongoDB three member replica set with an arbiter on AWS EC2.

## Content
- Three instances: a primary, a secondary and an arbiter.
- A security group
- Five route53 records


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami | The AMI to use for the instance | `string` | `""` | no |
| deletes\_on\_termination | Whether the volume should be destroyed on instance termination. | `bool` | `true` | no |
| dns\_name | This is the name of the hosted zone. | `string` | `""` | no |
| ebs\_device\_name | The name of the device to mount. | `string` | `"/dev/xvdz"` | no |
| ebs\_volume\_size | The size of the volume in gibibytes (GiB). | `number` | `100` | no |
| ebs\_volume\_type | The type of volume. Can be 'standard', 'gp2', 'io1', 'sc1', or 'st1'. | `string` | `"gp2"` | no |
| environment | n/a | `string` | `""` | no |
| ingress\_mongodb\_sg | List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| ingress\_mongoexporter\_sg | List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| ingress\_ssh\_sg | List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| instance\_name\_1 | Name of the first instance, used in tags and DNS | `string` | n/a | yes |
| instance\_name\_2 | Name of the second instance, used in tags and DNS | `string` | n/a | yes |
| instance\_name\_3 | Name of the arbiter instance, used in tags and DNS | `string` | n/a | yes |
| instance\_profile | The IAM Instance Profile to associate the instance with. Specified as the name of the Instance Profile | `string` | `""` | no |
| instance\_schedule | Schedule tag to control uptime | `string` | `""` | no |
| instance\_type\_arbiter | The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance. | `string` | `""` | no |
| instance\_type\_data | The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance. | `string` | `""` | no |
| key\_name | The key name of the Key Pair to use for the instance. | `string` | `""` | no |
| private\_ip\_1 | The private IP address assigned to the primary instance | `string` | `""` | no |
| private\_ip\_2 | The private IP address assigned to the secondary instance | `string` | `""` | no |
| private\_ip\_3 | The private IP address assigned to the arbiter instance | `string` | `""` | no |
| projectname | n/a | `string` | `""` | no |
| replicaset\_record | replicaSet and authSource connection string. You may only specify one TXT record per mongod instance. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| subnet\_id\_1 | The VPC Subnet ID to launch the primary instance in. | `string` | `""` | no |
| subnet\_id\_2 | The VPC Subnet ID to launch the secondary instance in. | `string` | `""` | no |
| subnet\_id\_3 | The VPC Subnet ID to launch the arbiter instance in. | `string` | `""` | no |
| vpc\_id | (Forces new resource) The VPC ID. | `string` | `""` | no |
| vpc\_security\_group\_ids | The associated security groups in non-default VPC | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |

## Outputs

No output.
