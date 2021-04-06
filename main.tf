resource "aws_instance" "primary" {
  ami                     = var.ami
  instance_type           = var.instance_type_data
  key_name                = var.key_name
  subnet_id               = var.subnet_id_1
  private_ip              = var.private_ip_1
  iam_instance_profile    = var.instance_profile
  vpc_security_group_ids  = [aws_security_group.mongodb.id]
  root_block_device {
      volume_type = "gp2"
      volume_size = 8
      encrypted   = true
    }
  ebs_block_device {
    device_name           = var.ebs_device_name
    volume_type           = var.ebs_volume_type
    volume_size           = var.ebs_volume_size
    delete_on_termination = var.deletes_on_termination
    encrypted             = true
  }
  tags = {
    Name        = var.instance_name_1
    Schedule    = var.instance_schedule
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
  iam_instance_profile    = var.instance_profile
  vpc_security_group_ids  = [aws_security_group.mongodb.id]
  root_block_device {
      volume_type = "gp2"
      volume_size = 8
      encrypted   = true
    }
  ebs_block_device {
    device_name           = var.ebs_device_name
    volume_type           = var.ebs_volume_type
    volume_size           = var.ebs_volume_size
    delete_on_termination = var.deletes_on_termination
    encrypted             = true
  }
  tags = {
    Name        = var.instance_name_2
    Schedule    = var.instance_schedule
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
  vpc_security_group_ids  = [aws_security_group.mongodb.id]
  root_block_device {
      volume_type = "gp2"
      volume_size = 8
      encrypted   = true
    }
  tags = {
    Name        = var.instance_name_3
    Schedule    = var.instance_schedule
    Project     = var.projectname
    Environment = var.environment
  }
}

### Route 53 ###

data "aws_route53_zone" "env" {
  name         = var.dns_name
  private_zone = true
}

resource "aws_route53_record" "mongoprimary" {
  zone_id = data.aws_route53_zone.env.zone_id
  name    = "${var.instance_name_1}.${data.aws_route53_zone.env.name}"
  type    = "A"
  ttl     = "300"
  records = [var.private_ip_1]
}

resource "aws_route53_record" "mongosecondary" {
  zone_id = data.aws_route53_zone.env.zone_id
  name    = "${var.instance_name_2}.${data.aws_route53_zone.env.name}"
  type    = "A"
  ttl     = "300"
  records = [var.private_ip_2]
}

resource "aws_route53_record" "mongoarbiter" {
  zone_id = data.aws_route53_zone.env.zone_id
  name    = "${var.instance_name_3}.${data.aws_route53_zone.env.name}"
  type    = "A"
  ttl     = "300"
  records = [var.private_ip_3]
}

resource "aws_route53_record" "servicelocator" {
  zone_id = data.aws_route53_zone.env.zone_id
  name    = "_mongodb._tcp.rs.${data.aws_route53_zone.env.name}"
  type    = "SRV"
  ttl     = "300"
  records = [
    "0 0 27017 ${aws_route53_record.mongoprimary.name}",
    "0 0 27017 ${aws_route53_record.mongosecondary.name}",
    "0 0 27017 ${aws_route53_record.mongoarbiter.name}"
  ]
}

resource "aws_route53_record" "replicaset" {
  zone_id = data.aws_route53_zone.env.zone_id
  name    = "rs.${data.aws_route53_zone.env.name}"
  type    = "TXT"
  ttl     = "300"
  records = var.replicaset_record
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

  ingress {
    from_port = 9216
    to_port   = 9216
    protocol  = "tcp"
    security_groups = var.ingress_mongoexporter_sg
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
