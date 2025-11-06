/*****************************************************************************************************************    
Created by: Debman Mukherjee    
Date: 03/04/2007    
Description: Select List of components that were to be paid before the present date    
Parameters:     
Returns:     
Modified By:     
******************************************************************************************************************/    

CREATE PROCEDURE [dbo].[uspGetInvoice] 
    (
      @iInvoiceHeaderID INT    
    )
AS 
    BEGIN    
    
        SELECT  *
        FROM    T_Invoice_Parent
        WHERE   I_Invoice_Header_ID = @iInvoiceHeaderID    
    
        SELECT DISTINCT
                ICH.* ,
                tibm.I_Batch_ID ,
                CM.S_Course_Code ,
                CM.I_Is_ST_Applicable ,
                ISNULL(CDM.N_Course_Duration, 0) AS N_Course_Duration ,
                tsbm.Dt_BatchStartDate AS Dt_Course_Start_Date ,
                tsbm.Dt_Course_Expected_End_Date ,
                ISNULL(tsbm.Dt_Course_Actual_End_Date,
                       tsbm.Dt_Course_Expected_End_Date) AS Dt_Course_Actual_End_Date
        FROM    T_Invoice_Child_Header ICH
                LEFT OUTER JOIN dbo.T_Course_Master CM ON ICH.I_Course_ID = CM.I_Course_ID
                LEFT OUTER JOIN dbo.T_Course_Fee_Plan CFP ON ICH.I_Course_FeePlan_ID = CFP.I_Course_Fee_Plan_ID
                LEFT OUTER JOIN dbo.T_Course_Delivery_Map CDM ON CFP.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
                LEFT OUTER JOIN dbo.T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
                LEFT OUTER JOIN dbo.T_Invoice_Batch_Map AS tibm ON ICH.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID
                LEFT OUTER JOIN dbo.T_Student_Batch_Master AS tsbm ON tibm.I_Batch_ID = tsbm.I_Batch_ID
        WHERE   ICH.I_Invoice_Header_ID = @iInvoiceHeaderID
                AND (tibm.I_Status = 1  OR tibm.I_Status IS NULL)  
    
        SELECT  ICD.*
        FROM    T_Invoice_Child_Detail ICD
                INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
        WHERE   I_Invoice_Header_ID = @iInvoiceHeaderID    
    
        SELECT  IDT.*
        FROM    T_Invoice_Detail_Tax IDT
                INNER JOIN T_Invoice_Child_Detail ICD ON IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
        WHERE   I_Invoice_Header_ID = @iInvoiceHeaderID    
    
    END
