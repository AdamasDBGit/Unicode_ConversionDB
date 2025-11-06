-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspModifySkillExamMaster]
	-- Add the parameters for the stored procedure here
	@iTestID int,
	@iSkillID int,
	@iCenterID int,
	@vPassFail varchar(20),
	@iCutOff int,
	@vTestBy varchar(20),
	@dTestOn datetime,
	@iFlag int,
	@sExamType varchar(100)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
    -- Insert statements for procedure here
	

		DECLARE @I_FLAG INT
	
	
			
		SELECT @I_FLAG = COUNT(*) FROM dbo.T_Role_Skill_Test_Dtls
		WHERE I_RST_Skill_ID = @iSkillID AND I_RST_Test_ID = @iTestID
		AND I_RST_Centre_Id = @iCenterID

		if(@iFlag=1)
			BEGIN
					IF(@I_FLAG > 0)
						BEGIN
								UPDATE dbo.T_Role_Skill_Test_Dtls
								SET I_RST_Test_ID = @iTestID,
									I_RST_Skill_ID = @iSkillID,
									I_RST_Centre_Id=@iCenterID,
									S_RST_PassFail=@vPassFail,
									I_RST_Cut_Off=@iCutOff,
									S_RST_Upd_By=@vTestBy,
									Dt_RST_Upd_On=@dTestOn,
									S_RST_Test_Type = @sExamType
									

								WHERE I_RST_Skill_ID = @iSkillID AND I_RST_Test_ID = @iTestID
								AND I_RST_Centre_Id = @iCenterID

						END
			
			
			
					ELSE

						BEGIN
										INSERT INTO dbo.T_Role_Skill_Test_Dtls(
																			I_RST_Test_ID,
																			I_RST_Skill_ID,
																			I_RST_Centre_Id,
																			S_RST_PassFail, 
																			I_RST_Cut_Off,
																			S_RST_Crtd_By,
																			Dt_RST_Crtd_On,
																			C_RST_Status,
																			S_RST_Test_Type 
																			
																	   )
										VALUES(
												@iTestID, 
												@iSkillID,
												@iCenterID,
												@vPassFail,
												@iCutOff,
												@vTestBy,
												@dTestOn,
												'A',
												@sExamType
												
											)
						END

		
			END	
			
			IF(@iFlag=0)

			BEGIN
					
			
					
						
								UPDATE dbo.T_Role_Skill_Test_Dtls
								SET I_RST_Test_ID = @iTestID,
									I_RST_Skill_ID = @iSkillID,
									I_RST_Centre_Id=@iCenterID,
									S_RST_PassFail=@vPassFail,
									I_RST_Cut_Off=@iCutOff,
									S_RST_Upd_By=@vTestBy,
									Dt_RST_Upd_On=@dTestOn,
									C_RST_Status='D',
									S_RST_Test_Type = @sExamType
									

								WHERE I_RST_Skill_ID = @iSkillID AND I_RST_Test_ID = @iTestID
								AND I_RST_Centre_Id = @iCenterID

			END	

				
			
	

END
