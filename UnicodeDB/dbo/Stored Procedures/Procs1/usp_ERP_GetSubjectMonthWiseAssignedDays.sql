-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Nov-14>
-- Description:	<Get Days/Class Assign for the subject and month>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectMonthWiseAssignedDays] 
	-- Add the parameters for the stored procedure here
	@iBrandID int,
	@iSubject int,
	@iMonthNo int=NULL
	,@iSchoolGroup INT=NULL
	,@iClass INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 select DISTINCT
	 SM.I_Subject_ID as SubjectID
	,SM.S_Subject_Name as SubjectName
	,subjectStructurePlan.I_Month_No as MonthNo
	,subjectStructurePlan.I_Day_No as DayNo
	 from 
	T_Subject_Master as SM 
	inner join
	T_School_Group as SG on SG.I_School_Group_ID=SM.I_School_Group_ID and SG.I_Status=1
	inner join
	T_Class as TC on TC.I_Class_ID=SM.I_Class_ID and TC.I_Status=1
	left join
	(
		select SSP.*,SSPD.I_Subject_Structure_Plan_Detail_ID,SSPD.I_Subject_Structure_ID,ESS.S_Name  from 
		T_ERP_Subject_Structure_Plan as SSP 
		inner join
		T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
		inner join
		T_ERP_Subject_Structure as ESS on ESS.I_Subject_Structure_ID=SSPD.I_Subject_Structure_ID
		inner join
		T_ERP_Subject_Structure_Header as ESSH on ESSH.I_Subject_Structure_Header_ID=ESS.I_Subject_Structure_Header_ID
		inner join
		T_ERP_Subject_Template_Header as ESTH on ESTH.I_Subject_Template_Header_ID=ESSH.I_Subject_Template_Header_ID
		inner join
		T_ERP_Subject_Template as EST on EST.I_Subject_Template_Header_ID=ESTH.I_Subject_Template_Header_ID
		and EST.I_Subject_Template_ID=ESS.I_Subject_Template_ID
		where SSP.I_Month_No=ISNULL(@iMonthNo,SSP.I_Month_No)
	) as subjectStructurePlan on subjectStructurePlan.I_Subject_ID=SM.I_Subject_ID
	where SM.I_Brand_ID=@iBrandID 
	and SG.I_School_Group_ID=ISNULL(@iSchoolGroup,SG.I_School_Group_ID) 
	and TC.I_Class_ID=ISNULL(@iClass,TC.I_Class_ID)
	and SM.I_Subject_ID= ISNULL(@iSubject,SM.I_Subject_ID)
	and SM.I_Status=1
	and subjectStructurePlan.I_Month_No IS NOT NULL

END
