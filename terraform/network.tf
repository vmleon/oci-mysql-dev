resource "oci_core_virtual_network" "mysql_dev" {
  compartment_id = var.compartment_ocid
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "mysqldev"
  dns_label      = "mysqldev"
}

resource "oci_core_internet_gateway" "vcn_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "InternetGateway"
  vcn_id         = oci_core_virtual_network.mysql_dev.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_virtual_network.mysql_dev.default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.vcn_internet_gateway.id
  }
}

resource "oci_core_subnet" "publicsubnet" {
  cidr_block                 = "10.0.1.0/24"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.mysql_dev.id
  display_name               = "Public Subnet"
  dns_label                  = "public"
  prohibit_public_ip_on_vnic = false
  security_list_ids          = [oci_core_virtual_network.mysql_dev.default_security_list_id, oci_core_security_list.http_security_list.id]
  route_table_id             = oci_core_virtual_network.mysql_dev.default_route_table_id
  dhcp_options_id            = oci_core_virtual_network.mysql_dev.default_dhcp_options_id
}

resource "oci_core_security_list" "http_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.mysql_dev.id
  display_name   = "HTTP Security List"

  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 80
      max = 80
    }
  }

}

resource "oci_core_subnet" "privatesubnet" {
  cidr_block                 = "10.0.2.0/24"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.mysql_dev.id
  display_name               = "Private Subnet"
  dns_label                  = "private"
  prohibit_public_ip_on_vnic = true
  security_list_ids          = [oci_core_virtual_network.mysql_dev.default_security_list_id, oci_core_security_list.mysql_security_list.id]
  route_table_id             = oci_core_virtual_network.mysql_dev.default_route_table_id
  dhcp_options_id            = oci_core_virtual_network.mysql_dev.default_dhcp_options_id
}

resource "oci_core_security_list" "mysql_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.mysql_dev.id
  display_name   = "MySQL Security List"

  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 3306
      max = 3306
    }
  }

  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 33060
      max = 33060
    }
  }

}
