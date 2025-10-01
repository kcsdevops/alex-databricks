variable "vm_size" {
  description = "Tamanho da VM"
  type        = string
  default     = "Standard_B1s"
}

variable "location" {
  description = "Região Azure"
  type        = string
  default     = "East US"
}

variable "allowed_ip" {
  description = "IP permitido para acesso RDP"
  type        = string
  default     = "177.214.188.64/32"
}

variable "admin_username" {
  description = "Usuário administrador"
  type        = string
  default     = "devadmin"
}

variable "admin_password" {
  description = "Senha administrador"
  type        = string
  default     = "DevP@ssw0rd123!"
  sensitive   = true
}