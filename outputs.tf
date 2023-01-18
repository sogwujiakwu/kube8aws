output "bastion_host_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "masters_private_ip" {
  value = aws_instance.masters.*.private_ip
}

output "workers_private_ip" {
  value = aws_instance.workers.*.private_ip
}

output "master_lb" {
  value = aws_lb.k8_masters_lb.id
}
