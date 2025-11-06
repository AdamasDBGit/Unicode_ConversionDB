CREATE PROCEDURE [dbo].[uspGetPaymentDetailsByTransactionCode]
    (
      @sBrandName Nnvarchar(max) ,
      @sStudentID Nnvarchar(max) ,
      @sTransactionCode Nnvarchar(max) ,
      @sExtReceiptNo Nnvarchar(max) = NULL ,
      @sSource Nnvarchar(max) ,
      @RAmount DECIMAL(14, 2) ,
      @RTax DECIMAL(14, 2),
      @sStatus Nnvarchar(max)=NULL
    )
AS
    BEGIN

        DECLARE @RAmountOnline DECIMAL(14, 2)
        DECLARE @RTaxAmountOnline DECIMAL(14, 2)
        DECLARE @ReceiptHeaderID INT
        DECLARE @iBrandID INT
        DECLARE @iStatus INT= 0
        
        
        IF ( @sBrandName = 'RICE' )
            SET @iBrandID = 109
		
		
        SELECT  @RAmountOnline = T1.TotalTransBaseAmount ,
                @RTaxAmountOnline = T1.TotalTransTaxAmount
        FROM    ( SELECT  --@ReceiptHeaderID = TRH.I_Receipt_Header_ID ,
                            TOPRM.S_Transaction_No ,
                            SUM(ISNULL(TRH.N_Receipt_Amount, 0.00)) AS TotalTransBaseAmount ,
                            SUM(ISNULL(TRH.N_Tax_Amount, 0.00)) AS TotalTransTaxAmount
                  FROM      dbo.T_OnlinePayment_Receipt_Mapping AS TOPRM
                            INNER JOIN dbo.T_Receipt_Header AS TRH ON TRH.I_Receipt_Header_ID = TOPRM.I_Receipt_Header_ID
                            INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TRH.I_Student_Detail_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                  WHERE     TOPRM.S_Transaction_No = @sTransactionCode
                            AND TOPRM.S_Ext_Receipt_No = ISNULL(@sExtReceiptNo,
                                                              NULL)
                --AND TRH.I_Invoice_Header_ID = @iInvoiceHeaderID
                            AND TRH.I_Status = 1
                            AND TOPRM.S_Crtd_By = @sSource
                            AND TSD.S_Student_ID = @sStudentID
                --AND TOPRM.N_Amount=TRH.N_Receipt_Amount
                --AND TOPRM.N_Tax=TRH.N_Tax_Amount
                            AND TCHND.I_Brand_ID = @iBrandID
                            GROUP BY TOPRM.S_Transaction_No
                ) T1       
                
        
        IF ( @RAmountOnline = @RAmount
             AND @RTaxAmountOnline = @RTax
           )
            BEGIN
         
                SET @sStatus = 'OK'
		
                SELECT  @sStatus  AS sStatus,
                        @RAmount AS RAmount,
                        @RTax AS RTax
         
            END 
         
        ELSE
            BEGIN
         
                SET @sStatus = 'NOT OK'
		
                SELECT  @sStatus  AS sStatus,
                        @RAmount AS RAmount,
                        @RTax AS RTax
         
            END
               
 END

        --IF ( @ReceiptHeaderID IS NOT NULL
        --     AND @ReceiptHeaderID <> 0
        --   )
        --    BEGIN

        --        SET @iStatus = @iStatus + 1

        --        IF ( @RAmountOnline = ( SELECT  ISNULL(SUM(ISNULL(TRCD.N_Amount_Paid,
        --                                                      0.00)), 0.00) AS BaseAmountPaid
        --                                FROM    dbo.T_Receipt_Header AS TRH
        --                                        INNER JOIN dbo.T_Receipt_Component_Detail
        --                                        AS TRCD ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
        --                                WHERE   TRH.I_Receipt_Header_ID = @ReceiptHeaderID
        --                              ) )
        --            BEGIN

        --                SET @RAmount = @RAmountOnline
        --                SET @iStatus = @iStatus + 1

        --            END

        --        IF ( @RTaxAmountOnline = ( SELECT   ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid,
        --                                                      0.00)), 0.00) AS TaxPaid
        --                                   FROM     dbo.T_Receipt_Header AS TRH
        --                                            INNER JOIN dbo.T_Receipt_Component_Detail
        --                                            AS TRCD ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
        --                                            LEFT JOIN dbo.T_Receipt_Tax_Detail
        --                                            AS TRTD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
        --                                   WHERE    TRH.I_Receipt_Header_ID = @ReceiptHeaderID
        --                                 ) )
        --            BEGIN

        --                SET @RTax = @RTaxAmountOnline
        --                SET @iStatus = @iStatus + 1

        --            END





        --    END


        --IF ( @iStatus = 3 )
        --    BEGIN
		
        --        SET @sStatus = 'OK'
		
        --        SELECT  @sStatus ,
        --                @RAmount ,
        --                @RTax
		
        --    END
		
		
        --ELSE
        --    BEGIN
	
        --        SET @sStatus = 'NOT OK'
		
        --        SELECT  @sStatus ,
        --                @RAmount ,
        --                @RTax
	
        --    END

