data "aws_ami" "imagem_ec2" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "al2023-ami-2023.*-x86_64" ]
  }
}

resource "aws_security_group" "gui_nginx_sg" {
  vpc_id = var.vpc_id
  name = "gui_nginx_sg"
  tags = {
    Name = "gui-nginx_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "gui_egress_sg_rule" {
  security_group_id = aws_security_group.gui_nginx_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
} 

resource "aws_vpc_security_group_ingress_rule" "gui_ingress_80_sg_rule" {
  security_group_id = aws_security_group.gui_nginx_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "gui_ingress_22_sg_rule" {
  security_group_id = aws_security_group.gui_nginx_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
}

resource "aws_network_interface" "gui_nginx_ei" {
  subnet_id = var.sn_priv01
  tags = {
    Name = "gui_nginx_ei"
  }
}

resource "aws_instance" "gui_nginx_ec2" {
  instance_type = "t2.micro"
  ami = data.aws_ami.imagem_ec2.id
  subnet_id = var.sn_priv01
  vpc_security_group_ids = [ aws_security_group.gui_nginx_sg.id ]
  key_name = aws_key_pair.lb_ssh_key_pair.key_name
  associate_public_ip_address = true
  tags = {
    Name = "gui_nginx_ec2"
  }
  user_data = <<-EOF
     #!/bin/bash
    yum update -y
    yum install python3 python3-pip git -y
    sudo systemctl enable rc-local
    mkdir /proway
    echo '#!/bin/bash' > /opt/rc.proway
    echo "cd /proway" >> /opt/rc.proway
    echo "git init" >> /opt/rc.proway
    echo "git config core.sparseCheckout true" >> /opt/rc.proway
    echo "git remote add -f origin https://github.com/Guizeraaaa/projeto-iac-guilherme.git" >> /opt/rc.proway
    echo "echo "back-end/*" >> .git/info/sparse-checkout" >> /opt/rc.proway
    echo "git checkout main && git pull origin main" >> /opt/rc.proway
    echo "cd back-end && pip install -r requirements.txt" >> /opt/rc.proway
    echo "cd /proway/back-end/ && flask --app application.py run -h 0.0.0.0" >> /opt/rc.proway
    chmod +x /opt/rc.proway
    /opt/rc.proway
    cp /proway/back-end/backend.service /etc/systemd/system/
    systemctl enable backend.service
    systemctl start backend.service
    reboot
  EOF
}


resource "tls_private_key" "lb_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "lb_ssh_key_pair" {
  key_name   = "gui_key_pair"
  public_key = tls_private_key.lb_ssh_key.public_key_openssh
}

