--sp_helptext '[AUDIT].[uspRequestListForNCRClosed]'  
  ---[AUDIT].[uspRequestListForNCRClosed] NULL,'01/Jan/2011','31/Mar/2011',1,3,0,NULL,2,1178
  
CREATE PROCEDURE [AUDIT].[uspRequestListForNCRClosed]     
(    
  @iCenterID  INT   = NULL ,    
  @dtFromDate  DATETIME = NULL  ,    
  @dtToDate  DATETIME = NULL  ,    
  @iFlag INT        ,   
  @iStatusAudit INT =NULL    ,   
  @iStatusChangeRequest INT =0   ,   
  @iAuditScheduleType  INT = NULL,    
  @iBrandID INT = NULL,  
  @iHierarchyDetailID INT = NULL,
  @iUserID INT = NULL
)    
  
AS    
BEGIN    
    IF @iFlag =1    
     BEGIN    
		   SELECT DISTINCT  ISNULL(ADS.[I_Audit_Schedule_ID],'') AS I_Audit_Schedule_ID  
			 ,ISNULL(ADS.[I_Center_ID],'') AS I_Center_ID    
			 ,ISNULL(Center.[S_Center_Name],'') AS S_Center_Name    
			 ,ISNULL(ADS.[Dt_Audit_On],getDAte()) AS Dt_Audit_On    
			 ,0 AS I_Status_ID    
			FROM [AUDIT].[T_Audit_Schedule] ADS
		    
		   INNER JOIN [AUDIT].[T_Audit_Result] ARSLT    
		   ON ADS.[I_Audit_Schedule_ID] = ARSLT.[I_Audit_Schedule_ID] 
		   INNER JOIN  AUDIT.T_Audit_Result_NCR ANCR 
		   ON ANCR.I_Audit_Result_ID = ARSLT.I_Audit_Result_ID   
		   INNER JOIN dbo.[T_Centre_Master] Center    
		   ON ADS.[I_Center_ID] = Center.[I_Centre_Id]
		   INNER JOIN dbo.[T_User_Master] UserTbl    
		   ON ADS.[I_User_ID] = UserTbl.[I_User_ID]
		   INNER JOIN dbo.T_Brand_Center_Details BCD    
		   ON BCD.I_Centre_Id  = Center.[I_Centre_Id]       
		     
		   WHERE     
		   ADS.[I_Center_ID] IN (SELECT I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@iHierarchyDetailID, @iBrandID))
		   AND    
		   ADS.[Dt_Audit_On] >= COALESCE(@dtFromDate,ADS.[Dt_Audit_On])    
		   AND     
		   ADS.[Dt_Audit_On] <= COALESCE(@dtToDate,ADS.[Dt_Audit_On])    
		   AND    
		   ANCR.[I_Status_ID] = COALESCE(@iStatusAudit,ANCR.[I_Status_ID])    
		   AND     
		   BCD.I_Brand_ID = COALESCE(@iBrandID,BCD.I_Brand_ID)     
		   AND 
		   UserTbl.I_User_ID = COALESCE(@iUserID,UserTbl.I_User_ID)    
		   ORDER BY S_Center_Name
		   
		   
		   
		   SELECT I_Audit_Schedule_ID,Dt_Audit_Date FROM AUDIT.T_Audit_Schedule_Details 
		   WHERE  I_Audit_Schedule_ID IN
		   (  
			 SELECT  DISTINCT ADS.[I_Audit_Schedule_ID]
		     FROM [AUDIT].[T_Audit_Schedule] ADS
		     INNER JOIN [AUDIT].[T_Audit_Result] ARSLT    
		     ON ADS.[I_Audit_Schedule_ID] = ARSLT.[I_Audit_Schedule_ID] 
		     INNER JOIN  AUDIT.T_Audit_Result_NCR ANCR 
		     ON ANCR.I_Audit_Result_ID = ARSLT.I_Audit_Result_ID   
		     INNER JOIN dbo.[T_Centre_Master] Center    
		     ON ADS.[I_Center_ID] = Center.[I_Centre_Id]
		     INNER JOIN dbo.[T_User_Master] UserTbl    
		     ON ADS.[I_User_ID] = UserTbl.[I_User_ID]
		     INNER JOIN dbo.T_Brand_Center_Details BCD    
		     ON BCD.I_Centre_Id  = Center.[I_Centre_Id]       
			   WHERE     
			   ADS.[I_Center_ID] IN (SELECT I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@iHierarchyDetailID, @iBrandID))
			   AND    
			   ADS.[Dt_Audit_On] >= COALESCE(@dtFromDate,ADS.[Dt_Audit_On])    
			   AND     
			   ADS.[Dt_Audit_On] <= COALESCE(@dtToDate,ADS.[Dt_Audit_On])    
			   AND    
			   ANCR.[I_Status_ID] = COALESCE(@iStatusAudit,ANCR.[I_Status_ID])    
			   AND     
			   BCD.I_Brand_ID = COALESCE(@iBrandID,BCD.I_Brand_ID)     
			   AND 
			   UserTbl.I_User_ID = COALESCE(@iUserID,UserTbl.I_User_ID)    
		   )
   
       END
       
       
       
       
   IF @iFlag =2    
     BEGIN    
		   SELECT DISTINCT  ISNULL(ADS.[I_Audit_Schedule_ID],'') AS I_Audit_Schedule_ID  
			 ,ISNULL(ADS.[I_Center_ID],'') AS I_Center_ID    
			 ,ISNULL(Center.[S_Center_Name],'') AS S_Center_Name    
			 ,ISNULL(ADS.[Dt_Audit_On],getDAte()) AS Dt_Audit_On    
			 ,0 AS I_Status_ID    
			FROM [AUDIT].[T_Audit_Schedule] ADS
		    
		   INNER JOIN [AUDIT].[T_Audit_Result] ARSLT    
		   ON ADS.[I_Audit_Schedule_ID] = ARSLT.[I_Audit_Schedule_ID] 
		   INNER JOIN  AUDIT.T_Audit_Result_NCR ANCR 
		   ON ANCR.I_Audit_Result_ID = ARSLT.I_Audit_Result_ID   
		   INNER JOIN dbo.[T_Centre_Master] Center    
		   ON ADS.[I_Center_ID] = Center.[I_Centre_Id]
		   INNER JOIN dbo.[T_User_Master] UserTbl    
		   ON ADS.[I_User_ID] = UserTbl.[I_User_ID]
		   INNER JOIN dbo.T_Brand_Center_Details BCD    
		   ON BCD.I_Centre_Id  = Center.[I_Centre_Id]       
		     
		   WHERE     
		   ADS.[I_Center_ID] IN (SELECT I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@iHierarchyDetailID, @iBrandID))
		   AND    
		   ADS.[Dt_Audit_On] >= COALESCE(@dtFromDate,ADS.[Dt_Audit_On])    
		   AND     
		   ADS.[Dt_Audit_On] <= COALESCE(@dtToDate,ADS.[Dt_Audit_On])    
		   AND    
		   ANCR.[I_Status_ID] != COALESCE(@iStatusAudit,ANCR.[I_Status_ID])    
		   AND     
		   BCD.I_Brand_ID = COALESCE(@iBrandID,BCD.I_Brand_ID)     
		   AND 
		   UserTbl.I_User_ID = COALESCE(@iUserID,UserTbl.I_User_ID)
		   AND [ARSLT].[I_Audit_Result_ID] NOT IN
				(SELECT DISTINCT TARN.[I_Audit_Result_ID] FROM [AUDIT].[T_Breach_Notice_NCR] AS TBNN
				INNER JOIN [AUDIT].[T_Audit_Result_NCR] AS TARN ON [TBNN].[I_Audit_Report_NCR_ID] = [TARN].[I_Audit_Report_NCR_ID])
				
		   ORDER BY S_Center_Name
		   
		   
		   
		   SELECT I_Audit_Schedule_ID,Dt_Audit_Date FROM AUDIT.T_Audit_Schedule_Details 
		   WHERE  I_Audit_Schedule_ID IN
		   (  
			 SELECT  DISTINCT ADS.[I_Audit_Schedule_ID]
		     FROM [AUDIT].[T_Audit_Schedule] ADS
		     INNER JOIN [AUDIT].[T_Audit_Result] ARSLT    
		     ON ADS.[I_Audit_Schedule_ID] = ARSLT.[I_Audit_Schedule_ID] 
		     INNER JOIN  AUDIT.T_Audit_Result_NCR ANCR 
		     ON ANCR.I_Audit_Result_ID = ARSLT.I_Audit_Result_ID   
		     INNER JOIN dbo.[T_Centre_Master] Center    
		     ON ADS.[I_Center_ID] = Center.[I_Centre_Id]
		     INNER JOIN dbo.[T_User_Master] UserTbl    
		     ON ADS.[I_User_ID] = UserTbl.[I_User_ID]
		     INNER JOIN dbo.T_Brand_Center_Details BCD    
		     ON BCD.I_Centre_Id  = Center.[I_Centre_Id]       
			   WHERE     
			   ADS.[I_Center_ID] IN (SELECT I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@iHierarchyDetailID, @iBrandID))
			   AND    
			   ADS.[Dt_Audit_On] >= COALESCE(@dtFromDate,ADS.[Dt_Audit_On])    
			   AND     
			   ADS.[Dt_Audit_On] <= COALESCE(@dtToDate,ADS.[Dt_Audit_On])    
			   AND    
			   ANCR.[I_Status_ID] != COALESCE(@iStatusAudit,ANCR.[I_Status_ID])    
			   AND     
			   BCD.I_Brand_ID = COALESCE(@iBrandID,BCD.I_Brand_ID)     
			   AND 
			   UserTbl.I_User_ID = COALESCE(@iUserID,UserTbl.I_User_ID)
			   AND [ARSLT].[I_Audit_Result_ID] NOT IN
				(SELECT DISTINCT TARN.[I_Audit_Result_ID] FROM [AUDIT].[T_Breach_Notice_NCR] AS TBNN
				INNER JOIN [AUDIT].[T_Audit_Result_NCR] AS TARN ON [TBNN].[I_Audit_Report_NCR_ID] = [TARN].[I_Audit_Report_NCR_ID])
		   )   
       END
       
   END
