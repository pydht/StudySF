trigger TR_SFTraining on Contact ( after insert, after update) {
    // 取引先更新処理
    Set<Id> accIDs = new Set<Id>();
    for (Contact  con : Trigger.new) {
        accIDs.add(con.accountid);   
    }
    
    // 取引先責任者のSFトレーニン参加人数カウント
    AggregateResult[] ars=[SELECT  count(ID) cnt,account.id aid  
                           FROM Contact 
                           WHERE account.id in:accIDs and ParticipatedCourse__c!=null  GROUP BY account.id];            
    
    Account[] accts = [SELECT ID FROM ACCOUNT WHERE ID in:accIDs];
    
    for(AggregateResult ar:ars){
        Integer cont=Integer.Valueof(String.Valueof(ar.get('cnt'))); 
        ID aid=(ID)ar.get('aid');
        for(Account acc:accts){
            if(acc.id==aid){
                acc.SFTrainingCount__c=cont;
            }                    
        }
    }
    // 取引先更新処理
    UPDATE accts;   
}