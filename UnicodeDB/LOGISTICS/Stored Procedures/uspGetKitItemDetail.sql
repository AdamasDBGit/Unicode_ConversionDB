/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:03/08/2007
-- Description:Get Kit Details From T_Kit_Master table
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetKitItemDetail]
(
	--@sKitCode VARCHAR(20)=NULL ,
	--@sKitDesc VARCHAR(200)=NULL 
	@iKitID INT = 0
)
AS
BEGIN
	--DECLARE @iKitID INT
	SELECT 
		ISNULL(I_Kit_ID,' ') AS I_Kit_ID	,
  		ISNULL(S_Kit_Code,' ') AS S_Kit_Code	,
		ISNULL(S_Kit_Desc, ' ') AS S_Kit_Desc	,
		ISNULL(I_Kit_Rate_INR, 0) AS I_Kit_Rate_INR	,
		ISNULL(I_Kit_Rate_USD, 0) AS I_Kit_Rate_USD
	FROM  LOGISTICS.T_Kit_Master
	WHERE 
	    --S_Kit_Code LIKE '%' + @sKitCode + '%'
		--OR S_Kit_Desc LIKE '%' + @sKitDesc + '%'
		I_Kit_ID = @iKitID

	--SET @iKitID = (SELECT I_Kit_ID FROM [LOGISTICS].T_Kit_Master WHERE S_Kit_Code LIKE '%' + @sKitCode + '%' OR S_Kit_Desc LIKE '%' + @sKitDesc + '%')

    SELECT
		ISNULL(KL.I_Logistics_ID, 0) AS  I_Logistics_ID	,
		ISNULL(KL.I_Kit_Qty, 0) AS  I_Kit_Qty	,
		ISNULL(LM.I_Logistics_Type_ID, 0) AS  I_Logistics_Type_ID	,
		ISNULL(LTM.S_Logistics_Type_Desc, 0) AS  S_Logistics_Type_Desc	,
		ISNULL(LM.S_Item_Code, 0) AS  S_Item_Code	,
		ISNULL(LM.S_Item_Desc, 0) AS  S_Item_Desc
	FROM  LOGISTICS.T_Kit_Logistics KL
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		ON KL.I_Logistics_ID = LM.I_Logistics_ID
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		ON LM.I_Logistics_Type_ID = LTM.I_Logistics_Type_ID
	WHERE 
        I_Kit_ID = @iKitID
	 
END
