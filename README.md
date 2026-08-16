# GOVP for Business Central

Extensión AL independiente para emitir un GOVP desde un albarán de venta
registrado de Microsoft Dynamics 365 Business Central. El usuario configura la
URL y el token por compañía, pulsa **Issue GOVP** y puede abrir la comprobación
desde el propio documento.

## Separación respecto de Dynamics / Dataverse

Este producto no sustituye ni duplica `govp-crm-dataverse`. El adaptador ya
existente de Dynamics observa oportunidades y procesos CRM. Esta extensión
opera con documentos ERP de Business Central. Los dos productos solo comparten
el contrato público de GOVP Exchange y sus identificadores verificables.

## Estado

La fuente `0.1.0` cubre configuración por compañía, token en `IsolatedStorage`,
emisión idempotente y campos de resultado sobre el albarán registrado. Su
estructura se prueba localmente y AL-Go está configurado para compilar contra
los artefactos oficiales W1 de Business Central 26. Antes de declarar producción debe superar instalación,
actualización y desinstalación en un sandbox de Business Central.

## Desarrollo

1. Instala la extensión oficial **AL Language** de Microsoft.
2. Descarga símbolos para Business Central 26 o adapta las versiones mínimas de
   `app.json` al sandbox de prueba.
3. Ejecuta `AL: Package` y publica el `.app` en un sandbox.
4. Ejecuta `npm test` para comprobar los invariantes de repositorio y contrato.

La automatización de compilación procede de la plantilla oficial
[`microsoft/AL-Go-PTE`](https://github.com/microsoft/AL-Go-PTE).

Licencia Apache-2.0.
