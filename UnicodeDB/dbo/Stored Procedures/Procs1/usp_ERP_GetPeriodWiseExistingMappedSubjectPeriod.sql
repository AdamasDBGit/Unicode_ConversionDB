-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-Sept-13>
-- Description:	<Get Subject Group status for another Section>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetPeriodWiseExistingMappedSubjectPeriod]
	-- Add the parameters for the stored procedure here
	@iRoutineStructureDetailID INT,
	@iSubjectGroupID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @iAcademicSession INT,@iSchoolGroup INT,@iClassID INT,@iStreamID INT,@iPeriod INT,@StartSlot time,@endSlot time

	select TOP 1 @iAcademicSession=RSH.I_School_Session_ID,@iSchoolGroup=RSH.I_School_Group_ID,@iClassID=RSH.I_Class_ID
	,@iStreamID=RSH.I_Stream_ID,@iPeriod=RSD.I_Period_No,@StartSlot=RSD.T_FromSlot,@endSlot=RSD.T_ToSlot
	
	from T_ERP_Routine_Structure_Detail as RSD
	inner join
	T_ERP_Routine_Structure_Header as RSH on RSD.I_Routine_Structure_Header_ID=RSH.I_Routine_Structure_Header_ID
	where RSD.I_Routine_Structure_Detail_ID=@iRoutineStructureDetailID



	select 
	SCR.I_Subject_ID as SubjectID,
	SCR.I_Faculty_Master_ID as FacultyMaster,
	SCR.SubjectGroupID 
	from 
	T_ERP_Routine_Structure_Header as RSH
	inner join
	T_ERP_Routine_Structure_Detail as RSD  on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	inner join
	T_ERP_Student_Class_Routine as SCR on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	where ISNULL(SCR.SubjectGroupID,0)=@iSubjectGroupID
	and RSH.I_School_Session_ID= @iAcademicSession AND RSH.I_School_Group_ID = @iSchoolGroup AND 
	RSH.I_Class_ID = @iClassID and ISNULL(RSH.I_Stream_ID,0) =ISNULL(@iStreamID,0)
	and (@iPeriod=RSD.I_Period_No OR (RSD.T_FromSlot= @StartSlot and RSD.T_ToSlot =  @endSlot))





END
