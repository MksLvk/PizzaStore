global class CustomPizzaBatch implements Database.Batchable<sObject>, Database.Stateful {

    public static final Integer SCOPE_SIZE = 5;

    private String query;


    global CustomPizzaBatch(String queryString) {
        query = queryString;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        /*if (scope != null && !scope.isEmpty()){
            Database.delete(scope, false);
        }*/
    }

    global void finish(Database.BatchableContext BC) {
        
    }

    global static Id invoke(String queryString) {
        CustomPizzaBatch batch = new CustomPizzaBatch(queryString);
        return Database.executeBatch(batch, SCOPE_SIZE);
    }
    


}