-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/07/2006
-- Description:	Gets all the tax components attached to a center
-- =============================================

CREATE PROCEDURE [dbo].[uspGetTaxCenterReceiptType] 
	@iCenterID int	
AS
BEGIN		

		DECLARE @nTaxRate numeric(10,6)

		CREATE TABLE #TempTable
		(
			I_Receipt_Type int,
			I_Tax_ID int,
			N_Tax_Rate numeric(10,6),
			S_Tax_Desc varchar(50)
		)

		INSERT INTO #TempTable
		SELECT A.I_Receipt_Type,A.I_Tax_ID,A.N_Tax_Rate,B.S_Tax_Desc
		FROM dbo.T_Tax_Country_ReceiptType A
		INNER JOIN dbo.T_Tax_Master B
		ON A.I_Tax_ID = B.I_Tax_ID
		WHERE A.I_Country_ID IN 
		(SELECT I_Country_ID FROM dbo.T_Centre_Master
			WHERE I_Centre_Id = @iCenterID)
		AND A.I_Status = 1
		AND ISNULL(A.Dt_Valid_From,GETDATE()) <= GETDATE()
		AND ISNULL(A.Dt_Valid_To,GETDATE()) >= GETDATE()
 
		CREATE TABLE #tempCenterTax
		(
			ID int identity(1,1),
			I_Receipt_Type int,
			I_Tax_ID int,
			N_Tax_Rate numeric(10,6),
			S_Tax_Desc varchar(50)
		)

		INSERT INTO #tempCenterTax
		SELECT A.I_Receipt_Type,A.I_Tax_ID,A.N_Tax_Rate,B.S_Tax_Desc
		FROM dbo.T_Receipt_Type_Tax A
		INNER JOIN dbo.T_Tax_Master B
		ON A.I_Tax_ID = B.I_Tax_ID
		WHERE  A.I_Centre_Id = @iCenterID
			AND A.I_Status <> 0
			AND ISNULL(A.Dt_Valid_From,GETDATE()) <= GETDATE()
			AND ISNULL(A.Dt_Valid_To,GETDATE()) >= GETDATE()

		DECLARE @iCount INT
		DECLARE @iRowCount INT
		SELECT @iRowCount = count(ID) FROM #tempCenterTax
		SET @iCount = 1

		WHILE (@iCount <= @iRowCount)
		BEGIN  
			IF EXISTS (SELECT * FROM #TempTable WHERE
						I_Receipt_Type IN 
						(SELECT I_Receipt_Type FROM #tempCenterTax WHERE ID = @iCount)
						AND
						I_Tax_ID IN 
						(SELECT I_Tax_ID FROM #tempCenterTax WHERE ID = @iCount))
			BEGIN
				SELECT @nTaxRate = N_Tax_Rate FROM #tempCenterTax WHERE ID = @iCount				

				UPDATE #TempTable
				SET N_Tax_Rate = @nTaxRate
				WHERE
				I_Receipt_Type IN 
				(SELECT I_Receipt_Type FROM #tempCenterTax WHERE ID = @iCount)
				AND
				I_Tax_ID IN 
				(SELECT I_Tax_ID FROM #tempCenterTax WHERE ID = @iCount)
			END
			ELSE
			BEGIN
				INSERT INTO #TempTable
				SELECT I_Receipt_Type,I_Tax_ID,N_Tax_Rate,S_Tax_Desc
				FROM #tempCenterTax WHERE ID = @iCount
			END

			SET @iCount = @iCount + 1
		END
		
		SELECT * FROM #TempTable WHERE N_Tax_Rate <> 0

	TRUNCATE TABLE #TempTable
	DROP TABLE #TempTable

	TRUNCATE TABLE #tempCenterTax
	DROP TABLE #tempCenterTax

END
