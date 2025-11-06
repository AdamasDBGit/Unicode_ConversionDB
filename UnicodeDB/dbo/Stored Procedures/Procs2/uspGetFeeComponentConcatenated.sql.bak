CREATE PROCEDURE [dbo].[uspGetFeeComponentConcatenated]
    (
      @iReceiptHeaderID INT
    )
AS 
    BEGIN
    
    CREATE TABLE #temp
    (
    FeeComponentList VARCHAR(MAX)
    )

        DECLARE @Names VARCHAR(8000)

        SELECT  @Names = COALESCE(@Names + ',', '') + TT.Component
        FROM    ( SELECT DISTINCT
                            TFCM.S_FeeComponentForSMS AS Component
                  FROM      dbo.T_Receipt_Component_Detail TRCD
                            INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                            INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                            INNER JOIN dbo.T_Receipt_Header TRH ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                  WHERE     TRCD.I_Receipt_Detail_ID = @iReceiptHeaderID
                ) TT
                
                INSERT INTO #temp
                        ( FeeComponentList )
                VALUES  ( @Names  -- FeeComponentList - int
                          )
                          
                          SELECT FeeComponentList FROM #temp T;

    END
