CREATE PROCEDURE [dbo].[uspGetReceiptDetails]      
(        
  @iReceiptID INT        
)        
AS        
BEGIN        
           
SELECT I_Receipt_Header_ID ,  
        S_Receipt_No ,  
        I_Invoice_Header_ID ,  
        Dt_Receipt_Date ,  
        I_Student_Detail_ID ,  
        I_PaymentMode_ID ,  
        I_Centre_Id ,  
        I_Enquiry_Regn_ID ,  
        N_Receipt_Amount ,  
        S_Fund_Transfer_Status ,  
        I_Status ,  
        Dt_CreditCard_Expiry ,  
        S_CreditCard_Issuer ,  
        S_Cancellation_Reason ,  
        N_CreditCard_No ,  
        S_ChequeDD_No ,  
        Dt_ChequeDD_Date ,  
        S_Bank_Name ,  
        S_Branch_Name ,  
        I_Receipt_Type ,  
        S_Crtd_By ,  
        S_Upd_By ,  
        Dt_Crtd_On ,  
        Dt_Upd_On ,  
        N_Tax_Amount ,  
        N_Amount_Rff ,  
        N_Receipt_Tax_Rff ,  
        S_AdjustmentRemarks FROM dbo.T_Receipt_Header AS trh  
        WHERE trh.I_Receipt_Header_ID = @iReceiptID  
      
    --SELECT I_Invoice_Header_ID ,  
    --        S_Invoice_No ,  
    --        I_Student_Detail_ID ,  
    --        I_Centre_Id ,  
    --        N_Invoice_Amount ,  
    --        N_Discount_Amount ,  
    --        N_Tax_Amount ,  
    --        Dt_Invoice_Date ,  
    --        I_Status ,  
    --        I_Discount_Scheme_ID ,  
    --        I_Discount_Applied_At ,  
    --        S_Crtd_By ,  
    --        S_Upd_By ,  
    --        Dt_Crtd_On ,  
    --        Dt_Upd_On ,  
    --        I_Coupon_Discount FROM dbo.T_Invoice_Parent AS tip  
    --WHERE tip.I_Student_Detail_ID = @iStudentID  
        
END
