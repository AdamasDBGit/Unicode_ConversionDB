
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- exec [dbo].[usp_ERP_GetStudentByRoutineStructureDetailID] 325,'2024-03-11'
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetStudentByRoutineStructureDetailID_BKP_2024Sept]
	-- Add the parameters for the stored procedure here
	(
		@StudentClassRoutineID INT = NULL,
		@Date datetime=null
		--@FacultyID INT = NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	TESCR.I_Student_Class_Routine_ID AS ClassRoutineID,
	TERSD.I_Routine_Structure_Detail_ID AS RoutineStructureDetailID,
	TERSH.I_Routine_Structure_Header_ID AS RoutineStructureHeaderID,
	--TERSH.I_Class_ID
	TSGC.I_School_Group_Class_ID AS SchoolGroupClassID,
	TSCS.I_Student_Detail_ID AS StudentDetailID,
	ISNULL(TSD.S_First_Name,'')+' '+ISNULL(TSD.S_Middle_Name,'')+' '+ISNULL(TSD.S_Last_Name,'') AS StudentName,
	TSCS.S_Class_Roll_No AS StudentRollNo,
	TSD.S_Student_ID AS StudentID,
	ISNULL(TEAED.I_IsPresent, 0) AS IsPresent 


	FROM T_ERP_Student_Class_Routine TESCR
	inner join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	inner join T_ERP_Routine_Structure_Header TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID
	inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_ID = TERSH.I_School_Group_ID
	inner join T_School_Group TSG ON TSG.I_School_Group_ID = TSGC.I_School_Group_ID
	inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID and TC.I_Class_ID=TERSH.I_Class_ID
	inner join T_Student_Class_Section TSCS ON TSCS.I_School_Session_ID = TERSH.I_School_Session_ID AND TSCS.I_School_Group_Class_ID = TSGC.I_School_Group_Class_ID --AND (TSCS.I_Section_ID = TERSH.I_Section_ID OR TSCS.I_Section_ID is null)-- AND (TSCS.I_Stream_ID = TERSH.I_Stream_ID OR TSCS.I_Stream_ID is null)
	AND ((TSCS.I_Section_ID = TERSH.I_Section_ID) OR (TSCS.I_Section_ID IS NULL AND TERSH.I_Section_ID IS NULL))
	AND ((TSCS.I_Stream_ID = TERSH.I_Stream_ID) OR (TSCS.I_Stream_ID IS NULL AND TERSH.I_Stream_ID IS NULL))
	inner join T_Student_Detail TSD ON TSD.I_Student_Detail_ID = TSCS.I_Student_Detail_ID
	left join T_ERP_Student_Subject TESS ON TESS.I_Subject_ID = TESCR.I_Subject_ID and TSD.I_Student_Detail_ID=TESS.I_Student_Detail_ID
	left join T_ERP_Attendance_Entry_Header TEAEH ON TEAEH.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID and CAST(TEAEH.Dt_Date AS DATE) = CAST(@Date AS DATE)-- DATE(TEAEH.Dt_CreatedAt)=@Date
	left join T_ERP_Attendance_Entry_Detail TEAED ON TEAED.I_Student_Detail_ID = TSCS.I_Student_Detail_ID and TEAEH.I_Attendance_Entry_Header_ID = TEAED.I_Attendance_Entry_Header_ID

	WHERE (TESCR.I_Student_Class_Routine_ID = @StudentClassRoutineID)  
END
