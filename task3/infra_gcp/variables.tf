variable "project" {
  description = "Project"
  default     = "m06308803865"
}

variable "region" {
  description = "Region"
  default     = "europe-central2"
}

variable "zone" {
  description = "Zone"
  default     = "europe-central2-a"
}



variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  default     = "/home/moazelbeshbeshy/.ssh/google_compute_engine.pub"
}


variable "credentials" {
  description = "My Credentials"
  default     = "/mnt/f/the_dev/python_test_dyntell/task3/gcp-key.json"
}
