# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)


Wiki del Proyecto: Integración Salesforce + Claude (MIAW)
Este repositorio contiene la arquitectura y el código necesario para integrar el modelo de IA Claude (Anthropic) con el canal de mensajería Messaging for In-App and Web (MIAW) de Salesforce.

🚀 Resumen de la Integración
La solución utiliza un Einstein Bot como intermediario para recibir mensajes desde MIAW y procesarlos a través de una clase de Invocable Apex que se conecta con la API de Claude.

🛠️ Componentes Técnicos
ClaudeInvocableService.cls: El "cerebro" en Apex que realiza las llamadas HTTP a Anthropic.
Claude_Settings__mdt: Metadato personalizado para almacenar de forma segura la API Key.
AnthropicAPI (Remote Site Setting): Autorización de seguridad para permitir tráfico hacia api.anthropic.com.
MIAW (Messaging for In-App and Web): Canal nativo de chat configurado en la organización.
⚙️ Configuración Paso a Paso
1. Seguridad y API Key
Para que la integración funcione, debes guardar tu clave de Anthropic en Salesforce:

Ve a Setup -> Custom Metadata Types.
Selecciona Claude Settings -> Manage Records.
Crea un registro llamado Default y pega tu clave en el campo API Key.
2. Habilitar Mensajería (MIAW)
Si el botón de activación de Messaging está bloqueado, verifica:

Omni-Channel: Debe estar habilitado en Omni-Channel Settings.
Licencia de Usuario: Tu usuario debe tener marcada la casilla Service Cloud User.
Sincronización: Si las licencias no aparecen, usa el botón Match Production Licenses en Company Information.
3. Configurar el Einstein Bot
Una vez habilitado el Bot Builder:

Crea un nuevo Bot de tipo "MIAW".
En el flujo del Bot, agrega un elemento de tipo Action.
Selecciona la acción de Apex: Enviar Mensaje a Claude.
Mapea el texto del usuario a la entrada y la respuesta de la acción a una variable del Bot.
🧪 Pruebas y Validación
Se incluye la clase ClaudeInvocableServiceTest para garantizar que la lógica de integración es correcta y permite el despliegue a producción.

Para validar la conexión manualmente, puedes ejecutar el siguiente código en la Consola de Desarrollador (Anonymous Apex):

ClaudeInvocableService.BotInput input = new ClaudeInvocableService.BotInput();
input.userMessage = 'Hola Claude, ¿estás conectado?';
List<ClaudeInvocableService.BotOutput> result = ClaudeInvocableService.sendMessageToClaude(new List<ClaudeInvocableService.BotInput>{input});
System.debug(result[0].claudeResponse);
Documentación generada automáticamente por Antigravity.
