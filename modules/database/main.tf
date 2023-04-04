module "networking" {
  source    = "../networking"
  namespace = var.namespace
}

module "aurora" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name           = var.dbname
  engine         = "aurora-mysql"
  engine_version = "5.7"
  instances = {
    1 = {
      instance_class      = var.instance_class
      publicly_accessible = false
    } /*
    2 = {
      identifier     = "mysql-static-1"
      instance_class = var.instance_class
    }*/
  }

  vpc_id                  = module.networking.vpc.vpc_id
  subnets                 = module.networking.vpc.public_subnets
  allowed_security_groups = [module.networking.sgForPetclinicDB]
  allowed_cidr_blocks     = module.networking.vpc.public_subnets_cidr_blocks

  iam_database_authentication_enabled = true
  master_username                     = "admin"
  master_password                     = "admin1234"
  create_random_password              = false

  apply_immediately   = true
  skip_final_snapshot = true

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = var.dbname
  db_cluster_parameter_group_family      = "aurora-mysql5.7"
  db_cluster_parameter_group_description = "${var.dbname} example cluster parameter group"
  db_cluster_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 120
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "immediate"
      }, {
      name         = "max_allowed_packet"
      value        = "67108864"
      apply_method = "immediate"
      }, {
      name         = "aurora_parallel_query"
      value        = "OFF"
      apply_method = "pending-reboot"
      }, {
      name         = "binlog_format"
      value        = "ROW"
      apply_method = "pending-reboot"
      }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
      }, {
      name         = "require_secure_transport"
      value        = "OFF"
      apply_method = "immediate"
      }, {
      name         = "tls_version"
      value        = "TLSv1.2"
      apply_method = "pending-reboot"
    }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = var.dbname
  db_parameter_group_family      = "aurora-mysql5.7"
  db_parameter_group_description = "${var.dbname} example DB parameter group"
  db_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 60
      apply_method = "immediate"
      }, {
      name         = "general_log"
      value        = 0
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "pending-reboot"
      }, {
      name         = "long_query_time"
      value        = 5
      apply_method = "immediate"
      }, {
      name         = "max_connections"
      value        = 2000
      apply_method = "immediate"
      }, {
      name         = "slow_query_log"
      value        = 1
      apply_method = "immediate"
      }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
    }
  ]

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  security_group_use_name_prefix  = false

  tags = var.tags
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                         = "ami-05e8e219ac7e82eba"
  instance_type               = "t2.micro"
  key_name                    = "PourUserTest2"
  monitoring                  = true
  vpc_security_group_ids      = [module.networking.sgForPetclinicDB, module.networking.sg_pub_id]
  subnet_id                   = module.networking.vpc.public_subnets[0]
  associate_public_ip_address = true


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  user_data = base64encode(templatefile("./modules/database/user-data.sh", local.vars))
  depends_on = [
    module.aurora
  ]
}
