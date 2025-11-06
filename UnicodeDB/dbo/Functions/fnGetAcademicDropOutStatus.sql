CREATE FUNCTION [dbo].[fnGetAcademicDropOutStatus]
    (
      @BatchID INT = NULL ,
      @iStudentID INT ,
      @dtDate DATE = NULL
    )
RETURNS INT
AS 
    BEGIN


        IF ( @dtDate IS NULL ) 
            BEGIN
                SET @dtDate = CONVERT(DATE, GETDATE())
            END

        DECLARE @dtStartDate DATE= DATEADD(dd, -31, @dtdate)
        DECLARE @dtAdmDate DATE= ( SELECT   Dt_Crtd_On
                                   FROM     dbo.T_Student_Detail
                                   WHERE    I_Student_Detail_ID = @iStudentID
                                 )
        DECLARE @DropOutStatus INT

        IF @BatchID IS NULL 
            BEGIN
                SET @BatchID = ( SELECT T2.I_Batch_ID
                                 FROM   ( SELECT    TSBD2.I_Student_ID ,
                                                    MAX(TSBD2.I_Student_Batch_ID) AS ID
                                          FROM      dbo.T_Student_Batch_Details TSBD2
                                          WHERE     TSBD2.I_Status IN ( 1, 3 )
                                                    AND TSBD2.I_Student_ID = @iStudentID
                                          GROUP BY  TSBD2.I_Student_ID
                                        ) T1
                                        INNER JOIN ( SELECT TSBD3.I_Student_ID ,
                                                            TSBD3.I_Student_Batch_ID AS ID ,
                                                            TSBD3.I_Batch_ID
                                                     FROM   dbo.T_Student_Batch_Details TSBD3
                                                     WHERE  TSBD3.I_Status IN (
                                                            1, 3 )
                                                            AND TSBD3.I_Student_ID = @iStudentID
                                                   ) T2 ON T1.ID = T2.ID
                                                           AND T1.I_Student_ID = T2.I_Student_ID
                               )
                       
            END
                       
        IF ( SELECT Dt_BatchStartDate
             FROM   dbo.T_Student_Batch_Master
             WHERE  I_Batch_ID = @BatchID
           ) > @dtDate 
            BEGIN
                SET @DropOutStatus = 0
            END
        ELSE 
            IF ( DATEDIFF(d, @dtAdmDate, @dtDate) < 31 ) 
                BEGIN
                    SET @DropOutStatus = 0
                END
        
        
            ELSE 
                IF EXISTS ( SELECT  *
                            FROM    dbo.T_TimeTable_Master TTTM
                                    INNER JOIN dbo.T_Student_Attendance TSA ON TTTM.I_TimeTable_ID = TSA.I_TimeTable_ID
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON TTTM.I_Batch_ID = TSBM.I_Batch_ID
                            WHERE   TSA.I_Student_Detail_ID = @iStudentID
                                    AND TTTM.I_Status = 1
                                    AND TTTM.Dt_Schedule_Date BETWEEN @dtStartDate
                                                              AND
                                                              DATEADD(d, 1,
                                                              @dtDate) --OR TSBM.Dt_BatchStartDate BETWEEN @dtStartDate AND DATEADD(d,1,@dtDate)
) 
                    BEGIN
                        SET @DropOutStatus = 0
                    END
                ELSE 
                    IF EXISTS ( SELECT  *
                                FROM    dbo.T_Student_Detail TSA
                                        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSA.I_Student_Detail_ID = TSBD.I_Student_ID
                                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                WHERE   TSA.I_Student_Detail_ID = @iStudentID
                                        AND TSBD.I_Status = 1
						--AND TTTM.I_Status=1
                                        AND TSBM.Dt_BatchStartDate BETWEEN @dtStartDate
                                                              AND
                                                              DATEADD(d, 1,
                                                              @dtDate) ) 
                        BEGIN
                            SET @DropOutStatus = 0
                        END
                    ELSE 
                        BEGIN
                            SET @DropOutStatus = 1
                        END

--END
--END
--ELSE
--BEGIN
--	SET @DropOutStatus=1
--END
        RETURN @DropOutStatus

    END


--SELECT * FROM dbo.T_Student_Attendance TSA where I_Student_Detail_ID=55578

--SELECT * FROM dbo.T_TimeTable_Master TTTM WHERE I_Batch_ID=5509
--SELECT * FROM dbo.T_TimeTable_Master TTTM WHERE I_TimeTable_ID=407999
