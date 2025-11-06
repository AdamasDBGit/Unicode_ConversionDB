CREATE FUNCTION [dbo].[fnGetHistoricalBatchID]
    (
      @iStudentID INT ,
      @dtDate DATETIME
    )
RETURNS INT
AS 
    BEGIN

        DECLARE @BatchID INT
	 
	 
        SET @BatchID = ( SELECT   TOP 1 TSBM.I_Batch_ID
                           FROM     ( SELECT    XX.I_Student_ID ,
                                                XX.I_Batch_ID ,
                                                XX.StartDate ,
                                                ISNULL(YY.StartDate,
                                                       CONVERT(DATETIME, GETDATE())) AS EndDate
                                      FROM      ( SELECT    TSBD.I_Student_ID ,
                                                            I_Batch_ID ,
                                                            CONVERT(DATETIME, Dt_Valid_From) AS StartDate ,
                                                            DENSE_RANK() OVER ( PARTITION BY I_Student_ID ORDER BY CONVERT(DATETIME, Dt_Valid_From) ASC ) AS DateRank
                                                  FROM      dbo.T_Student_Batch_Details TSBD
                                                  WHERE     TSBD.I_Student_ID = @iStudentID AND TSBD.I_Status IN (0,1,2)
                                                ) XX
                                                LEFT JOIN ( SELECT
                                                              TSBD.I_Student_ID ,
                                                              I_Batch_ID ,
                                                              CONVERT(DATETIME, Dt_Valid_From) AS StartDate ,
                                                              DENSE_RANK() OVER ( PARTITION BY I_Student_ID ORDER BY CONVERT(DATETIME, Dt_Valid_From) ASC ) AS DateRank
                                                            FROM
                                                              dbo.T_Student_Batch_Details TSBD
                                                            WHERE
                                                              TSBD.I_Student_ID = @iStudentID AND TSBD.I_Status IN (0,1,2)
                                                          ) YY ON XX.I_Student_ID = YY.I_Student_ID
                                                              AND YY.DateRank = XX.DateRank
                                                              + 1
                                    ) ZZ
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON ZZ.I_Batch_ID = TSBM.I_Batch_ID
                           WHERE    @dtDate BETWEEN ZZ.StartDate AND ZZ.EndDate
                         )
 
        RETURN (@BatchID) ;
	
    END