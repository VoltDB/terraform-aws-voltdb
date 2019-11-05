# Build the deployment.xml file
resource "xml_file" deployment {
  filename = "/Users/seetasomagani/deployment.xml"
  elements = var.deployment_elements
}

# Provision the VoltDB host(s)
resource "aws_instance" volt {
  count             = var.node_count
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  ami               = var.ami
  key_name          = var.key_name
  
  provisioner "file" {
	source				= "${xml_file.deployment.filename}"
	destination 		= "/home/ubuntu/deployment.xml"
	connection {
	  host = self.public_ip
      type     			= "ssh"
      user				= var.ssh_user
      private_key		= file(var.key_path)
    }
  }
  
  provisioner "file" {
    source      		= "${path.module}/start-volt-cluster.sh"
    destination 		= "/home/ubuntu/start-volt-cluster.sh"
    connection {
      host = self.public_ip
      type     			= "ssh"
      user				= var.ssh_user
      private_key		= file(var.key_path)
   }
  }
}

resource "null_resource" "copy_license" {
	count				= var.license_path == "" ? 0 : var.node_count
	provisioner "file" {
	source				= var.license_path
	destination 		= "/opt/voltdb/voltdb/license.xml"
	connection {
	  host     			= element(aws_instance.volt.*.public_ip, count.index)
      type     			= "ssh"
      user				= var.ssh_user
      private_key		= file(var.key_path)
    }
  }
  depends_on			= ["aws_instance.volt"]
}

locals {
    ips = join(",", aws_instance.volt.*.private_ip)
}

resource "null_resource" "start-volt-cluster" {
  count				= var.node_count
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/start-volt-cluster.sh",
      "/home/ubuntu/start-volt-cluster.sh ${var.node_count} ${local.ips} > startup.log",
      # Without a sleep, process gets killed before it even starts     
      "sleep 5"
    ]
    connection {
	  host     		= element(aws_instance.volt.*.public_ip, count.index)
      type     			= "ssh"
      user    			= var.ssh_user
      private_key		= file(var.key_path)
   }
  }
  depends_on = ["null_resource.copy_license"]
}
