--sp_helptext '[AUDIT].[uspGetNCRList]'



CREATE PROCEDURE [AUDIT].[uspGetNCRList]     
(    
  @iAuditScheduleID     INT      
  --Below Variable For Normal Operation    
  ,@iStatusID       INT = 0    
  --Below Variable For View Pending NCR    
  ,@iStatusID_Pending     INT = 0    
  --Below Variable For Breach Notice    
  ,@iStatusID_RequesteForClose  INT = 0    
  ,@iStatusID_Approved    INT = 0    
  ,@iStatusID_Closed     INT = 0   
  ,@CenterID  INT=0  
      
)    
    
AS    
BEGIN    
    
DECLARE @Sql VARCHAR(8000)   
  
    
 SET NOCOUNT OFF;    
     
SET @Sql = 'SELECT '    
  SET @sql = @sql + 'I_Audit_Report_NCR_ID'    
 SET @sql = @sql + ',S_NCR_Number'    
 SET @sql = @sql +',I_Audit_Result_ID'    
 SET @sql = @sql +',S_NCR_Desc'    
 SET @sql = @sql +',I_NCR_Type_ID'    
 SET @sql = @sql +',I_Audit_Functional_Type_ID'    
 SET @sql = @sql +',I_Is_Acknowledged'    
 SET @sql = @sql +',Dt_Acknowledged_On'    
 SET @sql = @sql +',S_Acknowledgement_Remarks'    
 SET @sql = @sql +',I_Status_ID'    
 SET @sql = @sql +',Dt_Target_Close'    
     
 IF @CenterID=0  
 BEGIN  
 SET @sql = @sql + ' FROM [AUDIT].[T_Audit_Result_NCR] WHERE I_Audit_Result_ID IN (SELECT I_Audit_Result_ID FROM [AUDIT].[T_Audit_Result] WHERE I_Audit_Schedule_ID = ' + LTRIM(STR(@iAuditScheduleID)) + ')'    
 END  
 ELSE  
 BEGIN 
 DECLARE @ScheduleDate DATETIME
 SET @ScheduleDate=(SELECT TAS.Dt_Audit_On FROM AUDIT.T_Audit_Schedule AS TAS WHERE TAS.I_Audit_Schedule_ID=@iAuditScheduleID)
 
 SET @sql = @sql + ' FROM [AUDIT].[T_Audit_Result_NCR] WHERE I_Audit_Result_ID IN (SELECT I_Audit_Result_ID FROM [AUDIT].[T_Audit_Result] WHERE I_Audit_Schedule_ID IN (select I_Audit_Schedule_ID from [AUDIT].T_Audit_Schedule where I_Center_ID=' + LTRIM(STR(@CenterID)) + ' and I_Audit_Schedule_ID <> ' + LTRIM(STR(@iAuditScheduleID)) + ' and Dt_Audit_On < CONVERT(DATETIME,'''+CONVERT(VARCHAR(50),@ScheduleDate)+''')))'    
 END  
   
 IF @iStatusID <> 0    
 BEGIN    
    
  SET @sql = @sql + ' AND I_Status_ID = COALESCE(' + LTRIM(STR(@iStatusID)) + ',I_Status_ID)'    
 END    
    
    
 IF @iStatusID_Pending <> 0    
 BEGIN    
  SET @sql = @sql + ' AND I_Status_ID <> COALESCE(' + LTRIM(STR(@iStatusID_Pending)) + ',I_Status_ID)'    
 END    
    
    
 IF @iStatusID_RequesteForClose <> 0 AND @iStatusID_Approved <>0 AND @iStatusID_Closed<>0    
 BEGIN    
  SET @sql = @sql + ' AND I_Status_ID IN ('+ LTRIM(STR(@iStatusID_RequesteForClose)) +', '+ LTRIM(STR(@iStatusID_Approved)) +', '+ LTRIM(STR(@iStatusID_Closed)) +')'    
 END     
    
--PRINT @sql    
EXECUTE(@sql)    
    
    
END  

--EXEC [AUDIT].[uspGetNCRList] 5,0,0,0,0,0,731


--SELECT CONVERT(DATETIME,'Jan 28 2011 12:00AM')
--[AUDIT].[uspGetNCRList] 6,730
