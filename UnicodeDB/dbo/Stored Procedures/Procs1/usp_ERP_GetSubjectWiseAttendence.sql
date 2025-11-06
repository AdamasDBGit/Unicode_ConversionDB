-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--exec [dbo].[usp_ERP_GetSubjectWiseAttendence] null, null, null, null, null, 4, null

CREATE PROCEDURE [dbo].[usp_ERP_GetSubjectWiseAttendence] 
	-- Add the parameters for the stored procedure here
	(
		@SchoolSessionID INT = NULL,
		@SchoolGroupID INT = NULL,
		@ClassID INT  = NULL,
		@StreamID INT = NULL,  
		@SectionID INT = NULL,
		@SubjectID INT = NULL,
		@StudentErpID nvarchar(100) = NULL
	)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

-- Insert statements for procedure here
	SELECT 
	TSCS.I_Brand_ID AS BrandId,
	TSCS.I_Student_Detail_ID AS StudentID,	
	max(TSCS.S_Student_ID) AS StudentErpID,
	max(ISNULL(TSD.S_First_Name, '') + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' ' + ISNULL(TSD.S_Last_Name, '')) AS StudentName,
	max(TC.S_Class_Name) AS Class,
	TSCS.I_School_Session_ID AS SchoolSectionID,
	TSGC.I_School_Group_ID AS SchoolGroupID,
	TSGC.I_Class_ID AS CLassID,
	--TSM.I_Subject_ID AS SubjectID,
	TSM.S_Subject_Name AS SubjectName,
	COUNT(AED.I_IsPresent) AS TotalClasses,
	SUM(CASE WHEN AED.I_IsPresent = 1 THEN 1 ELSE 0 END) AS Present

 

	FROM 
	T_Student_Class_Section TSCS 
	inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID 
	inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID 
	inner join T_Student_Detail TSD on TSD.I_Student_Detail_ID = TSCS.I_Student_Detail_ID
	left join T_ERP_Attendance_Entry_Detail as AED ON TSCS.I_Student_Detail_ID = AED.I_Student_Detail_ID 
	left join T_ERP_Attendance_Entry_Header TEAEH ON TEAEH.I_Attendance_Entry_Header_ID = AED.I_Attendance_Entry_Header_ID 
	left join T_ERP_Student_Class_Routine TESCR On TESCR.I_Student_Class_Routine_ID = TEAEH.I_Student_Class_Routine_ID
	left join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	left join T_ERP_Routine_Structure_Header  TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID 
		AND TSCS.I_School_Session_ID = TERSH.I_School_Session_ID 
		AND TERSH.I_Class_ID = TSGC.I_Class_ID 
		AND TERSH.I_School_Group_ID = TSGC.I_School_Group_ID
	left join T_Subject_Master TSM ON TESCR.I_Subject_ID = TSM.I_Subject_ID

	WHERE (TSCS.I_School_Session_ID=@SchoolSessionID OR @SchoolSessionID IS NULL) 
	AND (TSCS.I_Stream_ID=@StreamID OR @StreamID IS NULL) 
	AND (TSCS.I_Section_ID=@SectionID OR @SectionID IS NULL) 
	AND (TC.I_Class_ID=@ClassID OR @ClassID IS NULL) 
	AND (TSGC.I_School_Group_ID=@SchoolGroupID OR @SchoolGroupID IS NULL) 
	AND (TSCS.S_Student_ID=@StudentErpID OR @StudentErpID IS NULL) 
	AND (TSM.I_Subject_ID=@SubjectID OR @SubjectID IS NULL)
	GROUP BY TSCS.I_Brand_ID,TSCS.I_Student_Detail_ID, TSCS.I_School_Session_ID, TSGC.I_School_Group_ID,TSGC.I_Class_ID, TSM.I_Subject_ID ,TSM.S_Subject_Name



END
