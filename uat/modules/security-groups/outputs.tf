output "alb_sg" {
  value = module.alb_sg.security_group_id
}
 

 output "worker_sg" {
    value = module.worker_nodes_sg.security_group_id
 }