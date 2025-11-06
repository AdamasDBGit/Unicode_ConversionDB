
create FUNCTION [dbo].[fnGetTotalSessionCountSubjectWise]  
(  
 @iBatchID INT,  
 @iCenterID INT,
 @iSkillID INT,
 @StartDate DateTime = Null,  
 @EndDate DateTime = Null  
)  
RETURNS INT  
AS  
BEGIN  
 DECLARE @iCount INT  
  
 SELECT @iCount = COUNT(TM.I_TimeTable_ID) 
 FROM [dbo].[T_TimeTable_Master] AS TM  
	INNER JOIN dbo.T_Session_Master SM  
	ON SM.I_Session_ID=TM.I_Session_ID
	INNER JOIN dbo.T_EOS_SKILL_MASTER ESM  
	ON ESM.I_Skill_ID=SM.I_Skill_ID
 WHERE TM.[I_Batch_ID] = @iBatchID  
 AND TM.I_Center_ID = @iCenterID  
 AND ((DATEDIFF(DD,ISNULL(@StartDate,TM.[Dt_Schedule_Date]),TM.[Dt_Schedule_Date]) >= 0   
 AND DATEDIFF(DD,ISNULL(@EndDate,TM.[Dt_Schedule_Date]),TM.[Dt_Schedule_Date])<= 0))  
 AND ESM.I_Skill_ID=@iSkillID
 RETURN @iCount  
END