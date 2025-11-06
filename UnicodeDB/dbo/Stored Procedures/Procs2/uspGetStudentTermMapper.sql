CREATE PROCEDURE [dbo].[uspGetStudentTermMapper]
(
@iBrandID INT,
@CourseID INT
)
AS 
    BEGIN

        DECLARE @StudentID INT ;
        DECLARE @iCourseID INT ;
        DECLARE @iTermID INT ;
        
        DECLARE @iBatchID INT ;

        DECLARE TermMap CURSOR
        FOR
        (
        SELECT TSD.I_Student_Detail_ID,TCM.I_Course_ID,TTM.I_Term_ID,TSBD.I_Batch_ID FROM dbo.T_Student_Detail TSD
        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID
        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
        INNER JOIN dbo.T_Term_Course_Map TTCM ON TCM.I_Course_ID = TTCM.I_Course_ID
        INNER JOIN dbo.T_Term_Master TTM ON TTCM.I_Term_ID = TTM.I_Term_ID
        --INNER JOIN dbo.T_Module_Term_Map TMTM ON TTM.I_Term_ID = TMTM.I_Term_ID
        --INNER JOIN dbo.T_Module_Master TMM ON TMTM.I_Module_ID = TMM.I_Module_ID
        WHERE
        TCM.I_Course_ID=@CourseID
        AND TCM.I_Brand_ID=@iBrandID AND TCM.I_Status=1 AND TTCM.I_Status=1 AND TTM.I_Status=1 --AND TMTM.I_Status=1 AND TMM.I_Status=1
        AND TSBD.I_Status=1
        )
        OPEN TermMap
        FETCH NEXT FROM TermMap
INTO @StudentID,@iCourseID,@iTermID,@iBatchID

        WHILE ( @@FETCH_STATUS = 0 ) 
            BEGIN
                IF NOT EXISTS ( SELECT  *
                                FROM    dbo.T_Student_Term_Detail TSMD
                                WHERE   I_Student_Detail_ID = @StudentID
                                        AND I_Course_ID = @iCourseID
                                        AND I_Term_ID = @iTermID
                                        --AND I_Module_ID = @iModuleID
                                        AND I_Batch_ID = @iBatchID ) 
                    BEGIN
                        INSERT  INTO dbo.T_Student_Term_Detail
                                ( I_Term_ID ,
                                  --I_Module_ID ,
                                  I_Course_ID ,
                                  I_Student_Detail_ID ,
                                  I_Is_Completed ,
                                  S_Crtd_By ,
                                  Dt_Crtd_On ,
                                  I_Batch_ID
                                  --I_Is_Completed
		                    )
                        VALUES  ( @iTermID , -- I_Term_ID - int
                                  --@iModuleID , -- I_Module_ID - int
                                  @iCourseID , -- I_Course_ID - int
                                  @StudentID , -- I_Student_Detail_ID - int
                                  0, -- I_Is_Completed - bit
                                  'dba' , -- S_Crtd_By - varchar(20)
                                  GETDATE() , -- Dt_Crtd_On - datetime
                                  @iBatchID  -- I_Batch_ID - int
                                  
		                    )
                    END
	
                FETCH NEXT FROM TermMap
INTO @StudentID,@iCourseID,@iTermID,@iBatchID	
	
            END

        CLOSE TermMap ;
        DEALLOCATE TermMap ;


    END
