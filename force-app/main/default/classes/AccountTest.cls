@isTest
private class AccountTest {
    
    @isTest
    static void testAccountFieldInsertion() {
        // Setup test data
        Date expectedDate = Date.newInstance(2024, 10, 15);
        Account testAcc = new Account(
            Name = 'Test Account for Date Field',
            Fecha_de_ingreso_gerencia__c = expectedDate
        );
        
        // Perform test
        Test.startTest();
        insert testAcc;
        Test.stopTest();
        
        // Verify 
        Account insertedAcc = [SELECT Id, Name, Fecha_de_ingreso_gerencia__c FROM Account WHERE Id = :testAcc.Id];
        
        System.assertEquals('Test Account for Date Field', insertedAcc.Name, 'Account name should match');
        System.assertEquals(expectedDate, insertedAcc.Fecha_de_ingreso_gerencia__c, 'Custom field date should match');
    }
}
