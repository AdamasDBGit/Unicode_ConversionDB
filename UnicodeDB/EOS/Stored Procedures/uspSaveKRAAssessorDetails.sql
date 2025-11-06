/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will Save the Assessor Role for the particular Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspSaveKRAAssessorDetails]
(	
	@iBrandID INT,
	@iRoleID INT,
	@sAssessorRoles VARCHAR(500),
	@sCreatedBy VARCHAR(20),
	@sUpdatedBy VARCHAR(20),
	@DtCreatedOn DATETIME,
	@DtUpdatedOn DATETIME 
)	
AS
BEGIN
	
	DELETE FROM EOS.T_Role_Assessor WHERE I_Brand_ID = @iBrandID AND I_Role_ID = @iRoleID
	
	INSERT INTO EOS.T_Role_Assessor
		(I_Brand_ID, I_Role_ID, I_Assessor_Role_ID, I_Target_Day_Of_Month, I_Achievement_Day_Of_Month, S_Crtd_By, S_Upd_By, Dt_Crtd_On, Dt_Upd_On)
	SELECT 
		@iBrandID, @iRoleID, *, NULL, NULL, @sCreatedBy, @sUpdatedBy, @DtCreatedOn, @DtUpdatedOn
	FROM dbo.fnString2Rows(@sAssessorRoles,',')
	
END
