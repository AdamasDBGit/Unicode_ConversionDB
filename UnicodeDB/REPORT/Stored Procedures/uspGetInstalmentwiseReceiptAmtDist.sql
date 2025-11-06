CREATE PROCEDURE [REPORT].[uspGetInstalmentwiseReceiptAmtDist]
(
@iBrandID INT,
@sHierarchyListID VARCHAR(MAX),
@StudentID VARCHAR(MAX)
)

AS

BEGIN


--DECLARE @StudentID VARCHAR(MAX)

--SET @StudentID='1415/RICE/14704'
--SET @StudentID='1617/rice/1349'

SELECT  InvoiceDue.S_Student_ID ,
		InvoiceDue.StdName,
		InvoiceDue.S_Invoice_No,
		InvoiceDue.InvoiceDate,
        InvoiceDue.I_Invoice_Header_ID ,
        InvoiceDue.I_Invoice_Detail_ID ,
        InvoiceDue.I_Installment_No ,
        InvoiceDue.Dt_Installment_Date ,
        InvoiceDue.S_Component_Name ,
        InvoiceDue.N_Amount_Due ,
        ReceiptAmt.ReceiptCompAmount ,
        InvoiceTax.TotalTax,
        ReceiptTax.ReceiptCompTax,
        (InvoiceDue.N_Amount_Due-ISNULL(ReceiptAmt.ReceiptCompAmount,0.0)) AS BaseAmtDiff,
        (ISNULL(InvoiceTax.TotalTax,0.0)-ISNULL(ReceiptTax.ReceiptCompTax,0.0)) AS TaxDiff
FROM    ( SELECT    TSD.S_Student_ID ,
					TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name AS StdName,
					TIP.S_Invoice_No,
					CONVERT(DATE,TIP.Dt_Invoice_Date) AS InvoiceDate,
                    TIP.I_Invoice_Header_ID ,
                    TICD.I_Invoice_Detail_ID ,
                    TICD.I_Installment_No ,
                    TICD.Dt_Installment_Date ,
                    TFCM.S_Component_Name ,
                    TICD.N_Amount_Due
          FROM      dbo.T_Invoice_Parent TIP
                    INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                    INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                    INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                    INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
          WHERE     TSD.S_Student_ID = @StudentID
                    AND TIP.I_Status IN ( 1, 3 ) AND TIP.I_Centre_Id IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyListID,@iBrandID) FGCFR)
--ORDER BY TSD.S_Student_ID,TIP.I_Invoice_Header_ID,TICD.Dt_Installment_Date,TICD.I_Installment_No,TFCM.S_Component_Name
          
        ) InvoiceDue
        LEFT JOIN ( SELECT  I_Invoice_Detail_ID ,
                            ISNULL(SUM(ISNULL(N_Tax_Value, 0.0)),0.0) AS TotalTax
                    FROM    dbo.T_Invoice_Detail_Tax TIDT
                    GROUP BY I_Invoice_Detail_ID
                  ) InvoiceTax ON InvoiceDue.I_Invoice_Detail_ID = InvoiceTax.I_Invoice_Detail_ID
        LEFT JOIN ( SELECT  TRCD.I_Invoice_Detail_ID ,
                            ISNULL(SUM(TRCD.N_Amount_Paid),0.0) AS ReceiptCompAmount
                    FROM    dbo.T_Receipt_Component_Detail TRCD
                            INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                    WHERE   TRH.I_Status = 1
                    GROUP BY TRCD.I_Invoice_Detail_ID
                  ) ReceiptAmt ON InvoiceDue.I_Invoice_Detail_ID = ReceiptAmt.I_Invoice_Detail_ID
        LEFT JOIN ( SELECT  TRTD.I_Invoice_Detail_ID ,
                            ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid, 0.0)),0.0) AS ReceiptCompTax
                    FROM    dbo.T_Receipt_Tax_Detail TRTD
                            INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                            INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                    WHERE   TRH.I_Status = 1
                    GROUP BY TRTD.I_Invoice_Detail_ID
                  ) ReceiptTax ON InvoiceDue.I_Invoice_Detail_ID = ReceiptTax.I_Invoice_Detail_ID
ORDER BY InvoiceDue.S_Student_ID ,
        InvoiceDue.I_Invoice_Header_ID ,
        InvoiceDue.I_Installment_No ,
        InvoiceDue.Dt_Installment_Date ,
        InvoiceDue.S_Component_Name 
        
        
        
        --SELECT TSD.S_Student_ID,TRH.I_Invoice_Header_ID,SUM(TRH.N_Receipt_Amount)+SUM(TRH.N_Tax_Amount) AS TotalPaid FROM dbo.T_Receipt_Header TRH
        --INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
        --WHERE
        --TRH.I_Status=1 AND TSD.S_Student_ID=@StudentID AND TRH.I_Invoice_Header_ID IS NOT NULL
        --GROUP BY TSD.S_Student_ID,TRH.I_Invoice_Header_ID
        
        END
