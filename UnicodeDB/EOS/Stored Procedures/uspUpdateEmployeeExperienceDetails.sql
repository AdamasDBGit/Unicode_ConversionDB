/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP save/update all the work experience Details for a particualar employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspUpdateEmployeeExperienceDetails]
	(
		@iEmployeeID INT,
		@sJobDesc VARCHAR(200),
		@sCompanyName VARCHAR(100),
		@sIndustry VARCHAR(100),
		@dtFromDate DATETIME,
		@dtToDate DATETIME,
		@sCreatedBy VARCHAR(20),
		@sUpdatedBy VARCHAR(20),
		@dtCreatedOn DATETIME,
		@DtUpdatedOn DATETIME
  )
  AS
  BEGIN
  SET NOCOUNT ON;
	DELETE FROM EOS.T_Employee_WorkExp WHERE I_Employee_ID = @iEmployeeID AND Dt_Crtd_On  <> @dtCreatedOn
	
	INSERT INTO EOS.T_Employee_WorkExp 
	(
		I_Employee_ID,
		Dt_From_Date,
		Dt_To_Date,
		S_Company,
		S_Industry,		
		S_Job_Description,
		I_Status,
		S_Crtd_By,
		Dt_Crtd_On
	)
	VALUES
	(
		@iEmployeeID,
		@dtFromDate,
		@dtToDate,
		@sCompanyName,
		@sIndustry,
		@sJobDesc,
		1,--active status
		@sCreatedBy,
		@dtCreatedOn
	)

  END
