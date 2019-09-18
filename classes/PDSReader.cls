public class PDSReader {
    
    @AuraEnabled
    public static String excelData(String d,String pds_recordID){
        
        try{
            String pdsdata=d;
            List<String> data=d.split('\n');
            Map<String,String> sheetData=new Map<String,String>();
            for(String d_obj:data){
                List<String> s=d_obj.split(';');
                if(s.size()==2){
                    sheetData.put(s[0].trim(),s[1].trim());
                }
                
            }
        	System.debug('+++'+pds_recordID);
            PDSReader.getPdsFields(sheetData,pds_recordID);
            //PDSReader.getPdsFields(sheetData,'a4M2g0000008tiIEAQ');
		
           return 'Success';
        }
        catch(System.JSONException js){
            return 'Data Exception';
        }
        catch(Exception e){
        	 return 'Exception';
        }
        
   }
    
    public static void getPdsFields(Map<String,String> sheetData,String pds_id){
        
        String pds_Query='select ';
        
        Map<String,String> labelNameWithData=new Map<String,String>();
        Schema.DescribeSObjectResult d = Product_Data__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = d.fields.getMap();
        
        for(Schema.SObjectField s:fieldMap.values()){
             Schema.DescribeFieldResult fieldResult = s.getDescribe();
             	pds_Query=pds_Query+fieldResult.getName()+',';
            
            if(sheetData.get(fieldResult.getLabel())!=null){
                labelNameWithData.put(fieldResult.getName(),sheetData.get(fieldResult.getLabel()));
                System.debug('Name:'+fieldResult.getName()+':'+sheetData.get(fieldResult.getLabel()));
            }     	
        }
        pds_Query=pds_Query.substring(0,pds_Query.length()-1);
        pds_Query=pds_Query+' from Product_Data__c where id=:pds_id';
        System.debug('Query'+pds_Query);
        sObject s = Database.query(pds_Query);
        
        for(String str:labelNameWithData.keySet()){
            System.debug(Schema.getGlobalDescribe().get('Product_Data__c').getDescribe().fields.getMap().get(str).getDescribe().getType());
            if(Schema.getGlobalDescribe().get('Product_Data__c').getDescribe().fields.getMap().get(str).getDescribe().getType()==Schema.DisplayType.DOUBLE){
                System.debug(str+'+++'+labelNameWithData.get(str)); 
                s.put(str,Decimal.valueof(labelNameWithData.get(str)));
            }
			else if(Schema.getGlobalDescribe().get('Product_Data__c').getDescribe().fields.getMap().get(str).getDescribe().isCalculated()){
                continue;
			}
            else
            {
                System.debug(str+'+++'+labelNameWithData.get(str)+'string'); 
                s.put(str,labelNameWithData.get(str));   
            }
            /*s.put(str,labelNameWithData.get(str));*/
        	   
        }
        Database.update(s);
        System.debug('+++'+s);
        
    }
    


}