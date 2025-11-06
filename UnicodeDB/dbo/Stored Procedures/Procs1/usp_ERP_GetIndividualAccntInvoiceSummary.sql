
--sp_helptext uspGetInvoiceSummary  '53088'        
                
CREATE PROCEDURE [dbo].[usp_ERP_GetIndividualAccntInvoiceSummary]  --'8773'        
    (  
      @iInvoiceID INT  
    )  
AS   
    SET NOCOUNT OFF                  
    BEGIN TRY   
  
        SELECT  T1.S_Component_Name IndividualAccComponentName ,  
                T1.Amt ,  
                T2.TaxAmt ,  
                T1.Amt + T2.TaxAmt AS Total  
        FROM    ( SELECT    TFCM.S_Component_Name ,  
                            SUM(ISNULL(TICD.N_Amount_Due, 0)) AS Amt  
                  FROM      dbo.T_Invoice_Parent AS TIP  
                            INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID  
                            INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID  
                            INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID  
                  WHERE     TIP.I_Invoice_Header_ID = @iInvoiceID  
                            AND TIP.I_Status = 1  
                            AND TFCM.I_Fee_Component_Type_ID = 2  
                  GROUP BY  TFCM.S_Component_Name  
                ) T1  
                INNER JOIN ( SELECT TFCM.S_Component_Name ,  
                                    SUM(ISNULL(TIDT.N_Tax_Value, 0)) AS TaxAmt  
                             FROM   dbo.T_Invoice_Parent AS TIP  
                                    INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID  
                                    INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID  
                                    LEFT OUTER JOIN dbo.T_Invoice_Detail_Tax  
                                    AS TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID  
                                    INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID  
                             WHERE  TIP.I_Invoice_Header_ID = @iInvoiceID  
                                    AND TIP.I_Status = 1  
                                    AND TFCM.I_Fee_Component_Type_ID = 2  
                             GROUP BY TFCM.S_Component_Name  
                           ) T2 ON T1.S_Component_Name = T2.S_Component_Name  
  
    END TRY                  
                  
    BEGIN CATCH                  
 --Error occurred:                    
                  
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT                  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()                  
                  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                  
    END CATCH
