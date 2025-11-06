-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Issue no 254
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [EOS].[uspSaveExamListForSkill]
(	
	@iSkillID INT,
	@iExamID VARCHAR(1000) = NULL,
	@bPassMandatory BIT = NULL,
	@iCutOffMarks INT = NULL,
	@eExamStage INT = NULL,
	@iNumberOfResits INT = NULL,
	@sCreatedBy VARCHAR(20),	
	@sUpdatedBy VARCHAR(20),
	@DtCreatedOn DATETIME,
	@DtUpdatedOn DATETIME,
	@iCenterID INT = NULL,
	@iTotalTime INT = NULL
)
	
AS
BEGIN TRY
	BEGIN TRANSACTION
	INSERT INTO EOS.T_Skill_Exam_Map_Audit
		(
			I_Skill_Exam_ID,I_Centre_ID,I_Skill_ID,I_Exam_Component_ID,Is_Pass_Mandatory,I_Cut_Off,I_Exam_Stage,I_Total_Time,I_Number_Of_Resits,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
		)
		SELECT 
			I_Skill_Exam_ID,
			I_Centre_ID,
			I_Skill_ID,
			I_Exam_Component_ID,
			Is_Pass_Mandatory,
			I_Cut_Off,
			I_Exam_Stage,
			I_Total_Time,
			I_Number_Of_Resits,
			I_Status,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On 
		FROM 
			EOS.T_Skill_Exam_Map WITH(NOLOCK)
		WHERE
			I_Skill_ID = @iSkillID
		
	IF (@iCenterID IS NULL)
	BEGIN
		DELETE FROM EOS.T_Skill_Exam_Map WHERE I_Skill_ID = @iSkillID AND I_Centre_ID IS NULL --AND Dt_Upd_On != @DtUpdatedOn	
	END
	ELSE
	BEGIN
		DELETE FROM EOS.T_Skill_Exam_Map WHERE I_Skill_ID = @iSkillID AND I_Centre_ID = @iCenterID --AND Dt_Upd_On != @DtUpdatedOn	
	END
		
	IF(@iExamID IS NOT NULL)
	BEGIN		
	INSERT INTO EOS.T_Skill_Exam_Map
		(
			I_Centre_ID,I_Skill_ID,I_Exam_Component_ID,Is_Pass_Mandatory,I_Cut_Off,I_Exam_Stage,I_Total_Time,I_Number_Of_Resits,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
		)
		VALUES
		(
			@iCenterID, @iSkillID, @iExamID, @bPassMandatory, @iCutOffMarks,@eExamStage,@iTotalTime,@iNumberOfResits, 1, @sCreatedBy, @sUpdatedBy, @DtCreatedOn, @DtUpdatedOn
		)
	END
	COMMIT TRANSACTION
END TRY
BEGIN CATCH    
	 ROLLBACK TRANSACTION   
	 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
	 SELECT @ErrMsg = ERROR_MESSAGE(),    
	   @ErrSeverity = ERROR_SEVERITY()    
	    
	 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
