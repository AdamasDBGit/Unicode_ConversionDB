CREATE PROCEDURE [dbo].[usp_ERP_getStudentInformationList]
	@brandid INT,
	@Session INT,
	@SchoolGroup INT,
	@class INT,
	@section INT = NULL,
	@stream INT = NULL,
	@StudentID NVARCHAR(MAX) = NULL,
	@StudentName NVARCHAR(MAX) = NULL,
	@Limit INT,
    @Offset INT,
    @SortCol INT,
    @SortDir NVARCHAR(MAX),
    @Search NVARCHAR(MAX) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TotalRecords INT, @FilteredRecords INT;

	-- Total Records
	SELECT @TotalRecords = COUNT(*)
	FROM [dbo].[T_Student_Detail] AS SD
	JOIN [dbo].[T_Student_Class_Section] AS SCS ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID
	INNER JOIN [dbo].[T_School_Group_Class] AS SGC ON SCS.I_School_Group_Class_ID = SGC.I_School_Group_Class_ID
	INNER JOIN [dbo].[T_School_Group] AS SG ON SGC.I_School_Group_ID = SG.I_School_Group_ID
	INNER JOIN [dbo].[T_Class] AS TC ON TC.I_Class_ID = SGC.I_Class_ID
	WHERE SCS.I_Brand_ID = @brandid
	  AND (SGC.I_School_Group_ID = @SchoolGroup OR @SchoolGroup IS NULL)
	  AND (SGC.I_Class_ID = @class OR @class IS NULL)
	  AND (SCS.I_Section_ID = @section OR @section IS NULL)
	  AND (SCS.I_Stream_ID = @stream OR @stream IS NULL)
	  AND SCS.I_School_Session_ID = @Session
	  AND SD.I_Status = 1;

	-- Filtered Records
	SELECT @FilteredRecords = COUNT(*)
	FROM (
		SELECT SD.I_Student_Detail_ID
		FROM [dbo].[T_Student_Detail] AS SD
		JOIN [dbo].[T_Student_Class_Section] AS SCS ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID
		INNER JOIN [dbo].[T_School_Group_Class] AS SGC ON SCS.I_School_Group_Class_ID = SGC.I_School_Group_Class_ID
		INNER JOIN [dbo].[T_School_Group] AS SG ON SGC.I_School_Group_ID = SG.I_School_Group_ID
		INNER JOIN [dbo].[T_Class] AS TC ON TC.I_Class_ID = SGC.I_Class_ID
		WHERE SCS.I_Brand_ID = @brandid
		  AND (SGC.I_School_Group_ID = @SchoolGroup OR @SchoolGroup IS NULL)
		  AND (SGC.I_Class_ID = @class OR @class IS NULL)
		  AND (SCS.I_Section_ID = @section OR @section IS NULL)
		  AND (SCS.I_Stream_ID = @stream OR @stream IS NULL)
		  AND SCS.I_School_Session_ID = @Session
		  AND SD.I_Status = 1
		  AND (
			  @StudentName IS NULL OR
			  LTRIM(RTRIM(REPLACE(REPLACE(
				  SD.S_First_Name +
				  CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END +
				  CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END,
				  '  ', ' '
			  ), '  ', ' '))) LIKE '%' + LTRIM(RTRIM(REPLACE(REPLACE(@StudentName, '  ', ' '), '  ', ' '))) + '%'
		  )
		  AND (@StudentID IS NULL OR SD.S_Student_ID LIKE '%' + @StudentID + '%')
		  AND (
			  @Search IS NULL OR
			  SD.S_Student_ID LIKE '%' + @Search + '%' OR
			  SD.S_First_Name LIKE '%' + @Search + '%' OR
			  SD.S_Middle_Name LIKE '%' + @Search + '%' OR
			  SD.S_Last_Name LIKE '%' + @Search + '%' OR
			  SCS.S_Class_Roll_No LIKE '%' + @Search + '%' OR
			  SD.S_Mobile_No LIKE '%' + @Search + '%'
		  )
	) AS CountedRecords;

	-- Final Data
	SELECT
		SD.S_Student_ID AS StudentID,
		ERD.S_Enquiry_No AS EnquiryNo,
		SD.I_Student_Detail_ID AS StudentDetailID,
		CONCAT(
			SD.S_First_Name,
			CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END,
			CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END
		) AS FullName,
		TC.S_Class_Name AS Class,
		SCS.S_Class_Roll_No AS RollNo,
		SD.S_Mobile_No AS MobileNo,
		SD.I_Status AS StudentStatus,
		@TotalRecords AS TotalRecords,
		@FilteredRecords AS FilteredRecords,
		SG.S_School_Group_Name SchoolGroup,
		TS.S_Section_Name SectionName,

		SCS.I_Status AS Status
	FROM [dbo].[T_Student_Detail] AS SD
	JOIN [dbo].[T_Student_Class_Section] AS SCS ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID
	INNER JOIN [dbo].[T_School_Group_Class] AS SGC ON SCS.I_School_Group_Class_ID = SGC.I_School_Group_Class_ID
	INNER JOIN [dbo].[T_School_Group] AS SG ON SGC.I_School_Group_ID = SG.I_School_Group_ID
	INNER JOIN [dbo].[T_Class] AS TC ON TC.I_Class_ID = SGC.I_Class_ID
	LEFT JOIN [dbo].[T_Enquiry_Regn_Detail] AS ERD ON ERD.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID
	LEFT JOIN T_Section TS ON TS.I_Section_ID=SCS.I_Section_ID
	WHERE SCS.I_Brand_ID = @brandid
	  AND (SGC.I_School_Group_ID = @SchoolGroup OR @SchoolGroup IS NULL)
	  AND (SGC.I_Class_ID = @class OR @class IS NULL)
	  AND (SCS.I_Section_ID = @section OR @section IS NULL)
	  AND (SCS.I_Stream_ID = @stream OR @stream IS NULL)
	  AND SCS.I_School_Session_ID = @Session
	  AND SD.I_Status = 1
	  AND (
		  @StudentName IS NULL OR
		  LTRIM(RTRIM(REPLACE(REPLACE(
			  SD.S_First_Name +
			  CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END +
			  CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END,
			  '  ', ' '
		  ), '  ', ' '))) LIKE '%' + LTRIM(RTRIM(REPLACE(REPLACE(@StudentName, '  ', ' '), '  ', ' '))) + '%'
	  )
	  AND (@StudentID IS NULL OR SD.S_Student_ID LIKE '%' + @StudentID + '%')
	  AND (
		  @Search IS NULL OR
		  SD.S_Student_ID LIKE '%' + @Search + '%' OR
		  SD.S_First_Name LIKE '%' + @Search + '%' OR
		  SD.S_Middle_Name LIKE '%' + @Search + '%' OR
		  SD.S_Last_Name LIKE '%' + @Search + '%' OR
		  SCS.S_Class_Roll_No LIKE '%' + @Search + '%' OR
		  SD.S_Mobile_No LIKE '%' + @Search + '%'
	  )
	ORDER BY
		CASE WHEN @SortCol = 0 AND @SortDir = 'asc' THEN SD.S_Student_ID END ASC,
		CASE WHEN @SortCol = 0 AND @SortDir = 'desc' THEN SD.S_Student_ID END DESC,
		CASE WHEN @SortCol = 1 AND @SortDir = 'asc' THEN
			CONCAT(
				SD.S_First_Name,
				CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END,
				CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END
			)
		END ASC,
		CASE WHEN @SortCol = 1 AND @SortDir = 'desc' THEN
			CONCAT(
				SD.S_First_Name,
				CASE WHEN SD.S_Middle_Name IS NULL OR LTRIM(RTRIM(SD.S_Middle_Name)) = '' THEN '' ELSE ' ' + SD.S_Middle_Name END,
				CASE WHEN SD.S_Last_Name IS NULL OR LTRIM(RTRIM(SD.S_Last_Name)) = '' THEN '' ELSE ' ' + SD.S_Last_Name END
			)
		END DESC,
		CASE WHEN @SortCol = 3 AND @SortDir = 'asc' THEN SCS.S_Class_Roll_No END ASC,
		CASE WHEN @SortCol = 3 AND @SortDir = 'desc' THEN SCS.S_Class_Roll_No END DESC,
		CASE WHEN @SortCol = 4 AND @SortDir = 'asc' THEN SD.S_Mobile_No END ASC,
		CASE WHEN @SortCol = 4 AND @SortDir = 'desc' THEN SD.S_Mobile_No END DESC
	OFFSET @Offset ROWS
	FETCH NEXT @Limit ROWS ONLY;
END
