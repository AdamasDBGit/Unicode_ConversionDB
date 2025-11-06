
CREATE PROCEDURE [ACADEMICS].[uspUpdateStudentStatus]
AS 
    BEGIN
	--EXEC ACADEMICS.uspStudentWaitingStatus----2
	--EXEC ACADEMICS.uspGetStudentDefaulterStatus---3
	--EXEC ACADEMICS.uspGetStudentDropoutStatus-----4
	--EXEC ACADEMICS.uspGetStudentCompletedStatus---5
	--EXEC ACADEMICS.uspGetStudentLeaveStatus-------6
	--EXEC ACADEMICS.uspGetStudentDiscontinueStatus--7
	--EXEC ACADEMICS.uspStudentActiveStatus-----1
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
              I_Fee_Component_ID INT,
              S_Component_Name VARCHAR(100) ,
              I_Batch_ID INT,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
              TypeofCentre VARCHAR(MAX),
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
              IsGSTImplemented INT,
              Age INT,
              instanceChain VARCHAR(MAX)
            )

        INSERT  INTO #temp
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = '54', -- varchar(max)
                    @iBrandID = 109, -- int
                    @dtUptoDate = @dtDate, -- datetime
                    @sStatus = 'ALL' -- varchar(100)
                    
        --INSERT  INTO #temp
        --        EXEC REPORT.uspGetDueReport_History @sHierarchyList = '93', -- varchar(max)
        --            @iBrandID = 111, -- int
        --            @dtUptoDate = @dtDate, -- datetime
        --            @sStatus = 'ALL' -- varchar(100)
                    
                                
	
	
	
	
	
        CREATE TABLE #temp1
            (
              ID INT IDENTITY(1, 1) ,
              I_Student_Detail_ID INT ,
              S_Student_ID VARCHAR(MAX) ,
              S_Title VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              S_Batch_Name VARCHAR(MAX) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(MAX) ,
              S_Brand_Name VARCHAR(MAX) ,
              N_Due DECIMAL(14, 2) ,
              Discontinued INT ,
              Dropout INT ,
              IsOnLeave INT ,
              Defaulter INT,
              Waiting INT,
              Completed INT,
			  PreDefaulter INT,
			  DefaulterDate DATETIME,
			  PayDue INT,
			  PayDueDate Datetime
            )
	
        INSERT  INTO #temp1
                ( I_Student_Detail_ID ,
                  S_Student_ID ,
                  S_Title ,
                  StudentName ,
                  S_Batch_Name ,
                  I_Center_ID ,
                  S_Center_Name ,
                  S_Brand_Name ,
                  N_Due ,
                  Discontinued ,
                  Dropout ,
                  IsOnLeave ,
                  Defaulter,
                  Waiting,
                  Completed,
				  PreDefaulter,
				  DefaulterDate,
				  PayDue,
				  PayDueDate
	          )
                SELECT  T1.I_Student_Detail_ID ,
                        T1.S_Student_ID ,
                        T1.S_Title ,
                        T1.StudentName ,
                        T1.S_Batch_Name ,
                        T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.S_Brand_Name ,
                        ISNULL(T3.TotalDue, 0.0) AS NDue ,
                        T1.Discontinued ,
                        T1.Dropout ,
                        CASE WHEN T2.IsOnLeave IS NULL THEN 0
                             WHEN T2.IsOnLeave = 1 THEN 1
                        END AS IsOnLeave ,
                        CASE WHEN T3.Defaulter IS NULL THEN 0
                             WHEN T3.Defaulter = 1 THEN 1
                        END AS Defaulter,
                        T1.Waiting,
                        T1.Completed,
						CASE WHEN T4.PreDefaulter IS NULL THEN 0
                             WHEN T4.PreDefaulter = 1 THEN 1
                        END AS PreDefaulter,
						T4.PreDefaulterDate,
						CASE WHEN T5.PayDue IS NULL THEN 0
                             WHEN T5.PayDue = 1 THEN 1
                        END AS PayDue,
						T5.InstalmentDate
                FROM    ( SELECT    TSD.I_Student_Detail_ID ,
                                    TSD.S_Student_ID ,
                                    CASE WHEN TERD.I_Sex_ID = 1 THEN 'Mr.'
                                         WHEN TERD.I_Sex_ID = 2 THEN 'Ms.'
                                    END AS S_Title ,
                                    TSD.S_First_Name + ' '
                                    + ISNULL(TSD.S_Middle_Name, '') + ' '
                                    + TSD.S_Last_Name AS StudentName ,
                                    TSBM.S_Batch_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TCHND.S_Brand_Name ,
                                    1 - TSD.I_Status AS Discontinued ,
                                    --dbo.fnGetAcademicDropOutStatus(TSBM.I_Batch_ID,
                                    --                          TSD.I_Student_Detail_ID,
                                    --                          NULL) AS Dropout,
									1 AS Dropout,
                                    --dbo.fnGetWaitingStatus(TSD.I_Student_Detail_ID) AS Waiting,
									1 AS Waiting,
                                    dbo.fnGetCompletedStatus(TSD.I_Student_Detail_ID) AS Completed                         
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
                          WHERE     TCHND.I_Brand_ID IN ( 109 )
                                    AND (TSD.S_Student_ID LIKE '%/RICE/%') 
									AND LEN(TSD.S_Student_ID)<=16
                        ) T1
                        LEFT JOIN ( SELECT  TSLR.I_Student_Detail_ID ,
                                            1 AS IsOnLeave
                                    FROM    dbo.T_Student_Leave_Request TSLR
                                    WHERE   TSLR.I_Status = 1
                                            AND @dtDate BETWEEN TSLR.Dt_From_Date
                                                        AND   TSLR.Dt_To_Date
                                  ) T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
                        LEFT JOIN ( SELECT  DISTINCT
                                            XX.S_Student_ID ,
                                            XX.TotalDue ,
                                            1 AS Defaulter
                                    FROM    ( SELECT    S_Student_ID ,
                                                        SUM(ISNULL(Total_Due,
                                                              0)) AS TotalDue
                                              FROM      #temp TTT
											  inner join T_Student_Batch_Master TSBM on TTT.I_Batch_ID=TSBM.I_Batch_ID
                                              WHERE     DATEDIFF(d,
                                                              CASE WHEN TSBM.Dt_BatchStartDate>TTT.Dt_Installment_Date THEN TSBM.Dt_BatchStartDate
															  ELSE TTT.Dt_Installment_Date END,
                                                              GETDATE()) >= 31
                                                        --AND T1.S_Student_ID=@Sstudentid      
                                              GROUP BY  S_Student_ID
                                            ) XX
                                    WHERE   XX.TotalDue >= 100
                                  ) T3 ON T1.S_Student_ID = T3.S_Student_ID
						LEFT JOIN ( SELECT  DISTINCT
                                            XX.S_Student_ID ,
                                            XX.TotalDue ,
											XX.PreDefaulterDate,
                                            1 AS PreDefaulter
                                    FROM    ( SELECT    S_Student_ID ,
                                                        SUM(ISNULL(Total_Due,
                                                              0)) AS TotalDue,
														MIN(DATEADD(d,31-DATEDIFF(d,
                                                              CASE WHEN TSBM.Dt_BatchStartDate>TTT.Dt_Installment_Date THEN TSBM.Dt_BatchStartDate
															  ELSE TTT.Dt_Installment_Date END,
                                                              GETDATE()),GETDATE())) as PreDefaulterDate
                                              FROM      #temp TTT
											  inner join T_Student_Batch_Master TSBM on TTT.I_Batch_ID=TSBM.I_Batch_ID
                                              WHERE     
												DATEDIFF(d,
                                                              CASE WHEN TSBM.Dt_BatchStartDate>TTT.Dt_Installment_Date THEN TSBM.Dt_BatchStartDate
															  ELSE TTT.Dt_Installment_Date END,
                                                              GETDATE()) >= 11
														AND
														DATEDIFF(d,
                                                              CASE WHEN TSBM.Dt_BatchStartDate>TTT.Dt_Installment_Date THEN TSBM.Dt_BatchStartDate
															  ELSE TTT.Dt_Installment_Date END,
                                                              GETDATE()) < 31
                                                        --AND T1.S_Student_ID=@Sstudentid      
                                              GROUP BY  S_Student_ID
                                            ) XX
                                    WHERE   XX.TotalDue >= 100
                                  ) T4 ON T1.S_Student_ID = T4.S_Student_ID
								  LEFT JOIN ( SELECT  DISTINCT
                                            XX.S_Student_ID ,
                                            XX.TotalDue ,
											XX.InstalmentDate,
                                            1 AS PayDue
                                    FROM    ( SELECT    S_Student_ID ,
                                                        SUM(ISNULL(Total_Due,
                                                              0)) AS TotalDue,
														MIN(CASE WHEN TSBM.Dt_BatchStartDate>TTT.Dt_Installment_Date THEN TSBM.Dt_BatchStartDate
															  ELSE TTT.Dt_Installment_Date END) as InstalmentDate
                                              FROM      #temp TTT
											  inner join T_Student_Batch_Master TSBM on TTT.I_Batch_ID=TSBM.I_Batch_ID
                                              WHERE     DATEDIFF(d,
                                                              CASE WHEN TSBM.Dt_BatchStartDate>TTT.Dt_Installment_Date THEN TSBM.Dt_BatchStartDate
															  ELSE TTT.Dt_Installment_Date END,
                                                              GETDATE()) >=1
														and
														DATEDIFF(d,
                                                              CASE WHEN TSBM.Dt_BatchStartDate>TTT.Dt_Installment_Date THEN TSBM.Dt_BatchStartDate
															  ELSE TTT.Dt_Installment_Date END,
                                                              GETDATE()) <=10
                                                        --AND T1.S_Student_ID=@Sstudentid      
                                              GROUP BY  S_Student_ID
                                            ) XX
                                    WHERE   XX.TotalDue >= 100
                                  ) T5 ON T1.S_Student_ID = T5.S_Student_ID
                                              
        DECLARE @std INT
        DECLARE @due INT
        DECLARE @discon INT
        DECLARE @drop INT
        DECLARE @leave INT
        DECLARE @defaulter INT
        DECLARE @waiting INT
        DECLARE @completed INT
		DECLARE @predefaulter INT
		DECLARE @defaulterdate DATETIME=NULL
		DECLARE @paydue INT
		DECLARE @payduedate datetime
        
        DROP TABLE #temp
		
        DECLARE StatusUpdator CURSOR
        FOR
        SELECT I_Student_Detail_ID,N_Due,Discontinued,Dropout,IsOnLeave,Defaulter,Waiting,
		Completed,PreDefaulter,DefaulterDate,PayDue,PayDueDate
		FROM #temp1 T1 
		
        OPEN StatusUpdator
        FETCH NEXT FROM StatusUpdator
		INTO
		@std,@due,@discon,@drop,@leave,@defaulter,@waiting,@completed,@predefaulter,@defaulterdate,@paydue,@payduedate
		
        WHILE ( @@FETCH_STATUS = 0 ) 
            BEGIN
                INSERT  INTO dbo.T_Student_Status_Details_Archive
                        ( I_Student_Detail_ID ,
                          I_Student_Status_ID ,
                          I_Status ,
                          N_Due ,
                          Dt_Crtd_On ,
                          Dt_Upd_On ,
                          S_Crtd_By ,
                          S_Upd_By ,
                          IsEditable,
						  DefaulterDate
                        )
                        SELECT  I_Student_Detail_ID ,
                                I_Student_Status_ID ,
                                I_Status ,
                                N_Due ,
                                Dt_Crtd_On ,
                                Dt_Upd_On ,
                                S_Crtd_By ,
                                S_Upd_By ,
                                IsEditable,
								DefaulterDate
                        FROM    dbo.T_Student_Status_Details TSSD
                        WHERE   TSSD.I_Status = 1
                                AND TSSD.I_Student_Detail_ID = @std
                                AND CONVERT(DATE, TSSD.Dt_Crtd_On) < CONVERT(DATE, @dtDate)
			
                DELETE  FROM dbo.T_Student_Status_Details
                WHERE   I_Student_Detail_ID = @std
                        AND IsEditable = 1
			
                IF ( 
						@discon = 0
                     AND @drop = 0
      --               AND @leave = 0
      --               AND @waiting=0
      --               AND @completed=0
					 AND @defaulter = 0
                   ) 
                    BEGIN
                        INSERT  INTO dbo.T_Student_Status_Details
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  Dt_Upd_On ,
                                  S_Crtd_By ,
                                  S_Upd_By ,
                                  IsEditable
				        )
                        VALUES  ( @std , -- I_Student_Detail_ID - int
                                  1 , -- I_Student_Status_ID - int
                                  1 , -- I_Status - int
                                  NULL , -- N_Due - decimal
                                  @dtDate , -- Dt_Crtd_On - datetime
                                  NULL , -- Dt_Upd_On - datetime
                                  'dba' , -- S_Crtd_By - varchar(50)
                                  NULL , -- S_Upd_By - varchar(50)
                                  1  -- IsEditable - bit
				        )
				        
                    END
			
                ELSE 
                    BEGIN
                    
                    
						INSERT  INTO dbo.T_Student_Status_Details
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  Dt_Upd_On ,
                                  S_Crtd_By ,
                                  S_Upd_By ,
                                  IsEditable
				        )
                        VALUES  ( @std , -- I_Student_Detail_ID - int
                                  2 , -- I_Student_Status_ID - int
                                  @waiting , -- I_Status - int
                                  NULL , -- N_Due - decimal
                                  @dtDate , -- Dt_Crtd_On - datetime
                                  NULL , -- Dt_Upd_On - datetime
                                  'dba' , -- S_Crtd_By - varchar(50)
                                  NULL , -- S_Upd_By - varchar(50)
                                  1  -- IsEditable - bit
				        )
                    
                        INSERT  INTO dbo.T_Student_Status_Details
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  Dt_Upd_On ,
                                  S_Crtd_By ,
                                  S_Upd_By ,
                                  IsEditable
				        )
                        VALUES  ( @std , -- I_Student_Detail_ID - int
                                  3 , -- I_Student_Status_ID - int
                                  @defaulter , -- I_Status - int
                                  @due , -- N_Due - decimal
                                  @dtDate , -- Dt_Crtd_On - datetime
                                  NULL , -- Dt_Upd_On - datetime
                                  'dba' , -- S_Crtd_By - varchar(50)
                                  NULL , -- S_Upd_By - varchar(50)
                                  1  -- IsEditable - bit
				        )
				        
				        
                        INSERT  INTO dbo.T_Student_Status_Details
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  Dt_Upd_On ,
                                  S_Crtd_By ,
                                  S_Upd_By ,
                                  IsEditable
				        )
                        VALUES  ( @std , -- I_Student_Detail_ID - int
                                  4 , -- I_Student_Status_ID - int
                                  @drop , -- I_Status - int
                                  NULL , -- N_Due - decimal
                                  @dtDate , -- Dt_Crtd_On - datetime
                                  NULL , -- Dt_Upd_On - datetime
                                  'dba' , -- S_Crtd_By - varchar(50)
                                  NULL , -- S_Upd_By - varchar(50)
                                  1  -- IsEditable - bit
				        )
				        
                        INSERT  INTO dbo.T_Student_Status_Details
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  Dt_Upd_On ,
                                  S_Crtd_By ,
                                  S_Upd_By ,
                                  IsEditable
				        )
                        VALUES  ( @std , -- I_Student_Detail_ID - int
                                  6 , -- I_Student_Status_ID - int
                                  @leave , -- I_Status - int
                                  NULL , -- N_Due - decimal
                                  @dtDate , -- Dt_Crtd_On - datetime
                                  NULL , -- Dt_Upd_On - datetime
                                  'dba' , -- S_Crtd_By - varchar(50)
                                  NULL , -- S_Upd_By - varchar(50)
                                  1  -- IsEditable - bit
				        )
				        
				        
                        INSERT  INTO dbo.T_Student_Status_Details
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  Dt_Upd_On ,
                                  S_Crtd_By ,
                                  S_Upd_By ,
                                  IsEditable
				        )
                        VALUES  ( @std , -- I_Student_Detail_ID - int
                                  7 , -- I_Student_Status_ID - int
                                  @discon , -- I_Status - int
                                  NULL , -- N_Due - decimal
                                  @dtDate , -- Dt_Crtd_On - datetime
                                  NULL , -- Dt_Upd_On - datetime
                                  'dba' , -- S_Crtd_By - varchar(50)
                                  NULL , -- S_Upd_By - varchar(50)
                                  1  -- IsEditable - bit
				        )
				        
				        INSERT  INTO dbo.T_Student_Status_Details
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  Dt_Upd_On ,
                                  S_Crtd_By ,
                                  S_Upd_By ,
                                  IsEditable
				        )
                        VALUES  ( @std , -- I_Student_Detail_ID - int
                                  5 , -- I_Student_Status_ID - int
                                  @completed , -- I_Status - int
                                  NULL , -- N_Due - decimal
                                  @dtDate , -- Dt_Crtd_On - datetime
                                  NULL , -- Dt_Upd_On - datetime
                                  'dba' , -- S_Crtd_By - varchar(50)
                                  NULL , -- S_Upd_By - varchar(50)
                                  1  -- IsEditable - bit
				        )


						IF((@defaulter=0 OR @defaulter is NULL) and @defaulterdate is not null)
						BEGIN

							INSERT  INTO dbo.T_Student_Status_Details
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  Dt_Upd_On ,
                                  S_Crtd_By ,
                                  S_Upd_By ,
                                  IsEditable,
								  DefaulterDate
				        )
                        VALUES  ( @std , -- I_Student_Detail_ID - int
                                  8 , -- I_Student_Status_ID - int
                                  @predefaulter , -- I_Status - int
                                  NULL , -- N_Due - decimal
                                  @dtDate , -- Dt_Crtd_On - datetime
                                  NULL , -- Dt_Upd_On - datetime
                                  'dba' , -- S_Crtd_By - varchar(50)
                                  NULL , -- S_Upd_By - varchar(50)
                                  1,  -- IsEditable - bit
								  @defaulterdate
				        )


						END

						----
						IF((@defaulter=0 OR @defaulter is NULL) and (@predefaulter=0 OR @predefaulter is null) and @payduedate is not null)
						BEGIN

							INSERT  INTO dbo.T_Student_Status_Details
                                ( I_Student_Detail_ID ,
                                  I_Student_Status_ID ,
                                  I_Status ,
                                  N_Due ,
                                  Dt_Crtd_On ,
                                  Dt_Upd_On ,
                                  S_Crtd_By ,
                                  S_Upd_By ,
                                  IsEditable,
								  DefaulterDate
				        )
                        VALUES  ( @std , -- I_Student_Detail_ID - int
                                  9 , -- I_Student_Status_ID - int
                                  @paydue , -- I_Status - int
                                  NULL , -- N_Due - decimal
                                  @dtDate , -- Dt_Crtd_On - datetime
                                  NULL , -- Dt_Upd_On - datetime
                                  'dba' , -- S_Crtd_By - varchar(50)
                                  NULL , -- S_Upd_By - varchar(50)
                                  1,  -- IsEditable - bit
								  @payduedate
				        )


						END

						--DECLARE @studentID VARCHAR(MAX)

						--SELECT @studentID=S_Student_ID FROM T_Student_Detail WHERE I_Student_Detail_ID=@std

						--EXEC [LMS].[uspUpdateStudentStatus] @studentID,'Defaulter',@defaulter,@due,NULL
						--EXEC [LMS].[uspUpdateStudentStatus] @studentID,'Completed',@completed,NULL,NULL
						--EXEC [LMS].[uspUpdateStudentStatus] @studentID,'Discontinued',@discon,NULL,NULL
						----EXEC [LMS].[uspUpdateStudentStatus] @studentID,'Leave',@leave,NULL,NULL
						--EXEC [LMS].[uspUpdateStudentStatus] @studentID,'PreDefaulter',@predefaulter,NULL,@defaulterdate
						--EXEC [LMS].[uspUpdateStudentStatus] @studentID,'PaymentDue',@paydue,NULL,@payduedate

				        
                    END
                    
                    FETCH NEXT FROM StatusUpdator
                    INTO
                    @std,@due,@discon,@drop,@leave,@defaulter,@waiting, @completed, @predefaulter,@defaulterdate,@paydue,@payduedate
			
            END
		
        CLOSE StatusUpdator ;
        DEALLOCATE StatusUpdator ;  
        
        
        DROP TABLE #temp1                                       
	
	
    END
