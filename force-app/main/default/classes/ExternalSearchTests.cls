@IsTest
private class ExternalSearchTests {
 @IsTest
    static void testPositiveMocking() {
        HTTPMockFactory mock = new HTTPMockFactory(
            200,
            'OK',
            'I found it!',
            new Map<String, String>()
        );
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        String result = ExternalSearch.googleIt('epic search');
        Test.stopTest();

        System.assertEquals('I found it!', result, 'Expected to receive mock response');
    }


@IsTest
static void testNegativeMocking() {
    HTTPMockFactory mock = new HTTPMockFactory(
        500,
        'Internal Server Error',
        'Something went wrong',
        new Map<String, String>()
    );
    Test.setMock(HttpCalloutMock.class, mock);

    Test.startTest();
    try {
        ExternalSearch.googleIt('fail search');
        System.assert(false, 'Expected ExternalSearchException not thrown');
    } catch (ExternalSearch.ExternalSearchException e) {
        System.assert(e.getMessage().startsWith('Unexpected response code'), 'Expected exception for HTTP 500');
    }
    Test.stopTest();
}

@IsTest
static void testExceptionMocking() {
    Test.setMock(HttpCalloutMock.class, new HTTPExceptionMock());

    Test.startTest();
    try {
        ExternalSearch.googleIt('exception test');
        System.assert(false, 'Expected ExternalSearchException not thrown');
    } catch (ExternalSearch.ExternalSearchException e) {
        System.assert(e.getMessage().startsWith('Callout failed'), 'Expected exception for callout failure');
    }
    Test.stopTest();
}

@isTest
    static void testGoogleItSuccess() {
        Test.setMock(HttpCalloutMock.class, new HTTPSuccessMock());

        Test.startTest();
        String result = ExternalSearch.googleIt('Salesforce');
        Test.stopTest();

        System.assertEquals('Mocked Google response', result);
    }

    @isTest
    static void testGoogleItFailure() {
        Test.setMock(HttpCalloutMock.class, new HTTPExceptionMock());

      Test.startTest();
      try {
          ExternalSearch.googleIt('Salesforce');
          System.assert(false, 'Expected ExternalSearchException not thrown');
      } catch (ExternalSearch.ExternalSearchException e) {
          System.assert(e.getMessage().startsWith('Callout failed'));
      }
      Test.stopTest();
    }
}