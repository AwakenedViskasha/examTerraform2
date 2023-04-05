module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "example-asg"

  min_size            = 1
  max_size            = 8
  desired_capacity    = 1
  health_check_type   = "EC2"
  target_group_arns   = module.alb.target_group_arns
  vpc_zone_identifier = var.mod_networking.vpc.private_subnets
  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [var.mod_networking.sgForPetclinicApp]
    }
  ]

  # Launch template
  launch_template            = module.launch-template.launch_template_name
  create_launch_template     = false
  use_mixed_instances_policy = true
  security_groups            = [var.mod_networking.sgForPetclinicDB, var.mod_networking.sg_pub_id]
  ebs_optimized              = true
  enable_monitoring          = true

  # IAM role & instance profile
  scaling_policies = {
    my-policy = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
      }
    }
  }

}
locals {
  vars = {
    db_endpoint = "${var.mod_database.cluster_endpoint}"
  }
}

module "launch-template" {
  source  = "figurate/launch-template/aws"
  version = "1.0.4"
  # insert the 4 required variables here
  name                        = "petclinic_template"
  user_data                   = templatefile("./modules/asg/user-data.sh", local.vars)
  image_id                    = "ami-0abf419a9041a930d"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [var.mod_networking.awsSG.sgForPetclinicApp.name]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id          = var.mod_networking.vpc.vpc_id
  subnets         = var.mod_networking.vpc.public_subnets
  security_groups = [var.mod_networking.forLB]


  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      targets = {

      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}
