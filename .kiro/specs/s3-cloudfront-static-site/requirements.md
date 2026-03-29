# Documento de Requisitos

## Introducción

Este documento define los requisitos para la creación de un sitio web estático alojado en Amazon S3 y distribuido a través de Amazon CloudFront. La infraestructura como código (IaC) será construida con Terraform y desplegada en la cuenta AWS con perfil VOP_AWS_Project_DEV (412381767274) en la región us-east-1.

## Glosario

- **S3_Bucket**: Recurso de almacenamiento de Amazon S3 utilizado para alojar los archivos estáticos del sitio web.
- **CloudFront_Distribution**: Distribución de Amazon CloudFront que actúa como CDN para servir el contenido del S3_Bucket a los usuarios finales.
- **OAC**: Origin Access Control, mecanismo de seguridad que permite a CloudFront acceder al S3_Bucket sin exponer el bucket públicamente.
- **Terraform_Config**: Conjunto de archivos de configuración Terraform (.tf) que definen la infraestructura del sitio web estático.
- **Sitio_Estatico**: Conjunto de archivos HTML, CSS y JavaScript que conforman el sitio web servido al usuario final.
- **Bucket_Policy**: Política de acceso del S3_Bucket que restringe el acceso exclusivamente a la CloudFront_Distribution.

## Requisitos

### Requisito 1: Configuración del proveedor Terraform para AWS

**Historia de Usuario:** Como ingeniero de infraestructura, quiero que Terraform esté configurado con el proveedor AWS correcto, para que los recursos se desplieguen en la cuenta y región especificadas.

#### Criterios de Aceptación

1. THE Terraform_Config SHALL configurar el proveedor AWS con la región us-east-1.
2. THE Terraform_Config SHALL especificar el perfil AWS VOP_AWS_Project_DEV para la autenticación.
3. THE Terraform_Config SHALL definir una versión mínima requerida de Terraform y del proveedor AWS.

### Requisito 2: Creación del bucket S3 para alojamiento estático

**Historia de Usuario:** Como ingeniero de infraestructura, quiero un bucket S3 configurado para almacenar archivos estáticos, para que el sitio web tenga un origen de almacenamiento seguro.

#### Criterios de Aceptación

1. THE Terraform_Config SHALL crear un S3_Bucket con un nombre único que incluya un identificador del proyecto.
2. THE Terraform_Config SHALL configurar el S3_Bucket con el bloqueo de acceso público habilitado en todas las opciones.
3. THE Terraform_Config SHALL habilitar el versionado en el S3_Bucket para permitir la recuperación de archivos anteriores.
4. THE Terraform_Config SHALL aplicar cifrado del lado del servidor (SSE-S3) al S3_Bucket por defecto.
5. THE Terraform_Config SHALL etiquetar el S3_Bucket con las etiquetas Project, Environment y ManagedBy.

### Requisito 3: Configuración de la distribución CloudFront

**Historia de Usuario:** Como ingeniero de infraestructura, quiero una distribución CloudFront que sirva el contenido del bucket S3, para que los usuarios accedan al sitio web con baja latencia y alta disponibilidad.

#### Criterios de Aceptación

1. THE Terraform_Config SHALL crear una CloudFront_Distribution con el S3_Bucket como origen.
2. THE Terraform_Config SHALL configurar la CloudFront_Distribution para redirigir todas las solicitudes HTTP a HTTPS.
3. THE Terraform_Config SHALL configurar el documento raíz predeterminado de la CloudFront_Distribution como index.html.
4. THE Terraform_Config SHALL configurar la CloudFront_Distribution con la política de caché CachingOptimized de AWS.
5. THE Terraform_Config SHALL habilitar la compresión automática de objetos en la CloudFront_Distribution.
6. THE Terraform_Config SHALL restringir la CloudFront_Distribution a las ubicaciones de borde de Norteamérica y Europa (PriceClass_100) para optimizar costos.
7. THE Terraform_Config SHALL etiquetar la CloudFront_Distribution con las etiquetas Project, Environment y ManagedBy.

### Requisito 4: Seguridad de acceso al origen con OAC

**Historia de Usuario:** Como ingeniero de infraestructura, quiero que el bucket S3 solo sea accesible a través de CloudFront, para que el contenido no quede expuesto directamente en internet.

#### Criterios de Aceptación

1. THE Terraform_Config SHALL crear un OAC para la CloudFront_Distribution.
2. THE Terraform_Config SHALL configurar la Bucket_Policy para permitir acceso de lectura exclusivamente desde la CloudFront_Distribution mediante el OAC.
3. THE Terraform_Config SHALL configurar el OAC con el tipo de origen s3 y la política de firma always.

### Requisito 5: Manejo de errores personalizados en CloudFront

**Historia de Usuario:** Como usuario del sitio web, quiero que los errores de navegación se manejen correctamente, para que las rutas del sitio funcionen sin errores 403 o 404 inesperados.

#### Criterios de Aceptación

1. WHEN un error 403 (Forbidden) ocurre en el origen, THE CloudFront_Distribution SHALL responder con el documento index.html y el código de estado HTTP 200.
2. WHEN un error 404 (Not Found) ocurre en el origen, THE CloudFront_Distribution SHALL responder con el documento index.html y el código de estado HTTP 200.

### Requisito 6: Contenido inicial del sitio web estático

**Historia de Usuario:** Como ingeniero de infraestructura, quiero que se incluya un archivo HTML inicial de ejemplo, para que el despliegue pueda verificarse inmediatamente.

#### Criterios de Aceptación

1. THE Sitio_Estatico SHALL incluir un archivo index.html funcional como página de inicio.
2. THE Sitio_Estatico SHALL incluir un archivo error.html como página de error personalizada.

### Requisito 7: Outputs de Terraform

**Historia de Usuario:** Como ingeniero de infraestructura, quiero que Terraform exponga los valores clave de la infraestructura creada, para que pueda verificar el despliegue y utilizarlos en otros procesos.

#### Criterios de Aceptación

1. THE Terraform_Config SHALL exponer como output el nombre del S3_Bucket.
2. THE Terraform_Config SHALL exponer como output el ID de la CloudFront_Distribution.
3. THE Terraform_Config SHALL exponer como output el nombre de dominio de la CloudFront_Distribution.
4. THE Terraform_Config SHALL exponer como output el ARN del OAC.

### Requisito 8: Estructura del proyecto Terraform

**Historia de Usuario:** Como ingeniero de infraestructura, quiero que el código Terraform siga una estructura modular y organizada, para que sea mantenible y reutilizable.

#### Criterios de Aceptación

1. THE Terraform_Config SHALL organizar los recursos en archivos separados: main.tf, variables.tf, outputs.tf y providers.tf.
2. THE Terraform_Config SHALL parametrizar los valores configurables mediante variables con descripciones y valores por defecto apropiados.
3. THE Terraform_Config SHALL ubicar todos los archivos de infraestructura dentro del directorio kiro_aws del workspace.
