variable access_key {
	description = "AWS Access Key to create resources on your behalf"
}
variable secret_key	{
	description = "AWS Secret Key to create resources on your behalf"
}
variable region {
    description = "Region to instantiate the provider"
    default = "us-east-1"
}
variable availability_zone {
    description = "AZ for this VoltDB cluster"
    default = "us-east-1b"
}
