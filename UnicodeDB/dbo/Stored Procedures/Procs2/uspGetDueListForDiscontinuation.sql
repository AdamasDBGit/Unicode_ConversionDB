CREATE PROCEDURE [dbo].[uspGetDueListForDiscontinuation]
    (
      @iBrandID INT ,
      @sHierarchyListID NVARCHAR(MAX) ,
      @sStudentID NVARCHAR(MAX) = NULL ,
      @sFirstName NVARCHAR(MAX) = NULL ,
      @sMiddleName NVARCHAR(MAX) = NULL ,
      @sLastName NVARCHAR(MAX) = NULL
    )
AS
    BEGIN

        DECLARE @dtUptoDate DATETIME= GETDATE();

        CREATE TABLE #DUEREPORT
            (
              I_Student_Detail_ID INT ,
              S_Mobile_No VARCHAR(50) ,
              S_Student_ID VARCHAR(100) ,
              I_Roll_No INT ,
              S_Student_Name VARCHAR(200) ,
              S_Invoice_No VARCHAR(100) ,
              S_Receipt_No VARCHAR(100) ,
              Dt_Invoice_Date DATETIME ,
              I_Fee_Component_ID INT ,
              S_Component_Name VARCHAR(100) ,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
              TypeofCentre VARCHAR(MAX) ,
              S_Brand_Name VARCHAR(100) ,
              S_Cost_Center VARCHAR(100) ,
              Due_Value REAL ,
              Dt_Installment_Date DATETIME ,
              I_Installment_No INT ,
              I_Parent_Invoice_ID INT ,
              I_Invoice_Detail_ID INT ,
              Revised_Invoice_Date DATETIME ,
              Tax_Value DECIMAL(14, 2) ,
              Total_Value DECIMAL(14, 2) ,
              Amount_Paid DECIMAL(14, 2) ,
              Tax_Paid DECIMAL(14, 2) ,
              Total_Paid DECIMAL(14, 2) ,
              Total_Due DECIMAL(14, 2) ,
              IsGSTImplemented INT ,
              Age INT ,
              instanceChain VARCHAR(MAX)
            )         
              
        INSERT  INTO #DUEREPORT
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = @sHierarchyListID, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtUptoDate = @dtUptoDate, -- datetime
                    @sStatus = 'ALL' -- varchar(100)
    
        IF ( @sStudentID IS NULL
             AND @sFirstName IS NULL
             AND @sMiddleName IS NULL
             AND @sLastName IS NULL
           )
            BEGIN
		
                SELECT  D.TypeofCentre ,
                        D.S_Center_Name ,
                        ISNULL(D.S_Course_Name, ' ') AS S_Course_Name ,
                        ISNULL(D.S_Batch_Name, ' ') AS S_Batch_Name ,
                        D.S_Student_ID ,
                        D.S_Student_Name ,
                        D.S_Invoice_No ,
                        D.I_Invoice_Detail_ID ,
                        D.I_Installment_No ,
                        CONVERT(DATE, D.Dt_Installment_Date) AS Dt_Installment_Date ,
                        D.S_Component_Name ,
                        SUM(ISNULL(D.Due_Value, 0.00)) AS BaseAmount ,
                        SUM(ISNULL(D.Tax_Value, 0.00)) AS TaxAmount ,
                        SUM(ISNULL(D.Total_Value, 0.00)) AS TotalAmount ,
                        SUM(ISNULL(D.Amount_Paid, 0.00)) AS BasePaid ,
                        SUM(ISNULL(D.Tax_Paid, 0.00)) AS TaxPaid ,
                        SUM(ISNULL(D.Total_Paid, 0.00)) AS TotalPaid ,
                        SUM(ISNULL(D.Total_Due, 0.00)) AS TotalDue
                FROM    #DUEREPORT AS D
                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.S_Student_ID = D.S_Student_ID
                        WHERE
                        D.I_Invoice_Detail_ID NOT IN
                        (
                        SELECT TDSI.I_Invoice_Detail_ID FROM dbo.T_Discontinue_Student_Interface AS TDSI WHERE TDSI.[Status] IS NULL
                        )
                GROUP BY D.TypeofCentre ,
                        D.S_Center_Name ,
                        ISNULL(D.S_Course_Name, ' ') ,
                        ISNULL(D.S_Batch_Name, ' ') ,
                        D.S_Student_ID ,
                        D.S_Student_Name ,
                        D.S_Invoice_No ,
                        D.I_Invoice_Detail_ID ,
                        D.I_Installment_No ,
                        CONVERT(DATE, D.Dt_Installment_Date) ,
                        D.S_Component_Name
                HAVING  SUM(ISNULL(D.Total_Due, 0.00)) <> 0
                ORDER BY D.TypeofCentre ,
                        D.S_Center_Name ,
                        ISNULL(D.S_Course_Name, ' ') ,
                        ISNULL(D.S_Batch_Name, ' ') ,
                        D.S_Student_ID ,
                        D.S_Invoice_No ,
                        D.I_Installment_No 
		
            END
		
        ELSE
            BEGIN
		
                SELECT  D.TypeofCentre ,
                        D.S_Center_Name ,
                        ISNULL(D.S_Course_Name, ' ') AS S_Course_Name ,
                        ISNULL(D.S_Batch_Name, ' ') AS S_Batch_Name ,
                        D.S_Student_ID ,
                        D.S_Student_Name ,
                        D.S_Invoice_No ,
                        D.I_Invoice_Detail_ID ,
                        D.I_Installment_No ,
                        CONVERT(DATE, D.Dt_Installment_Date) AS Dt_Installment_Date ,
                        D.S_Component_Name ,
                        SUM(ISNULL(D.Due_Value, 0.00)) AS BaseAmount ,
                        SUM(ISNULL(D.Tax_Value, 0.00)) AS TaxAmount ,
                        SUM(ISNULL(D.Total_Value, 0.00)) AS TotalAmount ,
                        SUM(ISNULL(D.Amount_Paid, 0.00)) AS BasePaid ,
                        SUM(ISNULL(D.Tax_Paid, 0.00)) AS TaxPaid ,
                        SUM(ISNULL(D.Total_Paid, 0.00)) AS TotalPaid ,
                        SUM(ISNULL(D.Total_Due, 0.00)) AS TotalDue
                FROM    #DUEREPORT AS D
                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.S_Student_ID = D.S_Student_ID
                WHERE   D.S_Student_ID LIKE ISNULL(@sStudentID, '') + '%'
                        AND TSD.S_First_Name LIKE ISNULL(@sFirstName, '')
                        + '%'
                        AND ISNULL(TSD.S_Middle_Name, '') LIKE ISNULL(@sMiddleName,
                                                              ISNULL(TSD.S_Middle_Name,
                                                              '')) + '%'
                        AND TSD.S_Last_Name LIKE ISNULL(@sLastName, '') + '%'
                        AND
                        D.I_Invoice_Detail_ID NOT IN
                        (
                        SELECT TDSI.I_Invoice_Detail_ID FROM dbo.T_Discontinue_Student_Interface AS TDSI WHERE TDSI.[Status] IS NULL
                        )
                GROUP BY D.TypeofCentre ,
                        D.S_Center_Name ,
                        ISNULL(D.S_Course_Name, ' ') ,
                        ISNULL(D.S_Batch_Name, ' ') ,
                        D.S_Student_ID ,
                        D.S_Student_Name ,
                        D.S_Invoice_No ,
                        D.I_Invoice_Detail_ID ,
                        D.I_Installment_No ,
                        CONVERT(DATE, D.Dt_Installment_Date) ,
                        D.S_Component_Name
                HAVING  SUM(ISNULL(D.Total_Due, 0.00)) <> 0
                ORDER BY D.TypeofCentre ,
                        D.S_Center_Name ,
                        ISNULL(D.S_Course_Name, ' ') ,
                        ISNULL(D.S_Batch_Name, ' ') ,
                        D.S_Student_ID ,
                        D.S_Invoice_No ,
                        D.I_Installment_No      
        
        
            END

    END

