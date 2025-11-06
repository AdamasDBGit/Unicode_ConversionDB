/**************************************************************************************************************
Created by  : Sisir Halder
Date		: 21.05.2008
Description : Retrieves exam duration
Parameters  : @iExamComponentID -> Examination Component ID
			  @iCenterID		-> Center ID
Returns     : datarow
**************************************************************************************************************/ 
---------------------------------------------------------------------------------------------------------------  
-- Issue no 254
-- [EXAMINATION].[uspGetExamTotalTime] 357,114  
---------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [EXAMINATION].[uspGetExamTotalTime]  
(  
  @iExamComponentID INT = NULL
 ,@iCenterID INT = NULL  
)  
AS  
  
BEGIN  
 SET NOCOUNT ON;   
   
  DECLARE @flag INT
  SET @flag = 0
	
  SELECT @flag = COUNT(I_Skill_Exam_ID) FROM EOS.T_Skill_Exam_Map
  WHERE I_Exam_Component_ID = @iExamComponentID
	AND I_Centre_ID = @iCenterID
	AND I_Status <> 0

  IF @flag > 0
	BEGIN
	  SELECT * FROM EOS.T_Skill_Exam_Map
	  WHERE I_Exam_Component_ID = @iExamComponentID 
	  AND I_Centre_ID = @iCenterID
	  AND I_Status <> 0 
	END
  ELSE
	BEGIN
	  SELECT * FROM EOS.T_Skill_Exam_Map
	  WHERE I_Exam_Component_ID = @iExamComponentID
	  AND I_Centre_ID IS NULL 
	  AND I_Status <> 0 
	END
END
