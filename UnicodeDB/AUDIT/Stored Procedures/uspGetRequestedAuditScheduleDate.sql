CREATE PROCEDURE [AUDIT].[uspGetRequestedAuditScheduleDate]     
(    
 
  @dtFromDate  DATETIME = NULL  ,    
  @dtToDate  DATETIME = NULL  ,    
  @iStatusAudit INT =NULL    ,   --  Schedule = 1,ReScheduleRequested = 2,Visited = 3,Evaluated = 4    
  @iStatusChangeRequest INT =0   ,   --Requested = 1,Approved = 2,Reject = 3               --*Note If @iFlag=2 Then it Must    
  @iBrandID INT = NULL,  
  @iHierarchyDetailID INT = NULL
 
)    
 AS
 BEGIN   
 SET NOCOUNT OFF;
 SELECT    SCR.I_Schedule_Change_Request_ID    
   ,SCR.I_Audit_Schedule_ID                
   ,Adt.I_Center_ID AS I_Center_ID              
   ,ISNULL(Adt.[I_Audit_Type_ID],'') AS I_Audit_Type_ID    
   ,ISNULL(AudtType.[S_Audit_Type_Code],'') AS S_Audit_Type_Code    
   ,ISNULL(Adt.Dt_Audit_On,GETDATE()) AS Dt_Audit_On                  
   ,ISNULL(Adt.[I_User_ID],'') AS I_User_ID    
   ,ISNULL(Adt.[Dt_Crtd_On],getDAte()) AS ADT_Dt_Crtd_On    
   ,ISNULL(Adt.[Dt_Upd_On],getDAte()) AS ADT_Dt_Upd_On    
   ,ISNULL(Adt.[S_Crtd_By],'') AS ADT_S_Crtd_By    
   ,ISNULL(Adt.[S_Upd_By],'') AS ADT_S_Upd_By    
   ,ISNULL(SCR.Dt_Requested_Date,getDate()) AS  Dt_Requested_Date      
   ,ISNULL(SCR.S_Reason_Of_Change,'') AS S_Reason_Of_Change        
   ,ISNULL(SCR.S_Remarks,'') AS S_Remarks            
   ,SCR.I_Status_ID 
   ,ISNULL(SCR.S_Crtd_By,'') AS SCR_S_Crtd_By                   
   ,ISNULL(UserTbl.[S_First_Name]+' '+UserTbl.S_Middle_Name+' '+UserTbl.S_Last_Name,'') AS SCR_S_Originate_By    
   ,ISNULL(SCR.S_Upd_By,'') AS SCR_S_Upd_By             
   ,SCR.Dt_Crtd_On                  
   ,SCR.Dt_Upd_On                  
   ,ISNULL(Center.[S_Center_Name],'') AS S_Center_Name      
   ,ISNULL(ARSLT.F_Par_Score,'0') AS F_Par_Score    
   ,ISNULL(ARSLT.S_File_Name,'') AS S_File_Name       
   ,'0' AS I_Audit_Result_ID    
   ,'0' AS I_Total_No_NC    
   ,'0' AS I_Total_No_Repeated_NC    
   ,'0' AS I_Total_No_New_NC    
      
 FROM [AUDIT].[T_Schedule_Change_Request] SCR    
 INNER JOIN [AUDIT].[T_Audit_Schedule] Adt    
 ON SCR.[I_Audit_Schedule_ID] = Adt.[I_Audit_Schedule_ID]    
 INNER JOIN dbo.[T_Centre_Master] Center    
 ON Adt.[I_Center_ID] = Center.[I_Centre_Id]    
 LEFT JOIN [AUDIT].[T_Audit_Type] AudtType    
 ON Adt.[I_Audit_Type_ID] = AudtType.[I_Audit_Type_ID]    
 LEFT JOIN [AUDIT].[T_Audit_Result] ARSLT    
 ON Adt.[I_Audit_Schedule_ID] = ARSLT.[I_Audit_Schedule_ID]    
 INNER JOIN dbo.T_Brand_Center_Details BCD    
 ON BCD.I_Centre_Id  = Center.[I_Centre_Id]    
 LEFT JOIN dbo.[T_User_Master] UserTbl 
 ON Adt.[I_User_ID] = UserTbl.[I_User_ID]   
    
 WHERE SCR.[I_Audit_Schedule_ID] IN     
 (    
  SELECT ADS.[I_Audit_Schedule_ID]    
  FROM  [AUDIT].[T_Audit_Schedule] ADS    
  WHERE     

  ADS.[I_Center_ID] IN (SELECT I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@iHierarchyDetailID, @iBrandID))  
  AND    
  ADS.[Dt_Audit_On] >= COALESCE(@dtFromDate,ADS.[Dt_Audit_On])    
  AND     
  ADS.[Dt_Audit_On] <= COALESCE(@dtToDate,ADS.[Dt_Audit_On])    
  AND     
  ADS.[I_Status_ID] = COALESCE(@iStatusAudit,ADS.[I_Status_ID])    
  AND     
  BCD.I_Brand_ID = COALESCE(@iBrandID,BCD.I_Brand_ID)      
 )    
 AND SCR.[I_Status_ID]=@iStatusChangeRequest    
 
 ORDER BY S_Center_Name
    
    SELECT I_Schedule_Change_Request_ID,Dt_Audit_Date FROM [AUDIT].T_Schedule_Change_Request_Details
    WHERE I_Schedule_Change_Request_ID IN
    (  
      SELECT    SCR.I_Schedule_Change_Request_ID    
		 FROM [AUDIT].[T_Schedule_Change_Request] SCR    
		 INNER JOIN [AUDIT].[T_Audit_Schedule] Adt    
		 ON SCR.[I_Audit_Schedule_ID] = Adt.[I_Audit_Schedule_ID]    
		 INNER JOIN dbo.[T_Centre_Master] Center    
		 ON Adt.[I_Center_ID] = Center.[I_Centre_Id]    
		 LEFT JOIN [AUDIT].[T_Audit_Type] AudtType    
		 ON Adt.[I_Audit_Type_ID] = AudtType.[I_Audit_Type_ID]    
		 LEFT JOIN [AUDIT].[T_Audit_Result] ARSLT    
		 ON Adt.[I_Audit_Schedule_ID] = ARSLT.[I_Audit_Schedule_ID]    
		 INNER JOIN dbo.T_Brand_Center_Details BCD    
		 ON BCD.I_Centre_Id  = Center.[I_Centre_Id]    
		 LEFT JOIN dbo.[T_User_Master] UserTbl 
		 ON Adt.[I_User_ID] = UserTbl.[I_User_ID]   
		    
		 WHERE SCR.[I_Audit_Schedule_ID] IN     
		 (    
		  SELECT ADS.[I_Audit_Schedule_ID]    
		  FROM  [AUDIT].[T_Audit_Schedule] ADS    
		  WHERE     

		  ADS.[I_Center_ID] IN (SELECT I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@iHierarchyDetailID, @iBrandID))  
		  AND    
		  ADS.[Dt_Audit_On] >= COALESCE(@dtFromDate,ADS.[Dt_Audit_On])    
		  AND     
		  ADS.[Dt_Audit_On] <= COALESCE(@dtToDate,ADS.[Dt_Audit_On])    
		  AND     
		  ADS.[I_Status_ID] = COALESCE(@iStatusAudit,ADS.[I_Status_ID])    
		  AND     
		  BCD.I_Brand_ID = COALESCE(@iBrandID,BCD.I_Brand_ID)      
		 )    
		 AND SCR.[I_Status_ID]=@iStatusChangeRequest
 
	 )  
	 
	 END
