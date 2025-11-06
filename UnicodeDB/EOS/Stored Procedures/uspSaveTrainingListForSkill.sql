/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will retrieve the Skill list for a particular Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspSaveTrainingListForSkill]
(	
	@iSkillID INT,
	@xTrainingDetails XML = null,
	@iCenterID INT = null	
)	

AS
BEGIN TRY

	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT 
	DECLARE @sTrainingDetailsXML XML, @sTrainingXML XML
	DECLARE @iTrainingID INT, @iTrainingStage INT

	BEGIN TRANSACTION
	SET @AdjPosition = 1
	SET @sTrainingDetailsXML = @xTrainingDetails.query('/TrainingDetails[position()=sql:variable("@AdjPosition")]')

	SET @AdjCount = @xTrainingDetails.value('count((TrainingDetails/Training))','int')

	IF (@iCenterID IS NULL)
	BEGIN
		DELETE FROM EOS.T_Skill_Training_Mapping WHERE I_Skill_ID = @iSkillID AND I_Center_ID IS NULL
		
		WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @sTrainingXML = @xTrainingDetails.query('/TrainingDetails/Training[position()=sql:variable("@AdjPosition")]')
			SELECT	@iTrainingID = T.a.value('@I_Training_ID','int'),
					@iTrainingStage = T.a.value('@I_Training_Stage','int')
			FROM @sTrainingXML.nodes('/Training') T(a)

			INSERT INTO EOS.T_Skill_Training_Mapping
			(I_Center_ID,I_Skill_ID,I_Training_ID,I_Training_Stage,I_Status)
			VALUES
			(NULL,@iSkillID,@iTrainingID,@iTrainingStage,1)

			SET @AdjPosition=@AdjPosition+1
		END	
		
		
	END
	ELSE
	BEGIN
		DELETE FROM EOS.T_Skill_Training_Mapping WHERE I_Skill_ID = @iSkillID AND I_Center_ID = @iCenterID
		
		WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @sTrainingXML = @xTrainingDetails.query('/TrainingDetails/Training[position()=sql:variable("@AdjPosition")]')
			SELECT	@iTrainingID = T.a.value('@I_Training_ID','int'),
					@iTrainingStage = T.a.value('@I_Training_Stage','int')
			FROM @sTrainingXML.nodes('/Training') T(a)

			INSERT INTO EOS.T_Skill_Training_Mapping
			(I_Center_ID,I_Skill_ID,I_Training_ID,I_Training_Stage,I_Status)
			VALUES
			(@iCenterID,@iSkillID,@iTrainingID,@iTrainingStage,1)

			SET @AdjPosition=@AdjPosition+1
		END	
		
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
