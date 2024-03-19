# master
resource "aws_iam_role" "master_role" {
  name               = "master_role"
  path               = "/"
  assume_role_policy = "${file("${path.module}/master-role.json")}"
  tags = {
    yor_trace = "2448e013-627f-4bf4-895f-2fa9d83c39e7"
  }
}

resource "aws_iam_role_policy" "master_policy" {
  name   = "master_policy"
  role   = "${aws_iam_role.master_role.id}"
  policy = "${file("${path.module}/master-policy.json")}"
}

resource "aws_iam_instance_profile" "master_profile" {
  name  = "master_profile"
  roles = ["${aws_iam_role.master_role.name}"]
  tags = {
    yor_trace = "577b5737-1e05-44a4-99e8-32a0a48926b7"
  }
}

# worker
resource "aws_iam_role" "worker_role" {
  name               = "worker_role"
  path               = "/"
  assume_role_policy = "${file("${path.module}/worker-role.json")}"
  tags = {
    yor_trace = "984accc1-f0da-453a-9651-83bb6c500397"
  }
}

resource "aws_iam_role_policy" "worker_policy" {
  name   = "worker_policy"
  role   = "${aws_iam_role.worker_role.id}"
  policy = "${file("${path.module}/worker-policy.json")}"
}

resource "aws_iam_instance_profile" "worker_profile" {
  name  = "worker_profile"
  roles = ["${aws_iam_role.worker_role.name}"]
  tags = {
    yor_trace = "d90e5098-2bd6-4faa-95fc-d4bc41dabdac"
  }
}

# edge-router
resource "aws_iam_role" "edge-router_role" {
  name               = "edge-router_role"
  path               = "/"
  assume_role_policy = "${file("${path.module}/edge-router-role.json")}"
  tags = {
    yor_trace = "75c74a2f-b21d-4712-a4f9-09cf37272dff"
  }
}

resource "aws_iam_role_policy" "edge-router_policy" {
  name   = "edge-router_policy"
  role   = "${aws_iam_role.edge-router_role.id}"
  policy = "${file("${path.module}/edge-router-policy.json")}"
}

resource "aws_iam_instance_profile" "edge-router_profile" {
  name  = "edge-router_profile"
  roles = ["${aws_iam_role.edge-router_role.name}"]
  tags = {
    yor_trace = "cb12ec0d-e97a-4702-a3b1-06daf60881d7"
  }
}

# outputs
output "master_profile_name" {
  value = "${aws_iam_instance_profile.master_profile.name}"
}
output "worker_profile_name" {
  value = "${aws_iam_instance_profile.worker_profile.name}"
}
output "edge-router_profile_name" {
  value = "${aws_iam_instance_profile.edge-router_profile.name}"
}
