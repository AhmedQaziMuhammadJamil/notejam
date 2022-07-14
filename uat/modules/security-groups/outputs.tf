output "alb_sg" {
  value = module.alb_sg.security_group_id
}


output "worker_sg" {
  value = module.worker_nodes_sg.security_group_id
}

output "rds_sg" {
  value = module.rds_sg.security_group_id
}

output "redis_sg" {
  value =  module.redis_sg.security_group_id
}
output "rabbitmq_sg" {
  value = module.rabbitmq_sg.security_group_id
}