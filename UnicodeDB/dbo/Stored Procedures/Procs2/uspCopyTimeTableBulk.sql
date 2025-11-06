CREATE PROCEDURE [dbo].[uspCopyTimeTableBulk]
    (
      @CenterId INT ,
      @S_Crtd_By Nnvarchar(max) ,
      @I_TimeSlot_ID INT = NULL ,
      @XMLDateRange XML = NULL 
    )
AS 
    BEGIN

--SET @XMLDateRange='<Root>
--	<MonthWiseCopy Dt_Selected="6/21/2014 12:00:00 AM" Dt_DestDate="9/13/2014 12:00:00 AM" Order="1" />
--	<MonthWiseCopy Dt_Selected="9/13/2014 12:00:00 AM" Dt_DestDate="9/14/2014 12:00:00 AM" Order="2" /></Root>'

        CREATE TABLE #tempTimeTable
            (
              pkid INT IDENTITY(1, 1) ,
              fromDate DATETIME ,
              todate DATETIME ,
              sequenceorderid INT
            ) 
        CREATE TABLE #tempTimeTablewithid
            (
              pkid INT IDENTITY(1, 1) ,
              fromDate DATETIME ,
              todate DATETIME ,
              sequenceorderid INT ,
              ptimetableid INT
            ) 
        CREATE TABLE #tmp
            (
              I_TimeTable_ID INT ,
              I_Center_ID INT ,
              Dt_Schedule_Date DATETIME ,
              I_TimeSlot_ID INT ,
              I_Batch_ID INT ,
              I_Sub_Batch_ID INT NULL,
              I_Room_ID INT ,
              I_Skill_ID INT NULL ,
              I_Status INT ,
              S_Crtd_By nvarchar(max) NULL ,
              Dt_Crtd_On DATETIME ,
              S_Updt_By nvarchar(max) NULL ,
              Dt_Updt_On DATETIME NULL ,
              S_Remarks nvarchar(max) NULL ,
              I_Session_ID_ASIS INT ,
              I_Term_ID INT ,
              I_Module_ID INT ,
              S_Session_Name_ASIS nvarchar(max) ,
              S_Session_Topic_ASIS nvarchar(max) ,
              Dt_Actual_Date DATETIME NULL ,
              I_Is_Complete INT ,
              I_Employee_ID INT ,
              B_Is_Actual BIT ,
              ROW INT ,
              I_Session_ID INT ,
              S_Session_Code nvarchar(max) ,
              S_Session_Name nvarchar(max) ,
              S_Session_Topic nvarchar(max) ,
              I_Module_ID_tobe INT
            ) ;
 
        DECLARE @increment INT = 1 ;
        DECLARE @totalcount INT= 1 ;
        DECLARE @incrementS INT = 1 ;
        DECLARE @totalcountS INT= 1 ;
        DECLARE @routineDate DATETIME ;
        DECLARE @Todate DATETIME ;
        DECLARE @SDayOfWeek nvarchar(max) ;
        DECLARE @ptimetableid INT ;
  
        INSERT  INTO #tempTimeTable
                ( fromDate ,
                  todate ,
                  sequenceorderid
                )
                SELECT  T.c.value('@Dt_Selected', 'datetime') ,
                        T.c.value('@Dt_DestDate', 'datetime') ,
                        T.c.value('@Order', 'int')
                FROM    @XMLDateRange.nodes('/Root/MonthWiseCopy') T ( c ) ;  
                
                 
    
