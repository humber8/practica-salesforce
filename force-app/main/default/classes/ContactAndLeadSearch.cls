public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(String searchString) {
        String searchQuery = 'FIND \'' + searchString + '\' IN NAME FIELDS RETURNING Contact(Id, FirstName, LastName), Lead(Id, FirstName, LastName)';
        List<List<SObject>> searchList = Search.query(searchQuery);
        return searchList;
    }
}