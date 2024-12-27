public class UpdateContactCityService {
    public static void updateContactCities(Map<Id, Account> updatedAccounts, Map<Id, Account> oldAccounts) {
        // Collect Account IDs where BillingCity has changed
        Map<Id, String> accountCityMap = new Map<Id, String>();
        for (Id accId : updatedAccounts.keySet()) {
            if (updatedAccounts.get(accId).BillingCity != oldAccounts.get(accId).BillingCity) {
                accountCityMap.put(accId, updatedAccounts.get(accId).BillingCity);
            }
        }

        // If no accounts have changes, exit early
        if (accountCityMap.isEmpty()) {
            return;
        }

        // Fetch related Contacts and prepare for update
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact con : [
            SELECT Id, City__c, AccountId 
            FROM Contact 
            WHERE AccountId IN :accountCityMap.keySet()
        ]) {
            // Update Contact city based on the corresponding Account's new BillingCity
            con.City__c = accountCityMap.get(con.AccountId);
            contactsToUpdate.add(con);
        }

        // Perform bulk update if there are contacts to update
        if (!contactsToUpdate.isEmpty()) {
            try {
                update contactsToUpdate;
            } catch (DmlException e) {
                // Log errors for debugging purposes
                System.debug('Error updating contacts: ' + e.getMessage());
            }
        }
    }
}
