CREATE PROCEDURE [dbo].[uspGetNewAttendanceDataAIS]
AS 
    BEGIN
        DECLARE @dtDate DATETIME= GETDATE() ;

        CREATE TABLE #temp
            (
              I_Student_Detail_ID INT ,
              S_Mobile_No VARCHAR(50) ,
              S_Student_ID VARCHAR(100) ,
              I_Roll_No INT ,
              S_Student_Name VARCHAR(200) ,
              S_Invoice_No VARCHAR(100) ,
              S_Receipt_No VARCHAR(100) ,
              Dt_Invoice_Date DATETIME ,
              S_Component_Name VARCHAR(100) ,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
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
              sInstance VARCHAR(MAX)
            )

        INSERT  INTO #temp
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = '53', -- varchar(max)
                    @iBrandID = 107, -- int
                    @dtUptoDate = @dtDate, -- datetime
                    @sStatus = 'ALL' -- varchar(100)
                    
                    
        --INSERT  INTO dbo.T_AttendanceDataALLEntities
        --        ( StudentDetailID ,
        --          EmpCode ,
        --          Title ,
        --          EmpName ,
        --          DepartmentName ,
        --          LocationName ,
        --          CompanyName ,
        --          IsAttendenceIncluded ,
        --          IsActive
        --        )
                SELECT  'ST' + CAST(T4.I_Student_Detail_ID AS VARCHAR) AS StudentDetID ,
                        T4.S_Student_ID ,
                        T4.S_Title ,
                        T4.StudentName ,
                        T4.I_Center_ID ,
                        T4.S_Center_Name ,
                        --T4.S_Batch_Name,
                        T4.S_Brand_Name ,
                        'YES' AS IsAttendanceIncluded ,
                        CASE WHEN T4.Discontinued = 1
                                  OR T4.Dropout = 1
                                  OR T4.IsOnLeave = 1
                                  OR T4.Defaulter = 1 THEN 'NO'
                             WHEN T4.Discontinued = 0
                                  AND T4.Dropout = 0
                                  AND T4.IsOnLeave = 0
                                  AND T4.Defaulter = 0 THEN 'YES'
                        END AS IsActive
                FROM    ( SELECT    T1.I_Student_Detail_ID ,
                                    T1.S_Student_ID ,
                                    T1.S_Title ,
                                    T1.StudentName ,
                                    T1.S_Batch_Name ,
                                    T1.I_Center_ID ,
                                    T1.S_Center_Name ,
                                    T1.S_Brand_Name ,
                                    T1.Discontinued ,
                                    T1.Dropout ,
                                    CASE WHEN T2.IsOnLeave IS NULL THEN 0
                                         WHEN T2.IsOnLeave = 1 THEN 1
                                    END AS IsOnLeave ,
                                    CASE WHEN T3.Defaulter IS NULL THEN 0
                                         WHEN T3.Defaulter = 1 THEN 1
                                    END AS Defaulter
                          FROM      ( SELECT    TSD.I_Student_Detail_ID ,
                                                TSD.S_Student_ID ,
                                                CASE WHEN TERD.I_Sex_ID = 1
                                                     THEN 'Mr.'
                                                     WHEN TERD.I_Sex_ID = 2
                                                     THEN 'Ms.'
                                                END AS S_Title ,
                                                TSD.S_First_Name + ' '
                                                + ISNULL(TSD.S_Middle_Name, '')
                                                + ' ' + TSD.S_Last_Name AS StudentName ,
                                                TSBM.S_Batch_Name ,
                                                TCHND.I_Center_ID ,
                                                TCHND.S_Center_Name ,
                                                TCHND.S_Brand_Name ,
                                                1 - TSD.I_Status AS Discontinued ,
                                                0 AS Dropout
                                      FROM      dbo.T_Student_Detail TSD
                                                INNER JOIN ( SELECT
                                                              T1.I_Student_ID ,
                                                              T2.I_Batch_ID
                                                             FROM
                                                              ( SELECT
                                                              TSBD2.I_Student_ID ,
                                                              MAX(TSBD2.I_Student_Batch_ID) AS ID
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD2
                                                              WHERE
                                                              TSBD2.I_Status IN (
                                                              1, 3 )
                                                              GROUP BY TSBD2.I_Student_ID
                                                              ) T1
                                                              INNER JOIN ( SELECT
                                                              TSBD3.I_Student_ID ,
                                                              TSBD3.I_Student_Batch_ID AS ID ,
                                                              TSBD3.I_Batch_ID
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD3
                                                              WHERE
                                                              TSBD3.I_Status IN (
                                                              1, 3 )
                                                              ) T2 ON T1.I_Student_ID = T2.I_Student_ID
                                                              AND T1.ID = T2.ID
                                                           ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                                      WHERE     TCHND.I_Brand_ID = 107 AND TSBM.Dt_Course_Expected_End_Date>=@dtDate
                                      
                                    ) T1
                                    LEFT JOIN ( SELECT  TSLR.I_Student_Detail_ID ,
                                                        1 AS IsOnLeave
                                                FROM    dbo.T_Student_Leave_Request TSLR
                                                WHERE   TSLR.I_Status = 1
                                                        AND @dtDate BETWEEN TSLR.Dt_From_Date
                                                              AND
                                                              TSLR.Dt_To_Date
                                              ) T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
                                    LEFT JOIN ( SELECT  DISTINCT
                                                        XX.S_Student_ID ,
                                                        1 AS Defaulter
                                                FROM    ( SELECT
                                                              S_Student_ID ,
                                                              SUM(ISNULL(Total_Due,
                                                              0)) AS TotalDue
                                                          FROM
                                                              #temp TTT
                                                          WHERE
                                                              DATEDIFF(d,
                                                              TTT.Dt_Installment_Date,
                                                              GETDATE()) >= 10
                                                        --AND T1.S_Student_ID=@Sstudentid      
                                                          GROUP BY S_Student_ID
                                                        ) XX
                                                WHERE   XX.TotalDue >= 100
                                              ) T3 ON T1.S_Student_ID = T3.S_Student_ID
                        ) T4
               
                
                
                    
    END
