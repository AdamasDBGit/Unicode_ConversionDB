
CREATE PROCEDURE [ACADEMICS].[uspGetStudentDefaulterStatus]

AS 
    BEGIN
    
    
        CREATE TABLE #temp
            (
              id INT IDENTITY(1, 1) ,
              StudentID INT
            )

        INSERT  INTO #temp
                ( StudentID 
                )
                
                SELECT  DISTINCT
                        TSSD.I_Student_Detail_ID
                FROM    dbo.T_Student_Status_Details TSSD
                        INNER JOIN dbo.T_Student_Status_Master TSSM ON TSSD.I_Student_Status_ID = TSSM.I_Student_Status_ID
                WHERE   TSSD.I_Status = 1
                        AND TSSM.I_Status = 1
                        AND TSSD.IsEditable <> 0
                        
        CREATE TABLE #temp1
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
            
        DECLARE @dtDate DATETIME= GETDATE()

        INSERT  INTO #temp1
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = '54', -- varchar(max)
                    @iBrandID = 109, -- int
                    @dtUptoDate = @dtDate, -- datetime
                    @sStatus = 'ALL' -- varchar(100)
                    
                    --SELECT * FROM #temp1 T
                    
                    
        INSERT  INTO #temp1
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = '94', -- varchar(max)
                    @iBrandID = 111, -- int
                    @dtUptoDate = @dtDate, -- datetime
                    @sStatus = 'ALL' -- varchar(100)
                    
                    --SELECT * FROM #temp1 T 
                    
                    
        DECLARE @i INT= 1
        DECLARE @std INT
        DECLARE @Due DECIMAL(14, 2)
	
        
        
        
        WHILE ( @i <= ( SELECT  COUNT(*)
                        FROM    #temp
                      ) ) 
            BEGIN
            
                SELECT  @std = StudentID
                FROM    #temp
                WHERE   id = @i
        
                SELECT  @Due = ISNULL(TT.TDue, 0)
                FROM    ( SELECT    TSD.I_Student_Detail_ID ,
                                   SUM(ISNULL(T1.Total_Due,0)) AS TDue
                          FROM      #temp1 T1
                                    INNER JOIN dbo.T_Student_Detail TSD ON T1.S_Student_ID = TSD.S_Student_ID
                          WHERE     DATEDIFF(d, T1.Dt_Installment_Date,
                                             @dtDate) >= 31
                                    AND TSD.I_Student_Detail_ID = @std
                          GROUP BY  TSD.I_Student_Detail_ID
                          HAVING    SUM(ISNULL(T1.Total_Due,0)) >= 100.00
                        ) TT
                        
                        IF (@Due IS NULL)
                        BEGIN
                        	SET @Due=0.0
                        END
                        
                        --PRINT @std
                        --PRINT @Due
            
            
            
                IF EXISTS ( SELECT  *
                            FROM    dbo.T_Student_Status_Details TSSD
                                    INNER JOIN dbo.T_Student_Status_Master TSSM ON TSSD.I_Student_Status_ID = TSSM.I_Student_Status_ID
                            WHERE   TSSD.I_Status = 1
                                    AND TSSM.I_Status = 1
                                    AND TSSD.IsEditable <> 0
                                    AND TSSM.I_Student_Status_ID = 3
                                    AND TSSD.I_Student_Detail_ID = @std ) 
                    BEGIN
            
                        IF ( @Due > 0 ) 
                            BEGIN
				
                                EXEC ACADEMICS.uspInsertIntoStudentStatusArchive @StudentStatusID = 3, -- int
                                    @StudentID = @std -- int
					
                                UPDATE  dbo.T_Student_Status_Details
                                SET     Dt_Crtd_On = GETDATE() ,
                                        S_Crtd_By = 'dba' ,
                                        N_Due = @Due
                                WHERE   I_Student_Detail_ID = @std
                                        AND I_Status = 1
                                        AND IsEditable = 1
                                        AND I_Student_Status_ID = 3
                            END
				
                        ELSE 
                            BEGIN
				
                                EXEC ACADEMICS.uspInsertIntoStudentStatusArchive @StudentStatusID = 3, -- int
                                    @StudentID = @std -- int
				
                                UPDATE  dbo.T_Student_Status_Details
                                SET     I_Status = 0 ,
                                        Dt_Upd_On = GETDATE() ,
                                        S_Upd_By = 'dba',
                                        N_Due=@Due
                                WHERE   I_Student_Detail_ID = @std
                                        AND I_Status = 1
                                        AND IsEditable = 1
                                        AND I_Student_Status_ID = 3
                            END
            	
                    END
                    
                ELSE 
                    BEGIN
                        IF ( @Due > 0 ) 
                            BEGIN
                                INSERT  INTO dbo.T_Student_Status_Details
                                        ( I_Student_Detail_ID ,
                                          I_Student_Status_ID ,
                                          I_Status ,
                                          N_Due ,
                                          Dt_Crtd_On ,
                                          S_Crtd_By ,
                                          IsEditable
                    		          )
                                VALUES  ( @std , -- I_Student_Detail_ID - int
                                          3 , -- I_Student_Status_ID - int
                                          1 , -- I_Status - int
                                          @Due , -- N_Due - decimal
                                          GETDATE() , -- Dt_Crtd_On - datetime
                                          'dba' , -- S_Crtd_By - varchar(50)
                                          1  -- IsEditable - bit
                    		          )
                            END
                    END
                    
                  
                    
                SET @i = @i + 1
                SET @Due=0.0                            
            END                         
                                             
    END
