
CREATE PROCEDURE [dbo].[uspUpdateStudentAttendanceSolus]
AS 
    BEGIN TRY

        DECLARE @TStudentAttendance TABLE
            (
              I_Student_Detail_ID INT ,
              I_TimeTable_ID INT
            )       
 

        INSERT  INTO @TStudentAttendance
                ( I_Student_Detail_ID ,
                  I_TimeTable_ID  
                )	
  
  --CREATE TABLE T_Send_Attendance_Data
  --(
  
  --)
                SELECT  Z.I_Student_Detail_ID ,
                        z.I_TimeTable_ID
--,DATEDIFF(MINUTE,Start_Time,Arrival_Time) AS 'arrive',
--DATEDIFF(MINUTE,End_Time,Departure_Time) AS 'depart'
                FROM    ( SELECT    A.I_Centre_Id ,
                                    F.centercode ,
                                    A.I_Student_Detail_ID ,
                                    D.I_TimeTable_ID ,
                                    B.S_Student_ID ,
                                    c.I_Batch_ID ,
                                    D.Dt_Actual_Date ,
                                    D.Dt_Schedule_Date ,
                                    D.I_Module_ID ,
                                    D.I_Session_ID ,
                                    D.I_Room_ID ,
                                    D.S_Session_Name ,
                                    DATEADD(day,
                                            DATEDIFF(day, 0, E.Dt_Start_Time)
                                            * -1, E.Dt_Start_Time) AS Start_Time ,
                                    ISNULL(DATEADD(day,
                                                   DATEDIFF(day, 0,
                                                            CAST(F.[ArrivalTime] AS DATETIME))
                                                   * -1,
                                                   CAST(F.[ArrivalTime] AS DATETIME)),
                                           '') AS Arrival_Time ,
                                    DATEADD(day,
                                            DATEDIFF(day, 0, E.Dt_End_Time)
                                            * -1, E.Dt_End_Time) AS End_Time ,
                                    ISNULL(DATEADD(day,
                                                   DATEDIFF(day, 0,
                                                            CAST(F.DepartureTime AS DATETIME))
                                                   * -1,
                                                   CAST(F.DepartureTime AS DATETIME)),
                                           '') AS Departure_Time ,
                                    E.I_TimeSlot_ID
                          FROM      [dbo].[T_Student_Center_Detail] A
                                    INNER JOIN [dbo].[T_Student_Detail] B ON A.I_Student_Detail_ID = B.I_Student_Detail_ID
                                    INNER JOIN [dbo].[T_Student_Batch_Details] C ON C.[I_Student_ID] = A.I_Student_Detail_ID
                                    INNER JOIN [dbo].[T_TimeTable_Master] D ON D.I_Batch_ID = C.I_Batch_ID
                                    INNER JOIN [dbo].T_Center_Timeslot_Master E ON E.I_TimeSlot_ID = D.I_TimeSlot_ID
--inner join [dbo].[T_Send_Attendance_Data] F
                                    INNER JOIN dbo.T_Send_Attendance_Data F ON B.S_Student_ID = F.stdID 
--and A.I_Centre_Id = F.centercode 
                          WHERE     A.I_Centre_Id IN (
                                    SELECT DISTINCT
                                            CAST(centercode AS INT)
                                    FROM    [dbo].[T_Send_Attendance_Data] )
                                    AND C.I_Status = 1
                                    AND D.Dt_Schedule_Date = DATEADD(dd, 0,
                                                              DATEDIFF(dd, 0,
                                                              GETDATE()))--only considering the classes to be held on current date
                        ) AS z
                WHERE   ( Arrival_Time = '1900-01-01 00:00:00.000'
                          OR DATEDIFF(MINUTE, Start_Time, Arrival_Time) < 0
                        )
-- and (Departure_Time='1900-01-01 00:00:00.000' or DATEDIFF(MINUTE,End_Time,Departure_Time) >0)


--following statement will check the record exists and then merge the table

--MERGE [dbo].[T_Student_Attendance]  AS tmp
--USING (select * from @TStudentAttendance) AS tsa
--ON tsa.I_Student_Detail_ID = tmp.I_Student_Detail_ID and tsa.I_TimeTable_ID = tmp.I_TimeTable_ID 
--WHEN MATCHED THEN UPDATE SET tmp.I_Student_Detail_ID=tmp.I_Student_Detail_ID
--WHEN NOT MATCHED THEN
--INSERT(I_Student_Detail_ID,I_TimeTable_ID)
--VALUES(tsa.I_Student_Detail_ID,tsa.I_TimeTable_ID);
        INSERT  INTO [dbo].[T_Student_Attendance]
                ( I_Student_Detail_ID ,
                  I_TimeTable_ID ,
                  S_Crtd_By ,
                  Dt_Crtd_On
                )
                SELECT  tsa.I_Student_Detail_ID ,
                        tsa.I_TimeTable_ID ,
                        'dba' ,
                        GETDATE()
                FROM    @TStudentAttendance AS tsa
                WHERE   NOT EXISTS ( SELECT tmp.I_Student_Detail_ID ,
                                            tmp.I_TimeTable_ID
                                     FROM   [dbo].[T_Student_Attendance] AS tmp
                                     WHERE  tsa.I_Student_Detail_ID = tmp.I_Student_Detail_ID
                                            AND tsa.I_TimeTable_ID = tmp.I_TimeTable_ID )


 --drop table [dbo].[T_Send_Attendance_Data]

    END TRY

    BEGIN CATCH
	--Error occurred:  

        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
    END CATCH
