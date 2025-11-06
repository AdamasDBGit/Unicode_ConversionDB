   
  
CREATE PROCEDURE [dbo].[usp_ERP_GetSessionSchoolGroupClassStreamSectionName] 
(
	@SchoolSessionID INT = NULL,
    @SchoolGroupID INT = NULL,
    @ClassID INT = NULL,
    @StreamID INT = NULL,
    @SectionID INT = NULL,
	@iFacultyID INT = NULL
)
AS
BEGIN
	BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1
	TSASM.S_Label AS SchoolSessionName,
	TSG.S_School_Group_Name AS SchoolGroupName,
	TC.S_Class_Name AS ClassName,
	TS1.S_Stream AS StreamName,
	TS2.S_Section_Name AS SectionName,
	ISNULL(FM.S_Faculty_Name,'NA')+'('+ISNULL(FM.S_Faculty_Code,'-')+')' as FacultyName
	

	FROM
	T_ERP_Routine_Structure_Header TERSH
	INNER JOIN T_School_Academic_Session_Master TSASM ON TERSH.I_School_Session_ID = TSASM.I_School_Session_ID
	INNER JOIN T_School_Group TSG ON TSG.I_School_Group_ID = TERSH.I_School_Group_ID
	INNER JOIN T_Class TC ON TC.I_Class_ID = TERSH.I_Class_ID
	left JOIN T_Stream TS1 ON TS1.I_Stream_ID = TERSH.I_Stream_ID  
	left JOIN T_Section TS2 ON TS2.I_Section_ID = TERSH.I_Section_ID 
	left JOIN T_Faculty_Master as FM on FM.I_Faculty_Master_ID=TERSH.I_FacultyClassTeacher

	WHERE
	(TSASM.I_School_Session_ID = @SchoolSessionID OR @SchoolSessionID IS NULL) 
	AND (TSG.I_School_Group_ID = @SchoolGroupID OR @SchoolGroupID IS NULL)
	AND (TC.I_Class_ID = @ClassID OR @ClassID IS NULL) 
	AND (TS1.I_Stream_ID = @StreamID OR @StreamID IS NULL) 
	AND (TS2.I_Section_ID = @SectionID OR @SectionID IS NULL) 
	--AND (FM.I_Faculty_Master_ID = @iFacultyID OR @iFacultyID IS NULL)
	GROUP BY 
	TSASM.S_Label,
	TSG.S_School_Group_Name,
	TC.S_Class_Name,
	TS1.S_Stream,
	TS2.S_Section_Name,
	FM.S_Faculty_Name,
	FM.S_Faculty_Code


	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int

		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		select 0 StatusFlag,@ErrMsg Message
	END CATCH
END


