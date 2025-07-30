resource "aws_instance" "webservice" {
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"

  key_name = aws_key_pair.chave_ssh_aws.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.interface1.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.interface2.id
  }

  user_data = file("${path.module}/Scripts/setup-nginx.sh")

  tags = {
    Name       = "PB - JUL 2025"
    CostCenter = "CO92000024"
    Project    = "PB - JUL 2025"    
  }

  volume_tags = {
    Name       = "PB - JUL 2025"
    CostCenter = "CO92000024"
    Project    = "PB - JUL 2025"
  }
}

resource "aws_key_pair" "chave_ssh_aws" {
  key_name   = "chave-ssh-aws"
  public_key = file(var.chave_pub_aws)
}