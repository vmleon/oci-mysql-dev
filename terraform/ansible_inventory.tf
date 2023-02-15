resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/ansible_inventory.tftpl",
    {
      mysql_proxy_hostnames  = oci_core_instance.mysql_proxy.*.hostname_label
      mysql_proxy_public_ips = oci_core_instance.mysql_proxy.*.public_ip
    }
  )
  filename = "${path.module}/generated/server.ini"
}
