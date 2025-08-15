public class ExternalSearch {
    public class ExternalSearchException extends Exception {}

    public static String googleIt(String query) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://www.google.com/search?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
            req.setMethod('GET');

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() > 200) {
                throw new ExternalSearchException('Unexpected response code: ' + res.getStatusCode());
            }

            return res.getBody();
        } catch (Exception e) {
            throw new ExternalSearchException('Callout failed: ' + e.getMessage());
        }
    }
}