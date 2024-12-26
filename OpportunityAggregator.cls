/**
 * @description This class is responsible for aggregating Opportunity data by Account, 
 *              including the count of opportunities, total revenue, and parent account details.
 */
public class OpportunityAggregator {

    /**
     * @description Aggregates Opportunity data grouped by Account and logs the results.
     *              Retrieves the parent account details for each account and logs them alongside the aggregated data.
     *              
     * @param None This method does not accept any parameters.
     * @return None This method does not return any value. All results are logged to the debug log.
     * 
     * @details
     * - Performs an aggregate SOQL query to count the number of Opportunities and calculate the total revenue 
     *   for Opportunities with a StageName of 'Closed Won', grouped by Account.
     * - Retrieves parent account details for the Accounts in the aggregation results.
     * - Logs the following details for each Account:
     *   - Account ID
     *   - Parent Account ID
     *   - Parent Account Name
     *   - Total Opportunities
     *   - Total Revenue
     */
    public static void aggregateOpportunities() {
        // Perform SOQL query with aggregation and grouping
        List<AggregateResult> results = [
            SELECT 
                AccountId, 
                COUNT(Id) TotalOpportunities, 
                SUM(Amount) TotalRevenue 
            FROM 
                Opportunity 
            WHERE 
                StageName = 'Closed Won' 
            GROUP BY 
                AccountId 
            ORDER BY 
                SUM(Amount) DESC
        ];

        // Collect Account IDs for fetching parent details
        Set<Id> accountIds = new Set<Id>();
        for (AggregateResult ar : results) {
            accountIds.add((Id) ar.get('AccountId'));
        }

        // Query parent account details
        Map<Id, Account> accountMap = new Map<Id, Account>(
            [SELECT Id, ParentId, Parent.Name FROM Account WHERE Id IN :accountIds]
        );

        // Loop through the results and log the data
        for (AggregateResult ar : results) {
            Id accountId = (Id) ar.get('AccountId'); // Account ID associated with the Opportunity
            Long totalOpportunities = (Long) ar.get('TotalOpportunities'); // Total number of Opportunities for the Account
            Decimal totalRevenue = (Decimal) ar.get('TotalRevenue'); // Total revenue for the Opportunities of the Account

            Account acc = accountMap.get(accountId); // Account details retrieved from the Account query
            String parentAccountId = acc != null ? acc.ParentId : null; // Parent Account ID
            String parentAccountName = acc != null && acc.Parent != null ? acc.Parent.Name : 'No Parent'; // Parent Account Name

            // Log the aggregated and parent account data
            System.debug('Account ID: ' + accountId);
            System.debug('Parent Account ID: ' + parentAccountId);
            System.debug('Parent Account Name: ' + parentAccountName);
            System.debug('Total Opportunities: ' + totalOpportunities);
            System.debug('Total Revenue: ' + totalRevenue);
        }
    }
}
