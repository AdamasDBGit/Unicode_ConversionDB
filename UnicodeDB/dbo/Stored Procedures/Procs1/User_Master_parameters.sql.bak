CREATE   PROCEDURE [dbo].[User_Master_parameters]    
(   
 @User_ID INT = NULL,     
 @Username NVARCHAR(MAX) = NULL,     
 @Email NVARCHAR(MAX) = NULL,     
 @Name NVARCHAR(MAX) = NULL,       
 @Mobile NVARCHAR(MAX) = NULL,     
 @Status INT = NULL,   
 @isTeacher BIT = NULL,   
 @iBrandID INT = NULL,    @Offset INT = 0,   
 @Limit INT = 10,   
 @SortColumn NVARCHAR(MAX) = 'S_Username',   
 @SortDirection NVARCHAR(MAX) = 'asc',   
 @SearchValue NVARCHAR(MAX) = NULL   
)   
AS   
BEGIN   
 SET NOCOUNT ON;    WITH UserData AS (   
  SELECT    
   EU.I_User_ID AS ID,   
   S_Username AS Username,   
   S_Password AS Password,   
   EU.S_Email AS Email,   
   S_First_Name AS First_Name,   
   S_Middle_Name AS Middle_Name,   
   S_Last_Name AS Last_Name,   
   ISNULL(S_First_Name,'') + ' ' + ISNULL(S_Middle_Name,'') + ' ' + ISNULL(S_Last_Name,'') AS Name,   
   S_Mobile AS Mobile_No,   
   EU.I_Status AS Status,   
   EU.I_Created_By AS CrtdBy,   
   EU.Dt_CreatedAt AS CrtdOn,   
   EU.Dt_Last_Login AS Last_Login,   
   ISNULL(EUB.Is_Teaching_Staff, 'false') AS IsTeachingfaculty,   
   CASE WHEN ISNULL(EUB.Is_Teaching_Staff, 'false') = 'true'     THEN FM.I_Faculty_Master_ID ELSE NULL END AS FacultyMasterID,   
   ISNULL(UP.S_EMP_Code, 'NA') AS EmployeeCode,   
   CASE WHEN ISNULL(EUB.Is_Teaching_Staff, 'false') = 'true' THEN ISNULL(FM.S_Faculty_Code, 'NA') ELSE NULL END AS FacultyCode,   
   CASE WHEN ISNULL(EUB.Is_Teaching_Staff, 'false') = 'true' THEN ISNULL(FM.S_Faculty_Name, 'NA') ELSE NULL END AS FacultyName,   
   UserGroupMap.User_Group_ID AS UserGroupID,   
   ISNULL(UserGroupMap.S_User_GroupName, 'NA') AS UserGroupName,   
   EU.unUserId,   
   COUNT(*) OVER() AS TotalRecords,  -- 👈 include total count   
   ROW_NUMBER() OVER (   
    ORDER BY    
     CASE WHEN @SortDirection = 'asc' THEN   
      CASE    
       WHEN @SortColumn = 'S_Username' THEN S_Username   
       WHEN @SortColumn = 'Name' THEN ISNULL(S_First_Name,'') + ISNULL(S_Middle_Name,'') + ISNULL(S_Last_Name,'')   
       WHEN @SortColumn = 'Email' THEN EU.S_Email   
       WHEN @SortColumn = 'Mobile_No' THEN S_Mobile   
       WHEN @SortColumn = 'Status' THEN CAST(EU.I_Status AS VARCHAR)   
      END   
     END ASC,   
     CASE WHEN @SortDirection = 'desc' THEN   
      CASE    
       WHEN @SortColumn = 'S_Username' THEN S_Username   
       WHEN @SortColumn = 'Name' THEN ISNULL(S_First_Name,'') + ISNULL(S_Middle_Name,'') + ISNULL(S_Last_Name,'')   
       WHEN @SortColumn = 'Email' THEN EU.S_Email   
       WHEN @SortColumn = 'Mobile_No' THEN S_Mobile   
       WHEN @SortColumn = 'Status' THEN CAST(EU.I_Status AS VARCHAR)   
      END   
     END DESC   
   ) AS RowNum   
  FROM T_ERP_User AS EU   
  INNER JOIN T_ERP_User_Brand AS EUB ON EU.I_User_ID = EUB.I_User_ID AND EUB.I_Brand_ID = @iBrandID AND EUB.Is_Active = 1   
  LEFT JOIN T_User_Profile AS UP ON EU.I_User_ID = UP.I_User_ID AND UP.I_Status = 1    
  LEFT JOIN T_Faculty_Master AS FM ON FM.I_User_ID = UP.I_User_ID AND FM.I_Status = 1   
  LEFT JOIN (   
   SELECT URPM.I_User_Id,    
    STUFF((SELECT DISTINCT ', ' + CONVERT(VARCHAR, URPM2.User_Group_ID)   
        FROM T_ERP_Users_Role_Permission_Map AS URPM2   
        INNER JOIN T_ERP_User_Group_Master AS UGM ON URPM2.User_Group_ID = UGM.I_User_Group_Master_ID AND UGM.Is_Active = 1   
        WHERE URPM2.I_User_Id = URPM.I_User_Id AND URPM2.Is_Active = 1 AND URPM2.Brand_ID = @iBrandID   
        FOR XML PATH('')), 1, 2, '') AS User_Group_ID,   
    STUFF((SELECT DISTINCT ', ' + EGM2.S_User_GroupName   
        FROM T_ERP_Users_Role_Permission_Map AS URPM2   
        INNER JOIN T_ERP_User_Group_Master AS EGM2 ON URPM2.User_Group_ID = EGM2.I_User_Group_Master_ID AND EGM2.Is_Active = 1   
        WHERE URPM2.I_User_Id = URPM.I_User_Id AND URPM2.Is_Active = 1 AND URPM2.Brand_ID = @iBrandID   
        FOR XML PATH('')), 1, 2, '') AS S_User_GroupName   
   FROM T_ERP_Users_Role_Permission_Map AS URPM   
   WHERE URPM.Is_Active = 1 AND URPM.Brand_ID = @iBrandID   
   GROUP BY URPM.I_User_Id   
  ) AS UserGroupMap ON UserGroupMap.I_User_Id = EU.I_User_ID   
  WHERE   
   (EU.I_User_ID = ISNULL(@User_ID, EU.I_User_ID))   
   AND (EU.S_Username = ISNULL(@Username, EU.S_Username))   
   AND (EU.S_Email = ISNULL(@Email, EU.S_Email))   
   AND (   
    @Name IS NULL OR    
    CONCAT(ISNULL(EU.S_First_Name, ''), ' ', ISNULL(EU.S_Middle_Name, ''), ' ', ISNULL(EU.S_Last_Name, '')) LIKE '%' + @Name + '%'   
   )   
   AND (EU.S_Mobile = ISNULL(@Mobile, EU.S_Mobile))   
   AND (EU.I_Status = ISNULL(@Status, EU.I_Status))   
   AND (ISNULL(EUB.Is_Teaching_Staff, 'false') = ISNULL(@isTeacher, ISNULL(EUB.Is_Teaching_Staff, 'false')))   
   --AND EU.I_Status = 1    
   AND ISNULL(EU.Is_Active_Ignore_Allowed, 'false') = 'false'   
   AND (   
    @SearchValue IS NULL OR   
    EU.S_Username LIKE '%' + @SearchValue + '%' OR   
    EU.S_Email LIKE '%' + @SearchValue + '%' OR   
    S_Mobile LIKE '%' + @SearchValue + '%' OR   
    CONCAT(ISNULL(EU.S_First_Name, ''), ' ', ISNULL(EU.S_Middle_Name, ''), ' ', ISNULL(EU.S_Last_Name, '')) LIKE '%' + @SearchValue + '%'   
   )   
 )       
 SELECT * FROM UserData   
 WHERE RowNum BETWEEN @Offset + 1 AND @Offset + @Limit;   END   
