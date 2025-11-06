


CREATE PROCEDURE [dbo].[uspCanculateTaxFactorforReceipt]
    (
      @InvoiceDetailId INT ,
      @I_Fee_Component_ID INT ,
      @ReceiptDate DATE = NULL	
    )
AS 
    BEGIN
	
--SET @I_Invoice_Header_ID = 40513
--SET @I_Fee_Component_ID = 42
--SET @I_Installment_No = 1
--SET @I_Course_FeePlan_ID = 34769
		

        DECLARE @oldtaxrate NUMERIC(20, 11)
        DECLARE @Newtaxrate NUMERIC(20, 11)
        DECLARE @Factor NUMERIC(20, 11)
        DECLARE @DTReceiptDate DATE

        SET @Factor = 1
        IF @ReceiptDate IS NOT NULL 
            BEGIN
                SET @DTReceiptDate = @ReceiptDate
            END
        ELSE 
            BEGIN
                SELECT  @DTReceiptDate = Dt_Installment_Date
                FROM    dbo.T_Invoice_Child_Detail
                WHERE   I_Invoice_Detail_ID = @InvoiceDetailId
            END
		
		
		
		
        SELECT  @oldtaxrate = ISNULL(SUM(TD.N_Tax_Rate), 0)
        FROM    T_Tax_Country_Fee_Component TD WITH ( NOLOCK )
        WHERE   TD.I_Fee_Component_ID = @I_Fee_Component_ID
                AND CONVERT(DATE, @DTReceiptDate) >= TD.Dt_Valid_From
                AND CONVERT(DATE, @DTReceiptDate) <= TD.Dt_Valid_To
                AND TD.I_Status = 1


        SELECT  @Newtaxrate = ISNULL(SUM(TD.N_Tax_Rate), 0)
        FROM    T_Tax_Country_Fee_Component TD WITH ( NOLOCK )
        WHERE   TD.I_Fee_Component_ID = @I_Fee_Component_ID
                AND CONVERT(DATE, GETDATE()) >= TD.Dt_Valid_From
                AND CONVERT(DATE, GETDATE()) <= TD.Dt_Valid_To
                AND TD.I_Status = 1
		
		
        --IF @Newtaxrate <> 0
        --    AND @oldtaxrate IS NOT NULL 
        --    BEGIN
        SET @Factor = ( @oldtaxrate + 100 ) / ( @Newtaxrate + 100 )
            --END
        SELECT  @Newtaxrate AS Newtaxrate ,
                @oldtaxrate AS oldtaxrate ,
                @Factor AS Factor
        
    END
