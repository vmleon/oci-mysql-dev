data "oci_mysql_shapes" "mysql_shapes" {
  compartment_id = var.compartment_ocid
}

locals {
  mysql_shape = [for each in data.oci_mysql_shapes.mysql_shapes.shapes :
  each.name if length(regexall(".*E4.*", each.name)) > 0 && each.memory_size_in_gbs == 8][0]
}

resource "oci_mysql_mysql_db_system" "mysql_db_system" {
  availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[0], "name")
  compartment_id      = var.compartment_ocid
  shape_name          = local.mysql_shape
  subnet_id           = oci_core_subnet.privatesubnet.id

  admin_password = random_password.mysql_password.result
  admin_username = random_string.mysql_user.result

  description         = "MySQL DB System for Development"
  display_name        = "mysqldev"
  hostname_label      = "mysqldev"
  is_highly_available = false
}
