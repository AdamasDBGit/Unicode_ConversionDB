
CREATE PROCEDURE [dbo].[usp_ERP_GetRoutineHeaderData]
(
@BrandID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT COUNT(TESCRE.R_I_Routine_Structure_Header_ID) AS ExtraClassCount, TERSH.I_Routine_Structure_Header_ID AS I_Routine_Structure_Header_ID
	INTO #TempCount
	FROM T_ERP_Routine_Structure_Header TERSH 
	INNER JOIN [dbo].[T_ERP_Student_Class_Routine_ExtraClass] TESCRE ON TESCRE.R_I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID 
	WHERE TESCRE.Is_Active = 1
	GROUP BY TERSH.I_Routine_Structure_Header_ID

	SELECT COUNT(t3.I_Routine_Structure_Detail_ID) AS ClassMappedCount, t1.I_Routine_Structure_Header_ID AS I_Routine_Structure_Header_ID
	INTO #TempTeacherMapCount
	FROM T_ERP_Routine_Structure_Header t1 
	left JOIN [dbo].T_ERP_Routine_Structure_Detail t2 ON t1.I_Routine_Structure_Header_ID = t2.I_Routine_Structure_Header_ID 
	left join T_ERP_Student_Class_Routine t3 on t3.I_Routine_Structure_Detail_ID=t2.I_Routine_Structure_Detail_ID
	GROUP BY t1.I_Routine_Structure_Header_ID
    -- Insert statements for procedure here
	SELECT 
	TSG.I_Brand_Id BrandID,
	TERSH.I_School_Session_ID AS SchoolSessionID,
	TERSH.I_School_Group_ID AS SchoolGroupID,
	TERSH.I_Class_ID AS ClassID,
	TERSH.I_Stream_ID AS StreamID,
	TERSH.I_Section_ID AS SectionID,
	TERSH.I_Total_Periods AS TotalPeriods,
	TERSH.I_Routine_Structure_Header_ID AS HeaderID,
	TSASM.S_Label AS SchoolSessionName,
	TSG.S_School_Group_Name AS SchoolGroupName,
	TC.S_Class_Name AS ClassName,
	TS1.S_Stream AS StreamName,
	TS2.S_Section_Name AS SectionName,	
	CASE WHEN 
      (SELECT COUNT(*) FROM T_ERP_Routine_Structure_Detail AS TERSD WHERE TERSD.I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID) > 0 THEN 1 ELSE 0 END AS IsRoutineDetailsExists,
	  --CASE WHEN 
      --(SELECT COUNT(*) FROM T_ERP_Student_Class_Routine AS TESCR WHERE TESCR.I_Routine_Structure_Detail_ID = TERSD1.I_Routine_Structure_Detail_ID) > 0 THEN 1 ELSE 0 END AS IsTeacherMapped,
	Temp.ExtraClassCount AS ExtraClassCount,
	TempTeacher.ClassMappedCount AS ClassMappedCount
	
	FROM
	T_ERP_Routine_Structure_Header TERSH
	--INNER JOIN T_ERP_Routine_Structure_Detail TERSD1 on TERSD1.I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID
	INNER JOIN T_School_Academic_Session_Master TSASM ON TERSH.I_School_Session_ID = TSASM.I_School_Session_ID
	INNER JOIN T_School_Group TSG ON TSG.I_School_Group_ID = TERSH.I_School_Group_ID
	INNER JOIN T_Class TC ON TC.I_Class_ID = TERSH.I_Class_ID
	left JOIN T_Stream TS1 ON TS1.I_Stream_ID = TERSH.I_Stream_ID  
	left JOIN T_Section TS2 ON TS2.I_Section_ID = TERSH.I_Section_ID 
	left join #TempCount Temp ON Temp.I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID
	inner join #TempTeacherMapCount TempTeacher on TempTeacher.I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID
	WHERE TSG.I_Brand_Id = @BrandID
	GROUP BY 
	TSG.I_Brand_Id,
	--TERSD1.I_Routine_Structure_Detail_ID,
	TERSH.I_Routine_Structure_Header_ID,
	TERSH.I_School_Session_ID,
	TERSH.I_School_Group_ID,
	TERSH.I_Class_ID,
	TERSH.I_Stream_ID,
	TERSH.I_Section_ID,
	TERSH.I_Total_Periods,
	TSASM.S_Label,
	TSG.S_School_Group_Name,
	TC.S_Class_Name,
	TS1.S_Stream,
	TS2.S_Section_Name,
	Temp.ExtraClassCount,
	TempTeacher.ClassMappedCount

	ORDER BY
	TERSH.I_Routine_Structure_Header_ID DESC;

	DROP TABLE #TempCount;
END

