CREATE PROCEDURE [dbo].[MapMethodologyActivitySubject]
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 30-09-2023
-- Description:	To Map Methodology Activity with Subject
-- =============================================
-- Add the parameters for the stored procedure here
@SubjectID int,
@MethodologyActivityID int ,
@CreatedBy int



AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	Declare @S int , @MA int
	Set @S=(select I_Subject_ID from T_Subject_Master where I_Subject_ID=@SubjectID)
	set @MA=(select I_Methodology_Activity_ID from T_ERP_Methodology_Activity where 
	            I_Methodology_Activity_ID=@MethodologyActivityID)
    
	If @SubjectID=@S and @MethodologyActivityID=@MA

	insert into T_ERP_Methodology_Activity_Subject_ID
	 (I_Subject_ID,I_Methodology_Activity_ID,I_CreatedBy,Dt_CreatedAt)
	 values 
	 (@SubjectID,@MethodologyActivityID,@CreatedBy,SYSDATETIME() )
	 If @@ROWCOUNT!=0

     select 1 Index_no,'Activity Mapped with Subject Successfully' Message
	 
	 else
	 select 1 Index_no,'Activity Mapped with Subject Unsuccessfully Due to Wrong Subject or Activity Choosen ' Message
	 




END
