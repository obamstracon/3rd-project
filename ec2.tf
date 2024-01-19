resource "aws_instance" "obam-1" {
    ami = var.ami
    instance_type = var.type
    key_name = var.key_pair
    security_groups = [aws_security_group.obam-security-gpr-rule.id]
    subnet_id = aws_subnet.obam-public-subnet1.id
    availability_zone = var.availability_zones["a"]


    connection {
      type = "ssh"
      host = seif.map_public_ip 
      user = "ubuntu"
      private_key = file["/root/terraform/london-key-pair.pem"]
    }

    tags = {
      Name = "obam-1"
      source  = "terraform"
    }

  
}

# create the second instance

resource "aws_instance" "obam-2" {
  ami = var.ami
  instance_type = var.type
  key_name = var.key_pair
  security_groups = [aws_security_group.obam-security-gpr-rule.id]
  subnet_id = aws_subnet.obam-public-subnet2.id
  availability_zone = var.availability_zones["b"] 


  connection {
     type = "ssh"
      host = seif.map_public_ip 
      user = "ubuntu"
      private_key = file["/root/terraform/london-key-pair.pem"] 

  }


  tags = {
    Name = "obam-2"
    source  = "terraform" 
  }

}
  
# create the third instance

resource "aws_instance" "obam-3" {
  ami = var.ami
  instance_type = var.type
  key_name = var.key_pair
  security_groups = [aws_security_group.obam-security-gpr-rule.id]
  subnet_id = aws_subnet.obam-public-3.id
  availability_zone = var.availability_zones["c"] 


  connection{
     type = "ssh"
      host = seif.map_public_ip 
      user = "ubuntu"
      private_key = file["/root/terraform/london-key-pair.pem"] 
  } 


  tags = {
    Name = "obam-3"
    source  = "terraform" 
  }
  
}


resource "local_file" "ip_address" {
  filename = "/root/terraform/ansible-playbook/host-inventory"
  content = <<EOT
  $[aws_instance.obam-1.public_ip]
  $[aws_instance.obam-2.public_ip]
  $[aws_instance.obam-3.public_ip]
   EOT
  
}


# ##### first method  #####
#  transfer the public IP address of the instance to a file

output "instance_ips" {
  value = "aws_instance.my_server.*.public_ip"
}

# output to a file name host-inventory
resource "local_file" "host-inventory" {
  content = join("\n" , aws_instance.my_servers.*.public_ip)
  filename = "host-inventory"
}


   

    