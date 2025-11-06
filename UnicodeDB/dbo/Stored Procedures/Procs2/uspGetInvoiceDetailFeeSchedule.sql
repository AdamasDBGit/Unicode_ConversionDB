
CREATE PROCEDURE [dbo].[uspGetInvoiceDetailFeeSchedule]  --[dbo].[uspGetInvoiceDetailFeeSchedule] 168173     
    (    
      @iInvoiceHeaderID INT          
    )    
AS     
    BEGIN          
        SET NOCOUNT ON ;          
        DECLARE @iInvoiceDetailId INT          
        DECLARE @TempTable TABLE    
            (    
              I_Tax_ID INT ,    
              I_Invoice_Detail_ID INT ,    
              N_Tax_Value NUMERIC(18, 6) ,    
              TAX_CODE VARCHAR(20) ,    
              TAX_DESC VARCHAR(50),
              TAX_CHECK INT    
            )          
 -- TABLE[0] RETURNS ALL THE INFORMATION FROM T_INVOICE_PARENT           
        SELECT  TIP.*,TIP2.S_Invoice_No AS S_Parent_Invoice_No,TSIH.I_Cancellation_Reason_ID    
        FROM    T_Invoice_Parent TIP WITH ( NOLOCK )    
        LEFT OUTER JOIN dbo.T_Student_Invoice_History AS TSIH    
        ON TIP.I_Parent_Invoice_ID = TSIH.I_Invoice_Header_ID    
        LEFT OUTER JOIN dbo.T_Invoice_Parent AS TIP2    
        ON TSIH.I_Invoice_Header_ID = TIP2.I_Invoice_Header_ID    
        WHERE   TIP.I_Invoice_Header_ID = @iInvoiceHeaderID          
          
 -- TABLE[1] RETURNS ALL THE FIELDS FROM T_Invoice_Child_Header          
        SELECT  TIVC.I_Invoice_Child_Header_ID ,    
                TIVC.I_Invoice_Header_ID ,    
                TIVC.I_Course_ID ,    
                TIVC.I_Course_FeePlan_ID ,    
                TIVC.C_Is_LumpSum ,    
                TIVC.N_Amount ,    
                ISNULL(TIVC.N_Tax_Amount, 0) AS N_Tax_Amount ,    
                TCM.S_Course_Code ,    
                TCM.S_Course_Name,  
                ISNULL(TCM.[I_Is_ST_Applicable],'Y') AS I_Is_ST_Applicable,  
                TIBM.I_Batch_ID    
        FROM    T_Invoice_Child_Header TIVC    
                LEFT OUTER JOIN T_Course_Master TCM WITH ( NOLOCK ) ON TIVC.I_Course_ID = TCM.I_Course_ID  LEFT OUTER JOIN dbo.T_Invoice_Batch_Map TIBM ON TIVC.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID  
        WHERE   TIVC.I_Invoice_Header_ID = @iInvoiceHeaderID          
         
          
 -- TABLE[2] RETURNS all the records from T_INVOICE_CHILD_DETAIL and TAX DEATILS ORDER BY DATE          
 --SELECT ICD.* FROM T_Invoice_Child_Detail ICD          
 --INNER JOIN T_Invoice_Child_Header ICH          
 --ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID          
 --WHERE I_Invoice_Header_ID = @iInvoiceHeaderID           
 --ORDER BY ICD.I_Fee_Component_ID          
           
           
        SELECT DISTINCT    
                ICD.*    
        FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )    
                INNER JOIN T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID    
                LEFT JOIN T_Course_Fee_Plan_Detail TCFPD WITH ( NOLOCK ) ON TCFPD.I_Fee_Component_ID = ICD.I_Fee_Component_ID    
                                                              AND TCFPD.I_Course_Fee_Plan_ID = ICH.I_Course_FeePlan_ID    
        WHERE   ICH.I_Invoice_Header_ID = @iInvoiceHeaderID    
        --ADDITION STARTED ON 26/06/2017
        --AND ISNULL(ICD.Flag_IsAdvanceTax,'') <> 'Y'
        --ADDITION ENDED ON 26/06/2017
        ORDER BY ICD.I_Fee_Component_ID          
          
          
        DECLARE TABLE_CURSOR CURSOR FOR          
        SELECT ICD.I_Invoice_Detail_ID FROM T_Invoice_Child_Detail ICD WITH (NOLOCK)          
        WHERE ICD.I_Invoice_Child_Header_ID IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_child_Header ICH WITH (NOLOCK) WHERE ICH.I_Invoice_Header_ID = @iInvoiceHeaderID )          
        ORDER BY Dt_Installment_Date           
           
        OPEN TABLE_CURSOR          
        FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId          
           
        WHILE @@FETCH_STATUS = 0     
            BEGIN          
                INSERT  INTO @TempTable    
                        SELECT  IDT.I_Tax_ID ,    
                                IDT.I_Invoice_Detail_ID , 
                                --IDT.N_Tax_Value,   
                                IDT.N_Tax_Value N_Tax_Value,    
                                TM.S_TAX_CODE AS TAX_CODE ,    
                                TM.S_TAX_DESC AS TAX_DESC,  
                                CASE WHEN TM.S_TAX_CODE = 'SGST' then 1
									 WHEN TM.S_TAX_CODE = 'CGST' then 2
									 WHEN TM.S_TAX_CODE = 'IGST' then 3
									 else 0
								end	 
									  
                        FROM    T_Invoice_Detail_Tax IDT ,    
                                T_TAX_MASTER TM ,
                                --ADDITION STARTED ON 26/06/2017
                                T_Invoice_Child_Detail ICD   
                                --ADDITION ENDED ON 26/06/2017
                    WHERE   IDT.I_Invoice_Detail_ID = @iInvoiceDetailId    
                                AND TM.I_TAX_ID = IDT.I_TAX_ID           
                                --ADDITION STARTED ON 26/06/2017
                                AND IDT.I_Invoice_Detail_ID  = ICD.I_Invoice_Detail_ID
                                AND ISNULL(ICD.Flag_IsAdvanceTax,'') <> 'Y'
                                --ADDITION ENDED ON 26/06/2017
             
                FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId          
            END          
              
        CLOSE TABLE_CURSOR          
        DEALLOCATE TABLE_CURSOR          
           
 --TABLE[3] RETURNS TAX DEATILS           
        SELECT  *    
        FROM    @TempTable          
    END
