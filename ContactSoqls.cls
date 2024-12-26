public with sharing class ContactSoqls {
    public ContactSoqls() {

    }
    SELECT 
    Account.Name, 
    COUNT(Id) AS TotalContacts, 
    MAX(CreatedDate) AS LatestContactDate, 
    (SELECT Name, Amount FROM Opportunities WHERE StageName = 'Closed Won' ORDER BY Amount DESC) 
FROM 
    Contact 
WHERE 
    CreatedDate = LAST_N_DAYS:30 
    AND Email LIKE '%@example.com' 
GROUP BY 
    Account.Name 
ORDER BY 
    TotalContacts DESC

}