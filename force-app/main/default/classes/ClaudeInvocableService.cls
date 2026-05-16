public with sharing class ClaudeInvocableService {
    
    // Configuración para el Bot (Entrada)
    public class BotInput {
        @InvocableVariable(required=true description='Mensaje enviado por el usuario')
        public String userMessage;
    }
    
    // Configuración para el Bot (Salida)
    public class BotOutput {
        @InvocableVariable(description='Respuesta generada por Claude')
        public String claudeResponse;
    }

    @InvocableMethod(label='Enviar Mensaje a Claude' description='Envía un mensaje a la API de Anthropic y devuelve la respuesta' callout=true)
    public static List<BotOutput> sendMessageToClaude(List<BotInput> inputs) {
        List<BotOutput> outputs = new List<BotOutput>();
        
        // Obtener la API Key desde el Custom Metadata Type
        Claude_Settings__mdt setting;
        try {
            // Usamos un registro genérico llamado 'Default' si existe, o limitamos a 1
            setting = [SELECT API_Key__c FROM Claude_Settings__mdt LIMIT 1];
        } catch(Exception e) {
            System.debug('No se encontró configuración de Claude en Custom Metadata.');
        }
        
        String apiKey = setting != null ? setting.API_Key__c : '';
        if (String.isBlank(apiKey)) {
            BotOutput errOut = new BotOutput();
            errOut.claudeResponse = 'Error: API Key de Claude no configurada en Salesforce.';
            outputs.add(errOut);
            return outputs;
        }
        
        for (BotInput input : inputs) {
            BotOutput output = new BotOutput();
            output.claudeResponse = makeApiCallout(input.userMessage, apiKey);
            outputs.add(output);
        }
        
        return outputs;
    }
    
    private static String makeApiCallout(String message, String apiKey) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.anthropic.com/v1/messages');
        req.setMethod('POST');
        req.setHeader('x-api-key', apiKey);
        req.setHeader('anthropic-version', '2023-06-01');
        req.setHeader('content-type', 'application/json');
        
        // Estructura JSON para la API de Claude
        Map<String, Object> payload = new Map<String, Object>{
            'model' => 'claude-3-5-sonnet-20241022',
            'max_tokens' => 1024,
            'messages' => new List<Object>{
                new Map<String, String>{
                    'role' => 'user',
                    'content' => message
                }
            }
        };
        
        req.setBody(JSON.serialize(payload));
        
        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                // Parsear respuesta JSON de Claude
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> contentList = (List<Object>) responseMap.get('content');
                if (contentList != null && !contentList.isEmpty()) {
                    Map<String, Object> firstContent = (Map<String, Object>) contentList[0];
                    return (String) firstContent.get('text');
                }
            } else {
                return 'Error de API: ' + res.getStatusCode() + ' - ' + res.getBody();
            }
        } catch(Exception ex) {
            return 'Excepción en Apex: ' + ex.getMessage();
        }
        
        return 'Lo siento, no pude procesar la respuesta.';
    }
}
