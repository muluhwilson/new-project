esource "aws_instance" "ec2" {
  count = "${var.nodes_qty}"

  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  monitoring    = "${var.enable_detailed_monitoring == "1" ? true : false}"
  key_name      = "${var.aws_key_pair_name}"
  subnet_id     = "${element(var.subnet_ids, count.index)}"
  ebs_optimized = "${var.ebs_optimized}"

  vpc_security_group_ids = ["${var.ec2_sg_list}"]
  user_data              = "${var.ec2_user_data}"
  iam_instance_profile   = "${var.iam_instance_profile}"

  tags {
    "Name" = "${join("-", list(var.tag_project, format("%s%.1d", var.tag_role, count.index + 1), var.tag_service, element(var.tag_zones,count.index), var.tag_environment))}"

    "service"            = "${var.tag_service}"
    "role"               = "${var.tag_role}"
    "purpose"            = "${var.tag_purpose_ec2 != "" ? var.tag_purpose_ec2 : format("%s-app", var.tag_service)}"
    "environment"        = "${var.tag_environment}"
    "first_owner"        = "${var.tag_first_owner}"
    "second_owner"       = "${var.tag_second_owner}"
    "time_frame"         = "${var.tag_timeframe}"
    "provisioned"        = "terraform"
    "project"            = "${var.tag_project}"
    "configured"         = "${var.tag_configured}"
    "zone"               = "${element(var.tag_zones, count.index)}"
    "ansible"            = "${var.tag_configured == "ansible" ? "yes" : "no"}"
    "SEC_ASSETS_GATEWAY" = "${var.tag_sec_assets_gateway}"
    "SEC_ASSETS"         = "${var.tag_sec_assets}"
  }

  lifecycle {
    ignore_changes = ["security_groups", "user_data", "key_name"]
  }
}
