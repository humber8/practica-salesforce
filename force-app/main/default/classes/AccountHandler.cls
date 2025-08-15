public class AccountHandler {
    public Account insertNewAccount(String acctName) {
        Account acct = new Account(Name = acctName);
        try {
            insert acct;
            return acct;
        } catch (DmlException e) {
            System.debug('A DML exception has occurred: ' + e.getMessage());
            return null;
        }
    }
}