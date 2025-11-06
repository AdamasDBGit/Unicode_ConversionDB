/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will Save the Assessor Role for the particular Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspSaveKRADetails]
(	
	@iBrandID INT,
	@iRoleID INT,
	@sSubKRAXML XML,
	@sCreatedBy VARCHAR(20),
	@sUpdatedBy VARCHAR(20),
	@DtCreatedOn DATETIME,
	@DtUpdatedOn DATETIME 
)	
AS
BEGIN

	DECLARE @tmpTable TABLE 
	(
		I_KRA_ID INT,
		I_SubKRA_ID INT,
		I_SubKRA_Index_ID INT
	)
	
	INSERT INTO @tmpTable
	SELECT	T.c.value('@KRAID','int'),
			T.c.value('@SubKRAID','int'),
			T.c.value('@SubKRAIndexID','int')
	FROM   @sSubKRAXML.nodes('/KRA/SubKRA') T(c)
	
	DELETE FROM EOS.T_Role_KRA_SubKRA 
	WHERE I_Brand_ID = @iBrandID 
		AND I_Role_ID = @iRoleID 
		AND I_KRA_ID  IN (SELECT I_KRA_ID FROM @tmpTable)
		
	INSERT INTO EOS.T_Role_KRA_SubKRA
	(
		I_Brand_ID,
		I_Role_ID,
		I_KRA_ID,
		I_SubKRA_ID,
		I_SubKRA_Index_ID,
		I_Status,
		S_Crtd_By,
		S_Upd_By,
		Dt_Crtd_On,
		Dt_Upd_On
	)
	SELECT 	
		@iBrandID,
		@iRoleID,
		I_KRA_ID,
		I_SubKRA_ID,
		I_SubKRA_Index_ID,
		1,
		@sCreatedBy,
		@sUpdatedBy,
		@DtCreatedOn,
		@DtUpdatedOn
	FROM
		@tmpTable	
	
END
