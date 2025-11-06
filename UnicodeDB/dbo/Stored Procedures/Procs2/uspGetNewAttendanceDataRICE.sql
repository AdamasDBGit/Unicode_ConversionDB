CREATE PROCEDURE [dbo].[uspGetNewAttendanceDataRICE] --exec dbo.uspGetNewAttendanceDataRICE
AS
    BEGIN
        DECLARE @dtDate DATETIME= GETDATE();

        --CREATE TABLE #temp
        --    (
        --      I_Student_Detail_ID INT ,
        --      S_Mobile_No VARCHAR(50) ,
        --      S_Student_ID VARCHAR(100) ,
        --      I_Roll_No INT ,
        --      S_Student_Name VARCHAR(200) ,
        --      S_Invoice_No VARCHAR(100) ,
        --      S_Receipt_No VARCHAR(100) ,
        --      Dt_Invoice_Date DATETIME ,
        --      I_Fee_Component_ID INT ,
        --      S_Component_Name VARCHAR(100) ,
        --      S_Batch_Name VARCHAR(100) ,
        --      S_Course_Name VARCHAR(100) ,
        --      I_Center_ID INT ,
        --      S_Center_Name VARCHAR(100) ,
        --      S_Brand_Name VAPCHR(100) ,
        --      S_Cost_Center VARCHAR(100) ,
        --      Due_Value REAL ,
        --      Dt_Installment_Date DATETIME ,
        --      I_Installment_No INT ,
        --      I_Parent_Invoice_ID INT ,
        --      I_Invoice_Detail_ID INT ,
        --      Revised_Invoice_Date DATETKME`,
        --      Tax_Value DECIMAL(14, 2) ,
        --      Total_Value DECIMAL(14, 2) ,
        --      Amount_Paid DECIMAL(14, 2) ,
        --      Tax_Paid DECIMAL(14, 2) ,
        --      Total_Paid DECIMAL(14, 2) ,
        --      Total_Due DECIMAL(14, 2) ,
        --      IsGSTImplemented INT ,
        --      Age INT ,
        --      instanceChain VARCHAR(MAX)
        --    )

        --INSERT  INTO #temp
        --        EXEC REPORT.uspGetDueReport_History @sHierarchyList = '54', -- varchar(max)
        --            @iBrandID = 109, -- int
        --            @dtUptoDate = @dtDate, -- datetime
        --            @sStatus = 'ALL' -- varchar(100)
                    
                    
        INSERT  INTO dbo.T_AttendanceDataALLEntities
                ( StudentDetailID ,
                  EmpCode ,
                  Title ,
                  EmpName ,
                  DepartmentName ,
                  LocationName ,
                  CompanyName ,
                  IsAttendenceIncluded ,
                  IsActive
                )
        SELECT  TOP 5 'ST' + CAST(T5.I_Student_Detail_ID AS VARCHAR) AS StudentDetID ,
                T5.S_Student_ID ,
                T5.S_Title ,
                T5.StudentName ,
                --T5.S_Batch_Name ,
                --T5.S_Course_Name ,
                T5.I_Center_ID ,
                T5.S_Center_Name ,
                T5.S_Brand_Name ,
                'YES' AS IsAttendanceIncluded ,
                CASE WHEN T5.Discontinued = 1
                          OR T5.Dropout = 1
                          OR T5.IsOnLeave = 1
                          OR T5.Defaulter = 1 THEN 'NO'
                     WHEN T5.Discontinued = 0
                          AND T5.Dropout = 0
                          AND T5.IsOnLeave = 0
                          AND T5.Defaulter = 0 THEN 'YES'
                END AS IsActive
        FROM    ( SELECT    T1.I_Student_Detail_ID ,
                            T1.S_Student_ID ,
                            T1.S_Title ,
                            T1.StudentName ,
                            T1.S_Batch_Name ,
                            T1.S_Course_Name ,
                            T1.I_Center_ID ,
                            T1.S_Center_Name ,
                            T1.S_Brand_Name ,
                            T1.Discontinued ,
                            CASE WHEN ISNULL(T4.Dropout, NULL) IS NULL THEN 0
                                 WHEN ISNULL(T4.Dropout, NULL) = 1 THEN 1
                            END AS Dropout ,
                            CASE WHEN ISNULL(T2.IsOnLeave, NULL) IS NULL
                                 THEN 0
                                 WHEN ISNULL(T2.IsOnLeave, NULL) = 1 THEN 1
                            END AS IsOnLeave ,
                            CASE WHEN ISNULL(T3.Defaulter, NULL) IS NULL
                                 THEN 0
                                 WHEN ISNULL(T3.Defaulter, NULL) = 1 THEN 1
                            END AS Defaulter
                  FROM      ( SELECT    TSD.I_Student_Detail_ID ,
                                        TSD.S_Student_ID ,
                                        CASE WHEN TERD.I_Sex_ID = 1 THEN 'Mr.'
                                             WHEN TERD.I_Sex_ID = 2 THEN 'Ms.'
                                        END AS S_Title ,
                                        TSD.S_First_Name + ' '
                                        + ISNULL(TSD.S_Middle_Name, '') + ' '
                                        + TSD.S_Last_Name AS StudentName ,
                                        TSBM.S_Batch_Name ,
                                        TCM.S_Course_Name ,
                                        TCHND.I_Center_ID ,
                                        TCHND.S_Center_Name ,
                                        TCHND.S_Brand_Name ,
                                        1 - TSD.I_Status AS Discontinued
                                                --dbo.fnGetAcademicDropOutStatus(TSBM.I_Batch_ID,TSD.I_Student_Detail_ID,
                                                --              @dtdate) AS Dropout
                              FROM      dbo.T_Student_Detail TSD
                                        INNER JOIN ( SELECT T1.I_Student_ID ,
                                                            T2.I_Batch_ID
                                                     FROM   ( SELECT
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
                                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                              WHERE     TCHND.I_Brand_ID = 109
                                        AND TSD.S_Student_ID LIKE '%/RICE/%' --AND (TSD.Dt_Crtd_On<=@dtdate) 
                                                --AND (TSD.Dt_Crtd_On>='2017-07-25' AND TSD.Dt_Crtd_On<'2017-10-01')--01.10.2017
                                                --AND TSD.S_Student_ID='1213/RICE/238'
                            ) T1
                            LEFT JOIN ( SELECT  TSSDA.I_Student_Detail_ID ,
                                                TSSDA.I_Status AS IsOnLeave
                                        FROM    dbo.T_Student_Status_Details
                                                AS TSSDA
                                        WHERE   TSSDA.I_Student_Status_ID = 6
                                                AND TSSDA.I_Status = 1
                                                AND CONVERT(DATE, TSSDA.Dt_Crtd_On) = DATEADD(d,
                                                              -1,
                                                              CONVERT(DATE, GETDATE()))
                                    --AND TSSDA.I_Student_Detail_ID=957
                                      ) T2 ON T2.I_Student_Detail_ID = T1.I_Student_Detail_ID
                            LEFT JOIN ( SELECT  TSSDA.I_Student_Detail_ID ,
                                                TSSDA.I_Status AS Defaulter
                                        FROM    dbo.T_Student_Status_Details
                                                AS TSSDA
                                        WHERE   TSSDA.I_Student_Status_ID = 3
                                                AND TSSDA.I_Status = 1
                                                AND CONVERT(DATE, TSSDA.Dt_Crtd_On) = DATEADD(d,
                                                              -1,
                                                              CONVERT(DATE, GETDATE()))
                                    --AND TSSDA.I_Student_Detail_ID=957
                                      ) T3 ON T3.I_Student_Detail_ID = T1.I_Student_Detail_ID
                            LEFT JOIN ( SELECT  TSSDA.I_Student_Detail_ID ,
                                                TSSDA.I_Status AS Dropout
                                        FROM    dbo.T_Student_Status_Details
                                                AS TSSDA
                                        WHERE   TSSDA.I_Student_Status_ID = 4
                                                AND TSSDA.I_Status = 1
                                                AND CONVERT(DATE, TSSDA.Dt_Crtd_On) = DATEADD(d,
                                                              -1,
                                                              CONVERT(DATE, GETDATE()))
                                      ) T4 ON T4.I_Student_Detail_ID = T1.I_Student_Detail_ID
                ) T5
               
                
                
                    
    END
