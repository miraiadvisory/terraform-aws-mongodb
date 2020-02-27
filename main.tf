resource "aws_instance" "primary" {
  ami                     = var.ami
  instance_type           = var.instance_type_data
  key_name                = var.key_name
  subnet_id               = var.subnet_id_1
  private_ip              = var.private_ip_1
  vpc_security_group_ids  = ["${aws_security_group.mongodb.id}"]
  ebs_block_device {
    device_name           = var.ebs_device_name
    volume_type           = var.ebs_volume_type
    volume_size           = var.ebs_volume_size
    delete_on_termination = var.deletes_on_termination
  }
  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}

resource "aws_instance" "secondary" {
  ami                     = var.ami
  instance_type           = var.instance_type_data
  key_name                = var.key_name
  subnet_id               = var.subnet_id_2
  private_ip              = var.private_ip_2
  vpc_security_group_ids  = ["${aws_security_group.mongodb.id}"]
  ebs_block_device {
    device_name           = var.ebs_device_name
    volume_type           = var.ebs_volume_type
    volume_size           = var.ebs_volume_size
    delete_on_termination = var.deletes_on_termination
  }
  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}

resource "aws_instance" "arbiter" {
  ami                     = var.ami
  instance_type           = var.instance_type_arbiter
  key_name                = var.key_name
  subnet_id               = var.subnet_id_3
  private_ip              = var.private_ip_3
  vpc_security_group_ids  = ["${aws_security_group.mongodb.id}"]
  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}

### Route 53 ###

data "aws_route53_zone" "pro" {
  name         = var.dns_name
  private_zone = true
}

resource "aws_route53_record" "mongoprimary" {
  zone_id = data.aws_route53_zone.pro.zone_id
  name    = "mongodb1.${data.aws_route53_zone.pro.name}"
  type    = "A"
  ttl     = "300"
  records = [var.private_ip_1]
}

resource "aws_route53_record" "mongosecondary" {
  zone_id = data.aws_route53_zone.pro.zone_id
  name    = "mongodb2.${data.aws_route53_zone.pro.name}"
  type    = "A"
  ttl     = "300"
  records = [var.private_ip_2]
}

resource "aws_route53_record" "mongoarbiter" {
  zone_id = data.aws_route53_zone.pro.zone_id
  name    = "mongodb3.${data.aws_route53_zone.pro.name}"
  type    = "A"
  ttl     = "300"
  records = [var.private_ip_3]
}

resource "aws_route53_record" "servicelocator" {
  zone_id = data.aws_route53_zone.pro.zone_id
  name    = "_mongodb._tcp.rs.${data.aws_route53_zone.pro.name}"
  type    = "SRV"
  ttl     = "300"
  records = [
    "0 0 27017 ${aws_route53_record.mongoprimary.name}",
    "0 0 27017 ${aws_route53_record.mongosecondary.name}",
    "0 0 27017 ${aws_route53_record.mongoarbiter.name}"
  ]
}

resource "aws_route53_record" "replicaset" {
  zone_id = data.aws_route53_zone.pro.zone_id
  name    = "rs.${data.aws_route53_zone.pro.name}"
  type    = "TXT"
  ttl     = "300"
  records = ["authSource=eskariam&replicaSet=eskariam"]
}

### Security Group ###

resource "aws_security_group" "mongodb" {
  name        = "mongodb-sg"
  description = "MongoDB Cluster SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = var.ingress_ssh_sg
  }

  ingress {
    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"
    security_groups = var.ingress_mongodb_sg
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}