--SELECT * FROM  #tempTimeTable;-------------
            
        SELECT  @totalcount = MAX(sequenceorderid)
        FROM    #tempTimeTable ;
        
        WHILE ( @increment <= ISNULL(@totalcount, 0) ) 
            BEGIN
               
                SET @routineDate = NULL ;
                SET @Todate = NULL ;
                
                SELECT  @routineDate = fromDate ,
                        @Todate = todate
                FROM    #tempTimeTable
                WHERE   sequenceorderid = @increment ;
                SELECT  @SDayOfWeek = ( DATEPART(dw, @Todate) - 1 ) ;
                
               
                
                INSERT  INTO #tempTimeTablewithid
                        ( fromDate ,
                          todate ,
                          sequenceorderid ,
                          ptimetableid
                        )
                        SELECT  @routineDate ,
                                @Todate ,
                                @increment ,
                                tm.I_TimeTable_ID
                        FROM    dbo.T_TimeTable_Master TM WITH ( NOLOCK )
                                INNER JOIN dbo.T_TimeTable_Faculty_Map FM WITH ( NOLOCK ) ON TM.I_TimeTable_ID = FM.I_TimeTable_ID
                                INNER JOIN T_Center_Timeslot_Master TSM WITH ( NOLOCK ) ON tsm.I_TimeSlot_ID = TM.I_TimeSlot_ID
                        WHERE   TM.I_Center_ID = @CenterId
                                AND CONVERT(DATE, TM.Dt_Schedule_Date) = CONVERT(DATE, @routineDate)
                                AND TM.I_Status = 1
                                AND FM.B_Is_Actual = 0
                                AND TM.I_TimeSlot_ID = ISNULL(@I_TimeSlot_ID,
                                                              TM.I_TimeSlot_ID)
                        ORDER BY CONVERT(TIME, TSM.Dt_Start_Time) ;
                                
                SET @incrementS = 1
                    
                    
                SELECT  @totalcountS = MAX(pkid)
                FROM    #tempTimeTablewithid ;  
                
                DELETE  FROM dbo.T_TimeTable_Faculty_Map
                WHERE   I_TimeTable_ID IN (
                        SELECT  I_TimeTable_ID
                        FROM    dbo.T_TimeTable_Master AS TTTM
                        WHERE   CONVERT(DATE, Dt_Schedule_Date) = CONVERT(DATE, @ToDate)
                                AND I_Center_ID = @CenterId
                                AND TTTM.I_TimeSlot_ID = ISNULL(@I_TimeSlot_ID,
                                                              TTTM.I_TimeSlot_ID) )          
             
                UPDATE  dbo.T_TimeTable_Master
                SET     I_Status = 0 ,
                        S_Updt_By = @S_Crtd_By ,
                        Dt_Updt_On = GETDATE()
                WHERE   CONVERT(DATE, Dt_Schedule_Date) = CONVERT(DATE, @ToDate)
                        AND I_Center_ID = @CenterId
                        AND I_TimeSlot_ID = ISNULL(@I_TimeSlot_ID,
                                                   I_TimeSlot_ID)           
				
                WHILE ( @incrementS <= ISNULL(@totalcountS, 0) ) 
                    BEGIN
                    
                        SET @ptimetableid = 0 ;
                    
                        SELECT  @ptimetableid = ptimetableid
                        FROM    #tempTimeTablewithid
                        WHERE   pkid = @incrementS ;
                    
                        WITH    C ( I_TimeTable_ID, I_Center_ID, Dt_Schedule_Date, I_TimeSlot_ID, I_Batch_ID,I_Sub_Batch_ID, I_Room_ID, I_Skill_ID, I_Status, S_Crtd_By, Dt_Crtd_On, S_Updt_By, Dt_Updt_On, S_Remarks, I_Session_ID_ASIS, I_Term_ID, I_Module_ID, S_Session_Name_ASIS, S_Session_Topic_ASIS, Dt_Actual_Date, I_Is_Complete, I_Employee_ID, B_Is_Actual, ROW, I_Session_ID, S_Session_Code, S_Session_Name, S_Session_Topic, I_Module_ID_tobe )
                                  AS ( SELECT   tm.I_TimeTable_ID ,
                                                TM.I_Center_ID ,
                                                CONVERT(DATE, @Todate) Dt_Schedule_Date ,
                                                TM.I_TimeSlot_ID ,
                                                TM.I_Batch_ID ,
                                                TM.I_Sub_Batch_ID,
                                                TM.I_Room_ID ,
                                                TM.I_Skill_ID ,
                                                TM.I_Status ,
                                                @S_Crtd_By S_Crtd_By ,
                                                GETDATE() Dt_Crtd_On ,
                                                NULL S_Updt_By ,
                                                NULL Dt_Updt_On ,
                                                NULL S_Remarks ,
                                                TM.I_Session_ID I_Session_ID_ASIS ,---
                                                TM.I_Term_ID ,
                                                TM.I_Module_ID ,
                                                TM.S_Session_Name S_Session_Name_ASIS ,---
                                                TM.S_Session_Topic S_Session_Topic_ASIS ,---
                                                NULL Dt_Actual_Date ,
                                                0 I_Is_Complete ,
                                                FM.I_Employee_ID ,
                                                FM.B_Is_Actual ,
                                                CA.Row ,
                                                CA.I_Session_ID ,
                                                CA.S_Session_Code ,
                                                CA.S_Session_Name ,
                                                CA.S_Session_Topic ,
                                                CA.I_Module_ID I_Module_ID_tobe
                                       FROM     dbo.T_TimeTable_Master TM WITH ( NOLOCK )
                                                INNER JOIN dbo.T_TimeTable_Faculty_Map FM
                                                WITH ( NOLOCK ) ON TM.I_TimeTable_ID = FM.I_TimeTable_ID
                                                CROSS APPLY ( SELECT DISTINCT
                                                              ROW_NUMBER() OVER ( ORDER BY D.I_Sequence, C.I_Sequence, A.I_Sequence ) AS Row ,
                                                              A.I_Session_Module_ID ,
                                                              A.I_Session_ID ,
                                                              B.S_Session_Code ,
                                                              B.S_Session_Name ,
                                                              ISNULL(B.I_Skill_ID,
                                                              ISNULL(G.I_Skill_ID,
                                                              0)) AS I_Skill_ID ,
                                                              CASE
                                                              WHEN B.I_Skill_ID IS NOT NULL
                                                              THEN E.S_Skill_Desc
                                                              ELSE ISNULL(G.S_Skill_Desc,
                                                              'Others')
                                                              END AS S_Skill_Desc ,
                                                              A.I_Module_ID ,
                                                              A.I_Sequence ,
                                                              B.N_Session_Duration ,
                                                              C.I_Sequence AS Module_Term_Seq ,
                                                              D.I_Sequence AS Term_Course_Seq ,
                                                              C.I_Term_ID ,
                                                              B.S_Session_Topic ,
                                                              H.S_Term_Name
                                                              FROM
                                                              dbo.T_Session_Module_Map A
                                                              WITH ( NOLOCK )
                                                              INNER JOIN dbo.T_Session_Master B
                                                              WITH ( NOLOCK ) ON A.I_Session_ID = B.I_Session_ID
                                                              LEFT OUTER JOIN T_EOS_Skill_Master E
                                                              WITH ( NOLOCK ) ON B.I_Skill_ID = E.I_Skill_ID
                                                              INNER JOIN dbo.T_Module_Term_Map C
                                                              WITH ( NOLOCK ) ON A.I_Module_ID = C.I_Module_ID
                                                              INNER JOIN T_Module_Master F
                                                              WITH ( NOLOCK ) ON C.I_Module_ID = F.I_Module_ID
                                                              LEFT OUTER JOIN T_EOS_Skill_Master G
                                                              WITH ( NOLOCK ) ON F.I_Skill_ID = G.I_Skill_ID
                                                              INNER JOIN dbo.T_Term_Course_Map D
                                                              WITH ( NOLOCK ) ON C.I_Term_ID = D.I_Term_ID
                                                              INNER JOIN T_Student_Batch_master SBM
                                                              WITH ( NOLOCK ) ON SBM.I_Course_ID = D.I_Course_ID
                                                              AND SBM.I_Batch_ID = TM.I_Batch_ID
                                                              INNER JOIN dbo.T_Delivery_Pattern_Master
                                                              AS TDPM ON SBM.I_Delivery_Pattern_ID = TDPM.I_Delivery_Pattern_ID
                                                              AND TDPM.S_DaysOfWeek LIKE '%'
                                                              + @SDayOfWeek
                                                              + '%'
                                                              INNER JOIN dbo.T_Term_Master H
                                                              WITH ( NOLOCK ) ON C.I_Term_ID = H.I_Term_ID
                                                              AND GETDATE() >= ISNULL(A.Dt_Valid_From,
                                                              GETDATE())
                                                              AND GETDATE() <= ISNULL(A.Dt_Valid_To,
                                                              GETDATE())
                                                              AND A.I_Status <> 0
                                                              AND B.I_Status <> 0
                                                              AND C.I_Status <> 0
                                                              AND D.I_Status <> 0
                                                              AND Tm.I_Term_ID = C.I_Term_ID
                                                              --AND tm.I_Module_ID = A.I_Module_ID
                                                              OUTER APPLY ( SELECT
                                                              TTM.I_Batch_ID ,
                                                              TTM.I_Session_ID ,
                                                              TTm.I_Term_ID ,
                                                              ttm.I_Module_ID ,
                                                              ttm.I_TimeTable_ID
                                                              FROM
                                                              dbo.T_TimeTable_Master TTM
                                                              WITH ( NOLOCK )
                                                              INNER JOIN dbo.T_TimeTable_Faculty_Map TFM
                                                              WITH ( NOLOCK ) ON TTM.I_TimeTable_ID = TFM.I_TimeTable_ID
                                                              WHERE
                                                              TTM.I_Status = 1
																	  --AND CONVERT(DATE, Dt_Schedule_Date) BETWEEN CONVERT(DATE, DATEADD(dd,
																	  --1, @routineDate))
																	  --AND
																	  --CONVERT(DATE, DATEADD(dd,
																	  ---1, @ToDate))
                                                              AND ttm.I_TimeTable_ID <> @ptimetableid
                                                              --AND CONVERT(DATE, Dt_Schedule_Date) <> CONVERT(DATE, @routineDate)
                                                              AND TTM.I_Batch_ID = TM.I_Batch_ID
                                                              AND TTM.I_Session_ID = A.I_Session_ID
                                                              AND TTm.I_Term_ID = C.I_Term_ID
                                                              AND ttm.I_Module_ID = A.I_Module_ID
                                                              AND ISNULL(ttm.I_Sub_Batch_ID,0)=ISNULL(tm.I_Sub_Batch_ID,0)
                                                              ) OA
                                                              WHERE
                                                              oA.I_TimeTable_ID IS NULL
                      --ORDER BY  D.I_Sequence ,
                      --          C.I_Sequence ,
                      --          A.I_Sequence
                                                              
                                                            ) CA
                                       WHERE    TM.I_Status = 1
                                                AND tm.I_TimeTable_ID = @ptimetableid
                                                AND FM.B_Is_Actual = 0
                                                AND TM.I_Center_ID = @CenterId
                                                AND CONVERT(DATE, tm.Dt_Schedule_Date) = CONVERT(DATE, @routineDate)
                                                AND TM.I_TimeSlot_ID = ISNULL(@I_TimeSlot_ID,
                                                              TM.I_TimeSlot_ID)
                                     )
                            INSERT  INTO #tmp
                                    ( I_TimeTable_ID ,
                                      I_Center_ID ,
                                      Dt_Schedule_Date ,
                                      I_TimeSlot_ID ,
                                      I_Batch_ID ,
                                      I_Sub_Batch_ID,
                                      I_Room_ID ,
                                      I_Skill_ID ,
                                      I_Status ,
                                      S_Crtd_By ,
                                      Dt_Crtd_On ,
                                      S_Updt_By ,
                                      Dt_Updt_On ,
                                      S_Remarks ,
                                      I_Session_ID_ASIS ,
                                      I_Term_ID ,
                                      I_Module_ID ,
                                      S_Session_Name_ASIS ,
                                      S_Session_Topic_ASIS ,
                                      Dt_Actual_Date ,
                                      I_Is_Complete ,
                                      I_Employee_ID ,
                                      B_Is_Actual ,
                                      ROW ,
                                      I_Session_ID ,
                                      S_Session_Code ,
                                      S_Session_Name ,
                                      S_Session_Topic ,
                                      I_Module_ID_tobe
                                    )
                                    SELECT  cl.I_TimeTable_ID ,
                                            cl.I_Center_ID ,
                                            cl.Dt_Schedule_Date ,
                                            cl.I_TimeSlot_ID ,
                                            cl.I_Batch_ID ,
                                            cl.I_Sub_Batch_ID,
                                            cl.I_Room_ID ,
                                            cl.I_Skill_ID ,
                                            cl.I_Status ,
                                            cl.S_Crtd_By ,
                                            cl.Dt_Crtd_On ,
                                            cl.S_Updt_By ,
                                            cl.Dt_Updt_On ,
                                            cl.S_Remarks ,
                                            cl.I_Session_ID_ASIS ,
                                            cl.I_Term_ID ,
                                            cl.I_Module_ID ,
                                            cl.S_Session_Name_ASIS ,
                                            cl.S_Session_Topic_ASIS ,
                                            cl.Dt_Actual_Date ,
                                            cl.I_Is_Complete ,
                                            cl.I_Employee_ID ,
                                            cl.B_Is_Actual ,
                                            cl.ROW ,
                                            cl.I_Session_ID ,
                                            cl.S_Session_Code ,
                                            cl.S_Session_Name ,
                                            cl.S_Session_Topic ,
                                            cl.I_Module_ID_tobe
                                    FROM    T_TimeTable_Master M
                                            INNER JOIN C AS N ON m.I_TimeTable_ID = N.I_TimeTable_ID
                                                              AND M.I_Session_ID = N.I_Session_ID
                                            INNER JOIN C AS CL ON CL.I_TimeTable_ID = N.I_TimeTable_ID
                                                              AND CL.Row = ( N.row
                                                              + 1 )
                                    WHERE   M.I_Status = 1
                                            AND M.I_Center_ID = @CenterId
                                            AND CONVERT(DATE, m.Dt_Schedule_Date) = CONVERT(DATE, @routineDate)
                                            AND M.I_TimeSlot_ID = ISNULL(@I_TimeSlot_ID,
                                                              M.I_TimeSlot_ID)
                                            AND M.I_TimeTable_ID = @ptimetableid
                                    ORDER BY CL.I_Session_ID_ASIS ;


        --SELECT  *
        --FROM    #tmp ;-----------
