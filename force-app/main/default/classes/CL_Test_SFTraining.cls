@isTest
public class CL_Test_SFTraining {
    //同じ取引先の取先責任者が2件作成
    @testSetup static void setup(){   
        Account acc = new Account(
            Name = 'TestAcc' 
        );   
        insert acc;
        
        List<Contact> cons = new List<Contact>();
        Contact con1 = new Contact(
            LastName = 'TestCon1',
            AccountId=acc.id
        );   
        cons.add(con1);
        Contact con2 = new Contact(
            LastName = 'TestCon2',
            AccountId=acc.id
        );   
        cons.add(con2);
        insert cons;
    }
    
    
    @isTest static void test0001_positive() {
        // 同じ取引先の2名の取先責任者はそれぞれトレーニングレコードが１件づつ作成
        List<Contact> cons  = [SELECT Id,AccountId,LastName FROM Contact ];
        List<M_SFTraining__c> trs = new List<M_SFTraining__c>(); 
        
        M_SFTraining__c tr1 = new M_SFTraining__c(
            Name = 'SF1',
            Participant__c=cons[0].id,
            ParticipationDate__c = date.today()  
        );
        trs.add(tr1);
        M_SFTraining__c tr2 = new M_SFTraining__c(
            Name = 'SF2',
            Participant__c=cons[1].id,
            ParticipationDate__c = date.today()  
        );
        trs.add(tr2);
        
        // テスト開始
        Test.startTest();
        Database.SaveResult[] results = Database.insert(trs, false);  
        Test.stopTest();
        
        // 検証       
        ACCOUNT acc = [SELECT  Name,SFTrainingCount__c  FROM ACCOUNT    WHERE name='TestAcc' LIMIT 1];
        // 取引先別の参加人数は2名であること
        Assert.areEqual(2, acc.SFTrainingCount__c);
    }
}