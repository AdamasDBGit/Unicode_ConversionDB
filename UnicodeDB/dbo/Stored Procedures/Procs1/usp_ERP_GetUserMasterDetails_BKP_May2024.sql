
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-April-19>
-- Description:	<Get User Master Data per UserID>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetUserMasterDetails_BKP_May2024] 
	-- Add the parameters for the stored procedure here
	@iUserID INT =NULL,
	@sEmail nvarchar(max)=NULL,
	@sMobile nvarchar(max)=NULL,
	@iBrand INT = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT 
    EU.I_User_ID AS UserID,
    FM.I_Faculty_Master_ID AS FacultyMasterID,
    UP.S_EMP_Code AS EmployeeCode,
    CONCAT(EU.S_First_Name, ' ', EU.S_Middle_Name, ' ', EU.S_Last_Name) AS EmployeeName,
    UP.S_PAN AS PAN,
    UP.S_Aadhaar AS Aadhar,
    UP.S_Present_Address AS PresentAddress,
    UP.S_Permanent_Address AS PermanentAddress,
    UP.S_EMP_Type AS EmployeeType,
    UP.Dt_DOJ AS DOJ,
    UP.Dt_DOB AS DOB,
    UP.S_Gender AS Gender,
    UP.I_Maritial_ID AS I_Marital_Status_ID,
    UP.I_Religion_ID AS I_Religion_ID,
    EU.I_Status AS Status,
    EU.S_Email AS EMail,
    EU.S_Mobile AS MobileNo,
    UP.S_Photo AS Photo,
    UP.S_Signature AS Signature,
    EU.I_Created_By AS CreatedBy,
    EU.S_Username AS Username,
    EU.S_Password AS UserPassword,
    EU.Is_Teaching_Staff AS IsTeachingfaculty,
    UP.I_Brand_ID AS BrandID,
	UserGroupMap.User_Group_ID as UserGroupID,
	UserGroupMap.S_User_GroupName as UserGroupName
FROM 
    T_ERP_User EU
LEFT JOIN
    T_User_Profile UP ON EU.I_User_ID = UP.I_User_ID
LEFT JOIN
    T_Faculty_Master FM ON FM.I_User_ID = EU.I_User_ID
	LEFT JOIN
	(SELECT URPM.I_User_Id, 
       STUFF((
            SELECT DISTINCT ', ' + CONVERT(VARCHAR, URPM2.User_Group_ID)
            FROM T_ERP_Users_Role_Permission_Map AS URPM2
            WHERE URPM2.I_User_Id = URPM.I_User_Id
              AND URPM2.Is_Active = 1 
              AND URPM2.Brand_ID = ISNULL(@iBrand, URPM2.Brand_ID)
            FOR XML PATH('')), 1, 2, '') AS User_Group_ID,
       STUFF((
            SELECT DISTINCT ', ' + EGM2.S_User_GroupName
            FROM T_ERP_Users_Role_Permission_Map AS URPM2
            INNER JOIN T_ERP_User_Group_Master AS EGM2 ON URPM2.User_Group_ID = EGM2.I_User_Group_Master_ID
            WHERE URPM2.I_User_Id = URPM.I_User_Id
              AND URPM2.Is_Active = 1 
              AND URPM2.Brand_ID = ISNULL(@iBrand, URPM2.Brand_ID)
            FOR XML PATH('')), 1, 2, '') AS S_User_GroupName
FROM T_ERP_Users_Role_Permission_Map AS URPM
WHERE URPM.Is_Active = 1 
      AND URPM.Brand_ID = ISNULL(@iBrand, URPM.Brand_ID)
GROUP BY URPM.I_User_Id
	 )
	as  UserGroupMap on 
	UserGroupMap.I_User_Id=EU.I_User_ID  

WHERE 
    EU.I_User_ID = ISNULL(@iUserID, EU.I_User_ID)
    AND EU.S_Mobile = ISNULL(@sMobile, EU.S_Mobile)
    AND EU.S_Email = ISNULL(@sEmail, EU.S_Email)

END
