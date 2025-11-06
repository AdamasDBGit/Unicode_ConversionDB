--sp_helptext uspApproveOrRejectStudentBatch        
--uspApproveOrRejectStudentBatch        
        
CREATE PROCEDURE [dbo].[uspApproveOrRejectStudentBatch__BeforeFeePLanModify_March2023]             
(            
 @iBatchId INT,            
 @iStatus INT,            
 @UpdtBy NVARCHAR(MAX),            
 @UpdtOn DATETIME,            
 @iCenterId INT,            
 @dtBatchStartDate DATETIME,            
 @dtBatchExpectedEndDate DATETIME,            
 @MaxStrength int,            
 @MinRegnAmt decimal(18,2),            
 --@iTimeSlotId int,            
 @iTaskDetailId int = NULL,            
 @sBatchName NVARCHAR(MAX),          
 @bIsApproved bit,        
 @iFacultyId INT = NULL,      
 @iAdmissionGraceDays INT,    
 @MinStrength INT,  
 @iLateFeeGraceDays INT    ,
 @dtBatchIntroductionDate DATETIME = null,
 @sBatchIntroductionTime NVARCHAR(MAX) =null       
)            
AS            
BEGIN TRY

	DECLARE @EntryType VARCHAR(MAX)=NULL
	DECLARE @Status INT=NULL

	select @Status=I_Status from T_Student_Batch_Master where I_Batch_ID=@iBatchId

	IF(@iStatus=0)
		set @EntryType='UPDATE STATUS'
	ELSE IF(@Status IS NOT NULL and @Status=1)
		set @EntryType='ADD'
	ELSE IF (@Status>1)
		set @EntryType='UPDATE'

 IF(@iStatus = 4 OR @iStatus = 5)            
 BEGIN            
  UPDATE dbo.T_Student_Batch_Master             
  SET I_Status = 2,S_Batch_Name = @sBatchName, Dt_BatchStartDate = @dtBatchStartDate,Dt_Course_Expected_End_Date = @dtBatchExpectedEndDate,            
  S_Updt_By = @UpdtBy,            
  Dt_Upd_On = @UpdtOn,            
  --I_TimeSlot_Id = @iTimeSlotId,          
  b_IsApproved = @bIsApproved ,      
  I_Admission_GraceDays =  @iAdmissionGraceDays,  
  I_Latefee_Grace_Day = @iLateFeeGraceDays   ,
  Dt_BatchIntroductionDate =  @dtBatchIntroductionDate,
  s_BatchIntroductionTime =   @sBatchIntroductionTime   
 WHERE I_Batch_ID = @iBatchId             
              
  UPDATE dbo.T_Center_Batch_Details            
  SET I_Status = @iStatus,            
  S_Updt_By = @UpdtBy,            
  Dt_Upd_On = @UpdtOn,            
  Max_Strength = @MaxStrength,          
  I_Employee_ID = @iFacultyId,         
  I_Minimum_Regn_Amt = @MinRegnAmt,    
  I_Min_Strength = @MinStrength           
  WHERE I_Batch_ID = @iBatchId            
  AND I_Centre_Id = @iCenterId            
 END            
 ELSE            
 BEGIN            
  UPDATE dbo.T_Student_Batch_Master             
  SET I_Status = 3,            
  S_Updt_By = @UpdtBy,            
  Dt_Upd_On = @UpdtOn,          
  b_IsApproved = @bIsApproved ,      
  I_Admission_GraceDays =  @iAdmissionGraceDays,  
  I_Latefee_Grace_Day = @iLateFeeGraceDays   ,
  Dt_BatchIntroductionDate =  @dtBatchIntroductionDate,
  s_BatchIntroductionTime =   @sBatchIntroductionTime             
 WHERE I_Batch_ID = @iBatchId            
         
 UPDATE dbo.T_Center_Batch_Details            
  SET I_Status = NULL,            
  S_Updt_By = @UpdtBy,            
  Dt_Upd_On = @UpdtOn,            
  Max_Strength = @MaxStrength,            
  I_Minimum_Regn_Amt = @MinRegnAmt,    
  I_Min_Strength = @MinStrength            
  WHERE I_Batch_ID = @iBatchId            
  AND I_Centre_Id = @iCenterId            
          
 END            
             
 IF(ISNULL(@iTaskDetailId,0) > 0)            
 BEGIN            
  UPDATE T_Task_Details SET I_Status = 0,Dt_Updated_Date = GETDATE() WHERE I_Task_Details_Id = @iTaskDetailId            
 END 
 
 EXEC LMS.uspInsertBatchDetailsForInterface @iBatchId,@EntryType


END TRY            
BEGIN CATCH            
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int            
 SELECT @ErrMsg = ERROR_MESSAGE(),            
   @ErrSeverity = ERROR_SEVERITY()            
            
 RAISERROR(@ErrMsg, @ErrSeverity, 1)            
END CATCH

