resource "aws_security_group" "securitygroup1" {
  name        = "lydia-sec-gr1"
  description = "Allow http and https inbound traffic"

  vpc_id = data.aws_vpc.vpc.id
   
  ingress {
    description      = "HTTPS "
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "allow_http_https"
  }
}


resource "aws_instance" "instance" {
  ami           = "ami-09ba48996007c8b50"
  instance_type = "t2.micro"


  vpc_security_group_ids = [aws_security_group.securitygroup1.id]

  subnet_id =  aws_subnet.subnet_creation["publicsubnet"].id


  key_name = "lydiakey"
  
  tags = {
    Name = "web"
  }
}

resource  "aws_eip" "eip"{
    instance = aws_instance.instance.id
    vpc = true
    
}

terraform {
    backend "s3" {
    bucket = "bucket-lydia"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}