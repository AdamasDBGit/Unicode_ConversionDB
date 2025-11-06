-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_Verify_Access_Token_For_Payment]
	-- Add the parameters for the stored procedure here
	@stokenID nvarchar(max)
AS
BEGIN
	
	BEGIN TRY
	IF EXISTS (select * from T_Parent_Master PM where PM.S_Token=@stokenID and I_Status=1)
	BEGIN

		select distinct SD.S_Student_ID as StudentID,SPM.I_Brand_ID BrandID,PM.S_Mobile_No as MobileNo from T_Parent_Master as PM 
		inner join
		T_Student_Parent_Maps as SPM on PM.I_Parent_Master_ID=SPM.I_Parent_Master_ID and SPM.I_Status=1
		inner join
		T_Student_Detail as SD on SD.I_Student_Detail_ID=SPM.I_Student_Detail_ID and SD.I_Status=1
		where PM.S_Token=@stokenID and PM.I_Status=1

	END
    ELSE
	BEGIN

		 RAISERROR ('Invalid Token', 11,1);

	END

	
	END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    -- Use RAISERROR inside the CATCH block to return error
    -- information about the original error that caused
    -- execution to jump to the CATCH block.
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
END CATCH;


END
