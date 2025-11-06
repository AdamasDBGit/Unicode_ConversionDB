/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP save/update all the Qualification Details for a particualar employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspUpdateEmployeeQualificationDetails]
	(
		@iEmployeeID INT,
		@iQualificationNameID INT,
		@iQualificationTypeID INT,
		@nPercentage NUMERIC(8,2),
		@iPassingYear INT,
		@sCreatedBy VARCHAR(20),
		@sUpdatedBy VARCHAR(20),
		@dtCreatedOn DATETIME,
		@DtUpdatedOn DATETIME
	)
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS ( SELECT * FROM EOS.T_Employee_Qualification WHERE I_Employee_ID = @iEmployeeID AND
	I_Qualification_Type_ID = @iQualificationTypeID AND I_Qualification_Name_ID = @iQualificationNameID AND I_Status=1) --Active status
	
	BEGIN
		UPDATE EOS.T_Employee_Qualification
		SET I_Passing_Year = @iPassingYear,
		N_Percentage = @nPercentage,
		S_Upd_By = @sUpdatedBy,
		Dt_Upd_On = @DtUpdatedOn
		WHERE I_Employee_ID = @iEmployeeID AND
	   I_Qualification_Type_ID = @iQualificationTypeID AND I_Qualification_Name_ID = @iQualificationNameID AND I_Status=1

	END
	ELSE
	BEGIN
		INSERT INTO EOS.T_Employee_Qualification
		(
			I_Qualification_Type_ID,
			I_Qualification_Name_ID,
			I_Employee_ID,
			I_Passing_Year,
			N_Percentage,
			S_Crtd_By,
			Dt_Crtd_On,
     		I_Status	
			
	)
	
	VALUES
	(
		@iQualificationTypeID,
		@iQualificationNameID,
		@iEmployeeID,
		@iPassingYear,
		@nPercentage,
		@sCreatedBy,
		@dtCreatedOn,
		1 --Active status
	)	
			
	END
END
