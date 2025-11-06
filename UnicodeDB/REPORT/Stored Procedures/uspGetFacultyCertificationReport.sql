CREATE PROCEDURE [REPORT].[uspGetFacultyCertificationReport]
(    
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@S_Skill Varchar(500),
	@S_Employee_Name Varchar(500)
)    
AS    
BEGIN    
	DECLARE @iRowCount INT    
	Declare @dCurrentDate DateTime

	Set @dCurrentDate=CAST(SUBSTRING(CAST(@dtEndDate AS VARCHAR),1,11) as datetime)

	IF (@S_Skill='ALL')
		BEGIN
			SET @S_Skill=NULL
		END
	
	IF(@S_Employee_Name='')
		Begin
			SET @S_Employee_Name=NULL		
		End

	CREATE TABLE #tempSkill    
	(    
		CenterID		INT,
		CenterCode		VARCHAR(100),
		CenterName		VARCHAR(500),
		InstanceChain	VARCHAR(1000),
		S_Employee_Name Varchar(500),
		I_Emp_ID		INT,    
		I_Skill_ID		INT,    
		S_Skill_No		VARCHAR(20),    
		S_Skill_Desc	VARCHAR(100),    
		S_Skill_Type	VARCHAR(50),    
		I_Status		INT 
	)    

	INSERT INTO #tempSkill    
	SELECT  
	FN1.CenterID,
	FN1.CenterCode,
	FN1.CenterName,
	FN2.InstanceChain,    
	LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name),
	TESM.I_Employee_ID,
	TESM.I_Skill_ID,          
	TSM.S_Skill_No,    
	TSM.S_Skill_Desc,    
	TSM.S_Skill_Type,    
	TESM.I_Status    
	FROM 
	EOS.T_Employee_Skill_Map TESM WITH(NOLOCK) INNER JOIN dbo.T_EOS_Skill_Master TSM WITH(NOLOCK) ON TESM.I_Skill_ID=TSM.I_Skill_ID    
	INNER JOIN dbo.T_Employee_Dtls ED ON ED.I_Employee_ID=TESM.I_Employee_ID
	INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1 ON ED.I_Centre_Id=FN1.CenterID
	INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2 ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
	WHERE 
	TESM.I_Status <> 0 AND 
	LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name) 
	LIKE '%'+ISNULL(@S_Employee_Name,LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name) ) +'%' AND
	(TSM.S_Skill_No +','+TSM.S_Skill_Desc)=ISNULL(@S_Skill,(TSM.S_Skill_No +','+TSM.S_Skill_Desc))
	AND TESM.I_STATUS=1
   
	INSERT INTO #tempSkill    
	SELECT  
	FN1.CenterID,
	FN1.CenterCode,
	FN1.CenterName,
	FN2.InstanceChain,
	LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name),
	TERM.I_Employee_ID,    
	TRSM.I_Skill_ID,    
	TSM.S_Skill_No,    
	TSM.S_Skill_Desc,    
	TSM.S_Skill_Type,    
	TRSM.I_Status    
	FROM 
	EOS.T_Employee_Role_Map TERM WITH(NOLOCK) INNER JOIN EOS.T_Role_Skill_Map TRSM WITH(NOLOCK) ON TERM.I_Role_ID = TRSM.I_Role_ID
	INNER JOIN dbo.T_EOS_Skill_Master TSM WITH(NOLOCK) ON TRSM.I_Skill_ID = TSM.I_Skill_ID    
	INNER JOIN dbo.T_Employee_Dtls ED ON ED.I_Employee_ID=TERM.I_Employee_ID
	INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1 ON ED.I_Centre_Id=FN1.CenterID
	INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2 ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
	INNER JOIN EOS.T_Skill_Exam_Map SEM ON SEM.I_SKILL_ID=TRSM.I_Skill_ID AND SEM.I_CENTRE_ID IS NULL
	INNER JOIN EOS.T_Employee_Exam_Result EER ON EER.I_EXAM_COMPONENT_ID=SEM.I_EXAM_COMPONENT_ID AND EER.I_Employee_ID=TERM.I_Employee_ID
	WHERE 
	TRSM.I_Centre_ID IS NULL AND 
	LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name) 
	LIKE '%'+ISNULL(@S_Employee_Name,LTRIM(ISNULL(ED.S_Title,'') + ' ') + ED.S_First_Name + ' ' + LTRIM(ISNULL(ED.S_Middle_Name,'') + ' ' + ED.S_Last_Name) ) +'%' AND
	(TSM.S_Skill_No +','+TSM.S_Skill_Desc)=ISNULL(@S_Skill,(TSM.S_Skill_No +','+TSM.S_Skill_Desc))
	AND TRSM.I_Brand_ID = @iBrandID    
 
	CREATE TABLE #tempExam    
	(    
		I_Emp_ID			INT,    
		I_Skill_ID			INT,    
		I_Exam_Component_ID	INT,    
		S_Component_Name	VARCHAR(200),    
		S_Component_Type	VARCHAR(10),    
		I_Exam_Stage		INT,    
		I_Number_Of_Resits	INT,    
		I_No_Of_Attempts	INT,    
		I_Cut_Off			INT,    
		I_Status			INT,    
		Is_Pass_Mandatory	BIT,    
		B_Appeared			BIT,    
		B_Passed			BIT,    
		N_Marks				NUMERIC(8,2),  
		Dt_Crtd_On			DATETIME NULL,
		N_Full_Marks		NUMERIC(8,2)
	)    
     
	INSERT INTO #tempExam    
	SELECT  
	T.I_Emp_ID,    
	TSEM.I_Skill_ID,    
	TSEM.I_Exam_Component_ID,    
	TECM.S_Component_Name,    
	TECM.S_Component_Type,    
	TSEM.I_Exam_Stage,    
	TSEM.I_Number_Of_Resits,    
	1,    
	TSEM.I_Cut_Off,    
	TSEM.I_Status,    
	TSEM.Is_Pass_Mandatory, 
	1,   
	ISNULL(TEER.B_Passed,1),
	TEER.n_marks,
	TEER.Dt_Crtd_On ,
	(SELECT SUM(ISNULL(N_MARKS,0)*ISNULL(I_NO_OF_QUESTIONS,0)) FROM EXAMINATION.T_TEST_DESIGN_PATTERN WHERE I_TEST_DESIGN_ID IN
	(
		SELECT I_TEST_DESIGN_ID FROM EXAMINATION.T_TEST_DESIGN WHERE I_EXAM_COMPONENT_ID IN
		(
			SELECT I_EXAM_COMPONENT_ID FROM EOS.T_SKILL_EXAM_MAP WHERE I_SKILL_ID=TSEM.I_Skill_ID AND I_CENTRE_ID IS NULL AND I_STATUS=1
		)
	) )
	FROM 
	#tempSkill T WITH(NOLOCK) INNER JOIN EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK) ON T.I_Skill_ID = TSEM.I_Skill_ID    
	INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK) ON TSEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID    
	LEFT OUTER JOIN EOS.T_Employee_Exam_Result TEER WITH (NOLOCK) ON TEER.I_Exam_Component_ID=TSEM.I_Exam_Component_ID  AND T.I_Emp_ID=TEER.I_Employee_ID
	
	SELECT DISTINCT
	SK.CenterID,	
	SK.CenterCode,	
	SK.CenterName,	
	SK.InstanceChain,
	SK.S_Employee_Name,
	SK.I_Emp_ID,  
	--SK.I_Skill_ID, 
	SK.S_Skill_No,
	SK.S_Skill_Desc, 
	SK.S_Skill_Type, 
	SK.I_Status,
	--EX.I_Emp_ID,
	--EX.I_Skill_ID,
	EX.I_Exam_Component_ID,
	--EX.S_Component_Name,	
	--EX.S_Component_Type,		
	--EX.I_Exam_Stage,		
	--EX.I_Number_Of_Resits,
	EX.I_No_Of_Attempts,		
	--EX.I_Cut_Off,	
	--EX.I_Status,				
	--EX.Is_Pass_Mandatory,
	EX.B_Appeared,	
	EX.B_Passed,				
	ISNULL(EX.N_Marks,0) N_Marks,			
	EX.Dt_Crtd_On,
	EX.N_Full_Marks,
	FLOOR((EX.N_Marks/EX.N_Full_Marks)*100) As Percentage

	FROM 
	#tempSkill SK LEFT OUTER JOIN #tempExam EX ON SK.I_Emp_ID=EX.I_Emp_ID AND  SK.I_Skill_ID=EX.I_Skill_ID
	WHERE ISNULL(EX.Dt_Crtd_On ,@dCurrentDate) BETWEEn @dtStartDate AND @dtEndDate
	
	AND EX.B_Appeared<>0 
	AND EX.I_No_Of_Attempts<>0
	ORDER BY
	SK.CenterName,
	SK.I_Emp_ID,  
	SK.S_Skill_No,
	SK.S_Skill_Desc,
	EX.Dt_Crtd_On

	DROP TABLE #tempSkill
	DROP TABLE #tempExam
    
END
