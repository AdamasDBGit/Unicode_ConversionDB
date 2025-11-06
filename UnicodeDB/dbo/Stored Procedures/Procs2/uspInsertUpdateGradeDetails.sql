/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/
--exec [dbo].[uspInsertMultipleGatePassRequest] 2314,'Pick','test','19-0462,20-0462','2023-06-17','2023-06-20','13:05:20'


CREATE PROCEDURE [dbo].[uspInsertUpdateGradeDetails] 
(
	@iSchoolGradeID int,
	@iSessionID int,
	@iClassID int,
	@GradeMasterDetails UT_GradeMasterDetails readonly,
	@iExamGradeMasterHeaderID int = null
	--@dtRequestTime datetime=null
	
)
AS
begin transaction
BEGIN TRY 
IF(@iExamGradeMasterHeaderID !=0 )
BEGIN
--update 
UPDATE T_Exam_Grade_Master_Header
set 
 I_School_Group_ID     = @iSchoolGradeID
,I_School_Session_ID   = @iSessionID
,I_Class_ID            = @iClassID
,Dt_CreatedAt          = GETDATE()
,S_CreatedBy           = 1
where 
I_Exam_Grade_Master_Header_ID = @iExamGradeMasterHeaderID
-- delete detils table
DELETE FROM T_Exam_Grade_Master where I_Exam_Grade_Master_Header_ID = @iExamGradeMasterHeaderID
INSERT INTO T_Exam_Grade_Master
(
I_Exam_Grade_Master_Header_ID
,S_Symbol
,S_Name
,I_Lower_Limit
,I_Upper_Limit
,Dt_CreatedBy
,Dt_CreatedAt
)
SELECT  @iExamGradeMasterHeaderID,Symbol,Name,LowerLimit,UpperLimit,1,GETDATE() from @GradeMasterDetails
select 1 StatusFlag,'Exam grade updated succesfully' Message
END
ELSE
BEGIN
INSERT INTO T_Exam_Grade_Master_Header
(
 I_School_Group_ID  
,I_School_Session_ID
,I_Class_ID         
,Dt_CreatedAt       
,S_CreatedBy        
)
VALUES
(
@iSchoolGradeID
,@iSessionID
,@iClassID
,GETDATE()
,1
)
DECLARE @iLastID int
SET @iLastID = SCOPE_IDENTITY()
INSERT INTO T_Exam_Grade_Master
(
I_Exam_Grade_Master_Header_ID
,S_Symbol
,S_Name
,I_Lower_Limit
,I_Upper_Limit
,Dt_CreatedBy
,Dt_CreatedAt
)
SELECT  @iLastID,Symbol,Name,LowerLimit,UpperLimit,1,GETDATE() from @GradeMasterDetails
select 1 StatusFlag,'Exam grade created succesfully' Message
END



END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction
