-- Add the parameters for the stored procedure here  
CREATE PROCEDURE [dbo].[uspInsertUpdateEvaluationDetails]   
(  
 @I_Evaluation_ID   INT,  
 @I_Brand_ID   INT,  
 @S_Evaluation_Name VARCHAR(50),    
 @I_Status   INT,  
 @vEsdCrtdBy   VARCHAR(50),  
 @vEsdUpdBy   VARCHAR(50),  
 @iUpdateID   INT,  
 @dEsdCrtdOn   DATETIME,  
 @dEsdUpdOn   DATETIME  
 )  
  
AS  
BEGIN TRY   
SET NOCOUNT OFF;  
 DECLARE @iResult INT  
 --DECLARE @iUpdateID INT  
 BEGIN TRANSACTION   
 set @iResult = 0 -- set to default zero   
      
   IF @iUpdateID = 1 --for insert    
   begin  
     IF ( SELECT  COUNT(*)  
             FROM    dbo.T_Activity_Evaluation_Master AS TEM  
             WHERE   S_Evaluation_Name = @S_Evaluation_Name and I_Status = 1) = 0   
               
   INSERT INTO  dbo.T_Activity_Evaluation_Master 
  (     
    I_Brand_ID  
   ,S_Evaluation_Name    
   ,I_Status  
   ,S_Crtd_By  
   ,S_Upd_By  
   ,Dt_Crtd_On  
   ,Dt_Upd_On  
      
  )  
  VALUES   
  (        
    @I_Brand_ID 
   ,@S_Evaluation_Name             
   ,@I_Status       
   ,@vEsdCrtdBy        
   ,@vEsdUpdBy            
   ,@dEsdCrtdOn  
   ,@dEsdUpdOn    
  )    
  ELSE   
            BEGIN  
                RAISERROR('Entry with the same Evaluation Name. already exists',11,1)  
            END  
 end  
 --SELECT  @@IDENTITY  
 Else IF @iUpdateID = 0 -- for update  
  begin  
  UPDATE T_Activity_Evaluation_Master  
   SET S_Evaluation_Name = @S_Evaluation_Name    
  WHERE I_Evaluation_ID = @I_Evaluation_ID  
    
  --select * from T_Transport_Master;  
 end  
 Else IF @iUpdateID = 2 -- for delete  
  begin  
  select * from T_Activity_Evaluation_Master;  
  UPDATE T_Activity_Evaluation_Master  
   SET I_Status = @I_Status    
  WHERE I_Evaluation_ID = @I_Evaluation_ID    
 end  
   
 SELECT @iResult Result  
 COMMIT TRANSACTION   
END TRY  
BEGIN CATCH  
  ROLLBACK TRANSACTION    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
