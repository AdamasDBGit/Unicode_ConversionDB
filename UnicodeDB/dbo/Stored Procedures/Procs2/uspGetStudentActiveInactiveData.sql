CREATE PROCEDURE [dbo].[uspGetStudentActiveInactiveData] ( @dtDate DATE )
AS 
    BEGIN
    
        DECLARE @studentid INT
        DECLARE @Sstudentid VARCHAR(MAX)
    
		
        CREATE TABLE #temp
            (
              StudentDetailID INT ,
              StudentID VARCHAR(MAX) ,
              BatchID INT ,
              BatchName VARCHAR(MAX) ,
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              IsDiscontinued INT ,
              IsDropout INT ,
              IsOnLeave INT ,
              IsDefaulter INT
            )
	

	
        --CREATE TABLE #temp2
        --    (
        --      I_Student_Detail_ID INT ,
        --      S_Mobile_No VARCHAR(50) ,
        --      S_Student_ID VARCHAR(100) ,
        --      I_Roll_No INT ,
        --      S_Student_Name VARCHAR(200) ,
        --      S_Invoice_No VARCHAR(100) ,
        --      S_Receipt_No VARCHAR(100) ,
        --      Dt_Invoice_Date DATETIME ,
        --      S_Component_Name VARCHAR(100) ,
        --      S_Batch_Name VARCHAR(100) ,
        --      S_Course_Name VARCHAR(100) ,
        --      I_Center_ID INT ,
        --      S_Center_Name VARCHAR(100) ,
        --      S_Brand_Name VARCHAR(100) ,
        --      S_Cost_Center VARCHAR(100) ,
        --      Due_Value REAL ,
        --      Dt_Installment_Date DATETIME ,
        --      I_Installment_No INT ,
        --      I_Parent_Invoice_ID INT ,
        --      I_Invoice_Detail_ID INT ,
        --      Revised_Invoice_Date DATETIME ,
        --      Tax_Value DECIMAL(14, 2) ,
        --      Total_Value DECIMAL(14, 2) ,
        --      Amount_Paid DECIMAL(14, 2) ,
        --      Tax_Paid DECIMAL(14, 2) ,
        --      Total_Paid DECIMAL(14, 2) ,
        --      Total_Due DECIMAL(14, 2) ,
        --      sInstance VARCHAR(MAX)
        --    )
            
            
        INSERT  INTO #temp
                ( StudentDetailID ,
                  StudentID,
                  IsDiscontinued,
                  IsDropout   
                )
                SELECT  TSD.I_Student_Detail_ID ,
                        TSD.S_Student_ID,
                        TSD.I_Status,
                         dbo.fnGetAcademicDropOutStatus(TSD.I_Student_Detail_ID,
                                                              NULL)
                FROM    dbo.T_Student_Detail TSD
                WHERE   S_Student_ID LIKE '%/RICE/%'
                
                SELECT * FROM #temp TT
                  
                  
        --INSERT  INTO #temp2
        --        EXEC REPORT.uspGetDueReport_History @sHierarchyList = '54', -- varchar(max)
        --            @iBrandID = 109, -- int
        --            @dtUptoDate = @dtDate, -- datetime
        --            @sStatus = 'ALL' -- varchar(100)
                    
                    
        --            SELECT * FROM #temp2 TT
         /*           
        DECLARE StudentStatusFinder CURSOR
        FOR SELECT TT.StudentDetailID,TT.StudentID FROM #temp TT
        
        OPEN StudentStatusFinder
        FETCH NEXT FROM StudentStatusFinder           
        INTO @studentid,@Sstudentid
        
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                --UPDATE  #temp
                --SET     BatchID = dbo.fnGetHistoricalBatchID(@studentid,
                --                                             @dtDate)
                --WHERE   StudentDetailID = @studentid
        	
                --UPDATE  #temp
                --SET     BatchName = dbo.fnGetHistoricalBatchName(@studentid,
                --                                              @dtDate)
                --WHERE   StudentDetailID = @studentid
        	
                UPDATE  #temp
                SET     IsDropout = dbo.fnGetAcademicDropOutStatus(@studentid,
                                                              @dtDate) WHERE StudentDetailID=@studentid
        	
                --UPDATE  TT
                --SET     TT.IsDefaulter = 1
                --FROM    #temp TT
                --        INNER JOIN ( SELECT  DISTINCT
                --                            XX.S_Student_ID
                --                     FROM   ( SELECT    S_Student_ID ,
                --                                        SUM(ISNULL(Total_Due,
                --                                              0)) AS TotalDue
                --                              FROM      #temp2 T1
                --                              WHERE     DATEDIFF(d,
                --                                              T1.Dt_Installment_Date,
                --                                              GETDATE()) >= 10
                --                                        AND T1.S_Student_ID=@Sstudentid      
                --                              GROUP BY  S_Student_ID
                --                            ) XX
                --                     WHERE  XX.TotalDue >= 100
                --                   ) T2 ON TT.StudentID = T2.S_Student_ID
                --                   WHERE TT.StudentDetailID=@studentid
                                   
                 UPDATE T1
                 SET T1.IsOnLeave=1
                 FROM
                 #temp T1
                 INNER JOIN
                 (                  
                 SELECT TOP 1 TSLR.I_Student_Detail_ID FROM dbo.T_Student_Leave_Request TSLR WHERE TSLR.I_Student_Detail_ID=@studentid AND TSLR.I_Status=1
                 AND @dtDate BETWEEN TSLR.Dt_From_Date AND TSLR.Dt_To_Date
                 ) T2 ON T1.StudentDetailID=T2.I_Student_Detail_ID
                 
                 
                 PRINT @Sstudentid
                 
                 FETCH NEXT FROM StudentStatusFinder
                 INTO @studentid,@Sstudentid              
        	
            END
            
            CLOSE StudentStatusFinder
            DEALLOCATE StudentStatusFinder
            
            --UPDATE TT
            --     SET TT.CenterID=T1.I_Centre_Id,TT.CenterName=T1.S_Center_Name
            --     FROM
            --     #temp TT
            --     INNER JOIN
            --     (
            --     SELECT TCBD.I_Batch_ID,TCBD.I_Centre_Id,TCHND.S_Center_Name FROM dbo.T_Center_Batch_Details TCBD
            --     INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id=TCHND.I_Center_ID
                 --) T1 ON TT.BatchID=T1.I_Batch_ID
                 
                 
                SELECT * FROM #temp;
                            
            */
	
    END
