CREATE PROCEDURE [dbo].[uspGetNewAttendanceDataAWS]
AS 
    BEGIN
        DECLARE @dtDate DATETIME= GETDATE() ;

       CREATE TABLE #temp
            (
              I_Student_Detail_ID INT ,
              S_Mobile_No nvarchar(max) ,
              S_Student_ID nvarchar(max) ,
              I_Roll_No INT ,
              S_Student_Name nvarchar(max) ,
              S_Invoice_No nvarchar(max) ,
              S_Receipt_No nvarchar(max) ,
              Dt_Invoice_Date DATETIME ,
              S_Component_Name nvarchar(max) ,
              S_Batch_Name nvarchar(max) ,
              S_Course_Name nvarchar(max) ,
              I_Center_ID INT ,
              S_Center_Name nvarchar(max) ,
              S_Brand_Name nvarchar(max) ,
              S_Cost_Center nvarchar(max) ,
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
              sInstance nvarchar(max)
            )

        INSERT  INTO #temp
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = '126', -- nvarchar(max)
                    @iBrandID = 110, -- int
                    @dtUptoDate = @dtDate, -- datetime
                    @sStatus = 'ALL' -- nvarchar(max)
                    
                    
        INSERT INTO dbo.T_AttendanceData_ALLEntities
                ( StudentID ,
                  Title ,
                  StudentName ,
                  LocationName ,
                  BatchName ,
                  CompanyName ,
                  IsAttendanceIncluded ,
                  IsActive
                )            
        SELECT  TSD.S_Student_ID AS StudentID ,
                CASE WHEN TERD.I_Sex_ID = 1 THEN 'Mr.'
                     WHEN TERD.I_Sex_ID = 2 THEN 'Ms.'
                END AS Title ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                + ISNULL(TSD.S_Last_Name, '') AS StudentName ,
                TCHND.S_Center_Name AS LocationName ,
                TSBM.S_Batch_Name AS BatchName ,
                TCHND.S_Brand_Name AS CompanyName ,
                'YES' AS IsAttendenceIncluded ,
                --YY.ID
                CASE WHEN TTC.Is_Released = 1  THEN 'NO'
                     WHEN (TTC.Is_Released = 0
                          OR TTC.Is_Released IS NULL) AND TSD.I_Status=1  THEN 'YES'
                     WHEN TSD.I_Status=0 THEN 'NO'     
                END IsActive
        FROM    dbo.T_Student_Detail TSD
                INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                LEFT JOIN dbo.T_Transfer_Certificates TTC ON TSD.I_Student_Detail_ID = TTC.I_Student_Detail_ID
                --LEFT JOIN 
                --(
                --SELECT  DISTINCT XX.I_Student_Detail_ID,1 AS ID
                --FROM    ( SELECT    I_Student_Detail_ID ,
                                    
                --                    SUM(ISNULL(Total_Due,0) ) AS TotalDue
                --          FROM      #temp T
                --          GROUP BY  I_Student_Detail_ID 
                                    
                --        ) XX
                --WHERE   XX.TotalDue >= 200 ) YY ON TSD.I_Student_Detail_ID=YY.I_Student_Detail_ID
        WHERE   TSBD.I_Status = 1
                AND TCHND.I_Brand_ID IN ( 110 )
                    --AND DATENAME(YYYY,TSBM.Dt_BatchStartDate)=DATENAME(YYYY,GETDATE())
                AND TSBM.Dt_BatchStartDate >= '2015-04-01'
                --AND TSD.I_Status = 1
                AND TSD.S_Student_ID NOT IN 
                (
                SELECT  DISTINCT XX.S_Student_ID
                FROM    ( SELECT    S_Student_ID ,
                                    
                                    SUM(ISNULL(Total_Due,0) ) AS TotalDue
                          FROM      #temp T
                          GROUP BY  S_Student_ID 
                                    
                        ) XX
                WHERE   XX.TotalDue >= 200 )
                
        --ORDER BY TCHND.S_Brand_Name ,
        --        TCHND.S_Center_Name ,
        --        TSBM.S_Batch_Name ,
        --        TSD.S_Student_ID
        
        UNION ALL
        
        SELECT DISTINCT TSD.S_Student_ID AS StudentID ,
                CASE WHEN TERD.I_Sex_ID = 1 THEN 'Mr.'
                     WHEN TERD.I_Sex_ID = 2 THEN 'Ms.'
                     WHEN TERD.I_Sex_ID IS NULL THEN 'Mr/Ms'
                END AS Title ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                + ISNULL(TSD.S_Last_Name, '') AS StudentName ,
                TCHND.S_Center_Name AS LocationName ,
                TSBM.S_Batch_Name AS BatchName ,
                TCHND.S_Brand_Name AS CompanyName ,
                'YES' AS IsAttendenceIncluded ,
                'NO' AS IsActive
                FROM dbo.T_Student_Detail TSD
                INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
        WHERE
        TSD.S_Student_ID IN
        (
        
                SELECT DISTINCT XX.S_Student_ID
                FROM    ( SELECT    S_Student_ID ,
                                    
                                    SUM(ISNULL(Total_Due,0) ) AS TotalDue
                          FROM      #temp T
                          GROUP BY  S_Student_ID 
                                    
                        ) XX
                WHERE   XX.TotalDue >= 200)
                AND TSBM.S_Batch_Name LIKE '%2015%'
                
                
                    
    END
