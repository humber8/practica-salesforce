public class HTTPMockFactory implements HttpCalloutMock {
    private Integer statusCode;
    private String status;
    private String body;
    private Map<String, String> headers;

    public HTTPMockFactory(Integer statusCode, String status, String body, Map<String, String> headers) {
        this.statusCode = statusCode;
        this.status = status;
        this.body = body;
        this.headers = headers;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setStatus(status);
        res.setBody(body);

        if (headers != null) {
            for (String key : headers.keySet()) {
                res.setHeader(key, headers.get(key));
            }
        }

        return res;
    }
}
