({
	 csvRead : function(cmp,event,helper){
        var files = event.getSource().get("v.files");
        var file=files[0];
      
        console.log(files.length + ' files !!');
        console.log( + ' files !!');
        if(files.length>1)
        {
            cmp.set("v.error_Message","Only One File");
            cmp.set("v.toast_error",true);           
        }   
        else if(file.name.includes("PDS") && file.name.split('.').pop().toLowerCase()=='csv'){
            cmp.set("v.toast_error",false); 
            
              var excelreader=new FileReader();
                    excelreader.onload = $A.getCallback(function(){
                    var fileData=excelreader.result.replace(/\0/g, '');
                  
                    cmp.set("v.excelData",fileData);
                    helper.excelDataTransfer(cmp,event);
                    
                });
                excelreader.readAsText(file, 'ISO-8859-1');
         }  
         else if(file.name.split('.').pop().toLowerCase()!='csv')
         {
            cmp.set("v.error_Message","Only CSV File is Allowed");
            cmp.set("v.toast_error",true);
         }
         else if(!file.name.includes("PDS")){
         	cmp.set("v.error_Message","File Name must contains PDS");
            cmp.set("v.toast_error",true);        
         }
    }
    
})