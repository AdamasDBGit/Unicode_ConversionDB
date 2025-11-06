
CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectMappedWithTemplateStructure] 
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@iSubject INT=NULL
	,@iUserID INT=NULL
	,@iSchoolGroup INT=NULL
	,@iClass INT = NULL
	,@iAcademicSession INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 select 
	 SM.I_Subject_ID as SubjectID
	 ,SM.S_Subject_Code as SubjectCode
	 ,SM.S_Subject_Name as SubjectName
	 ,CASE 
	 WHEN ISNULL(Routine.No_Current_Year_Routine_Created,0) > 0 THEN 1
	 ELSE 0 
	 END as ISCurrentSessionRoutineCreated
	 ,CASE 
	 WHEN ISNULL(CompleteSubjectStructure.No_Of_Complete_Subject_Structure,0) > 0 THEN 1
	 ELSE 0
	 END as ISSubjectStructureCompleted 
	 from T_Subject_Master as SM
	inner join
	( select count(*) as No_Current_Year_Routine_Created,ESCR.I_Subject_ID from 
	T_ERP_Student_Class_Routine as ESCR
	inner join
	T_ERP_Routine_Structure_Detail as ERSD on ERSD.I_Routine_Structure_Detail_ID=ESCR.I_Routine_Structure_Detail_ID 
	inner join
	T_ERP_Routine_Structure_Header as ERSH on ERSH.I_Routine_Structure_Header_ID=ERSD.I_Routine_Structure_Header_ID
	inner join
	T_School_Academic_Session_Master as SASM on SASM.I_School_Session_ID=ERSH.I_School_Session_ID
	where 
	SASM.I_School_Session_ID=ISNULL(@iAcademicSession,SASM.I_School_Session_ID)
	--CONVERT(DATE,SASM.Dt_Session_Start_Date) <= CONVERT(DATE,GETDATE()) and CONVERT(DATE,SASM.Dt_Session_End_Date) >= CONVERT(DATE,GETDATE())
	and SASM.I_Brand_ID=@iBrandID
	group by ESCR.I_Subject_ID
	) as Routine on Routine.I_Subject_ID=SM.I_Subject_ID
	inner join
	(
	select count(*) as No_Of_Complete_Subject_Structure ,ESSH.I_Subject_ID from 
	T_ERP_Subject_Template_Header as ESTH
	inner join
	T_ERP_Subject_Template as EST on EST.I_Subject_Template_Header_ID=ESTH.I_Subject_Template_Header_ID
	inner join
	T_ERP_Subject_Structure_Header as ESSH on ESSH.I_Subject_Template_Header_ID=EST.I_Subject_Template_Header_ID
	inner join
	T_ERP_Subject_Structure as ESS on ESS.I_Subject_Structure_Header_ID=ESSH.I_Subject_Structure_Header_ID and ESS.I_Subject_Template_ID=EST.I_Subject_Template_ID
	where ESTH.I_Brand_ID=@iBrandID and EST.I_IsLeaf_Node=1
	group by ESSH.I_Subject_ID
	) as CompleteSubjectStructure on CompleteSubjectStructure.I_Subject_ID=SM.I_Subject_ID
	inner join
	T_School_Group as SG on SG.I_School_Group_ID=SM.I_School_Group_ID and SG.I_Status=1
	inner join
	T_Class as TC on TC.I_Class_ID=SM.I_Class_ID and TC.I_Status=1
	where SM.I_Brand_ID=@iBrandID 
	and SG.I_School_Group_ID=ISNULL(@iSchoolGroup,SG.I_School_Group_ID) 
	and TC.I_Class_ID=ISNULL(@iClass,TC.I_Class_ID)
	and SM.I_Subject_ID= ISNULL(@iSubject,SM.I_Subject_ID)
	and SM.I_Status=1





END

