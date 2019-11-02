output "custom_port_instance_arn_map" {
  description = "Custom tf map holding info about target ports, instances and corresponding target group ARNs"
  value       = local.port_instance_arn_map
}

output "aws_alb_certification_json" {
  description = "Complete AWS ALB object"
  value       = { for i, j in aws_lb.certification : i => j }
}

output "aws_lb_target_group_http_json" {
  description = "All data about target groups"
  value       = { for j, k in aws_lb_target_group.http : j => k }
}

output "aws_lb_listener_front_end_json" {
  description = "All data about aws alb listeners"
  value       = { for j, k in aws_lb_listener.front_end : j => k }
}

output "aws_lb_target_group_attachment_http_json" {
  description = "All data about aws alb attachemets to tagret groups"
  value       = { for j, k in aws_lb_target_group_attachment.http : j => k }
}

