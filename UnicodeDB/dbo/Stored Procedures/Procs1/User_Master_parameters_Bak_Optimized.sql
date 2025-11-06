
--EXEC [User_Master_parameters_Mod] NULL,NULL,NUll,NUll,Null,NUll,NUll,107,0,10,'S_Username','asc',NULL

CReate PROCEDURE [dbo].[User_Master_parameters_Bak_Optimized]
(
	@User_ID INT = NULL,  
	@Username NVARCHAR(MAX) = NULL,  
	@Email NVARCHAR(MAX) = NULL,  
	@Name NVARCHAR(MAX) = NULL,    
	@Mobile NVARCHAR(MAX) = NULL,  
	@Status INT = NULL,
	@isTeacher BIT = NULL,
	@iBrandID INT = NULL,

	@Offset INT = 0,
	@Limit INT = 10,
	@SortColumn NVARCHAR(MAX) = 'S_Username',
	@SortDirection NVARCHAR(MAX) = 'asc',
	@SearchValue NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	WITH BaseUser AS (
		SELECT 
			EU.I_User_ID,
			EU.S_Username,
			EU.S_Password,
			EU.S_Email,
			EU.S_First_Name,
			EU.S_Middle_Name,
			EU.S_Last_Name,
			EU.S_Mobile,
			EU.I_Status,
			EU.I_Created_By,
			EU.Dt_CreatedAt,
			EU.Dt_Last_Login,
			EU.unUserId,
			ISNULL(EUB.Is_Teaching_Staff, 'false') AS IsTeachingfaculty,
			UP.S_EMP_Code,
			FM.I_Faculty_Master_ID,
			FM.S_Faculty_Code,
			FM.S_Faculty_Name,
			UGM.User_Group_ID,
			UGM.S_User_GroupName,
			FullName = LTRIM(RTRIM(CONCAT(ISNULL(EU.S_First_Name, ''), ' ', ISNULL(EU.S_Middle_Name, ''), ' ', ISNULL(EU.S_Last_Name, '')))),
			TotalCount = COUNT(*) OVER()
		FROM T_ERP_User AS EU
		INNER JOIN T_ERP_User_Brand AS EUB 
			ON EU.I_User_ID = EUB.I_User_ID 
			AND EUB.I_Brand_ID = @iBrandID 
			AND EUB.Is_Active = 1
		LEFT JOIN T_User_Profile AS UP 
			ON EU.I_User_ID = UP.I_User_ID 
			AND UP.I_Status = 1 
		LEFT JOIN T_Faculty_Master AS FM 
			ON FM.I_User_ID = UP.I_User_ID 
			AND FM.I_Status = 1
		LEFT JOIN (
			SELECT 
				URPM.I_User_Id, 
				User_Group_ID = STUFF((SELECT DISTINCT ', ' + CONVERT(VARCHAR, UR2.User_Group_ID)
					FROM T_ERP_Users_Role_Permission_Map UR2
					INNER JOIN T_ERP_User_Group_Master UGM2 
						ON UR2.User_Group_ID = UGM2.I_User_Group_Master_ID 
						AND UGM2.Is_Active = 1
					WHERE UR2.I_User_Id = URPM.I_User_Id 
						AND UR2.Is_Active = 1 
						AND UR2.Brand_ID = @iBrandID
					FOR XML PATH('')), 1, 2, ''),
				S_User_GroupName = STUFF((SELECT DISTINCT ', ' + UGM2.S_User_GroupName
					FROM T_ERP_Users_Role_Permission_Map UR2
					INNER JOIN T_ERP_User_Group_Master UGM2 
						ON UR2.User_Group_ID = UGM2.I_User_Group_Master_ID 
						AND UGM2.Is_Active = 1
					WHERE UR2.I_User_Id = URPM.I_User_Id 
						AND UR2.Is_Active = 1 
						AND UR2.Brand_ID = @iBrandID
					FOR XML PATH('')), 1, 2, '')
			FROM T_ERP_Users_Role_Permission_Map URPM
			WHERE URPM.Is_Active = 1 
				AND URPM.Brand_ID = @iBrandID
			GROUP BY URPM.I_User_Id
		) UGM ON UGM.I_User_Id = EU.I_User_ID
		WHERE 
			(@User_ID IS NULL OR EU.I_User_ID = @User_ID)
			AND (@Username IS NULL OR EU.S_Username = @Username)
			AND (@Email IS NULL OR EU.S_Email = @Email)
			AND (@Name IS NULL OR LTRIM(RTRIM(CONCAT(ISNULL(EU.S_First_Name, ''), ' ', ISNULL(EU.S_Middle_Name, ''), ' ', ISNULL(EU.S_Last_Name, '')))) LIKE '%' + @Name + '%')
			AND (@Mobile IS NULL OR EU.S_Mobile = @Mobile)
			AND (@Status IS NULL OR EU.I_Status = @Status)
			AND (ISNULL(EUB.Is_Teaching_Staff, 'false') = ISNULL(@isTeacher, ISNULL(EUB.Is_Teaching_Staff, 'false')))
			AND EU.I_Status = 1 
			AND ISNULL(EU.Is_Active_Ignore_Allowed, 'false') = 'false'
			AND (
				@SearchValue IS NULL OR
				EU.S_Username LIKE '%' + @SearchValue + '%' OR
				EU.S_Email LIKE '%' + @SearchValue + '%' OR
				EU.S_Mobile LIKE '%' + @SearchValue + '%' OR
				LTRIM(RTRIM(CONCAT(ISNULL(EU.S_First_Name, ''), ' ', ISNULL(EU.S_Middle_Name, ''), ' ', ISNULL(EU.S_Last_Name, '')))) LIKE '%' + @SearchValue + '%'
			)
	)
	SELECT I_User_ID as ID,S_Username as Username,S_Password as Password,
	S_Email as Email,S_First_Name as First_Name,S_Middle_Name as Middle_Name,
	S_Last_Name as Last_Name,FullName as Name,S_Mobile as Mobile_No,I_Status as Status
	,I_Created_By as CrtdBy,Dt_CreatedAt as CrtdOn,Dt_Last_Login as Last_Login,IsTeachingfaculty as IsTeachingfaculty
	,I_Faculty_Master_ID as FacultyMasterID,
	S_EMP_Code as EmployeeCode,S_Faculty_Code as FacultyCode,S_Faculty_Name as FacultyName
	,User_Group_ID as UserGroupID,S_User_GroupName as UserGroupName,unUserId as unUserId
	,TotalCount as unUserId
	
	FROM (
		SELECT *,
			ROW_NUMBER() OVER (
				ORDER BY
					CASE 
						WHEN @SortColumn = 'S_Username' AND @SortDirection = 'asc' THEN S_Username 
					END ASC,
					CASE 
						WHEN @SortColumn = 'S_Username' AND @SortDirection = 'desc' THEN S_Username 
					END DESC,
					CASE 
						WHEN @SortColumn = 'Name' AND @SortDirection = 'asc' THEN FullName 
					END ASC,
					CASE 
						WHEN @SortColumn = 'Name' AND @SortDirection = 'desc' THEN FullName 
					END DESC,
					CASE 
						WHEN @SortColumn = 'Email' AND @SortDirection = 'asc' THEN S_Email 
					END ASC,
					CASE 
						WHEN @SortColumn = 'Email' AND @SortDirection = 'desc' THEN S_Email 
					END DESC,
					CASE 
						WHEN @SortColumn = 'Mobile_No' AND @SortDirection = 'asc' THEN S_Mobile 
					END ASC,
					CASE 
						WHEN @SortColumn = 'Mobile_No' AND @SortDirection = 'desc' THEN S_Mobile 
					END DESC,
					CASE 
						WHEN @SortColumn = 'Status' AND @SortDirection = 'asc' THEN CAST(I_Status AS VARCHAR) 
					END ASC,
					CASE 
						WHEN @SortColumn = 'Status' AND @SortDirection = 'desc' THEN CAST(I_Status AS VARCHAR) 
					END DESC
			) AS RowNum
		FROM BaseUser
	) Paged
	WHERE RowNum BETWEEN @Offset + 1 AND @Offset + @Limit;

END

