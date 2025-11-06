CREATE PROCEDURE [EXAMINATION].[uspAddHomework]
(
--@iHomeworkId INT,
@sHomeworkName varchar(200),
@sHomeworkDesc varchar(2000),
@dSubmissionDate datetime = NULL ,
@iBatchId INT,	
@iCenterId INT,
@iTermId INT,
@iSessionID INT,
@sCreatedBy varchar(20)= NULL ,
@dCreatedOn datetime = NULL 
)
AS
SET NOCOUNT OFF
BEGIN TRY	

	INSERT INTO EXAMINATION.T_Homework_Master
		( --I_Homework_ID, 
		  S_Homework_Name,
		  S_Homework_Desc,
		  Dt_Submission_Date,
		  I_Batch_ID,
		  I_Center_ID,
		  I_Term_ID,
		  I_session_ID,
		  I_Status, 
		  S_Crtd_By, 
		  Dt_Crtd_On )
		VALUES
		( --@iHomeworkId, 
		  @sHomeworkName, 
		  @sHomeworkDesc,
		  @dSubmissionDate,
		  @iBatchId,
		  @iCenterId,
		  @iTermId,
		  @iSessionID,
		  1,
		  @sCreatedBy, 
		  @dCreatedOn )
		  
END TRY    
BEGIN CATCH    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
