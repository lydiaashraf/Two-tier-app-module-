resource "aws_security_group" "securitygroup2" {
  name        = "lydia-sec-gr"
  description = "Allow RDS traffic"

  vpc_id = data.aws_vpc.vpc.id
   
  ingress {
    description      = "RDS"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

  }
  

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "RDS"
  }
}

resource "aws_db_subnet_group" "subnet-group" {
  name       = "lydia-subnet-group"
  subnet_ids = [aws_subnet.subnet_creation["privatesubnet1"].id, aws_subnet.subnet_creation["privatesubnet2"].id]

  tags = {
    Name = "lydia-subnet-gr"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "lydiadb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "lydia"
  password             = "12345678"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = "lydia-subnet-group"
  multi_az = true

  port = 3306
  vpc_security_group_ids = [aws_security_group.securitygroup2.id]
}