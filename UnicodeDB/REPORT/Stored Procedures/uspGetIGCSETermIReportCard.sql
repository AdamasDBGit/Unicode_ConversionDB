


CREATE PROCEDURE [REPORT].[uspGetIGCSETermIReportCard]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @iBatchID INT ,
      @iTermID INT = NULL ,
      @iStudentID INT = NULL ,
      @sSubject VARCHAR(MAX) = NULL
    )
AS
    BEGIN

        CREATE TABLE #STDMRKSDTLS
            (
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              TermID INT ,
              TermName VARCHAR(MAX) ,
              ModuleID INT ,
              ModuleName VARCHAR(MAX) ,
              BatchID INT ,
              BatchName VARCHAR(MAX) ,
              StudentDetailID INT ,
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              ExamComponentID INT ,
              ExamComponentName VARCHAR(MAX) ,
              SubjectName VARCHAR(MAX) ,
              PaperName VARCHAR(MAX) ,
              AllottedMarks DECIMAL(14, 2) ,
              Weightage INT ,
              ObtainedMarks DECIMAL(14, 2) ,
              ObtainedMarksPercent DECIMAL(14, 2) ,
              ObtainedMarksSubjectwise DECIMAL(14, 2) ,
              AllottedMarksSubjectwise DECIMAL(14, 2) ,
              Attendance INT ,
              Conduct VARCHAR(20) ,
              Grade VARCHAR(10) ,
              Sequence INT ,
              TotalMarks DECIMAL(14, 2) ,
              TotalMarksPercent DECIMAL(14, 2),
              PromotionStatus VARCHAR(MAX),
			  SubjectwiseAttendance int,
			  ClassTeacher varchar(max)
            )

		
		
        INSERT  INTO #STDMRKSDTLS
                ( CourseID ,
                  CourseName ,
                  TermID ,
                  TermName ,
                  ModuleID ,
                  ModuleName ,
                  BatchID ,
                  BatchName ,
                  StudentDetailID ,
                  StudentID ,
                  StudentName ,
                  ExamComponentID ,
                  ExamComponentName ,
                  SubjectName ,
                  PaperName ,
                  ObtainedMarks ,
                  AllottedMarks ,
                  Weightage ,
                  Attendance ,
                  Conduct ,
                  Sequence,
                  PromotionStatus,
				  ClassTeacher
		        )
                SELECT  TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TTM.I_Term_ID ,
                        TTM.S_Term_Name ,
                        TMM.I_Module_ID ,
                        TMM.S_Module_Name ,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name ,
                        TSD.I_Student_Detail_ID ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        TECM.I_Exam_Component_ID ,
                        TECM.S_Component_Name ,
                        CASE WHEN TECM.S_Component_Name LIKE 'COMPUTER%'
                             THEN 'COMPUTER SCIENCE'
                             ELSE SUBSTRING(TECM.S_Component_Name, 0,
                                            CHARINDEX(' ',
                                                      TECM.S_Component_Name, 1))
                        END AS SubjectName ,
                        REPLACE(SUBSTRING(TECM.S_Component_Name,
                                          CHARINDEX(' ', TECM.S_Component_Name,
                                                    1) + 1,
                                          LEN(TECM.S_Component_Name)
                                          - CHARINDEX(' ',
                                                      TECM.S_Component_Name, 1)),
                                'SCIENCE ', '') AS Paper ,
                        TSM.I_Exam_Total ,
                        TMES.I_TotMarks ,
                        TMES.N_Weightage ,
                        --ISNULL(REPORT.fnGetStudentAttendanceDetails(TSD.I_Student_Detail_ID,
                        --                                     TTM.I_Term_ID,
                        --                                     TSBM.I_Batch_ID),CAST(TSIA.N_Attendance as VARCHAR)) AS Attendance ,
						TSIA.N_Attendance as Attendance,
                        REPORT.fnGetStudentConductDetails(TSD.I_Student_Detail_ID,
                                                          TTM.I_Term_ID,
                                                          TSBM.I_Batch_ID) AS Conduct ,
                        ISNULL(TECM.I_Sequence_No, 0),
                        ISNULL(TNPL.PromotedStatus,'Granted')+' ('+ISNULL(SBM.S_Batch_Name,'Batch Not Assigned')+')' AS PromotionStatus,
						TED.S_First_Name+' '+ISNULL(TED.S_Middle_Name,'')+' '+TED.S_Last_Name as ClassTeacher
                FROM    EXAMINATION.T_Student_Marks AS TSM
                        INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                        INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TBEM.I_Term_ID
                        INNER JOIN dbo.T_Module_Master AS TMM ON TMM.I_Module_ID = TBEM.I_Module_ID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBEM.I_Batch_ID
						INNER JOIN T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID=TCBD.I_Batch_ID
						INNER JOIN T_Employee_Dtls TED ON TED.I_Employee_ID=TCBD.I_Employee_ID
                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSM.I_Student_Detail_ID
                        INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
                        LEFT JOIN dbo.T_Exam_Component_Master AS TECM ON TECM.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                        LEFT JOIN dbo.T_Module_Eval_Strategy AS TMES ON TMES.I_Course_ID = TCM.I_Course_ID
                                                              AND TMES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                                              AND TMES.I_Module_ID = TBEM.I_Module_ID
                                                              AND TMES.I_Status = 1
                        LEFT JOIN dbo.T_NotPromotedList_2019 AS TNPL ON TSD.S_Student_ID=TNPL.StudentID
						LEFT JOIN EXAMINATION.T_Student_Internal_Attendance TSIA on TSD.I_Student_Detail_ID=TSIA.I_Student_Detail_ID
												and TSIA.I_Exam_Component_ID=TBEM.I_Exam_Component_ID and TSIA.I_Term_ID=TBEM.I_Term_ID
                        LEFT JOIN
						(
						SELECT TSBD.I_Student_ID,TSBM.S_Batch_Name FROM dbo.T_Student_Batch_Details AS TSBD
						INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
						INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
						WHERE TCM.I_Brand_ID=107 AND TCM.S_Course_Name LIKE '%2020%' AND TCM.I_Status=1 AND TSBD.I_Status IN (1,3)
						) SBM ON TSD.I_Student_Detail_ID=SBM.I_Student_ID                                      
                WHERE   TBEM.I_Status = 1
                        AND TBEM.I_Batch_ID = @iBatchID
                        AND TTM.I_Term_ID = ISNULL(@iTermID, TBEM.I_Term_ID)
                        AND TSD.I_Student_Detail_ID = ISNULL(@iStudentID,
                                                             TSD.I_Student_Detail_ID)
                ORDER BY TCM.S_Course_Name ,
                        TTM.S_Term_Name ,
                        TSBM.S_Batch_Name ,
                        TSD.S_Student_ID ,
                        ISNULL(TECM.I_Sequence_No, 0)
                        
        UPDATE  T1
        SET     T1.ObtainedMarksPercent = T2.PaperwiseTotal--,T1.AllottedMarksSubjectwise=100.00
        FROM    #STDMRKSDTLS AS T1
                INNER JOIN ( SELECT S.CourseName ,
                                    S.TermID ,
                                    S.TermName ,
                                    S.BatchID ,
                                    S.BatchName ,
                                    S.StudentID ,
                                    S.StudentName ,
                                    S.SubjectName ,
                                    S.PaperName ,
                                    ROUND(( ( SUM(( ISNULL(S.ObtainedMarks, 0)
                                                    * S.Weightage ) / 100)
                                              / SUM(ISNULL(S.AllottedMarks, 0)) )
                                            * 100 ), 0) AS PaperwiseTotal
                             FROM   #STDMRKSDTLS AS S
                             GROUP BY S.CourseName ,
                                    S.TermID ,
                                    S.TermName ,
                                    S.BatchID ,
                                    S.BatchName ,
                                    S.StudentID ,
                                    S.StudentName ,
                                    S.SubjectName ,
                                    S.PaperName
                           ) T2 ON T2.BatchID = T1.BatchID
                                   AND T2.TermID = T1.TermID
                                   AND T2.StudentID = T1.StudentID
                                   AND T2.SubjectName = T1.SubjectName
                                   AND T2.PaperName = T1.PaperName                                                              
                                                     
                                                     
        UPDATE  T1
        SET     T1.ObtainedMarksSubjectwise = T2.SubjectwiseTotal ,
                T1.AllottedMarksSubjectwise = 100.00
        FROM    #STDMRKSDTLS AS T1
                INNER JOIN ( SELECT S.CourseName ,
                                    S.TermID ,
                                    S.TermName ,
                                    S.BatchID ,
                                    S.BatchName ,
                                    S.StudentID ,
                                    S.StudentName ,
                                    S.SubjectName ,
                                    ROUND(SUM(ISNULL(S.ObtainedMarksPercent, 0)),
                                          0) AS SubjectwiseTotal
                             FROM   #STDMRKSDTLS AS S
                             GROUP BY S.CourseName ,
                                    S.TermID ,
                                    S.TermName ,
                                    S.BatchID ,
                                    S.BatchName ,
                                    S.StudentID ,
                                    S.StudentName ,
                                    S.SubjectName
                           ) T2 ON T2.BatchID = T1.BatchID
                                   AND T2.TermID = T1.TermID
                                   AND T2.StudentID = T1.StudentID
                                   AND T2.SubjectName = T1.SubjectName
        
        
        
        DECLARE @i INT = 1
    
    --IF(upper(rtrim(ltrim(@sClass)))=upper('Class 9') or upper(rtrim(ltrim(@sClass)))=upper('Class 12') or upper(rtrim(ltrim(@sClass)))=upper('Class 10') or upper(rtrim(ltrim(@sClass)))=upper('Class 11') )
        IF ( @i = 1 )
            BEGIN
    
                UPDATE  #STDMRKSDTLS
                SET     AllottedMarks = NULL ,
                        Weightage = NULL ,
                        SubjectName = PaperName ,
                        PaperName = NULL
                WHERE   ExamComponentID IN ( 25, 46, 59 )
		    
                CREATE TABLE #tblGradeMst
                    (
                      ID INT IDENTITY ,
                      FromMarks NUMERIC(8, 2) ,
                      ToMarks NUMERIC(8, 2) ,
                      Grade VARCHAR(5)
                    )
              
              
                INSERT  INTO #tblGradeMst
                        ( FromMarks, ToMarks, Grade )
                VALUES  ( 0, 40, 'F' )
                INSERT  INTO #tblGradeMst
                        ( FromMarks, ToMarks, Grade )
                VALUES  ( 40, 50, 'C' )
                INSERT  INTO #tblGradeMst
                        ( FromMarks, ToMarks, Grade )
                VALUES  ( 50, 60, 'C+' )
                INSERT  INTO #tblGradeMst
                        ( FromMarks, ToMarks, Grade )
                VALUES  ( 60, 70, 'B' )
                INSERT  INTO #tblGradeMst
                        ( FromMarks, ToMarks, Grade )
                VALUES  ( 70, 80, 'B+' )
                INSERT  INTO #tblGradeMst
                        ( FromMarks, ToMarks, Grade )
                VALUES  ( 80, 90, 'A' )
                INSERT  INTO #tblGradeMst
                        ( FromMarks, ToMarks, Grade )
                VALUES  ( 90, 100, 'A+' )
		
                UPDATE  #STDMRKSDTLS
                SET     Grade = ( SELECT    Grade
                                  FROM      #tblGradeMst
                                  WHERE     CAST(ROUND(ObtainedMarks, 0) AS INT) >= FromMarks
                                            AND CAST(ROUND(ObtainedMarks, 0) AS INT) < ToMarks
                                )
                WHERE   ExamComponentID IN ( 25, 46, 59 )
                UPDATE  #STDMRKSDTLS
                SET     Grade = 'A+'
                WHERE   CAST(ROUND(ObtainedMarks, 0) AS INT) = 100
                        AND ExamComponentID IN ( 25, 46, 59 )
				--UPDATE #tblResult SET  HighestGrade= (select Grade from #tblGradeMst where cast(round(HighestMarks,0) as int)>=FromMarks and cast(round(HighestMarks,0) as int)<ToMarks) where        IN (25,46,59)
   
				--UPDATE #tblResult SET  HighestGrade= 'A+' where cast(round(HighestMarks,0) as int)=100 and I_Exam_Component_ID IN (25,46,59)
		
                UPDATE  #STDMRKSDTLS
                SET     ObtainedMarks = NULL ,
                        ObtainedMarksSubjectwise = 0
                WHERE   ExamComponentID IN ( 25, 46, 59 )

            END
            
            
        UPDATE  #STDMRKSDTLS
        SET     AllottedMarksSubjectwise = NULL
        WHERE   ObtainedMarksSubjectwise = 0.00
            
            
        UPDATE  T1
        SET     T1.TotalMarks = T2.TotalMarks
        FROM    #STDMRKSDTLS AS T1
                INNER JOIN ( SELECT M1.StudentDetailID ,
                                    M1.TermID ,
                                    SUM(ISNULL(M1.AvgTotal, 0)) AS TotalMarks
                             FROM   ( SELECT    S.StudentDetailID ,
                                                S.TermID ,
                                                S.SubjectName ,
                                                AVG(ISNULL(S.ObtainedMarksSubjectwise,
                                                           0)) AS AvgTotal
                                      FROM      #STDMRKSDTLS AS S
                                      WHERE     S.ExamComponentID <> 59
                                      GROUP BY  S.StudentDetailID ,
                                                S.TermID ,
                                                S.SubjectName
                                    ) M1
                             GROUP BY M1.StudentDetailID ,
                                    M1.TermID
                           ) T2 ON T2.StudentDetailID = T1.StudentDetailID
                                   AND T2.TermID = T1.TermID
        
        
        
        UPDATE  T1
        SET     T1.TotalMarksPercent = T2.AllottedTotal
        FROM    #STDMRKSDTLS AS T1
                INNER JOIN ( SELECT M1.StudentDetailID ,
                                    M1.TermID ,
                                    SUM(ISNULL(M1.AvgTotal, 0)) AS AllottedTotal
                             FROM   ( SELECT    S.StudentDetailID ,
                                                S.TermID ,
                                                S.SubjectName ,
                                                AVG(ISNULL(S.AllottedMarksSubjectwise,
                                                           0)) AS AvgTotal
                                      FROM      #STDMRKSDTLS AS S
                                      WHERE     S.ExamComponentID <> 59
                                      GROUP BY  S.StudentDetailID ,
                                                S.TermID ,
                                                S.SubjectName
                                    ) M1
                             GROUP BY M1.StudentDetailID ,
                                    M1.TermID
                           ) T2 ON T2.StudentDetailID = T1.StudentDetailID
                                   AND T2.TermID = T1.TermID
		
        --SELECT S.CourseName,S.TermID,S.TermName,S.BatchID,S.BatchName,S.StudentID,S.StudentName,S.SubjectName,
        --ROUND(((SUM(ISNULL(S.ObtainedMarks,0))/SUM(ISNULL(S.AllottedMarks,0)))* 100),0) AS SubjectwiseTotal FROM #STDMRKSDTLS AS S  
        --GROUP BY S.CourseName,S.TermID,S.TermName,S.BatchID,S.BatchName,S.StudentID,S.StudentName,S.SubjectName 

		update T1
		set
		T1.SubjectwiseAttendance=T2.AvgAttn
		from
		#STDMRKSDTLS T1
		inner join
		(
		select CourseID,TermID,ModuleID,BatchID,StudentDetailID,SubjectName,SUM(ISNULL(Attendance,0))/COUNT(ExamComponentID) as AvgAttn 
		from #STDMRKSDTLS
		group by CourseID,TermID,ModuleID,BatchID,StudentDetailID,SubjectName
		) T2 on T2.BatchID = T1.BatchID
                                   AND T2.TermID = T1.TermID
                                   AND T2.StudentDetailID = T1.StudentDetailID
                                   AND T2.SubjectName = T1.SubjectName
       
                                                  
        IF ( @sSubject IS NULL )
            SELECT  CourseID ,
                    CourseName ,
                    TermID ,
                    TermName ,
                    ModuleID ,
                    ModuleName ,
                    BatchID ,
                    BatchName ,
                    StudentDetailID ,
                    StudentID ,
                    StudentName ,
                    ExamComponentID ,
                    ExamComponentName ,
                    SubjectName ,
                    REPLACE(S.PaperName,'PAPER ','') AS PaperName,
                    AllottedMarks ,
                    Weightage ,
                    ObtainedMarks ,
                    ObtainedMarksPercent ,
                    ObtainedMarksSubjectwise ,
                    AllottedMarksSubjectwise ,
                    Attendance ,
                    Conduct ,
                    Grade ,
                    Sequence ,
                    TotalMarks ,
                    TotalMarksPercent,
                    PromotionStatus,
					SubjectwiseAttendance,
					ClassTeacher
            FROM    #STDMRKSDTLS AS S
            ORDER BY S.CourseName ,
                    S.TermName ,
                    S.BatchName ,
                    S.StudentID ,
                    S.Sequence
                    --S.ExamComponentID
			
        ELSE
            SELECT  CourseID ,
                    CourseName ,
                    TermID ,
                    TermName ,
                    ModuleID ,
                    ModuleName ,
                    BatchID ,
                    BatchName ,
                    StudentDetailID ,
                    StudentID ,
                    StudentName ,
                    ExamComponentID ,
                    ExamComponentName ,
                    SubjectName ,
                    REPLACE(S.PaperName,'PAPER ','') AS PaperName,
                    AllottedMarks ,
                    Weightage ,
                    ObtainedMarks ,
                    ObtainedMarksPercent ,
                    ObtainedMarksSubjectwise ,
                    AllottedMarksSubjectwise ,
                    Attendance ,
                    Conduct ,
                    Grade ,
                    Sequence ,
                    TotalMarks ,
                    TotalMarksPercent,
                    PromotionStatus,
					SubjectwiseAttendance,
					ClassTeacher
            FROM    #STDMRKSDTLS AS S
            WHERE   S.SubjectName = @sSubject
            ORDER BY S.CourseName ,
                    S.TermName ,
                    S.BatchName ,
                    S.StudentID ,
                    S.Sequence
                    --S.ExamComponentID	
        
        DROP TABLE #STDMRKSDTLS                                             


    END
