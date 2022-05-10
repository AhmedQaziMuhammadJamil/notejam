output "alb-sg" {
  value = aws_security_group.alb["NoteJam-Alb-SG"].id
}

output "rds-sg" {
  value = aws_security_group.rds["NoteJam-RDS-SG"].id
}

output "worker-sg" {
  value = aws_security_group.worker-node["NoteJam-Worker-SG"].id
}

