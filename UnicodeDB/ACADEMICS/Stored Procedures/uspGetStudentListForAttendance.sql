CREATE PROCEDURE [ACADEMICS].[uspGetStudentListForAttendance] --[ACADEMICS].[uspGetStudentListForAttendance] 3,1,0,'2012-12-17 00:00:00.000'              
    (
      @iTimeTableID INT ,
      @iCenterID INT ,
      @iFlag INT ,
      @DtScheduleDate DATETIME = NULL            
    )
AS 
    BEGIN                
        DECLARE @iBatchID INT          
        DECLARE @iTermID INT           
        DECLARE @iModuleID INT          
        DECLARE @iSessionID INT
        DECLARE @iSub_Batch_ID INT =0
        DECLARE @iSubBatch_Name varchar(100)            
                 
        SELECT  @iBatchID = TTTM.I_Batch_ID ,
                @iTermID = TTM.I_Term_ID ,
                @iModuleID = TMM.I_Module_ID ,
                @iSessionID = TTTM.I_Session_ID,
                @iSub_Batch_ID= ISNULL(TTTM.I_Sub_Batch_ID,0) ,
                @iSubBatch_Name=TSB.S_Sub_Batch_Name 

        FROM    dbo.T_TimeTable_Master AS TTTM
                INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TTTM.I_Term_ID
                INNER JOIN dbo.T_Module_Master AS TMM ON TMM.I_module_ID = TTTM.I_module_ID
                LEFT OUTER  JOIN T_Student_Sub_Batch_Master  TSB ON  ISNULL(TSB.I_Sub_Batch_ID,0)=ISNULL(TTTM.I_Sub_Batch_ID,0)   AND TSB.I_Status = 1 
        WHERE   TTTM.I_TimeTable_ID = @iTimeTableID
                AND TTTM.I_Status = 1
                AND TTM.I_Status = 1
                AND TMM.I_Status = 1         
                  
        DECLARE @iCourseID INT           
        SELECT  @iCourseID = I_Course_ID
        FROM    dbo.T_Student_Batch_Master
        WHERE   I_Batch_ID = @iBatchID          
            
               
        IF @iFlag = 1 
            BEGIN          
                SELECT DISTINCT
                        ISNULL(SBD.I_RollNo,SD.I_RollNo) AS I_RollNo ,
                        SD.I_Student_Detail_ID ,
                        SD.S_Student_ID ,
                        SD.S_First_Name ,
                        SD.S_Middle_Name ,
                        SD.S_Last_Name ,
                        @iCenterID AS I_Centre_Id ,
                        @iBatchID AS I_Batch_ID ,
                        IsOnLeave = CASE WHEN ISNULL(TSLR.I_Student_Leave_ID,
                                                     0) > 0 THEN 1
                                         ELSE 0
                                    END
                FROM    dbo.T_Student_Detail SD
                        INNER JOIN dbo.T_Student_Batch_Details SBD ON SD.I_Student_Detail_ID = SBD.I_Student_ID
                                                              AND SBD.I_Batch_ID = @iBatchID
                        INNER JOIN dbo.T_Student_Center_Detail SCD ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Term_Detail STD ON STD.I_Student_Detail_ID = SD.I_Student_Detail_ID
                                                              AND STD.I_Term_ID = @iTermID
                                                              AND SCD.I_Centre_Id = @iCenterID
                                                              AND SCD.I_Status = 1
                                                              AND STD.I_Is_Completed = 0
                                                              AND SBD.I_Status = 1
                        LEFT OUTER JOIN dbo.T_Student_Leave_Request AS TSLR ON SD.I_Student_Detail_ID = TSLR.I_Student_Detail_ID
                                                              AND TSLR.I_Status = 1
                                                              AND @DtScheduleDate BETWEEN TSLR.Dt_From_Date
                                                              AND
                                                              TSLR.Dt_To_Date 
                        WHERE SD.I_Status=1                                      
               ORDER BY ISNULL(SBD.I_RollNo,SD.I_RollNo) 
        
            END  
            ELSE IF @iFlag=2
            BEGIN
                      
           SELECT DISTINCT
                        ISNULL(SBD.I_RollNo,SD.I_RollNo) AS I_RollNo ,
                        SD.I_Student_Detail_ID ,
                        SD.S_Student_ID ,
                        SD.S_First_Name ,
                        SD.S_Middle_Name ,
                        SD.S_Last_Name ,
                        @iCenterID AS I_Centre_Id ,
                        @iTimeTableID AS I_Batch_ID ,
                        IsOnLeave = CASE WHEN ISNULL(TSLR.I_Student_Leave_ID,
                                                     0) > 0 THEN 1
                                         ELSE 0
                                    END
        
                FROM    dbo.T_Student_Detail SD
                        INNER JOIN dbo.T_Student_Batch_Details SBD ON SD.I_Student_Detail_ID = SBD.I_Student_ID
                                                           AND SBD.I_Batch_ID = @iTimeTableID
                        INNER JOIN dbo.T_Student_Center_Detail SCD ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Term_Detail STD ON STD.I_Student_Detail_ID = SD.I_Student_Detail_ID
                                                              AND SCD.I_Centre_Id = @iCenterID
                                                              AND SCD.I_Status = 1
                                                              AND STD.I_Is_Completed = 0
                                                              AND SBD.I_Status = 1
                        LEFT OUTER JOIN dbo.T_Student_Leave_Request AS TSLR ON SD.I_Student_Detail_ID = TSLR.I_Student_Detail_ID
                                                              AND TSLR.I_Status = 1
                        WHERE SD.I_Status=1                                      
                   

            END
            IF @iFlag = 3 
            BEGIN  
            IF @iSub_Batch_ID<>0
            BEGIN        
                SELECT DISTINCT
                        ISNULL(SBD.I_RollNo,SD.I_RollNo) AS I_RollNo ,
                        SD.I_Student_Detail_ID ,
                        SD.S_Student_ID ,
                        SD.S_First_Name ,
                        SD.S_Middle_Name ,
                        SD.S_Last_Name ,
                        @iCenterID AS I_Centre_Id ,
                        @iBatchID AS I_Batch_ID ,
                        IsOnLeave = CASE WHEN ISNULL(TSLR.I_Student_Leave_ID,
                                                     0) > 0 THEN 1
                                         ELSE 0
                                    END,
                         @iSub_Batch_ID as I_Sub_Batch_ID,
                         @iSubBatch_Name as S_Sub_Batch_Name  
                FROM    dbo.T_Student_Detail SD
                        INNER JOIN dbo.T_Student_Batch_Details SBD ON SD.I_Student_Detail_ID = SBD.I_Student_ID
                                                              AND SBD.I_Batch_ID = @iBatchID
                        INNER JOIN dbo.T_Student_Center_Detail SCD ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Term_Detail STD ON STD.I_Student_Detail_ID = SD.I_Student_Detail_ID
                                                              AND STD.I_Term_ID = @iTermID
                                                              AND SCD.I_Centre_Id = @iCenterID
                                                              AND SCD.I_Status = 1
                                                              AND STD.I_Is_Completed = 0
                                                              AND SBD.I_Status = 1
                        LEFT OUTER JOIN dbo.T_Student_Leave_Request AS TSLR ON SD.I_Student_Detail_ID = TSLR.I_Student_Detail_ID
                                                              AND TSLR.I_Status = 1
                                                          
                        INNER  JOIN T_Student_Sub_Batch_Master  TSB ON  SBD.I_Batch_ID=TSB.I_Batch_ID
                        INNER JOIN T_Student_Sub_Batch_Student_Mapping TSBM ON  TSBM.I_Sub_Batch_ID=TSB.I_Sub_Batch_ID AND TSBM.I_Status = 1
                        AND  TSBM.I_Student_Detail_ID = SD.I_Student_Detail_ID 
                        AND TSB.I_Sub_Batch_ID=@iSub_Batch_ID
                         AND TSB.I_Status = 1 
                         WHERE SD.I_Status=1                                  
       
               ORDER BY ISNULL(SBD.I_RollNo,SD.I_RollNo) 
               END
               ELSE
               BEGIN
                SELECT DISTINCT
                        ISNULL(SBD.I_RollNo,SD.I_RollNo) AS I_RollNo ,
                        SD.I_Student_Detail_ID ,
                        SD.S_Student_ID ,
                        SD.S_First_Name ,
                        SD.S_Middle_Name ,
                        SD.S_Last_Name ,
                        @iCenterID AS I_Centre_Id ,
                        @iBatchID AS I_Batch_ID ,
                        IsOnLeave = CASE WHEN ISNULL(TSLR.I_Student_Leave_ID,
                                                     0) > 0 THEN 1
                                         ELSE 0
                                    END,
                         @iSub_Batch_ID as I_Sub_Batch_ID,
                         @iSubBatch_Name as S_Sub_Batch_Name  
                FROM    dbo.T_Student_Detail SD
                        INNER JOIN dbo.T_Student_Batch_Details SBD ON SD.I_Student_Detail_ID = SBD.I_Student_ID
                                                              AND SBD.I_Batch_ID = @iBatchID
                        INNER JOIN dbo.T_Student_Center_Detail SCD ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Term_Detail STD ON STD.I_Student_Detail_ID = SD.I_Student_Detail_ID
                                                              AND STD.I_Term_ID = @iTermID
                                                              AND SCD.I_Centre_Id = @iCenterID
                                                              AND SCD.I_Status = 1
                                                              AND STD.I_Is_Completed = 0
                                                              AND SBD.I_Status = 1
                        LEFT OUTER JOIN dbo.T_Student_Leave_Request AS TSLR ON SD.I_Student_Detail_ID = TSLR.I_Student_Detail_ID
                                                              AND TSLR.I_Status = 1
                                                              --akash
                                                              AND (@DtScheduleDate BETWEEN TSLR.Dt_From_Date
                                                              AND
                                                              TSLR.Dt_To_Date)
                                                              --akash
                        LEFT OUTER  JOIN T_Student_Sub_Batch_Master  TSB ON  SBD.I_Batch_ID=TSB.I_Sub_Batch_ID
                        AND TSB.I_Sub_Batch_ID=@iSub_Batch_ID   AND TSB.I_Status = 1 
                        WHERE SD.I_Status=1                                   
       
               ORDER BY ISNULL(SBD.I_RollNo,SD.I_RollNo)
               END
        
            END
        ELSE 
            BEGIN          
                SELECT DISTINCT
                        ISNULL(SBD.I_RollNo,SD.I_RollNo) AS I_RollNo ,
                        SD.I_Student_Detail_ID ,
                        SD.S_Student_ID ,
                        SD.S_First_Name ,
                        SD.S_Middle_Name ,
                        SD.S_Last_Name ,
                        @iCenterID AS I_Centre_Id ,
                        SBD.I_Batch_ID,
                        IsOnLeave = CASE WHEN ISNULL(TSLR.I_Student_Leave_ID,
                                                     0) > 0 THEN 1
                                         ELSE 0
                                    END
                FROM    dbo.T_Student_Detail SD
                        INNER JOIN dbo.T_Student_Center_Detail SCD ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Batch_Details SBD ON SD.I_Student_Detail_ID = SBD.I_Student_ID
                                                              AND SBD.I_Status = 1
                                                              AND [SBD].[I_Batch_ID] <> @iBatchID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON SBD.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                                              AND TCBD.I_Centre_Id = @iCenterID
                        INNER JOIN dbo.T_Student_Term_Detail STD ON STD.I_Student_Detail_ID = SD.I_Student_Detail_ID
                                                              AND SCD.I_Centre_Id = @iCenterID
                                                              AND SCD.I_Status = 1
                                                              AND STD.I_Is_Completed = 0
                        LEFT OUTER JOIN dbo.T_Student_Leave_Request AS TSLR ON SD.I_Student_Detail_ID = TSLR.I_Student_Detail_ID
                                                              AND TSLR.I_Status = 1
                                                              AND (@DtScheduleDate BETWEEN TSLR.Dt_From_Date
                                                              AND
                                                              TSLR.Dt_To_Date) 
                WHERE   STD.I_Term_ID = ISNULL(@iTermID, STD.I_Term_ID)
                        AND TSBM.I_Course_ID = @iCourseID
                        AND TCBD.I_Status IN ( 4, 5, 6 )
                        AND SD.I_Status=1
                ORDER BY SBD.I_Batch_ID,ISNULL(SBD.I_RollNo,SD.I_RollNo)
            END    
    END
