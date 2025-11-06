CREATE PROCEDURE [dbo].[uspInsertAttendanceDataForEntireDay]
    (
      @iBatchID INT ,
      @dtScheduleDate DATE ,
      @sCrtdBy NVARCHAR(MAX),
      @dtCrtd DATETIME
      --@iBrandID INT ,
      --@sHierarchyID NVARCHAR(MAX)
    )
AS 
    BEGIN
		IF((SELECT I_Centre_Id FROM dbo.T_Center_Batch_Details WHERE I_Batch_ID=@iBatchID)=1)
		BEGIN
        CREATE TABLE #temp ( StudentID INT )
        
        DECLARE @iStudentID INT ;
        DECLARE @iTimeTableID INT ;
        
        INSERT  INTO #temp
                ( StudentID 
                )
                SELECT  I_Student_ID
                FROM    dbo.T_Student_Batch_Details TSBD
                WHERE   I_Batch_ID = @iBatchID
                        AND I_Status = 1
        
        DECLARE BatchStudentList CURSOR
        FOR (SELECT StudentID FROM #temp T)
        
        OPEN BatchStudentList
        FETCH NEXT FROM BatchStudentList
        INTO @iStudentID
        
        WHILE @@FETCH_STATUS = 0 
            BEGIN
        
                IF EXISTS ( SELECT  *
                            FROM    dbo.T_Student_Attendance TSA
                                    INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
                            WHERE   I_Student_Detail_ID = @iStudentID
                                    AND TTTM.Dt_Schedule_Date = @dtScheduleDate ) 
                    BEGIN
        	
                        CREATE TABLE #temp1
                            (
                              iStudentID INT ,
                              iTimeTableID INT ,
                              dtDate DATETIME
                            )
        	
                        INSERT  INTO #temp1
                                ( iStudentID ,
                                  iTimeTableID ,
                                  dtDate 
                                )
                                SELECT  TSSBSM.I_Student_Detail_ID ,
                                        TTTM.I_TimeTable_ID ,
                                        GETDATE() AS CurrDate
                                FROM    dbo.T_TimeTable_Master TTTM
                                        INNER JOIN dbo.T_Student_Sub_Batch_Master TSSBM ON TTTM.I_Sub_Batch_ID = TSSBM.I_Sub_Batch_ID
                                        INNER JOIN dbo.T_Student_Sub_Batch_Student_Mapping TSSBSM ON TSSBM.I_Sub_Batch_ID = TSSBSM.I_Sub_Batch_ID
                                WHERE   TTTM.I_Status = 1
                                        AND TSSBM.I_Status = 1
                                        AND TSSBSM.I_Status = 1
                                        AND TSSBSM.I_Student_Detail_ID = @iStudentID
                                        AND TTTM.Dt_Schedule_Date = @dtScheduleDate
                                        AND TTTM.I_Sub_Batch_ID IS NOT NULL
                                        AND TTTM.I_TimeTable_ID NOT IN (
                                        SELECT  TSA.I_TimeTable_ID
                                        FROM    dbo.T_Student_Attendance TSA
                                        WHERE   I_Student_Detail_ID = @iStudentID )
                                UNION ALL
                                SELECT  TSBD.I_Student_ID AS I_Student_Detail_ID ,
                                        TTTM.I_TimeTable_ID ,
                                        GETDATE() AS CurrDate
                                FROM    dbo.T_TimeTable_Master TTTM
                                        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TTTM.I_Batch_ID = TSBD.I_Batch_ID
                                WHERE   TTTM.I_Status = 1
                                        AND TTTM.Dt_Schedule_Date = @dtScheduleDate
                                        AND TSBD.I_Student_ID = @iStudentID
                                        AND TSBD.I_Status = 1
                                        AND TTTM.I_Sub_Batch_ID IS NULL
                                        AND TTTM.I_TimeTable_ID NOT IN (
                                        SELECT  TSA.I_TimeTable_ID
                                        FROM    dbo.T_Student_Attendance TSA
                                        WHERE   I_Student_Detail_ID = @iStudentID )
                                        
                                        
                        INSERT  INTO dbo.T_Student_Attendance
                                ( I_Student_Detail_ID ,
                                  S_Crtd_By ,
                                  Dt_Crtd_On ,
                                  I_TimeTable_ID
                                                
                                )
                                SELECT  iStudentID ,
                                        @sCrtdBy ,
                                        @dtCrtd,
                                        iTimeTableID
                                FROM    #temp1 T ;
                                        
                        DECLARE TimeTableList CURSOR
                        FOR (SELECT DISTINCT TT.iTimeTableID FROM #temp1 TT)
        
                        OPEN TimeTableList
                        FETCH NEXT FROM TimeTableList
        INTO @iTimeTableID ;
        
                        WHILE @@FETCH_STATUS = 0 
                            BEGIN
                                IF ( ( SELECT   I_Is_Complete
                                       FROM     dbo.T_TimeTable_Master
                                       WHERE    I_TimeTable_ID = @iTimeTableID
                                     ) <> 1 ) 
                                    BEGIN
                                        DECLARE @ActualDate DATE= GETDATE() ;--(SELECT Dt_Schedule_Date FROM dbo.T_TimeTable_Master TTTM WHERE I_TimeTable_ID=@iTimeTableID)
                                        EXEC dbo.uspUpdateTimeTable @iTimeTableID = @iTimeTableID, -- int
                                            @dtActualDate = @ActualDate,-- datetime
                                            @iIsComplete = 1 -- int
                                    END    
        	    
                                FETCH NEXT FROM TimeTableList
        	    INTO @iTimeTableID ;
        	
                            END
                        CLOSE TimeTableList ;
                        DEALLOCATE TimeTableList ;
                                        
                                        
                        DROP TABLE #temp1 ;
                    END
                    
                FETCH NEXT FROM BatchStudentList
                    INTO @iStudentID
        	
            END
        CLOSE BatchStudentList ;
        DEALLOCATE BatchStudentList ;
        END
    END

