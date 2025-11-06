
CREATE PROCEDURE [ERP_REPORTS].[usp_ERP_GetStudentBatchOccupancy_New]
    (
      -- Add the parameters for the stored procedure here    
      @iBrandID INT ,
      @sHierarchyList VARCHAR(MAX)=NULL ,
      @EndDate DATETIME ,
      @iCourseID VARCHAR(800) = NULL ,
      @StartDate DATETIME    
    )
AS 
    BEGIN TRY    
    
        IF @iCourseID IS NULL 
            BEGIN    
                SELECT  
						TBM.S_Brand_Name Brand,
						CM2.S_Center_Name AS Center ,
						TBM.S_Brand_Code "Batch Code",
						[TSBM].S_Batch_Name "Batch Name",
						CFM.S_CourseFamily_Name "Course Family Name",
						CM.S_Course_Name "Course Name",
						[TSBM].[Dt_BatchStartDate] "Start Date",
						TDPM.S_Pattern_Name "Days",
						TCBD.I_Min_Strength "Min. Capacity",
						TCBD.Max_Strength "Max Capacity",
						StudentCount.NoOfStudents "No of Student Enrolled"


				
						--[TBCD].[I_Brand_ID] ,
      --                  TBM.S_Brand_Code ,
      --                  CM2.S_Center_Name AS S_Center_Name ,
      --                  [TSBM].[S_Batch_Code] ,
      --                  [TSBM].S_Batch_Name ,
      --                  CM.S_Course_Name ,
      --                  CFM.S_CourseFamily_Name ,
      --                  [TSBM].[Dt_BatchStartDate] ,
      --                  [TSBM].[Dt_Course_Expected_End_Date] ,
      --                  [TSBM].[Dt_Course_Actual_End_Date] ,
      --                  TSBM.Dt_BatchIntroductionDate ,
      --                  TDPM.S_Pattern_Name ,
      --                  TSBM.I_TimeSlot_ID ,
      --                  TCBD.Max_Strength ,
						--TCBD.I_Min_Strength,
      --                  StudentCount.NoOfStudents ,
      --                  ( SELECT    CAST(CAST(LEFT(MIN(CONVERT(TIME, TCTM.Dt_Start_Time)),
      --                                             5) AS VARCHAR) + '  to '
      --                              + CAST(LEFT(MAX(CONVERT(TIME, TCTM.Dt_End_Time)),
      --                                          5) AS VARCHAR) AS VARCHAR) AS TimeSlot
      --                    FROM      dbo.T_Center_Timeslot_Master TCTM
      --                              INNER JOIN dbo.fnGetCentersForReports(@sHierarchyList,
      --                                                        @iBrandID) AS FCR ON TCTM.I_Center_ID = FCR.centerID
      --                  ) AS TimeSlot
                FROM    dbo.T_Center_Batch_Details AS TCBD
                        INNER JOIN 
						(SELECT  FGCFR.centerID    
                                            FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) AS FGCFR)
						AS TCM ON TCBD.I_Centre_Id = TCM.centerID
						INNER JOIN T_Centre_Master as CM2 on CM2.I_Centre_Id=TCM.centerID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TCBD.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Brand_Center_Details AS TBCD ON TCBD.I_Centre_Id = TBCD.I_Centre_Id
                        INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                        INNER JOIN dbo.T_Course_Master CM ON TSBM.I_Course_ID = CM.I_Course_ID
                        INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID = CFM.I_CourseFamily_ID
                        INNER JOIN dbo.T_Delivery_Pattern_Master TDPM ON TSBM.I_Delivery_Pattern_ID = TDPM.I_Delivery_Pattern_ID
                        LEFT JOIN ( SELECT  TSBD1.I_Batch_ID ,
                                            COUNT(DISTINCT TSBD1.I_Student_ID) AS NoOfStudents
                                    FROM    dbo.T_Student_Batch_Details TSBD1
                                    WHERE   TSBD1.I_Status=1
									--and ISNULL(TSBD1.Dt_Valid_To,GETDATE())<='2021-01-05'
                                    GROUP BY TSBD1.I_Batch_ID
                                  ) StudentCount ON TCBD.I_Batch_ID = StudentCount.I_Batch_ID
                WHERE   TSBM.Dt_BatchStartDate>= @StartDate
                        AND  TSBM.Dt_BatchStartDate<DATEADD(d,1,@EndDate)   
                ORDER BY [TBCD].[I_Brand_ID] ,
                        [TBCD].[I_Centre_Id]   
            END    
        ELSE 
            BEGIN    
			        SELECT
						TBM.S_Brand_Name Brand,
						CM2.S_Center_Name AS Center ,
						TBM.S_Brand_Code "Batch Code",
						[TSBM].S_Batch_Name "Batch Name",
						CFM.S_CourseFamily_Name "Course Family Name",
						CM.S_Course_Name "Course Name",
						[TSBM].[Dt_BatchStartDate] "Start Date",
						TDPM.S_Pattern_Name "Days",
						TCBD.I_Min_Strength "Min. Capacity",
						TCBD.Max_Strength "Max Capacity",
						StudentCount.NoOfStudents "No of Student Enrolled"

	  
	  --				 [TBCD].[I_Brand_ID] ,
      --                  TBM.S_Brand_Code ,
      --                  CM2.S_Center_Name AS S_Center_Name ,
      --                  [TSBM].[S_Batch_Code] ,
      --                  [TSBM].S_Batch_Name ,
      --                  CM.S_Course_Name ,
      --                  CFM.S_CourseFamily_Name ,
      --                  [TSBM].[Dt_BatchStartDate] ,
      --                  [TSBM].[Dt_Course_Expected_End_Date] ,
      --                  [TSBM].[Dt_Course_Actual_End_Date] ,
      --                  TSBM.Dt_BatchIntroductionDate ,
      --                  TDPM.S_Pattern_Name ,
      --                  TSBM.I_TimeSlot_ID ,
      --                  TCBD.Max_Strength ,
						--TCBD.I_Min_Strength,
      --                  StudentCount.NoOfStudents ,
      --                  ( SELECT    CAST(CAST(LEFT(MIN(CONVERT(TIME, TCTM.Dt_Start_Time)),
      --                                             5) AS VARCHAR) + '  to '
      --                              + CAST(LEFT(MAX(CONVERT(TIME, TCTM.Dt_End_Time)),
      --                                          5) AS VARCHAR) AS VARCHAR) AS TimeSlot
                        --  FROM      dbo.T_Center_Timeslot_Master TCTM
                        --            INNER JOIN dbo.fnGetCentersForReports(@sHierarchyList,
                        --                                      @iBrandID) AS FCR ON TCTM.I_Center_ID = FCR.centerID
                        --) AS TimeSlot
                FROM    dbo.T_Center_Batch_Details AS TCBD
                        INNER JOIN 
						(SELECT  FGCFR.centerID    
                                            FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) AS FGCFR)
						AS TCM ON TCBD.I_Centre_Id = TCM.centerID
						INNER JOIN T_Centre_Master as CM2 on CM2.I_Centre_Id=TCM.centerID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TCBD.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Brand_Center_Details AS TBCD ON TCBD.I_Centre_Id = TBCD.I_Centre_Id
                        INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                        INNER JOIN dbo.T_Course_Master CM ON TSBM.I_Course_ID = CM.I_Course_ID
                        INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID = CFM.I_CourseFamily_ID
                        INNER JOIN dbo.T_Delivery_Pattern_Master TDPM ON TSBM.I_Delivery_Pattern_ID = TDPM.I_Delivery_Pattern_ID
                        LEFT JOIN ( SELECT  TSBD1.I_Batch_ID ,
                                            COUNT(DISTINCT TSBD1.I_Student_ID) AS NoOfStudents
                                    FROM    dbo.T_Student_Batch_Details TSBD1
                                    WHERE   TSBD1.I_Status=1
									--and ISNULL(TSBD1.Dt_Valid_To,GETDATE())<='2021-01-05'
                                    GROUP BY TSBD1.I_Batch_ID
                                  ) StudentCount ON TCBD.I_Batch_ID = StudentCount.I_Batch_ID
                WHERE TSBM.I_Course_ID IN (
                        SELECT  Val
                        FROM    fnString2Rows(@iCourseID, ',') )
						and
				TSBM.Dt_BatchStartDate>= @StartDate
                        AND  TSBM.Dt_BatchStartDate<DATEADD(d,1,@EndDate)   
                ORDER BY [TBCD].[I_Brand_ID] ,
                        [TBCD].[I_Centre_Id]     
            END    
    
    END TRY    
    
    BEGIN CATCH    
     
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT    
    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH
