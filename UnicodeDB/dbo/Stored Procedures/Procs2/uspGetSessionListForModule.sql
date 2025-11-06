CREATE PROCEDURE [dbo].[uspGetSessionListForModule]  
(  
 @iModuleId INT,  
 @dtCurrentDate datetime = null  
)  
  
AS  
BEGIN  
   
 SET NOCOUNT OFF  
 Set @dtCurrentDate = ISNULL(@dtCurrentDate,GETDATE())  
 SELECT SM.I_Session_ID,  
   SM.S_Session_Code,  
   SM.S_Session_Name,  
   SM.N_Session_Duration,  
   SM.S_Session_Topic,  
   SM.I_Session_Type_ID,  
   STM.S_Session_Type_Name,  
   SMM.I_Sequence  
 FROM dbo.T_Session_Master SM WITH(NOLOCK)  
 INNER JOIN dbo.T_Session_Module_Map SMM  
 ON SM.I_Session_ID = SMM.I_Session_ID   
 INNER JOIN dbo.T_Session_Type_Master STM  
 ON SM.I_Session_Type_ID = STM.I_Session_Type_ID  
 WHERE SMM.I_Module_ID = @iModuleId  
 AND SM.I_Status = 1   
 AND STM.I_Status = 1  
 AND SMM.I_Status = 1  
 AND @dtCurrentDate >= ISNULL(SMM.Dt_Valid_From,@dtCurrentDate)  
 AND @dtCurrentDate <= ISNULL(SMM.Dt_Valid_To,@dtCurrentDate) 
 ORDER BY SMM.I_Sequence, SM.S_Session_Code 
END
