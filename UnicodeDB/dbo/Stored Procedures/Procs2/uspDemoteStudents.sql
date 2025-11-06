CREATE PROCEDURE [dbo].[uspDemoteStudents] ( @studentdetID INT )
AS 
    BEGIN


        CREATE TABLE #temp
            (
              studentbatchid INT ,
              studentid INT ,
              istatus INT
            )

        INSERT  INTO #temp
                ( studentbatchid ,
                  studentid ,
                  istatus 
                )
                SELECT TOP 2
                        I_Student_Batch_ID ,
                        I_Student_ID ,
                        TSBD.I_Status AS Sts
                FROM    dbo.T_Student_Batch_Details TSBD
                WHERE   I_Student_ID = @studentdetID
                ORDER BY I_Student_Batch_ID DESC


        IF ( ( ( SELECT TOP 1
                        istatus
                 FROM   #temp
                 WHERE  studentid = @studentdetID
               ) <> 1 )
             AND ( ( SELECT TOP 1
                            istatus
                     FROM   #temp
                     WHERE  studentid = @studentdetID
                   ) <> 2 )
           ) 
            BEGIN
                UPDATE  TT
                SET     TT.I_Status = 1
                FROM    dbo.T_Student_Batch_Details TT
                        INNER JOIN #temp T ON T.studentbatchid = TT.I_Student_Batch_ID
                                              AND T.studentid = TT.I_Student_ID
                WHERE   T.istatus = 2
	
                UPDATE  TT
                SET     TT.I_Status = 0
                FROM    dbo.T_Student_Batch_Details TT
                        INNER JOIN #temp T ON T.studentbatchid = TT.I_Student_Batch_ID
                                              AND T.studentid = TT.I_Student_ID
                WHERE   T.istatus = 3
	
            END

    END
