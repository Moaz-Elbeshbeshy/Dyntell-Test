variable "project_id" {
    type        = string
    description = "GCP task-manager ID"
}

variable "region" {
    type    =  string
    default = "us-central1"
}

variable "zone" {
    type      = string
    default   = "us-central1-a"
}

variable "vm_name" {
  default = "task-manager-vm"
}

variable "credentials_file" {
  type = string
}

variable "machine_type" {
  default = "e2-micro"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  default     = "/home/moazelbeshbeshy/.ssh/google_compute_engine.pub"
}
