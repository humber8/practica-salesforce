public class HTTPExceptionMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        throw new CalloutException('Simulated callout failure');
    }
}