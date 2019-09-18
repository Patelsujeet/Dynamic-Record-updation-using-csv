({
	  excelDataTransfer :  function(cmp,evt){
        var action=cmp.get("c.excelData");
        
       	cmp.set("v.toast_waiting",true);  
        cmp.set("v.file_disabled",true);  
          
        action.setParams({
            "d":cmp.get("v.excelData")+"",
           "pds_recordID":cmp.get("v.pds_record_Id")
        });
        action.setCallback(this,function(response){
             var state = response.getState();
            		if (state === "SUCCESS") {
                		console.log("From server: " + response.getReturnValue());
                        if(response.getReturnValue()=='Success'){
                            cmp.set("v.toast_waiting",false);
                            cmp.set("v.toast_success",true);
                            cmp.set("v.file_disabled",false);
                        }  
                        else{
                             cmp.set("v.error_Message","Contact System Administrator or Server Error");
                            cmp.set("v.toast_waiting",false);
                            cmp.set("v.toast_error",true);
                            cmp.set("v.file_disabled",true);
                        }
            		}	
            		else if (state === "ERROR")
                    {
						var errors = response.getError();
            			if (errors) 
                        {
               			    if (errors[0] && errors[0].message)
                            {
						      console.log("Error message: " +errors[0].message);
                                cmp.set("v.error_Message","Contact System Administrator or Server Error");
                                cmp.set("v.toast_waiting",false);
                        		cmp.set("v.toast_error",true);
       						}
		                } else {
                    		console.log("Unknown error");
                		}
                    }   
        });
         $A.enqueueAction(action);
    }
})