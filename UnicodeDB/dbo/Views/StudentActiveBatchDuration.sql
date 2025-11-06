
CREATE VIEW [dbo].[StudentActiveBatchDuration]
AS


WITH STDLIST AS (SELECT DISTINCT
                                            TSBD.I_Student_ID ,
                                            TSBD.I_Batch_ID ,
                                            CONVERT(DATE, ISNULL(TSBD.Dt_Valid_From,
                                                              '2099-01-01')) AS ActiveFromDate
                                  FROM      dbo.T_Student_Batch_Details AS TSBD
                                  WHERE     TSBD.I_Student_ID IN (
                                            SELECT  TSD.I_Student_Detail_ID
                                            FROM    dbo.T_Student_Detail AS TSD
                                            WHERE   TSD.S_Student_ID LIKE '%/RICE/%' OR TSD.S_Student_ID LIKE '%/AC/%' )
                                            AND TSBD.I_Status IN ( 0, 1, 2 ))


    SELECT  T2.* ,
            DATEADD(d, -1, ISNULL(T3.ActiveFromDate, '2099-01-02')) AS ActiveToDate
    FROM    ( SELECT    T1.I_Student_ID ,
                        T1.I_Batch_ID ,
                        T1.ActiveFromDate ,
                        DENSE_RANK() OVER ( PARTITION BY T1.I_Student_ID ORDER BY T1.ActiveFromDate ASC ) AS Rownum
              FROM      ( SELECT * FROM STDLIST
              --SELECT DISTINCT
              --                      TSBD.I_Student_ID ,
              --                      TSBD.I_Batch_ID ,
              --                      CONVERT(DATE, ISNULL(TSBD.Dt_Valid_From,
              --                                           '2099-01-01')) AS ActiveFromDate
              --            FROM      dbo.T_Student_Batch_Details AS TSBD
              --            WHERE     TSBD.I_Student_ID IN (
              --                      SELECT  TSD.I_Student_Detail_ID
              --                      FROM    STDLIST AS TSD )
              --                      AND TSBD.I_Status IN ( 0, 1, 2 )
                        ) T1
            ) T2
            LEFT JOIN ( SELECT  T1.I_Student_ID ,
                                T1.I_Batch_ID ,
                                T1.ActiveFromDate ,
                                DENSE_RANK() OVER ( PARTITION BY T1.I_Student_ID ORDER BY T1.ActiveFromDate ASC ) AS Rownum
                        FROM    ( SELECT * FROM STDLIST
                        --SELECT DISTINCT
                        --                    TSBD.I_Student_ID ,
                        --                    TSBD.I_Batch_ID ,
                        --                    CONVERT(DATE, ISNULL(TSBD.Dt_Valid_From,
                        --                                      '2099-01-01')) AS ActiveFromDate
                        --          FROM      dbo.T_Student_Batch_Details AS TSBD
                        --          WHERE     TSBD.I_Student_ID IN (
                        --                    SELECT  TSD.I_Student_Detail_ID
                        --                    FROM    dbo.T_Student_Detail AS TSD
                        --                    WHERE   TSD.S_Student_ID LIKE '%/RICE/%' )
                        --                    AND TSBD.I_Status IN ( 0, 1, 2 )
                                ) T1
                      ) T3 ON T2.Rownum + 1 = T3.Rownum
                              AND T3.I_Student_ID = T2.I_Student_ID