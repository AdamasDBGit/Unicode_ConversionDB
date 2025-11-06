CREATE PROCEDURE [dbo].[uspCreateBatch_BKP_LANG]                   
(                     
  @sBatchCode NVARCHAR(MAX),            
  @iCourseID INT,            
  @iDeliveryPatternID INT,            
  --@iTimeSlotId INT,            
  @IsHOBatch bit,            
  @dtBatchStartDate DATETIME,            
  @iStatus INT,            
  @dtCourseExpectedEndDate DATETIME,            
  @sCreatedBy NVARCHAR(MAX),            
  @dtCreatedOn DATETIME,            
  @FacultyId INT,            
  @sBatchName NVARCHAR(MAX),          
  @bIsApproved BIT,        
  @iAdmissionGraceDays INT,      
  @bIsCorporate BIT,    
  @iLateFeeGraceDays INT  ,  
  @dtBatchIntroductionDate DATETIME = NULL,  
  @sBatchIntroductionTime NVARCHAR(MAX) = NULL           
)                    
AS                    
BEGIN TRY            
DECLARE @sBatchCodeMax VARCHAR(50)            
SELECT TOP 1 @sBatchCodeMax = @sBatchCode + RIGHT('000' + CAST(SUBSTRING(S_Batch_Code,10,3)+1 AS varchar(3)), 3)             
FROM T_Student_Batch_Master WHERE S_Batch_Code             
LIKE @sBatchCode+'%' ORDER BY S_Batch_Code DESC            
SET @sBatchCode = ISNULL(@sBatchCodeMax, @sBatchCode+'001')            
            
INSERT INTO T_Student_Batch_Master(            
 S_Batch_Code,            
 S_Batch_Name,            
 I_Course_ID,            
 I_Delivery_Pattern_ID,            
 --I_TimeSlot_ID,            
 b_IsHOBatch,            
 Dt_BatchStartDate,            
 I_Status,            
 Dt_Course_Expected_End_Date,            
 S_Crtd_By,            
 Dt_Crtd_On,            
 I_User_ID,          
 b_IsApproved   ,        
 I_Admission_GraceDays,      
 b_IsCorporateBatch,    
 I_Latefee_Grace_Day ,  
 Dt_BatchIntroductionDate,  
 s_BatchIntroductionTime       
) VALUES (             
 @sBatchCode,            
 @sBatchName,            
 @iCourseID,            
 @iDeliveryPatternID,            
 --@iTimeSlotId,            
 @IsHOBatch,            
 @dtBatchStartDate,            
 @iStatus,            
 @dtCourseExpectedEndDate,            
 @sCreatedBy,            
 @dtCreatedOn,            
 @FacultyId,          
 @bIsApproved,        
 @iAdmissionGraceDays,      
 @bIsCorporate,    
 @iLateFeeGraceDays  ,  
 @dtBatchIntroductionDate,  
  @sBatchIntroductionTime       
 )            
SELECT TOP 1 I_Batch_ID, S_Batch_Code FROM dbo.T_Student_Batch_Master ORDER BY I_Batch_ID DESC            
END TRY            
BEGIN CATCH            
 --Error occurred:              
            
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int            
 SELECT @ErrMsg = ERROR_MESSAGE(),            
   @ErrSeverity = ERROR_SEVERITY()            
            
 RAISERROR(@ErrMsg, @ErrSeverity, 1)            
END CATCH    

