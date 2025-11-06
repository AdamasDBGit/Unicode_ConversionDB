CREATE PROCEDURE [REPORT].[uspGetAccrualvsAdjustmentwithAging]
(
@sHierarchyListID VARCHAR(MAX),
@iBrandID INT,
@dtStartDate DATETIME,
@dtEndDate DATETIME,
@iVal INT
)
AS

BEGIN

DECLARE @i INT

SET @i=0

CREATE TABLE #temp
(
CenterName VARCHAR(MAX),
CourseName VARCHAR(MAX),
BatchName VARCHAR(MAX),
StudentID VARCHAR(MAX),
StudentName VARCHAR(MAX),
ContactNo VARCHAR(MAX),
RollNo INT,
InvHeaderID INT,
InvNo VARCHAR(MAX),
InvDetID INT,
InstNo INT,
InstDate DATE,
MonthYear VARCHAR(MAX),
Aging INT,
ComponentName VARCHAR(MAX),
AmountDue DECIMAL(14,2),
AmountPaid DECIMAL(14,2),
TaxDue DECIMAL(14,2),
TaxPaid DECIMAL(14,2),
AmtDiff DECIMAL(14,2),
TaxDiff DECIMAL(14,2),
TotalDiff DECIMAL(14,2)
)

WHILE (@i<=@iVal)

BEGIN

INSERT INTO #temp
        ( CenterName ,
          CourseName ,
          BatchName ,
          StudentID ,
          StudentName ,
          ContactNo ,
          RollNo ,
          InvHeaderID ,
          InvNo ,
          InvDetID ,
          InstNo ,
          InstDate ,
          MonthYear ,
          Aging ,
          ComponentName ,
          AmountDue ,
          AmountPaid ,
          TaxDue ,
          TaxPaid ,
          AmtDiff ,
          TaxDiff ,
          TotalDiff
        )
