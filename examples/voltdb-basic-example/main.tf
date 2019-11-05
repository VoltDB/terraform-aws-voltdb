provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

module voltdb {
  source = "../../"

  node_count = 3
  instance_type = "t2.medium"
  availability_zone = var.availability_zone
  region = var.region
  ami = "ami-054e818a627ed97bc"

  key_name = "ec2"
  ssh_user = "ubuntu"
  key_path = "/Users/seetasomagani/.ssh/ec2"
  
  deployment_elements = {
    "deployment.cluster.@kfactor" = "0"
    "deployment.cluster.@sitesperhost" = "4"
    "deployment.commandlog.@enabled" = "false"
  }

  license_path = "/Users/seetasomagani/Projects/pro/VoltDBFieldEngineering-Enterprise_Expires-2020-01-09.xml"
}
