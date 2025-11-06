CREATE PROCEDURE [dbo].[uspGetStudentOnAccountReceipts]
    (
      @iStudentDetailID INT = NULL ,
      @iEnquiryID INT ,
      @iCenterID INT        
    )
AS 
    BEGIN          
        SELECT  I_Student_Detail_ID ,
                I_Enquiry_Regn_ID ,
                N_Receipt_Amount ,
                N_Tax_Amount ,
                S_Receipt_No ,
                Dt_Receipt_Date ,
                I_Receipt_Header_ID ,
                I_Receipt_Type
        FROM    dbo.T_Receipt_Header AS TRH
        WHERE   I_Receipt_Type <> 2
                AND I_Centre_Id = @iCenterID
                AND ( I_Student_Detail_ID = @iStudentDetailID
                      OR I_Enquiry_Regn_ID = @iEnquiryID
                    )
                AND I_Status <> 0
        ORDER BY Dt_Receipt_Date DESC
    END
