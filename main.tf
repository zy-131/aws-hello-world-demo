provider "aws" {
    region = "us-west-1"
}

resource "aws_instance" "hello_world" {
    ami = "ami-02a7ad1c45194c72f" # Amazon Linux 2023 AMI
    instance_type = "t2.micro"

    tags = {
        Name = "HelloWorldInstance"
    }

    security_groups = [aws_security_group.web_access.name]

    user_data = <<-EOF
                #!/bin/bash
                sudo dnf update -y
                sudo dnf install -y nginx
                echo "Hello World!" | sudo tee /usr/share/nginx/html/index.html
                systemctl start nginx
                systemctl enable nginx
                EOF
} 

resource "aws_security_group" "web_access" {
    name = "web_access"
    description = "Allow HTTP and SSH access"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "instance_id" {
  value = aws_instance.hello_world.id
  description = "Hello World EC2 Instance ID"
}

output "public_ip" {
    value = aws_instance.hello_world.public_ip
    description = "The public IP of the HelloWorld Instance"
}
