## key pair
resource "aws_key_pair" "ansible_key_pair" {
    key_name = "ansible_key_pair"
    public_key = file("~/.ssh/id_rsa.pub")
}

## eip
resource "aws_eip" "ansible_eip" {
    instance = aws_instance.ansible_ec2.id
    vpc = true
}

resource "aws_instance" "ansible_ec2" {
    ami = "ami-0c9c942bd7bf113a2"
    instance_type="t2.micro"

    subnet_id = aws_subnet.main_public_subnet.id

    vpc_security_group_ids = [aws_security_group.ansible_sg.id]

    key_name = aws_key_pair.ansible_key_pair.key_name

    tags = {
        Name = "ansible_ec2"
    }
}