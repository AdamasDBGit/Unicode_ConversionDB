-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-Sept-13>
-- Description:	<Get Subject Group status for another Section>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetPeriodSubjectWiseMappedSubjectPeriod]
	-- Add the parameters for the stored procedure here
	@iRoutineStructureDetailID INT,
	@iSubjectGroupID INT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @iAcademicSession INT,@iSchoolGroup INT,@iClassID INT,@iStreamID INT,@iPeriod INT,@StartSlot time,@endSlot time,@DayID INT

	select TOP 1 @iAcademicSession=RSH.I_School_Session_ID,@iSchoolGroup=RSH.I_School_Group_ID,@iClassID=RSH.I_Class_ID
	,@iStreamID=RSH.I_Stream_ID,@iPeriod=RSD.I_Period_No,@StartSlot=RSD.T_FromSlot,@endSlot=RSD.T_ToSlot
	,@DayID=RSD.I_Day_ID
	from T_ERP_Routine_Structure_Detail as RSD
	inner join
	T_ERP_Routine_Structure_Header as RSH on RSD.I_Routine_Structure_Header_ID=RSH.I_Routine_Structure_Header_ID
	where RSD.I_Routine_Structure_Detail_ID=@iRoutineStructureDetailID


	print @iStreamID

	print @iPeriod

	print @StartSlot

	print @endSlot

	select DISTINCT
	SM.I_Subject_ID as SubjectID,SM.SubjectGroupID,SM.S_Subject_Name as SubjectName,
	CASE WHEN SM.SubjectGroupID IS NULL THEN 'false'
	ELSE 'true' END as GroupedSubject,
	CASE WHEN ExistingMappedSubjects.MappedSubjectID IS NULL THEN 'true'
	ELSE 'false' END as Ischooseable,
	ExistingMappedSubjects.*
	from T_Subject_Master as SM 
	left join
	(
	select 
	SCR.I_Subject_ID as MappedSubjectID,
	SCR.I_Faculty_Master_ID as MappedFacultyMaster,
	FM.S_Faculty_Name as MappedFacultyName,
	SCR.SubjectGroupID  MappedSubjectGroupID
	from 
	T_ERP_Routine_Structure_Header as RSH
	inner join
	T_ERP_Routine_Structure_Detail as RSD  on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	inner join
	T_ERP_Student_Class_Routine as SCR on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	inner join
	T_Faculty_Master as FM on SCR.I_Faculty_Master_ID=FM.I_Faculty_Master_ID
	where ISNULL(SCR.SubjectGroupID,0)=@iSubjectGroupID
	and RSH.I_School_Session_ID= @iAcademicSession AND RSH.I_School_Group_ID = @iSchoolGroup AND 
	RSH.I_Class_ID = @iClassID and ISNULL(RSH.I_Stream_ID,0) =ISNULL(@iStreamID,0) and RSD.I_Day_ID=@DayID
	and (@iPeriod=RSD.I_Period_No AND (RSD.T_FromSlot= @StartSlot and RSD.T_ToSlot =  @endSlot)))

	as ExistingMappedSubjects on SM.I_Subject_ID=ExistingMappedSubjects.MappedSubjectID 
	and ExistingMappedSubjects.MappedSubjectGroupID=SM.SubjectGroupID
	where ISNULL(SM.SubjectGroupID,0)=ISNULL(@iSubjectGroupID,0)
	and 
	SM.I_School_Group_ID = @iSchoolGroup AND 
	SM.I_Class_ID = @iClassID and ISNULL(SM.I_Stream_ID,0) =ISNULL(@iStreamID,0)





END
