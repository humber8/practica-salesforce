@IsTest
private class AccountWrapperTests {
 @TestSetup
    static void setupData() {
        // Cuenta con oportunidades de alto monto (debería ser alta prioridad)
        Account highPriorityAcc = new Account(Name = 'Cuenta Alta Prioridad');
        insert highPriorityAcc;

        List<Opportunity> highOpps = new List<Opportunity>{
            new Opportunity(Name = 'Oportunidad 1', Amount = 120000, StageName = 'Closed Won', CloseDate = Date.today(), AccountId = highPriorityAcc.Id),
            new Opportunity(Name = 'Oportunidad 2', Amount = 130000, StageName = 'Closed Won', CloseDate = Date.today(), AccountId = highPriorityAcc.Id)
        };
        insert highOpps;

        // Cuenta con oportunidades de bajo monto (no debería ser alta prioridad)
        Account lowPriorityAcc = new Account(Name = 'Cuenta Baja Prioridad');
        insert lowPriorityAcc;

        List<Opportunity> lowOpps = new List<Opportunity>{
            new Opportunity(Name = 'Oportunidad 3', Amount = 5000, StageName = 'Closed Won', CloseDate = Date.today(), AccountId = lowPriorityAcc.Id),
            new Opportunity(Name = 'Oportunidad 4', Amount = 8000, StageName = 'Closed Won', CloseDate = Date.today(), AccountId = lowPriorityAcc.Id)
        };
        insert lowOpps;

        // Cuenta sin oportunidades (debería lanzar excepción)
        Account noOppAcc = new Account(Name = 'Cuenta Sin Oportunidades');
        insert noOppAcc;
    }

    @isTest
    static void testIsHighPriority() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Cuenta Alta Prioridad' LIMIT 1];
        AccountWrapper wrapper = new AccountWrapper(acc);
        System.assertEquals(true, wrapper.isHighPriority(), 'Debe ser alta prioridad');
    }

    @isTest
    static void testIsHighPriority_Negative() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Cuenta Baja Prioridad' LIMIT 1];
        AccountWrapper wrapper = new AccountWrapper(acc);
        System.assertEquals(false, wrapper.isHighPriority(), 'No debe ser alta prioridad');
    }

    @isTest
    static void testGetRoundedAvgPriceOfOpps_Exception() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Cuenta Sin Oportunidades' LIMIT 1];
        AccountWrapper wrapper = new AccountWrapper(acc);
        try {
            wrapper.getRoundedAvgPriceOfOpps();
            System.assert(false, 'Se esperaba una excepción AWException');
        } catch (AccountWrapper.AWException e) {
            System.assertEquals('No won Opportunities', e.getMessage());
        }
    }
    @isTest
    static void testNegativeAccountWrapperAvgPriceOfOpps() {
      // GIVEN
      Account acct = [SELECT Id FROM Account LIMIT 1];
      List<Opportunity> opps = [
        SELECT Amount
        FROM Opportunity
        WHERE accountId = :acct.Id
      ];
      for(Opportunity o : opps) {
        o.Amount = 0;
      }
      update opps;
      AccountWrapper acctWrapper = new AccountWrapper(acct);
      // WHEN
      try {
        Test.startTest();
          acctWrapper.getRoundedAvgPriceOfOpps();
        Test.stopTest();
        Assert.fail('An exception should have been thrown');
      } catch (AccountWrapper.AWException e) {
        // THEN
        Assert.isTrue(
          e.getMessage().equalsIgnoreCase('no won opportunities'),
          'Exception message does not match: ' + e.getMessage()
        );
      }
    }
}    
