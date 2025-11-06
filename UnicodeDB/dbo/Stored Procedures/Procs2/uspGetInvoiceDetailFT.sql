CREATE PROCEDURE [dbo].[uspGetInvoiceDetailFT]
(
	@iInvoiceHeaderID int,
	@dtReceiptDate datetime
)

AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @iInvoiceDetailId INT
	DECLARE @iCountryID INT
	DECLARE @iCenterID INT

	DECLARE @TempTable TABLE(I_Tax_ID INT, I_Invoice_Detail_ID INT, N_Tax_Value NUMERIC(18,6),TAX_CODE VARCHAR(20),TAX_DESC VARCHAR(50))
	-- TABLE[0] RETURNS ALL THE INFORMATION FROM T_INVOICE_PARENT	
	SELECT * FROM T_Invoice_Parent 
	WHERE I_Invoice_Header_ID = @iInvoiceHeaderID

	-- TABLE[1] RETURNS ALL THE FIELDS FROM T_Invoice_Child_Header
	SELECT TIVC.*,TCM.S_Course_Code,TCM.S_Course_Name 
    FROM T_Invoice_Child_Header TIVC,T_Course_Master TCM
	WHERE TIVC.I_Invoice_Header_ID = @iInvoiceHeaderID
	AND TIVC.I_Course_ID=TCM.I_Course_ID


	SELECT @iCenterID = I_Centre_Id
	FROM T_Invoice_Parent 
	WHERE I_Invoice_Header_ID = @iInvoiceHeaderID

	SELECT @iCountryID = I_Country_ID
	FROM dbo.T_Centre_Master
	WHERE I_Centre_Id = @iCenterID
	
	
	SELECT DISTINCT ICD.*,TCFPD.I_Display_Fee_Component_ID,ICH.I_Course_ID,ICD.I_Fee_Component_ID,@iCountryID AS Country,@iCenterID AS Center,ICH.I_Course_ID,ICD.I_Fee_Component_ID,
		[dbo].fnGetCompanyShare(@dtReceiptDate,@iCountryID,@iCenterID,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID) AS N_Company_Share
	FROM T_Invoice_Child_Detail ICD
	INNER JOIN T_Invoice_Child_Header ICH
	ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
	INNER JOIN T_Course_Fee_Plan_Detail TCFPD
	ON TCFPD.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	AND TCFPD.I_Course_Fee_Plan_ID = ICH.I_Course_FeePlan_ID
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = @iCenterID
	AND BCD.I_Status = 1
	WHERE I_Invoice_Header_ID = @iInvoiceHeaderID 
	ORDER BY ICD.I_Fee_Component_ID


	DECLARE TABLE_CURSOR CURSOR FOR
	SELECT ICD.I_Invoice_Detail_ID FROM T_Invoice_Child_Detail ICD
	WHERE ICD.I_Invoice_Child_Header_ID IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_child_Header ICH WHERE ICH.I_Invoice_Header_ID = @iInvoiceHeaderID )
	ORDER BY Dt_Installment_Date 
	
	OPEN TABLE_CURSOR
	FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @TempTable
			SELECT IDT.I_Tax_ID, IDT.I_Invoice_Detail_ID,IDT.N_Tax_Value,TM.S_TAX_CODE AS TAX_CODE,TM.S_TAX_DESC AS TAX_DESC 
			FROM T_Invoice_Detail_Tax IDT, T_TAX_MASTER TM 
			WHERE 			
			IDT.I_Invoice_Detail_ID = @iInvoiceDetailId AND
			TM.I_TAX_ID = IDT.I_TAX_ID 
			
			FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId
		END
				
	CLOSE TABLE_CURSOR
	DEALLOCATE TABLE_CURSOR
	
	--TABLE[3] RETURNS TAX DEATILS	
	SELECT * FROM @TempTable
END
