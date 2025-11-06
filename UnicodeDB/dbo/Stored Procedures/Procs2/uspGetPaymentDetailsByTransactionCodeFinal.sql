CREATE PROCEDURE [dbo].[uspGetPaymentDetailsByTransactionCodeFinal]
    (
      @sBrandName Nnvarchar(max) ,
      @sStudentID Nnvarchar(max) ,
      @sTransactionCode Nnvarchar(max) ,
      @sExtReceiptNo Nnvarchar(max) = NULL ,
      @sSource Nnvarchar(max) ,
      @sStatus Nnvarchar(max) = NULL
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
                            AND TRH.I_Status = 1
                            AND TOPRM.S_Crtd_By = @sSource
                            AND TSD.S_Student_ID = @sStudentID
                            AND TCHND.I_Brand_ID = @iBrandID
                            GROUP BY TOPRM.S_Transaction_No
                ) T1    
		
		
        IF EXISTS ( SELECT  *
                    FROM    dbo.T_OnlinePayment_Receipt_Mapping AS TOPRM
                    WHERE   TOPRM.S_Transaction_No = @sTransactionCode
                            AND TOPRM.S_Crtd_By = @sSource )
            BEGIN
        
                SET @sStatus = 'OK'
		
                SELECT  @sStatus AS sStatus,
						@RAmountOnline AS RAmount,
                        @RTaxAmountOnline AS RTax
        
            END
        
        ELSE
            BEGIN
        
                SET @sStatus = 'NOT OK'
		
                SELECT  @sStatus AS sStatus,
						@RAmountOnline AS RAmount,
                        @RTaxAmountOnline AS RTax
        
            END
        
              
                
        

               
    END