-- insert statements 

                          
                                 
                        INSERT  INTO dbo.T_TimeTable_Master
                                ( I_Center_ID ,
                                  Dt_Schedule_Date ,
                                  I_TimeSlot_ID ,
                                  I_Batch_ID ,
                                  I_Room_ID ,
                                  I_Skill_ID ,
                                  I_Status ,
                                  S_Crtd_By ,
                                  Dt_Crtd_On ,
                                  S_Updt_By ,
                                  Dt_Updt_On ,
                                  S_Remarks ,
                                  I_Session_ID ,
                                  I_Term_ID ,
                                  I_Module_ID ,
                                  S_Session_Name ,
                                  S_Session_Topic ,
                                  Dt_Actual_Date ,
                                  I_Is_Complete,
                                  I_Sub_Batch_ID
                                )
                                SELECT  I_Center_ID ,
                                        Dt_Schedule_Date ,
                                        I_TimeSlot_ID ,
                                        I_Batch_ID ,
                                        I_Room_ID ,
                                        I_Skill_ID ,
                                        I_Status ,
                                        S_Crtd_By ,
                                        Dt_Crtd_On ,
                                        S_Updt_By ,
                                        Dt_Updt_On ,
                                        S_Remarks ,
                                        I_Session_ID ,
                                        I_Term_ID ,
                                --I_Module_ID ,
                                        I_Module_ID_tobe ,
                                        S_Session_Name ,
                                        S_Session_Topic ,
                                        Dt_Actual_Date ,
                                        I_Is_Complete,
                                        I_Sub_Batch_ID
                                FROM    #tmp ;
        
                        INSERT  INTO dbo.T_TimeTable_Faculty_Map
                                ( I_TimeTable_ID ,
                                  I_Employee_ID ,
                                  B_Is_Actual
                
                                )
                                SELECT  TTM.I_TimeTable_ID ,
                                        T.I_Employee_ID ,
                                        T.B_Is_Actual
                                FROM    dbo.T_TimeTable_Master TTM
                                        INNER JOIN #tmp T ON TTM.I_Center_ID = T.I_Center_ID
                                                             AND CONVERT(DATE, TTM.Dt_Schedule_Date) = CONVERT(DATE, T.Dt_Schedule_Date)
                                                             AND TTM.I_TimeSlot_ID = T.I_TimeSlot_ID
                                                             AND TTM.I_Batch_ID = T.I_Batch_ID
                                                             AND TTM.I_Room_ID = T.I_Room_ID
                                                             AND TTM.I_Status = T.I_Status
                                                             AND TTM.I_Session_ID = T.I_Session_ID
                                                             AND TTM.I_Term_ID = T.I_Term_ID
                                                             AND TTM.I_Module_ID = T.I_Module_ID_tobe
                                                             AND ISNULL(TTM.I_Sub_Batch_ID,0)=ISNULL(T.I_Sub_Batch_ID,0)
 
						
					
                        TRUNCATE TABLE #tmp ; 
                        SET @incrementS = @incrementS + 1 ;
                    END ;
                TRUNCATE TABLE #tempTimeTablewithid ;
                    

--end insert
                SET @increment = @increment + 1 ;
            END ;
    
        DROP TABLE #tmp ;
        DROP TABLE #tempTimeTable ;
        DROP TABLE #tempTimeTablewithid ;

    END

