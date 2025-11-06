CREATE  PROCEDURE [dbo].[SPTeacherDetailsRecordSync_INT]
--(
--	--@TeacherIDS			VARCHAR(MAX)
--)
AS
BEGIN
		---Teacher Details
		SELECT 
			DISTINCT
			TED.I_Employee_ID			AS TeacherID,
			TED.S_Title				AS TeacherTitle,
			TED.S_First_Name		AS TeacherFirstName,
			TED.S_Middle_Name		AS MiddleName,
			TED.S_Last_Name			AS TeacherLastName,
			TED.S_Phone_No			AS TeacherPhone,
			TED.S_Email_ID			AS TeacherMaildID,
			TED.Dt_DOB				AS TeacherDOB,
			0						AS [TeacherUserId]
			--TESM2.I_Skill_ID		AS SkillID,
			--TED.I_Centre_Id			AS CenterID
		
		FROM dbo.T_Employee_Dtls						AS TED
		INNER JOIN EOS.T_Employee_Role_Map				AS TERM		ON TERM.I_Employee_ID = TED.I_Employee_ID
		INNER JOIN dbo.T_Role_Master					AS TRM		ON TRM.I_Role_ID = TERM.I_Role_ID
		INNER JOIN EOS.T_Employee_Skill_Map				AS TESM		ON TESM.I_Employee_ID = TED.I_Employee_ID
		INNER JOIN dbo.T_EOS_Skill_Master				AS TESM2	ON TESM2.I_Skill_ID = TESM.I_Skill_ID
		INNER JOIN dbo.T_Center_Hierarchy_Name_Details	AS TCHND	ON TED.I_Centre_Id=TCHND.I_Center_ID
		WHERE 
			TRM.I_Role_ID=18
			AND 
			TED.I_Status=3 
			AND 
			TCHND.I_Brand_ID=109
			AND 
			TERM.I_Status_ID>0 
			AND
			TESM.I_Status  >0

		--Teacher Skill 

		SELECT 
			DISTINCT
			TED.I_Employee_ID			AS TeacherID,			
			TESM2.I_Skill_ID		AS SkillID	,
			0						AS [TeacherUserId]		
		
		FROM dbo.T_Employee_Dtls						AS TED
		INNER JOIN EOS.T_Employee_Role_Map				AS TERM		ON TERM.I_Employee_ID = TED.I_Employee_ID
		INNER JOIN dbo.T_Role_Master					AS TRM		ON TRM.I_Role_ID = TERM.I_Role_ID
		INNER JOIN EOS.T_Employee_Skill_Map				AS TESM		ON TESM.I_Employee_ID = TED.I_Employee_ID
		INNER JOIN dbo.T_EOS_Skill_Master				AS TESM2	ON TESM2.I_Skill_ID = TESM.I_Skill_ID
		INNER JOIN dbo.T_Center_Hierarchy_Name_Details	AS TCHND	ON TED.I_Centre_Id=TCHND.I_Center_ID
		WHERE 
			TRM.I_Role_ID=18
			AND 
			TED.I_Status=3 
			AND 
			TCHND.I_Brand_ID=109
			AND 
			TERM.I_Status_ID>0 
			AND
			TESM.I_Status  >0
	 --Teacher Center 
		SELECT 
			DISTINCT
			TED.I_Employee_ID			AS TeacherID,			
			TED.I_Centre_Id			AS CenterID		,
			0						AS [TeacherUserId]
		
		FROM dbo.T_Employee_Dtls						AS TED
		INNER JOIN EOS.T_Employee_Role_Map				AS TERM		ON TERM.I_Employee_ID = TED.I_Employee_ID
		INNER JOIN dbo.T_Role_Master					AS TRM		ON TRM.I_Role_ID = TERM.I_Role_ID
		INNER JOIN EOS.T_Employee_Skill_Map				AS TESM		ON TESM.I_Employee_ID = TED.I_Employee_ID
		INNER JOIN dbo.T_EOS_Skill_Master				AS TESM2	ON TESM2.I_Skill_ID = TESM.I_Skill_ID
		INNER JOIN dbo.T_Center_Hierarchy_Name_Details	AS TCHND	ON TED.I_Centre_Id=TCHND.I_Center_ID
		WHERE 
			TRM.I_Role_ID=18
			AND 
			TED.I_Status=3 
			AND 
			TCHND.I_Brand_ID=109
			AND 
			TERM.I_Status_ID>0 
			AND
			TESM.I_Status  >0

END
