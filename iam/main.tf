resource "aws_iam_role" "ec2-ssm-role" {
  name = "${var.basename}-ec2-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "EC2AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-ssm-role-attachment" {
  role       = aws_iam_role.ec2-ssm-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2-ssm-profile" {
  name = "${var.basename}-ec2-ssm-profile"
  role = aws_iam_role.ec2-ssm-role.name
}