
CREATE PROCEDURE [dbo].[uspHoldResultUpdate]
(
	@iStudentResultID int = null
)
AS

BEGIN TRY 

  UPDATE T_Student_Result 
  SET I_IsHold =
 ( CASE  
WHEN (I_IsHold = 0) THEN 1
WHEN (I_IsHold = 1) THEN 0 
ELSE  (I_IsHold)
END)
where I_Student_Result_ID = @iStudentResultID
select 1 as StatusFlag,'Updated successfully' as Message
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
