# input variables
variable "short_name" { default = "kube" }
variable "public_key" {}

# SSH keypair for the instances
resource "aws_key_pair" "default" {
  key_name   = "${var.short_name}"
  public_key = "${var.public_key}"
  tags = {
    yor_trace = "6248ae2d-e20a-41b8-8720-6b12b476289e"
  }
}

# output variables
output "keypair_name" {
  value = "${aws_key_pair.default.key_name}"
}
