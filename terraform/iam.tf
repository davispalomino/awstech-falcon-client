data "template_file" "role_task" {
  template = "${file("iam/role_task.tpl")}"
}
data "template_file" "policy_task" {
  template = "${file("iam/policy_task.tpl")}"
}
resource "aws_iam_role" "role-task" {
  name = "${var.owner}-${var.env}-${var.service}-role"

  assume_role_policy = "${data.template_file.role_task.rendered}"
}

resource "aws_iam_role_policy" "this" {
  name = "${var.owner}-${var.env}-${var.service}"
  role = "${aws_iam_role.role-task.id}"
  policy = "${data.template_file.policy_task.rendered}"
}

# resource "aws_iam_role_policy_attachment" "role-attach" {
#     role       = "${aws_iam_role.role-task.name}"
#     policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }