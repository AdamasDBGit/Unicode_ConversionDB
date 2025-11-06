/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 30.05.2007
Description : This SP will retrieve all tasks done for the center creation
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/


CREATE PROCEDURE [NETWORK].[uspGetCenterTaskAudit]
	@iCenterID INT
AS
BEGIN

	CREATE TABLE #TempTable
	(
		ID INT,
		Description varchar(1000),
		CreatedBy Varchar(20),
		UpdateBy Varchar(20),
		DtCrtdOn Datetime,
		DtUpdOn Datetime,
		Status INT,
		Reason varchar(1000),
		TypeOfTask Varchar(100)
	)

	DECLARE @iAgreementID INT

--	get agreement id for the center
	SELECT @iAgreementID = I_Agreement_ID
		FROM NETWORK.T_Agreement_Center
		WHERE I_Centre_Id = @iCenterID

--	insert agreement history into temptable
	INSERT INTO #TempTable
	SELECT I_Agreement_ID,S_Company_Name,S_Crtd_By,S_Upd_By,
			Dt_Crtd_On,Dt_Upd_On,I_Status,S_Reason,'Agreement'
	FROM NETWORK.T_Agreement_Details
		WHERE I_Agreement_ID = @iAgreementID
		AND I_Status <> 0
	UNION
	SELECT I_Agreement_ID,S_Company_Name,S_Crtd_By,S_Upd_By,
			Dt_Crtd_On,Dt_Upd_On,I_Status,S_Reason,'Agreement'
	FROM NETWORK.T_Agreement_Audit
		WHERE I_Agreement_ID = @iAgreementID
		AND I_Status <> 0

--	insert payment details history in temptable
	INSERT INTO #TempTable
	SELECT I_Center_Payment_Details_ID,S_Remarks,S_Crtd_By,S_Upd_By,
			Dt_Crtd_On,Dt_Upd_On,I_Status,S_Reason,'Payment Details'
	FROM NETWORK.T_Center_Payment_Details
		WHERE I_Centre_Id = @iCenterID
		AND I_Status <> 0
	UNION
	SELECT I_Payment_ID,S_Remarks,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,
			I_Status,S_Reason,'Payment Details'
	FROM NETWORK.T_Center_Payment_Details_Audit
		WHERE I_Centre_Id = @iCenterID
		AND I_Status <> 0


--	insert infrastructure details into temp table
--	INSERT INTO #TempTable
--	SELECT I_Center_Infrastructure_Audit,S_Reason,S_Crtd_By,S_Upd_By,
--			Dt_Crtd_On,Dt_Upd_On,I_Status,S_Reason,'Infrastructure'
--	FROM NETWORK.T_Center_InfrastructureRequest
--		WHERE I_Centre_Id = @iCenterID
--		AND I_Status <> 0


--	insert center modification details into temp table
	INSERT INTO #TempTable
	SELECT I_Centre_Id,S_Center_Name,S_Crtd_By,S_Upd_By,Dt_Crtd_On,
			Dt_Upd_On,I_Status,NULL,'Center'
	FROM dbo.T_Centre_Master
		WHERE I_Centre_Id = @iCenterID
		AND I_Status <> 0
	UNION
	SELECT I_Centre_Id,S_Center_Name,S_Crtd_By,S_Upd_By,Dt_Crtd_On,
			Dt_Upd_On,I_Status,NULL,'Center'
	FROM NETWORK.T_Center_Master_Audit
		WHERE I_Centre_Id = @iCenterID
		AND I_Status <> 0
	
--	Select the inserted values from temptable
	SELECT * FROM #TempTable
	ORDER BY DtCrtdOn,DtUpdOn

	DROP TABLE #TempTable

END
