resource "oci_bastion_bastion" "mysql_bastion" {
  bastion_type     = "standard"
  compartment_id   = var.compartment_ocid
  target_subnet_id = oci_core_subnet.privatesubnet.id

  client_cidr_block_allow_list = ["0.0.0.0/0"]
  name                         = "mysql_bastion"
}

resource "oci_bastion_session" "mysql_session" {
  bastion_id = oci_bastion_bastion.mysql_bastion.id
  key_details {
    public_key_content = var.ssh_public_key
  }
  target_resource_details {
    session_type = "PORT_FORWARDING"

    target_resource_port               = oci_mysql_mysql_db_system.mysql_db_system.endpoints[0].port
    target_resource_private_ip_address = oci_mysql_mysql_db_system.mysql_db_system.endpoints[0].ip_address
  }

  #Optional
  display_name = "mysql_bastion_session"
}
