# ──────────────────────────────────────────────
# Outputs — Valores clave de la infraestructura
# ──────────────────────────────────────────────

output "s3_bucket_name" {
  description = "Nombre del bucket S3 utilizado para el sitio estático"
  value       = aws_s3_bucket.static_site.id
}

output "cloudfront_distribution_id" {
  description = "ID de la distribución CloudFront"
  value       = aws_cloudfront_distribution.static_site.id
}

output "cloudfront_domain_name" {
  description = "Nombre de dominio de la distribución CloudFront para acceder al sitio"
  value       = aws_cloudfront_distribution.static_site.domain_name
}

output "oac_arn" {
  description = "ARN del Origin Access Control (OAC) de CloudFront"
  value       = aws_cloudfront_origin_access_control.static_site.arn
}
