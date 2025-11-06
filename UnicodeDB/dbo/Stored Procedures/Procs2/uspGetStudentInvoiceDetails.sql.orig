CREATE PROCEDURE [dbo].[uspGetStudentInvoiceDetails]
    (
      @sStudentCode VARCHAR(500) ,
      @sStudentFName VARCHAR(50) ,
      @sStudentMName VARCHAR(50) ,
      @sStudentLName VARCHAR(50) ,
      @sInvoiceNo VARCHAR(50) ,
      @iCentreId INT      
    )
AS
    BEGIN      
      
        SET NOCOUNT OFF      
        SELECT  A.I_Invoice_Header_ID ,
                A.N_Invoice_Amount ,
                A.N_Discount_Amount ,
                A.S_Invoice_No ,
                A.Dt_Invoice_Date ,
                A.N_Tax_Amount ,
                B.I_Student_Detail_ID ,
                B.S_Student_ID ,
                ISNULL(B.S_First_Name, '') AS S_First_Name ,
                ISNULL(B.S_Middle_Name, '') AS S_Middle_Name ,
                ISNULL(B.S_Last_Name, '') AS S_Last_Name ,
                C.S_Center_Name ,
                TERD.I_Corporate_Plan_ID
        FROM    dbo.T_Student_Detail B
                INNER JOIN dbo.T_Invoice_Parent A ON A.I_Student_Detail_ID = B.I_Student_Detail_ID
                INNER JOIN dbo.T_Centre_Master C ON A.I_Centre_Id = C.I_Centre_Id
                INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON B.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                LEFT OUTER JOIN CORPORATE.T_Corporate_Plan AS TCP ON TERD.I_Corporate_Plan_ID = TCP.I_Corporate_Plan_ID
        WHERE   (ISNULL(A.I_Status, 1) IN ( 1, 3 ) OR (A.Dt_Upd_On>='2017-07-01' AND A.I_Status=0 AND A.S_Cancel_Type=1))       
-- Commented on 13-Oct-2008 to reflect dropout students in invoice payment receipt generation --        
--AND ISNULL(B.I_Status,1) = 1        
                AND B.S_Student_ID LIKE ISNULL(@sStudentCode, B.S_Student_ID)
                AND A.S_Invoice_No LIKE ISNULL(@sInvoiceNo, A.S_Invoice_No)
                + '%'
                AND B.S_First_Name LIKE ISNULL(@sStudentFName, B.S_First_Name)
                + '%'
                AND ISNULL(B.S_Middle_Name, '') LIKE ISNULL(@sStudentMName, '')
                + '%'
                AND B.S_Last_Name LIKE ISNULL(@sStudentLName, B.S_Last_Name)
                + '%'
                AND A.I_Centre_Id = ISNULL(@iCentreId, A.I_Centre_Id)
                AND ( TCP.I_Corporate_Plan_Type_ID IS NULL
                      OR TCP.I_Corporate_Plan_Type_ID = 3
                    )
        ORDER BY B.S_Student_ID        
      
    END
