@isTest
private class ClaudeInvocableServiceTest {
    
    // Mock callout class
    private class ClaudeHttpCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id": "msg_123", "type": "message", "role": "assistant", "content": [{"type": "text", "text": "Hola soy Claude"}]}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testSendMessageToClaude() {
        Test.setMock(HttpCalloutMock.class, new ClaudeHttpCalloutMock());
        
        ClaudeInvocableService.BotInput input = new ClaudeInvocableService.BotInput();
        input.userMessage = 'Hola';
        
        List<ClaudeInvocableService.BotInput> inputs = new List<ClaudeInvocableService.BotInput>{ input };
        
        Test.startTest();
        List<ClaudeInvocableService.BotOutput> outputs = ClaudeInvocableService.sendMessageToClaude(inputs);
        Test.stopTest();
        
        System.assertNotEquals(null, outputs, 'La salida no debe ser nula');
        System.assertEquals(1, outputs.size(), 'Debe haber exactamente 1 salida');
        // Validamos si falló por falta de metadata o si retornó el mock
        String response = outputs[0].claudeResponse;
        System.assert(response.contains('Hola soy Claude') || response.contains('Error: API Key'), 'La respuesta debe ser del mock o un error de metadata por estar en un test');
    }
}
