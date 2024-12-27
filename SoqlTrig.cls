public with sharing class SoqlTrig {
    public SoqlTrig() {
     
 Map<String, Set<Contact>> accConMap = new Map<String, Set<Contact>>();
 for (Contact con : [
	SELECT
		Id,
		LastName,
		Account.BillingCity,
		AccountId
	FROM
		Contact
	WHERE
		Account.BillingCity = 'Bangalore'
 ]) {
	
	System.debug('-=-- AccountId -=- '+con.AccountId);
	Set<Contact> conSet = new Set<Contact> ();
	
	if (accConMap.containsKey(con.AccountId)) {
	    conSet = accConMap.get(con.AccountId);
	}
	
	conSet.add(con);
	accConMap.put(con.AccountId, conSet);
}
System.debug('-=- accConMap -=- '+accConMap);
    }
}