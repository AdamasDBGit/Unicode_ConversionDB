
CREATE FUNCTION [dbo].[fnGetTotalHomeWorkCountTeacherWise]  
(  
 @iEmployeeID INT,
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
  
 SELECT @iCount = COUNT(HM.I_Homework_ID) 
 FROM  [EXAMINATION].[T_Homework_Master]  HM	
	INNER JOIN dbo.T_Session_Master SM  
	ON SM.I_Session_ID=HM.I_Session_ID
	INNER JOIN dbo.T_EOS_SKILL_MASTER ESM  
	ON ESM.I_Skill_ID=SM.I_Skill_ID
	INNER JOIN [EXAMINATION].[T_Homework_Submission] HS
	ON HS.I_Homework_ID=HM.I_Homework_ID
 WHERE HM.[I_Batch_ID] = @iBatchID  
 AND HM.I_Center_ID = @iCenterID 
 AND HS.I_Employee_ID= @iEmployeeID
 AND ((DATEDIFF(DD,ISNULL(@StartDate,HM.Dt_Submission_Date),HM.Dt_Submission_Date) >= 0   
 AND DATEDIFF(DD,ISNULL(@EndDate,HM.Dt_Submission_Date),HM.Dt_Submission_Date)<= 0))  
 AND ESM.I_Skill_ID=@iSkillID
 RETURN @iCount  
END