--*********************    
--Created By: Sharmila Basu 24/04/2012    
--**********************    
--exec uspInsertBatchInstallment '<items><item I_Batch_ID="435" I_Installment_No="1" Dt_Installment_Date="6/1/2012 12:00:00 AM" N_Installment_Amount="4000" C_Is_LumpSum="N"   S_Crtd_By="sa" Dt_Crtd_On="4/24/2012 6:19:33 PM"></item><item I_Batch_ID="435" I_Installment_No="2" Dt_Installment_Date="7/1/2012 12:00:00 AM" N_Installment_Amount="2000" C_Is_LumpSum="N"   S_Crtd_By="sa" Dt_Crtd_On="4/24/2012 6:19:33 PM"></item><item I_Batch_ID="435" I_Installment_No="3" Dt_Installment_Date="8/1/2012 12:00:00 AM" N_Installment_Amount="2000" C_Is_LumpSum="N"   S_Crtd_By="sa" Dt_Crtd_On="4/24/2012 6:19:33 PM"></item><item I_Batch_ID="435" I_Installment_No="4" Dt_Installment_Date="9/1/2012 12:00:00 AM" N_Installment_Amount="2000" C_Is_LumpSum="N"   S_Crtd_By="sa" Dt_Crtd_On="4/24/2012 6:19:33 PM"></item><item I_Batch_ID="435" I_Installment_No="5" Dt_Installment_Date="10/1/2012 12:00:00 AM" N_Installment_Amount="2000" C_Is_LumpSum="N"   S_Crtd_By="sa" Dt_Crtd_On="4/24/2012 6:19:33 PM"></item><item I_Batch_ID="435" I_Installment_No="0" Dt_Installment_Date="4/25/2012 12:00:00 AM" N_Installment_Amount="11000" C_Is_LumpSum="Y"   S_Crtd_By="sa" Dt_Crtd_On="4/24/2012 6:19:33 PM"></item></items>'  
CREATE PROCEDURE [dbo].[uspInsertBatchInstallment]   
(
	@XMLDOC varchar(max)--,@out int out  
)   
AS   
BEGIN   
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON    
     
declare @xml_hndl int   
BEGIN TRY    
  
--BEGIN TRANSACTION    
  
exec sp_xml_preparedocument @xml_hndl OUTPUT, @XMLDOC   
  
INSERT INTO   dbo.T_Batch_Installment_Detail (I_Batch_ID,I_Installment_No,Dt_Installment_Date,N_Installment_Amount,C_Is_LumpSum,S_Crtd_By,Dt_Crtd_On)  
	SELECT    *  
	FROM  OPENXML (@xml_hndl, '/items/item',1)  
				WITH (  
						 I_Batch_ID  int,  
						 I_Installment_No int,  
						 Dt_Installment_Date datetime,  
						 N_Installment_Amount numeric,  
						 C_Is_LumpSum varchar(20),  
						 S_Crtd_By varchar(20),  
						 Dt_Crtd_On datetime  
					  )  
	      
END TRY    
BEGIN CATCH    
 --Error occurred:      
 --ROLLBACK TRANSACTION    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH    
END
