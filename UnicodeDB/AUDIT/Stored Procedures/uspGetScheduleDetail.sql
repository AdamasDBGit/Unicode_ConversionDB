/*
-- =================================================================
-- Author:Sanjay Mitra
-- Create date:10/07/2007 
-- Description: Select From  [T_Audit_Schedule] used in GetCenterAuditDetails Method in AuditBuilder
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspGetScheduleDetail] 
(
		@iAuditScheduleID INT = 0		
)

AS
BEGIN

	SET NOCOUNT OFF;

	SELECT 
	   ISNULL([I_Audit_Schedule_ID],'') AS I_Audit_Schedule_ID
      ,ISNULL(AdtSeche.[I_Center_ID],'') AS I_Center_ID
      ,ISNULL(AdtSeche.[Dt_Audit_On],getDAte()) AS Dt_Audit_On
      ,ISNULL(AdtSeche.[I_User_ID],'') AS I_User_ID
      ,ISNULL(AdtSeche.[I_Audit_Type_ID],'') AS I_Audit_Type_ID
	  ,ISNULL(AudtType.[S_Audit_Type_Code],'') AS S_Audit_Type_Code
      ,ISNULL(AdtSeche.[I_Status_ID],'') AS I_Status_ID
      ,ISNULL(AdtSeche.[S_Crtd_By],'') AS S_Crtd_By
      ,ISNULL(AdtSeche.[S_Upd_By],'') AS S_Upd_By
      ,ISNULL(AdtSeche.[Dt_Crtd_On],getDAte()) AS Dt_Crtd_On
      ,ISNULL(AdtSeche.[Dt_Upd_On],getDAte()) AS Dt_Upd_On
      ,ISNULL(Center.[S_Center_Name],'') AS S_Center_Name
      ,ISNULL(_User.[S_Login_ID],'') AS S_Login_ID
	FROM  [AUDIT].[T_Audit_Schedule] AdtSeche
	
	LEFT JOIN [AUDIT].[T_Audit_Type] AudtType
	ON AdtSeche.[I_Audit_Type_ID] = AudtType.[I_Audit_Type_ID]
	LEFT JOIN dbo.[T_Centre_Master] Center
	ON AdtSeche.[I_Center_ID] = Center.[I_Centre_Id]
	LEFT JOIN dbo.[T_User_Master] _User
	ON AdtSeche.[I_User_ID] = _User.I_User_ID


	WHERE 
	AdtSeche.[I_Audit_Schedule_ID] =  @iAuditScheduleID
		
END
