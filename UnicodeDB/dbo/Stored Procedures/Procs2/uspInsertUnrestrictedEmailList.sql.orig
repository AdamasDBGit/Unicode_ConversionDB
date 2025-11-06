CREATE PROCEDURE [dbo].[uspInsertUnrestrictedEmailList] --'<Root><EmailId sEmailId="abc@abc.com" /><EmailId sEmailId="one@vao.com" /><EmailId sEmailId="test@gmail.com" /><EmailId sEmailId="a123@abc.com" /></Root>','sa','1/12/2011'
(                          
                      
 @sEmailId VARCHAR(MAX),    
 @sCrtdBy VARCHAR(20),                    
 @dtCrtdOn DATETIME=NULL           
)                          
AS                             
BEGIN TRY                            
 BEGIN TRANSACTION        
               
 DECLARE @xml_hndl INT           
       
  CREATE TABLE #tempEmail            
  (                        
    EmailId VARCHAR(200)        
  )      
        
  EXEC sp_xml_preparedocument @xml_hndl OUTPUT, @sEmailId            
        
  INSERT INTO #tempEmail      
   (         
      EmailId      
   )      
   SELECT sEmailId              
   From                  
   OPENXML(@xml_hndl, '/Root/EmailId', 1)                  
 With                  
 (                  
    sEmailId VARCHAR(200) '@sEmailId'              
  )                  
   
        
    DECLARE @cn_email VARCHAR(50)            
          
    DECLARE INSERT_Email CURSOR FOR            
    SELECT EmailId FROM #tempEmail  
            
  OPEN INSERT_Email             
  FETCH NEXT FROM INSERT_Email INTO @cn_email            
               
  WHILE @@FETCH_STATUS = 0                
   BEGIN             
     IF NOT EXISTS(SELECT S_Email_Id FROM dbo.T_Unrestricted_EmailId_List WHERE S_Email_Id = @cn_email)      
       BEGIN      
     INSERT INTO dbo.T_Unrestricted_EmailId_List  
      (             
  S_Email_Id ,  
  S_Crtd_By ,  
  Dt_Crtd_On  
      )            
    VALUES  (   
    @cn_email,  
    @sCrtdBy,                    
 @dtCrtdOn  
      )     
        
      END           
             
    FETCH NEXT FROM INSERT_Email INTO @cn_email                  
                 
   END            
               
  CLOSE INSERT_Email             
  DEALLOCATE INSERT_Email          
              
  DROP TABLE #tempEmail      
       
  SELECT S_Email_Id FROM dbo.T_Unrestricted_EmailId_List      
  COMMIT TRANSACTION                
                
END TRY                  
                        
BEGIN CATCH                  
              
  ROLLBACK TRANSACTION                  
                        
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int                            
 SELECT @ErrMsg = ERROR_MESSAGE(),                            
 @ErrSeverity = ERROR_SEVERITY()                            
 RAISERROR(@ErrMsg, @ErrSeverity, 1)                
                           
END CATCH
