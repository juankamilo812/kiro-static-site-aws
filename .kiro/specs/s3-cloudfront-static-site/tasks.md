# Plan de Implementación: Sitio Web Estático con S3 y CloudFront

## Visión General

Implementación incremental de la infraestructura Terraform para desplegar un sitio web estático en AWS usando S3 como origen y CloudFront como CDN. Cada tarea construye sobre la anterior, comenzando por la configuración base del proveedor y terminando con la integración completa de todos los componentes.

## Tareas

- [x] 1. Configurar el proveedor Terraform y la estructura del proyecto
  - [x] 1.1 Crear `kiro_aws/providers.tf` con el bloque `terraform` (versiones requeridas) y el bloque `provider "aws"` configurado con región `us-east-1` y perfil `VOP_AWS_Project_DEV`
    - Incluir `required_version >= 1.0` y `required_providers` con `aws ~> 5.0`
    - _Requisitos: 1.1, 1.2, 1.3, 8.1, 8.3_
  - [x] 1.2 Crear `kiro_aws/variables.tf` con todas las variables parametrizables: `project_name`, `environment`, `aws_region`, `aws_profile`, `default_root_object`, `price_class` y `tags`
    - Cada variable debe tener `description` no vacía y `default` apropiado
    - _Requisitos: 8.2_

- [x] 2. Implementar el bucket S3 y su configuración de seguridad
  - [x] 2.1 Crear `kiro_aws/main.tf` con el recurso `aws_s3_bucket` usando un nombre que incluya `var.project_name`
    - Aplicar etiquetas `Project`, `Environment` y `ManagedBy`
    - _Requisitos: 2.1, 2.5_
  - [x] 2.2 Agregar el recurso `aws_s3_bucket_public_access_block` con las 4 opciones de bloqueo en `true`
    - `block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`
    - _Requisitos: 2.2_
  - [x] 2.3 Agregar los recursos `aws_s3_bucket_versioning` (habilitado) y `aws_s3_bucket_server_side_encryption_configuration` (SSE-S3)
    - _Requisitos: 2.3, 2.4_
  - [ ]* 2.4 Escribir test basado en propiedades para el bucket S3
    - **Propiedad 1: El nombre del bucket contiene el identificador del proyecto**
    - **Valida: Requisito 2.1**
  - [ ]* 2.5 Escribir test basado en propiedades para etiquetas
    - **Propiedad 2: Todos los recursos etiquetables tienen las etiquetas requeridas**
    - **Valida: Requisitos 2.5, 3.7**

- [x] 3. Implementar CloudFront Distribution con OAC
  - [x] 3.1 Agregar el recurso `aws_cloudfront_origin_access_control` en `kiro_aws/main.tf` con tipo `s3` y firma `always`
    - _Requisitos: 4.1, 4.3_
  - [x] 3.2 Agregar el recurso `aws_cloudfront_distribution` con el S3 bucket como origen, vinculado al OAC
    - Configurar `viewer_protocol_policy = "redirect-to-https"`, `default_root_object = "index.html"`, compresión habilitada, `PriceClass_100`
    - Usar la política de caché gestionada `CachingOptimized` de AWS
    - Aplicar etiquetas `Project`, `Environment` y `ManagedBy`
    - _Requisitos: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7_
  - [x] 3.3 Configurar las respuestas de error personalizadas en la distribución CloudFront para códigos 403 y 404
    - Ambos deben redirigir a `/index.html` con código de respuesta 200 y TTL de caché de 10 segundos
    - _Requisitos: 5.1, 5.2_
  - [ ]* 3.4 Escribir test basado en propiedades para respuestas de error
    - **Propiedad 3: Las respuestas de error personalizadas redirigen correctamente**
    - **Valida: Requisitos 5.1, 5.2**

- [x] 4. Configurar la Bucket Policy y subir archivos estáticos
  - [x] 4.1 Agregar el recurso `aws_s3_bucket_policy` que permite `s3:GetObject` exclusivamente desde `cloudfront.amazonaws.com` condicionado al ARN de la distribución
    - _Requisitos: 4.2_
  - [x] 4.2 Crear `kiro_aws/index.html` con contenido HTML5 básico que confirme el despliegue exitoso
    - _Requisitos: 6.1_
  - [x] 4.3 Crear `kiro_aws/error.html` con contenido HTML5 de página de error personalizada
    - _Requisitos: 6.2_
  - [x] 4.4 Agregar recursos `aws_s3_object` en `main.tf` para subir `index.html` y `error.html` al bucket con `content_type = "text/html"`
    - _Requisitos: 6.1, 6.2_

- [x] 5. Checkpoint - Verificar configuración intermedia
  - Asegurar que todos los archivos Terraform son válidos con `terraform validate`, preguntar al usuario si surgen dudas.

- [x] 6. Definir outputs y validación final
  - [x] 6.1 Crear `kiro_aws/outputs.tf` con los outputs: `s3_bucket_name`, `cloudfront_distribution_id`, `cloudfront_domain_name` y `oac_arn`
    - Cada output debe tener `description` y referenciar el recurso correspondiente
    - _Requisitos: 7.1, 7.2, 7.3, 7.4_
  - [ ]* 6.2 Escribir test basado en propiedades para outputs
    - **Propiedad 4: Todos los outputs requeridos están definidos**
    - **Valida: Requisitos 7.1, 7.2, 7.3, 7.4**
  - [ ]* 6.3 Escribir test basado en propiedades para variables
    - **Propiedad 5: Todas las variables tienen descripción y valor por defecto**
    - **Valida: Requisito 8.2**

- [x] 7. Checkpoint final - Validación completa
  - Ejecutar `terraform validate` y `terraform fmt` para asegurar que toda la configuración es válida y está formateada correctamente. Preguntar al usuario si surgen dudas.

## Notas

- Las tareas marcadas con `*` son opcionales y pueden omitirse para un MVP más rápido
- Cada tarea referencia los requisitos específicos para trazabilidad
- Los checkpoints aseguran validación incremental
- Los tests basados en propiedades validan propiedades universales de correctitud
- Todos los archivos se crean en el directorio `kiro_aws/` del workspace
