variable "project_name" {
  description = "Nombre del proyecto para nombrar recursos"
  type        = string
  default     = "kiro-static-site"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Región AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Perfil AWS CLI para la autenticación"
  type        = string
  default     = "VOP_AWS_Project_DEV"
}

variable "default_root_object" {
  description = "Documento raíz predeterminado de CloudFront"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Clase de precio de la distribución CloudFront"
  type        = string
  default     = "PriceClass_100"
}

variable "tags" {
  description = "Etiquetas comunes aplicadas a todos los recursos"
  type        = map(string)
  default = {
    Project     = "kiro-static-site"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
