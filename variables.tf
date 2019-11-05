variable key_name {
	description = "SSH key to log into the EC2 instances"
}

variable ami {
    description = "VoltDB AMI"
}

variable instance_type {
    description = "Type of EC2 instance"
}

variable availability_zone {
    description = "AZ for this VoltDB cluster"
}

variable region {
    description = "Region to instantiate the provider"
}

variable node_count {
    description = "Number of nodes in the VoltDB cluster"
    default = 0
}

variable license_path {
    description = "Path to the VoltDB enterprise license file"
}

variable key_path {
    description = "Local path to the private key" 
}

variable ssh_user {
    description = "User to SSH into the EC2 instance"
}

variable deployment_elements {
    description = "Deployment XML elements to be set"
}