SELECT Final.S_Center_Name ,
                Final.S_Course_Name ,
                Final.S_Batch_Name ,
                Final.S_Student_ID ,
                Final.StudentName ,
                Final.ContactNo,
                Final.I_RollNo ,
                Final.I_Invoice_Header_ID ,
                Final.S_Invoice_No ,
                Final.I_Invoice_Detail_ID ,
                Final.I_Installment_No ,
                Final.Dt_Installment_Date ,
                DATENAME(MONTH,Final.Dt_Installment_Date)+' '+CAST(DATEPART(YYYY,Final.Dt_Installment_Date) AS VARCHAR) AS MonthYear,
                DATEDIFF(m,Final.Dt_Installment_Date,GETDATE()) AS Ageing,
                Final.S_Component_Name ,
                Final.N_Amount_Due ,
                Final.ReceiptCompAmount ,
                Final.TotalTax ,
                Final.ReceiptCompTax,
                Final.BaseAmtDiff,
                Final.TaxDiff,
                Final.BaseAmtDiff+Final.TaxDiff AS TotalDiff
		FROM
		(
        SELECT  InvoiceDue.S_Center_Name ,
                InvoiceDue.S_Course_Name ,
                InvoiceDue.S_Batch_Name ,
                InvoiceDue.S_Student_ID ,
                InvoiceDue.StudentName ,
                InvoiceDue.ContactNo,
                InvoiceDue.I_RollNo ,
                InvoiceDue.I_Invoice_Header_ID ,
                InvoiceDue.S_Invoice_No ,
                InvoiceDue.I_Invoice_Detail_ID ,
                InvoiceDue.I_Installment_No ,
                InvoiceDue.Dt_Installment_Date ,
                InvoiceDue.S_Component_Name ,
                InvoiceDue.N_Amount_Due ,
                ReceiptAmt.ReceiptCompAmount ,
                InvoiceTax.TotalTax ,
                ReceiptTax.ReceiptCompTax ,
                ( InvoiceDue.N_Amount_Due
                  - ISNULL(ReceiptAmt.ReceiptCompAmount, 0.0) ) AS BaseAmtDiff ,
                ( ISNULL(InvoiceTax.TotalTax, 0.0)
                  - ISNULL(ReceiptTax.ReceiptCompTax, 0.0) ) AS TaxDiff
        FROM    ( SELECT    TCHND.S_Center_Name ,
                            TCM.S_Course_Name ,
                            TSBM.S_Batch_Name ,
                            TSD.S_Student_ID ,
                            TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name,
                                                            '') + ' '
                            + TSD.S_Last_Name AS StudentName ,
                            TSD.S_Mobile_No AS ContactNo,
                            TSD.I_RollNo ,
                            TIP.I_Invoice_Header_ID ,
                            TIP.S_Invoice_No ,
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
                            INNER JOIN ( SELECT T1.I_Student_ID ,
                                                T2.I_Batch_ID
                                         FROM   ( SELECT    TSBD2.I_Student_ID ,
                                                            MAX(TSBD2.I_Student_Batch_ID) AS ID
                                                  FROM      dbo.T_Student_Batch_Details TSBD2
                                                  WHERE     TSBD2.I_Status IN (
                                                            1, 3 ,2,0)
                                                  GROUP BY  TSBD2.I_Student_ID
                                                ) T1
                                                INNER JOIN ( SELECT
                                                              TSBD3.I_Student_ID ,
                                                              TSBD3.I_Student_Batch_ID AS ID ,
                                                              TSBD3.I_Batch_ID
                                                             FROM
                                                              dbo.T_Student_Batch_Details TSBD3
                                                             WHERE
                                                              TSBD3.I_Status IN (
                                                              1, 3 ,2,0)
                                                           ) T2 ON T1.I_Student_ID = T2.I_Student_ID
                                                              AND T1.ID = T2.ID
                                       ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                                 AND TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                            INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                            INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                  WHERE     TICD.Dt_Installment_Date >= DATEADD(d,-(@i*360),@dtStartDate)
                            AND TICD.Dt_Installment_Date < DATEADD(d,1,DATEADD(d,-(@i*360),@dtEndDate))
                            --AND TSD.S_Student_ID='1314/AC/1376'
                            AND TCHND.I_Center_ID IN (
                            SELECT  FGCFR.centerID
                            FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                            AND TIP.I_Status IN ( 1, 3 )
--ORDER BY TSD.S_Student_ID,TIP.I_Invoice_Header_ID,TICD.Dt_Installment_Date,TICD.I_Installment_No,TFCM.S_Component_Name
                  
                ) InvoiceDue
                LEFT JOIN ( SELECT  I_Invoice_Detail_ID ,
                                    ISNULL(SUM(ISNULL(N_Tax_Value, 0.0)), 0.0) AS TotalTax
                            FROM    dbo.T_Invoice_Detail_Tax TIDT
                            GROUP BY I_Invoice_Detail_ID
                          ) InvoiceTax ON InvoiceDue.I_Invoice_Detail_ID = InvoiceTax.I_Invoice_Detail_ID
                LEFT JOIN ( SELECT  TRCD.I_Invoice_Detail_ID ,
                                    ISNULL(SUM(TRCD.N_Amount_Paid), 0.0) AS ReceiptCompAmount
                            FROM    dbo.T_Receipt_Component_Detail TRCD
                                    INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                            WHERE   TRH.I_Status = 1
                            GROUP BY TRCD.I_Invoice_Detail_ID
                          ) ReceiptAmt ON InvoiceDue.I_Invoice_Detail_ID = ReceiptAmt.I_Invoice_Detail_ID
                LEFT JOIN ( SELECT  TRTD.I_Invoice_Detail_ID ,
                                    ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid, 0.0)),
                                           0.0) AS ReceiptCompTax
                            FROM    dbo.T_Receipt_Tax_Detail TRTD
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                                    INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                            WHERE   TRH.I_Status = 1
                            GROUP BY TRTD.I_Invoice_Detail_ID
                          ) ReceiptTax ON InvoiceDue.I_Invoice_Detail_ID = ReceiptTax.I_Invoice_Detail_ID
        --ORDER BY InvoiceDue.S_Student_ID ,
        --        InvoiceDue.I_Invoice_Header_ID ,
        --        InvoiceDue.I_Installment_No ,
        --        InvoiceDue.Dt_Installment_Date ,
        --        InvoiceDue.S_Component_Name 
        ) Final
        --WHERE
        --(Final.TaxDiff+Final.BaseAmtDiff)!=0
        ORDER BY Final.S_Center_Name,Final.S_Course_Name,Final.S_Batch_Name,Final.S_Student_ID ,
                Final.I_Invoice_Header_ID ,
                Final.I_Installment_No ,
                Final.Dt_Installment_Date ,
                Final.S_Component_Name
                
                
                SET @i=@i+1
                
                END
                
                SELECT * FROM #temp WHERE TotalDiff>0.00;
                
                
                END
