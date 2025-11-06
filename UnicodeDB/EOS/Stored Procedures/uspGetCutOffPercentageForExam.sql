/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 13.06.2007
Description : This SP will retrieve the Cut_Off Percentage for the Exam Component
Parameters  : Exam Component ID
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetCutOffPercentageForExam]
(
	@iExamComponentID INT,
	@iUserID INT = NULL
)
AS
BEGIN
	IF (@iUserID IS NOT NULL)
	BEGIN
		DECLARE @iCenterID INT
		
		SELECT @iCenterID = E.I_Centre_ID 
		FROM dbo.T_User_Master U WITH(NOLOCK)
		INNER JOIN dbo.T_Employee_Dtls E WITH(NOLOCK)
			ON U.I_Reference_ID = E.I_Employee_ID
		WHERE U.I_User_ID = @iUserID
		
		IF EXISTS (SELECT TSEM.I_Cut_Off
						FROM 
							EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)	
						WHERE 
							TSEM.I_Exam_Component_ID = @iExamComponentID
							AND TSEM.I_Centre_ID = @iCenterID
							AND I_Status = 1
				  )
		BEGIN
			SELECT 
				TSEM.I_Cut_Off
			FROM 
				EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)	
			WHERE 
				TSEM.I_Exam_Component_ID = @iExamComponentID
				AND TSEM.I_Centre_ID = @iCenterID
				AND I_Status = 1
		END
		ELSE
		BEGIN
			SELECT 
				TSEM.I_Cut_Off
			FROM 
				EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)	
			WHERE 
				TSEM.I_Exam_Component_ID = @iExamComponentID
				AND TSEM.I_Centre_ID IS NULL
				AND I_Status = 1
		END
	END
	ELSE
	BEGIN
		SELECT 
			TSEM.I_Cut_Off
		FROM 
			EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)	
		WHERE 
			TSEM.I_Exam_Component_ID = @iExamComponentID
			AND TSEM.I_Centre_ID IS NULL
			AND I_Status = 1
	END
END
