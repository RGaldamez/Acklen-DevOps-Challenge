resource "aws_security_group" "chat-security-group" {
  name   = "chat-security-group"
  vpc_id = aws_vpc.chat-vpc.id
  egress {
    to_port   = 0
    from_port = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  #application default port, needs to be open to communicate with load balancer
  ingress {
    to_port   = 5000
    from_port = 5000
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    to_port   = 22
    from_port = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    to_port   = 80
    from_port = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    to_port   = 443
    from_port = 443
    protocol  = "tcp"

  }
  tags = {
    Name = "chat-security-group"
  }
}
