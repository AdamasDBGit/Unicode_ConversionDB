
CREATE PROCEDURE [dbo].[KPMG_uspGetUnAcknowledgedPoItems]


AS
BEGIN
	
	

	SET NOCOUNT ON;
	DECLARE @TempTable TABLE (ID INT , OraclePoId VARCHAR(100), PO_PR_Id INT)
	IF EXISTS(SELECT 1 FROM Tbl_KPMG_PoDetailItems WHERE Fld_KPMG_Status=4)
	BEGIN
		INSERT INTO @TempTable (OraclePoId,PO_PR_Id)
		SELECT DISTINCT(B.OraclePoId) , B.Fld_KPMG_PoPr_Id 			 
		FROM Tbl_KPMG_PoDetailItems(NOLOCK) A 
		INNER JOIN Tbl_KPMG_PoDetails (NOLOCK) B 			
		ON A.Fld_KPMG_PoPr_Id=B.Fld_KPMG_PoPr_Id AND A.Fld_KPMG_Status = 4
		
		SELECT 			
			 B.Fld_KPMG_PO_Id AS PoNumber,
			 B.OraclePoId AS OraclePoId,		 
			 A.Fld_KPMG_Barcode AS BarCode,
			 B.Fld_KPMG_Item_Id AS ItemCode,
			 A.OracleLinieId AS OracleLineId,
			 A.Fld_KPMG_Status AS ItemStatus
			 FROM Tbl_KPMG_PoDetailItems(NOLOCK) A 
			 INNER JOIN Tbl_KPMG_PoDetails (NOLOCK) B			 	
			 ON A.Fld_KPMG_PoPr_Id=B.Fld_KPMG_PoPr_Id --AND A.Fld_KPMG_Status <> 4
			 JOIN @TempTable C on C.OraclePoId = B.OraclePoId AND C.PO_PR_Id = A.Fld_KPMG_PoPr_Id
	END
	
	
END
