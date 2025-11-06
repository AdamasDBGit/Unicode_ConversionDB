CREATE PROCEDURE [dbo].[uspGetActiveInvoiceByStudentId]
    (
      @iStudentDetailID INT ,
      @iCenterID INT = NULL  
    )
AS 
    BEGIN   
  
  
        DECLARE @iBatchID INT  
  
        SELECT  @iBatchID = I_Batch_ID
        FROM    T_Student_Batch_Details
        WHERE   I_Student_ID = @iStudentDetailID
                AND I_Status = 1  
  
  
  
  
  
        SELECT  A.I_Invoice_Header_ID ,
                S_Invoice_No ,
                I_Student_Detail_ID ,
                I_Centre_Id ,
                N_Invoice_Amount ,
                A.N_Discount_Amount ,
                A.N_Tax_Amount ,
                Dt_Invoice_Date ,
                A.I_Status ,
                A.I_Discount_Scheme_ID ,
                A.I_Discount_Applied_At ,
                A.S_Crtd_By ,
                S_Upd_By ,
                A.Dt_Crtd_On ,
                Dt_Upd_On ,
                I_Coupon_Discount ,
                I_Parent_Invoice_ID
        FROM    T_Invoice_Parent A
                INNER JOIN T_Invoice_Child_Header B ON A.I_Invoice_Header_ID = B.I_Invoice_Header_ID
                INNER JOIN T_Invoice_Batch_Map C ON C.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID
        WHERE   I_Student_Detail_ID = @iStudentDetailID
                AND I_Centre_Id = ISNULL(@iCenterID, I_Centre_Id)
                AND A.I_Status in (1,3)
                AND C.I_Status = 1
                AND I_Batch_ID = @iBatchID  
  
  
    END
