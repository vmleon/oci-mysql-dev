
output "mysql_password" {
  value     = random_password.mysql_password.result
  sensitive = true
}


output "mysql_user" {
  value     = random_string.mysql_user.result
  sensitive = false
}

output "mysql_shape" {
  value = local.mysql_shape
}

output "mysql_ip_address" {
  value = oci_mysql_mysql_db_system.mysql_db_system.endpoints[0].ip_address
}

output "bastion_ssh_command" {
  value = lookup(oci_bastion_session.mysql_session.ssh_metadata, "command")
}
