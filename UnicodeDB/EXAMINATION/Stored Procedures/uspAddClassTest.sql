
CREATE PROCEDURE [EXAMINATION].[uspAddClassTest]
(
--@iHomeworkId INT,
@sClassTestName varchar(200),
@sClassTestDesc varchar(2000),
@dSubmissionDate datetime = NULL ,
@iBatchId INT,	
@iCenterId INT,
@iTimeTableId INT,
@sCreatedBy varchar(20)= NULL ,
@dCreatedOn datetime = NULL,
@ntotalmarks DECIMAL(14,1) 
)
AS
SET NOCOUNT OFF
BEGIN TRY	

	INSERT INTO EXAMINATION.T_ClassTest_Master
	        ( S_ClassTest_Name ,
	          S_ClassTest_Desc ,
	          Dt_Submission_Date ,
	          I_Batch_ID ,
	          I_Center_ID ,
	          I_Status ,
	          S_Crtd_By ,
	          Dt_Crtd_On ,
	          I_TimeTable_ID,
	          N_Total_Marks
	        )
	VALUES  ( @sClassTestName, -- S_ClassTest_Name - varchar(max)
	          @sClassTestDesc, -- S_ClassTest_Desc - varchar(max)
	          @dSubmissionDate , -- Dt_Submission_Date - datetime
	          @iBatchId , -- I_Batch_ID - int
	          @iCenterId , -- I_Center_ID - int
	          1 , -- I_Status - int
	          @sCreatedBy , -- S_Crtd_By - varchar(max)
	          @dCreatedOn , -- Dt_Crtd_On - datetime
	          @iTimeTableId, -- I_TimeTable_ID - int
	          @ntotalmarks
	        )
		  
END TRY    
BEGIN CATCH    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
