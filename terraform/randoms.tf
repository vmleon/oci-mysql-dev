resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  min_numeric      = 3
  min_special      = 2
  min_lower        = 2
  min_upper        = 2
  override_special = "@#$^&?-_()[]"
}


resource "random_string" "mysql_user" {
  length  = 6
  special = false
}
