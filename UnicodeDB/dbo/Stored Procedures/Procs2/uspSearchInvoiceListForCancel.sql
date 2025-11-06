CREATE PROCEDURE [dbo].[uspSearchInvoiceListForCancel] -- 11,'','','sa','',''  
    (      
      @iCenterId INT = NULL ,      
      @sInvoiceId NVARCHAR(max) = NULL ,      
      @sStudentId NVARCHAR(max) = NULL ,      
      @sStudentFirstName NVARCHAR(max) = NULL ,      
      @sStudentSecondName NVARCHAR(max) = NULL ,      
      @sStudentLastName NVARCHAR(max) = NULL          
    )      
AS       
    BEGIN          
        SET NOCOUNT ON ;          
        DECLARE @sStudentName nvarchar(max)          
        DECLARE @sStudentDetailId INT          
          
        SELECT  TIP.I_Student_Detail_ID ,      
                TIP.I_Invoice_Header_ID ,      
                ISNULL(TSD.S_First_Name, '') ,      
                ISNULL(TSD.S_Middle_Name, '') ,      
                ISNULL(TSD.S_Last_Name, '') ,      
                TSD.S_STUDENT_ID ,      
                TIP.S_Invoice_No ,      
                TIP.Dt_Invoice_Date      
        FROM    T_INVOICE_PARENT TIP ,      
                T_STUDENT_DETAIL TSD ,      
                T_STUDENT_CENTER_DETAIL TSCD      
        WHERE   TSCD.I_Centre_Id = @iCenterId  
				AND TIP.I_Centre_ID = @iCenterId
                AND TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID      
                AND TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID      
                AND TIP.S_Invoice_No LIKE ISNULL(@sInvoiceId, TIP.S_Invoice_No)+'%'      
                AND TSD.S_Student_ID LIKE ISNULL(@sStudentId, TSD.S_Student_ID)+'%'     
                AND TSD.S_First_Name LIKE ISNULL(@sStudentFirstName,      
                                                 TSD.S_First_Name) + '%'      
                 AND ISNULL(TSD.S_Middle_Name,'') LIKE ISNULL(@sStudentSecondName,      
                                                  ISNULL(TSD.S_Middle_Name,'')) + '%'    
                AND TSD.S_Last_Name LIKE ISNULL(@sStudentLastName,      
                                                TSD.S_Last_Name) + '%'      
                AND TIP.I_STATUS in (1,3)      
                AND TSD.I_Status = 1      
                AND ISNULL([TSD].[S_Is_Corporate], 'N') = 'N'      
        ORDER BY TSD.S_Student_ID          
          
    END


