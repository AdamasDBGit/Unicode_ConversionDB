--**********************************
-- Created By: Debarshi Basu
-- Created Date : 20/7/2007
-- UPDATES THE FEE SHARING MASTER
--**********************************


CREATE PROCEDURE [dbo].[uspUpdateFeeSharingMaster] 
	@iIndex int = NULL,
	@iBrandID INT = NULL,
	@iCountryID INT = NULL,
	@iCenterID INT = NULL,
	@iCourseID INT = NULL,
	@iFeeComponentID INT = NULL,
	@nCompanyShare NUMERIC(8,4),
	@dtStartDate DATETIME,
	@dtEndDate DATETIME,
	@sCrtdBy varchar(20),
	@dtCrtdOn datetime,
	@iFlag INT
AS
BEGIN

	IF @iFlag = 1
		BEGIN
			INSERT INTO dbo.T_Fee_Sharing_Audit
			SELECT I_Fee_Sharing_ID,I_Brand_ID,I_Country_ID,I_Center_ID,I_Course_ID,
				I_Fee_Component_ID,N_Company_Share,Dt_Period_Start,Dt_Period_End,
				I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
			FROM dbo.T_Fee_Sharing_Master
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Course_ID,0) = ISNULL(@iCourseID,0)
				AND	  ISNULL(I_Fee_Component_ID,0) = ISNULL(@iFeeComponentID,0)


			INSERT INTO dbo.T_Fee_Sharing_Master
			(I_Country_ID,I_Brand_ID,I_Center_ID,I_Course_ID,I_Fee_Component_ID,
				N_Company_Share,Dt_Period_Start,Dt_Period_End,I_Status,S_Crtd_By,Dt_Crtd_On)
			VALUES
			(@iCountryID,@iBrandID,@iCenterID,@iCourseID,@iFeeComponentID,@nCompanyShare,
				@dtStartDate,@dtEndDate,1,@sCrtdBy,@dtCrtdOn)
		END
	ELSE IF @iFlag = 2
		BEGIN
			INSERT INTO dbo.T_Fee_Sharing_Audit
			SELECT I_Fee_Sharing_ID,I_Brand_ID,I_Country_ID,I_Center_ID,I_Course_ID,
				I_Fee_Component_ID,N_Company_Share,Dt_Period_Start,Dt_Period_End,
				I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
			FROM dbo.T_Fee_Sharing_Master
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Course_ID,0) = ISNULL(@iCourseID,0)
				AND	  ISNULL(I_Fee_Component_ID,0) = ISNULL(@iFeeComponentID,0)


			UPDATE dbo.T_Fee_Sharing_Master
				SET N_Company_Share = @nCompanyShare,
					Dt_Period_Start = @dtStartDate,
					Dt_Period_End = @dtEndDate,
					S_Upd_By = @sCrtdBy,
					Dt_Upd_On = @dtCrtdOn
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Course_ID,0) = ISNULL(@iCourseID,0)
				AND	  ISNULL(I_Fee_Component_ID,0) = ISNULL(@iFeeComponentID,0)
				AND	  ISNULL(I_Brand_ID,0) = ISNULL(@iBrandID,0)
				AND   Dt_Period_End > GETDATE()
				AND I_Fee_Sharing_ID = ISNULL(@iIndex,I_Fee_Sharing_ID)
		END
	ELSE IF @iFlag = 3
		BEGIN
			INSERT INTO dbo.T_Fee_Sharing_Audit
			SELECT I_Fee_Sharing_ID,I_Brand_ID,I_Country_ID,I_Center_ID,I_Course_ID,
				I_Fee_Component_ID,N_Company_Share,Dt_Period_Start,Dt_Period_End,
				I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
			FROM dbo.T_Fee_Sharing_Master
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Course_ID,0) = ISNULL(@iCourseID,0)
				AND	  ISNULL(I_Fee_Component_ID,0) = ISNULL(@iFeeComponentID,0)
				AND	  ISNULL(I_Brand_ID,0) = ISNULL(@iBrandID,0)


			DELETE FROM dbo.T_Fee_Sharing_Master
			WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
				AND	  ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
				AND   ISNULL(I_Course_ID,0) = ISNULL(@iCourseID,0)
				AND	  ISNULL(I_Fee_Component_ID,0) = ISNULL(@iFeeComponentID,0)
				AND	  ISNULL(I_Brand_ID,0) = ISNULL(@iBrandID,0)

		END

END
