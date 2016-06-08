public class FirstPageController {
    
    public Account myAccount { get; set; }
    public List<Account> myAccountList { get; set; }
    public Boolean editMode { get; set; }
    
    public FirstPageController () {
        //retrieveRecord();
        myAccountList = [SELECT Id, Name, Phone, Industry, Owner.Name FROM Account];
    }
    
    public void edit() {
        editMode = true;
    }
    
    public void save() {
        update myAccount;
        editMode = false;
    }
    
    public void cancel() {
        retrieveRecord();
    }
    
    public void retrieveRecord() {
        editMode = false;
        myAccount = [SELECT Id, Name, Phone, Industry, Owner.Name FROM Account WHERE Id = '0012800000Y0WhQ'];
    }
    
    
}