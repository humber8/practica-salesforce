# Wiki del Proyecto: Integración Salesforce + Claude (MIAW)

Este repositorio contiene la arquitectura y el código necesario para integrar el modelo de IA **Claude (Anthropic)** con el canal de mensajería **Messaging for In-App and Web (MIAW)** de Salesforce.

## 🚀 Resumen de la Integración
La solución utiliza un **Einstein Bot** como intermediario para recibir mensajes desde MIAW y procesarlos a través de una clase de **Invocable Apex** que se conecta con la API de Claude.

---

## 🛠️ Componentes Técnicos
1. **ClaudeInvocableService.cls**: El "cerebro" en Apex que realiza las llamadas HTTP a Anthropic.
2. **Claude_Settings__mdt**: Metadato personalizado para almacenar de forma segura la API Key.
3. **AnthropicAPI (Remote Site Setting)**: Autorización de seguridad para permitir tráfico hacia `api.anthropic.com`.
4. **MIAW (Messaging for In-App and Web)**: Canal nativo de chat configurado en la organización.

---

## ⚙️ Configuración Paso a Paso

### 1. Seguridad y API Key
Para que la integración funcione, debes guardar tu clave de Anthropic en Salesforce:
- Ve a **Setup** -> **Custom Metadata Types**.
- Selecciona **Claude Settings** -> **Manage Records**.
- Crea un registro llamado `Default` y pega tu clave en el campo **API Key**.

### 2. Habilitar Mensajería (MIAW)
Si el botón de activación de Messaging está bloqueado, verifica:
- **Omni-Channel:** Debe estar habilitado en *Omni-Channel Settings*.
- **Licencia de Usuario:** Tu usuario debe tener marcada la casilla **Service Cloud User**.
- **Sincronización:** Si las licencias no aparecen, usa el botón **Match Production Licenses** en *Company Information*.

### 3. Configurar el Einstein Bot
Una vez habilitado el Bot Builder:
1. Crea un nuevo Bot de tipo "MIAW".
2. En el flujo del Bot, agrega un elemento de tipo **Action**.
3. Selecciona la acción de Apex: **Enviar Mensaje a Claude**.
4. Mapea el texto del usuario a la entrada y la respuesta de la acción a una variable del Bot.

---

## 🧪 Pruebas y Validación
Se incluye la clase `ClaudeInvocableServiceTest` para garantizar que la lógica de integración es correcta y permite el despliegue a producción.

Para validar la conexión manualmente, puedes ejecutar el siguiente código en la **Consola de Desarrollador (Anonymous Apex)**:

```apex
ClaudeInvocableService.BotInput input = new ClaudeInvocableService.BotInput();
input.userMessage = 'Hola Claude, ¿estás conectado?';
List<ClaudeInvocableService.BotOutput> result = ClaudeInvocableService.sendMessageToClaude(new List<ClaudeInvocableService.BotInput>{input});
System.debug(result[0].claudeResponse);
```

---
*Documentación generada automáticamente por Antigravity.*
