CREATE FUNCTION dbo.fnGetHistoricalBatchStrength
    (
      @iBatchID INT ,
      @dtDate DATE
    )
RETURNS INT
AS 
    BEGIN

        DECLARE @StudentStrength INT
        
        SET @StudentStrength=

								 (SELECT COUNT(DISTINCT T3.I_Student_ID) AS StudentStrength
                                 FROM   ( SELECT    T1.I_Batch_ID ,
                                                    T1.I_Student_ID ,
                                                    T1.Dt_Valid_From AS ValidFromDate ,
                                                    ISNULL(T2.Dt_Valid_From,
                                                           GETDATE()) AS ValidToDate
                                          FROM      ( SELECT  TSBM.I_Batch_ID ,
                                                              TSBD.I_Student_ID ,
                                                              TSBD.Dt_Valid_From ,
                                                              DENSE_RANK() OVER ( PARTITION BY TSBM.I_Batch_ID,
                                                              TSBD.I_Student_ID ORDER BY TSBD.Dt_Valid_From ASC ) AS Sequence
                                                      FROM    dbo.T_Student_Batch_Details TSBD WITH (NOLOCK)
                                                              INNER JOIN dbo.T_Student_Batch_Master TSBM WITH (NOLOCK) ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                                              --INNER JOIN dbo.T_Center_Batch_Details TCBD WITH (NOLOCK) ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                                              --INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                                      WHERE   TSBD.Dt_Valid_From IS NOT NULL
                                                              AND TSBM.I_Batch_ID = @iBatchID

                                                    ) T1
                                                    LEFT JOIN ( SELECT
                                                              TSBM.I_Batch_ID ,
                                                              TSBD.I_Student_ID ,
                                                              TSBD.Dt_Valid_From ,
                                                              DENSE_RANK() OVER ( PARTITION BY TSBM.I_Batch_ID,
                                                              TSBD.I_Student_ID ORDER BY TSBD.Dt_Valid_From ASC ) AS Sequence
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD WITH (NOLOCK)
                                                              INNER JOIN dbo.T_Student_Batch_Master TSBM WITH (NOLOCK) ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                                              --INNER JOIN dbo.T_Center_Batch_Details TCBD WITH (NOLOCK) ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                                              --INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                                      WHERE   TSBD.Dt_Valid_From IS NOT NULL
                                                              AND TSBM.I_Batch_ID = @iBatchID

                                                              ) T2 ON T1.I_Batch_ID = T2.I_Batch_ID
                                                              AND T1.I_Student_ID = T2.I_Student_ID
                                                              AND T1.Sequence = T2.Sequence
                                                              - 1
 
                                        ) T3 WHERE @dtDate BETWEEN T3.ValidFromDate AND T3.ValidToDate
                                        GROUP BY T3.I_Batch_ID
                                        )
                                        
                                        RETURN @StudentStrength

    END