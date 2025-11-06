CREATE PROCEDURE [AUDIT].[uspGetNewCenterAuditList]     
(    
  @dtFromDate  DATETIME = NULL  ,    
  @dtToDate  DATETIME = NULL  ,    
  @iStatusAudit INT =NULL    ,   --  Schedule = 1,ReScheduleRequested = 2,Visited = 3,Evaluated = 4    
  @iBrandID INT = NULL,  
  @iHierarchyDetailID INT = NULL,
  @iUserID INT = NULL
)    
  
AS    
 SET NOCOUNT OFF;    
BEGIN    

SELECT TAS.I_Audit_Schedule_ID,TAS.Dt_Audit_On ,TAS.I_Status_ID,Center.S_Center_Name,TAS.I_User_ID,TAS.S_Crtd_By,TAS.S_Upd_By,TAS.I_Center_ID FROM [AUDIT].[T_Audit_Schedule] AS TAS
INNER JOIN dbo.[T_Centre_Master] Center    
ON TAS.[I_Center_ID] = Center.[I_Centre_Id]    

WHERE [TAS].[I_Center_ID] NOT IN 
(
SELECT DISTINCT [TAS1].[I_Center_ID]
FROM [AUDIT].[T_Audit_Result] AS TAR
INNER JOIN [AUDIT].[T_Audit_Schedule] TAS1
ON [TAR].[I_Audit_Schedule_ID] = TAS1.[I_Audit_Schedule_ID])
AND TAS.[I_Center_ID] IN (SELECT I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@iHierarchyDetailID, @iBrandID))  
AND TAS.[Dt_Audit_On] >= COALESCE(@dtFromDate,TAS.[Dt_Audit_On])    
AND TAS.[Dt_Audit_On] <= COALESCE(@dtToDate,TAS.[Dt_Audit_On])    
AND TAS.I_Status_ID = COALESCE(@iStatusAudit,TAS.[I_Status_ID]) 
AND TAS.I_User_ID =COALESCE(@iUserID,TAS.I_User_ID)    


SELECT I_Audit_Schedule_ID,Dt_Audit_Date FROM AUDIT.T_Audit_Schedule_Details 
   WHERE  I_Audit_Schedule_ID IN
   (  
	    SELECT  TAS.I_Audit_Schedule_ID FROM [AUDIT].[T_Audit_Schedule] AS TAS
		INNER JOIN dbo.[T_Centre_Master] Center    
		ON TAS.[I_Center_ID] = Center.[I_Centre_Id]    
		WHERE [TAS].[I_Center_ID] NOT IN 
		(
		SELECT DISTINCT [TAS1].[I_Center_ID]
		FROM [AUDIT].[T_Audit_Result] AS TAR
		INNER JOIN [AUDIT].[T_Audit_Schedule] TAS1
		ON [TAR].[I_Audit_Schedule_ID] = TAS1.[I_Audit_Schedule_ID])
		AND TAS.[I_Center_ID] IN (SELECT I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@iHierarchyDetailID, @iBrandID))  
		AND TAS.[Dt_Audit_On] >= COALESCE(@dtFromDate,TAS.[Dt_Audit_On])    
		AND TAS.[Dt_Audit_On] <= COALESCE(@dtToDate,TAS.[Dt_Audit_On])    
		AND TAS.I_Status_ID = COALESCE(@iStatusAudit,TAS.[I_Status_ID]) 
		AND TAS.I_User_ID =COALESCE(@iUserID,TAS.I_User_ID)    

   )
END
