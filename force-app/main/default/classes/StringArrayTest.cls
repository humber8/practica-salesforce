public class StringArrayTest {
    public static List<String> generateStringArray(Integer count) {
        List<String> strList = new List<String>();
        for(Integer i = 0; i < count; i++) {
            strList.add('Test ' + i);
        }
        return strList;
    }
}