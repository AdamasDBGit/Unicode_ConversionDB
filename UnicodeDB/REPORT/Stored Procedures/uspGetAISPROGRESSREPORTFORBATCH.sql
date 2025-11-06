
--EXEC REPORT.uspGetAISPROGRESSREPORT

/*
EXEC [REPORT].[uspGetAISPROGRESSREPORTFORBATCH] @iBatchID=8058,@iTermID=NULL,@iStudentID=6077

*/

CREATE PROCEDURE [REPORT].[uspGetAISPROGRESSREPORTFORBATCH] 
    (
	  @sHierarchyList VARCHAR(MAX) , 
      @iBrandID INT , 
      @iBatchID INT , 
      @iTermID INT = NULL , 
      @iStudentID INT = NULL     
    ) 
AS 
    BEGIN 
        DECLARE @iCourseID INT , 
            @sCourierName VARCHAR(50) , 
            @sBatchName VARCHAR(100) , 
            @sClass VARCHAR(10) , 
            @iBatchExamID INT , 
            @iModuleID INT , 
            @iExamComponentID INT , 
            @sStudentName VARCHAR(250) , 
            @sStudentID VARCHAR(250) , 
            @t1 INT = 0 ,--Akash 
            @t2 INT = 0 ,--Akash 
            @t3 INT = NULL--Akash 

        SELECT  @iCourseID = tsbm.I_Course_ID , 
                @sBatchName = tsbm.S_Batch_Name , 
                @sCourierName = tcm.S_Course_Name , 
                @sClass = tcm.s_course_desc 
        FROM    dbo.T_Student_Batch_Master AS tsbm 
                INNER JOIN T_Course_Master tcm ON tcm.I_Course_ID = tsbm.I_Course_ID 
        WHERE   tsbm.I_Batch_ID = @iBatchID 


		/*

		Changes for AIS 2018-19
				(Refer Supporting SP REPORT.uspGetAISReportCardDisplayCaptions as well)
		
		ASSUMPTIONS for this year:
			ADCHK modules would have ADCHK text in modulenames
			ADCHK Sequence would be after general modules in Module/Term map
			ADCHK Module marks would be added to Module marks in Sequence 1 in Module/Term map 
			S_Display_Name column should be appropriately set in T_Module_Master, for display in report
				Weightages should be set in Modules in sequence 1,2,3 of Module/Term map (Adcheck to be kept 0)
					for captions to be displayed in Format Average(Unit/Adcheck + Project) (20), Term (80)
			Exam component wise Module weightages in T_Module_Eval_Strategy and may not tally with Module weightages in Module/Term map	


		*/

		DECLARE  @ModulesForFirstColumn AS TABLE (I_RID INT, I_Term_Id INT, I_Module_Id INT, I_Sequence INT, S_Module_Name VARCHAR(250))

		INSERT INTO @ModulesForFirstColumn(I_RID,I_Term_Id,I_Module_Id,I_Sequence,S_Module_Name)
		SELECT ROW_NUMBER() OVER ( PARTITION BY MTM.I_Term_ID ORDER BY MTM.I_Sequence ) RID,
				TCM.I_Term_Id , MTM.I_Module_Id, MTM.I_Sequence ,MM.S_Module_Name         
        FROM   dbo.T_Term_Course_Map TCM WITH ( NOLOCK ) 
				INNER JOIN T_Module_Term_Map MTM WITH ( NOLOCK ) ON MTM.I_Term_ID = TCM.I_Term_ID
				INNER JOIN T_Module_Master MM  WITH ( NOLOCK ) ON MM.I_Module_ID = MTM.I_Module_ID
        WHERE  I_Course_ID = @iCourseID 
            AND TCM.I_Status = 1 
			AND MTM.I_Status = 1 
			
			AND (--MM.S_Module_Name LIKE '%ADCHK%' OR 
				(@sClass IN ('Class 3','Class 4')  --Grade III and IV would have 3 Modules to be displayed in report 4 ADCHK Modules and one more after sequence 3, to be displayed in Column1 of RC
					AND MTM.I_Sequence > 3)	
				OR (@sClass NOT IN ('Class 3','Class 4')
					AND MTM.I_Sequence > 2)	--Other grades would have 4 ADCHK modules after sequence 2
					)
					


		--SELECT * FROM @ModulesForFirstColumn
		
		

        CREATE TABLE #tbltempResult 
            ( 
              I_Center_ID INT , 
              I_Batch_Exam_ID INT , 
              I_Batch_ID INT , 
              I_Course_ID INT , 
              courseSequence INT , 
              I_Term_ID INT , 
              I_Module_ID INT , 
              S_Module_Name VARCHAR(250) , 
              I_Exam_Component_ID INT , 
              S_Component_Name VARCHAR(250) , 
              GradeSequence INT , 
              I_Student_Detail_ID INT , 
              I_Exam_Total NUMERIC(8, 2) , 
              ModuleID1 INT , 			 
			  ModuleID1FullMarks INT , --Added As Per New Format 2018-19 
			  ModuleID1Weightage NUMERIC(8, 2) ,--Added As Per New Format 2018-19 
              ModuleID1Marks NUMERIC(8, 2) , 
              ModuleID2 INT ,
			  ModuleID2FullMarks INT , --Added As Per New Format 2018-19 
			  ModuleID2Weightage NUMERIC(8, 2) ,--Added As Per New Format 2018-19 
              ModuleID2Marks NUMERIC(8, 2) , 
              ModuleID3 INT , 
			  ModuleID3FullMarks INT , --Added As Per New Format 2018-19 
			  ModuleID3Weightage NUMERIC(8, 2) ,--Added As Per New Format 2018-19 
              ModuleID3Marks NUMERIC(8, 2) , 
              ModuleID4 INT ,
			  ModuleID4FullMarks INT , --Added As Per New Format 2018-19 
			  ModuleID4Weightage NUMERIC(8, 2) , --Added As Per New Format 2018-19 
              ModuleID4Marks NUMERIC(8, 2) ,
			  
			  /* --Added As Per New Format 2018-19 START*/
			  ModuleID5 INT ,
			  ModuleID5FullMarks INT , 
			  ModuleID5Weightage NUMERIC(8, 2) , 
              ModuleID5Marks NUMERIC(8, 2) ,
			  ModuleID6 INT ,
			  ModuleID6FullMarks INT , 
			  ModuleID6Weightage NUMERIC(8, 2) , 
              ModuleID6Marks NUMERIC(8, 2) ,
			  ModuleID7 INT ,
			  ModuleID7FullMarks INT , 
			  ModuleID7Weightage NUMERIC(8, 2) , 
              ModuleID7Marks NUMERIC(8, 2) ,
			  ModuleID8 INT ,
			  ModuleID8FullMarks INT , 
			  ModuleID8Weightage NUMERIC(8, 2) , 
              ModuleID8Marks NUMERIC(8, 2) ,
			  /* --Added As Per New Format 2018-19 END*/
			  				  
              B_Optional BIT 
            ) 


        CREATE TABLE #tblResult 
            ( 
              I_Student_Detail_ID INT , 
              S_Student_ID VARCHAR(250) , 
              S_Student_Name VARCHAR(150) , 
              I_Course_ID INT , 
              S_Course_Name VARCHAR(250) , 
              I_Batch_ID INT , 
              S_Batch_Name VARCHAR(250) , 
              I_Term_ID INT , 
              S_Term_Name VARCHAR(250) , 
              I_Exam_Component_ID INT , 
              S_Exam_Component_Name VARCHAR(200) , 
              I_Module_ID1 INT ,
              ModuleID1FullMarks INT , 
			  ModuleID1Weightage NUMERIC(8, 2) , 
              I_Exam_Total1 NUMERIC(8, 2) , 
              I_Module_ID2 INT , 
              ModuleID2FullMarks INT , 
			  ModuleID2Weightage NUMERIC(8, 2) , 
              I_Exam_Total2 NUMERIC(8, 2) , 
              I_Module_ID3 INT ,
              ModuleID3FullMarks INT , 
			  ModuleID3Weightage NUMERIC(8, 2) , 
              I_Exam_Total3 NUMERIC(8, 2) , 
              I_Module_ID4 INT , 
              ModuleID4FullMarks INT , 
			  ModuleID4Weightage NUMERIC(8, 2) , 
              I_Exam_Total4 NUMERIC(8, 2) , 
			  			  
              TotalMarks NUMERIC(8, 2) , 
              totalGrade VARCHAR(5) , 
              HighestMarks NUMERIC(8, 2) , 
              HighestGrade VARCHAR(5) , 
              classname VARCHAR(15) , 
              Term1TotalMarks NUMERIC(8, 2) , 
              Term2TotalMarks NUMERIC(8, 2) , 
              Term3TotalMarks NUMERIC(8, 2) , 
              Cum1 NUMERIC(8, 2) , 
              cum2 NUMERIC(8, 2) , 
              cum3 NUMERIC(8, 2) , 
              cumTotal NUMERIC(8, 2) ,
              Cum40 NUMERIC(8, 2) , 
              cum60 NUMERIC(8, 2) ,
              cum4060Total NUMERIC(8, 2) , 
              --cum3 NUMERIC(8, 2) , 
              T2M1 NUMERIC(8, 2) , 
              T2M2 NUMERIC(8, 2) , 
              T2M3 NUMERIC(8, 2) , 
              T2M4 NUMERIC(8, 2) , 
              TermOne NUMERIC(8, 2) , 
              totalgradeT1 VARCHAR(5) , 
              totalgradeT2 VARCHAR(5) , 
              B_Optional BIT , 
              I_term_sequence INT,
              I_Exam_Componenent_Sequence INT--akash 
            )  
            
            
        INSERT  INTO #tblResult 
                ( I_Student_Detail_ID , 
                  S_Student_ID , 
                  S_Student_Name , 
                  I_Course_ID , 
                  S_Course_Name , 
                  I_Batch_ID , 
                  S_Batch_Name , 
                  I_Term_ID , 
                  S_Term_Name , 
                  I_Exam_Component_ID , 
                  S_Exam_Component_Name , 
                  classname , 
                  B_Optional , 
                  I_term_sequence ,
                  I_Exam_Componenent_Sequence--akash
                ) 
                SELECT DISTINCT 
                        tsd.I_Student_Detail_ID , 
                        TSD.S_Student_ID , 
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') 
                        + ' ' + TSD.S_Last_Name StudentName , 
                        @iCourseID , 
                        @sCourierName , 
                        @iBatchID , 
                        @sBatchName , 
                        TBEM.I_Term_ID , 
                        TTM.S_Term_Name , 
                        TBEM.I_Exam_Component_ID , 
                        tecm.S_Component_Name , 
                        @sClass , 
                        tbem.B_Optional , 
                        TCM.I_Sequence,
                        tecm.I_Sequence_No 
                FROM    EXAMINATION.T_Batch_Exam_Map AS tbem WITH ( NOLOCK ) 
                        INNER JOIN EXAMINATION.T_Student_Marks TSM WITH ( NOLOCK ) ON tsm.I_Batch_Exam_ID = tbem.I_Batch_Exam_ID AND tbem.I_Status=1
                        INNER JOIN dbo.T_Student_Detail AS tsd WITH ( NOLOCK ) ON tsm.I_Student_Detail_ID = tsd.I_Student_Detail_ID 
                        INNER JOIN dbo.T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID 
                                                              AND TSBD.I_Status IN ( 
                                                              1, 2 ) 
  --- 
                        INNER JOIN dbo.T_Student_Batch_Details TSBD1 WITH ( NOLOCK ) ON TSD.I_Student_Detail_ID = TSBD1.I_Student_ID 
                                                              AND TSBD1.I_Status IN ( 
                                                              1, 2, 0 ) 
                                                              AND tsbd1.I_Batch_ID = tbem.I_Batch_ID 
                        INNER JOIN dbo.T_Student_Batch_Master SBM WITH ( NOLOCK ) ON TSBD1.I_Batch_ID = SBM.I_Batch_ID 
                                                              AND SBM.I_Course_ID = @iCourseID 
                                                              AND SBM.I_Status = 2 
  -- 
                        INNER JOIN dbo.T_Term_Master TTM WITH ( NOLOCK ) ON TBEM.I_Term_ID = TTM.I_Term_ID 
  -- 
                        INNER JOIN ( SELECT I_Term_ID , 
                                            ROW_NUMBER() OVER ( PARTITION BY I_Course_ID ORDER BY I_Sequence ) I_Sequence 
                                     FROM   dbo.T_Term_Course_Map WITH ( NOLOCK ) 
                                     WHERE  I_Course_ID = @iCourseID 
                                            AND I_Status = 1 
                                   ) TCM ON TCM.I_Term_ID = TTM.I_Term_ID 
  -- 
                        INNER JOIN dbo.T_Exam_Component_Master AS tecm WITH ( NOLOCK ) ON TBEM.I_Exam_Component_ID = tecm.I_Exam_Component_ID 
                WHERE   TSBD.I_Batch_ID = @iBatchID 
						AND tbem.I_Status=1--akash
                        AND tbem.I_Term_ID = ISNULL(@iTermID, tbem.I_Term_ID) 
                        AND TSM.I_Student_Detail_ID = ISNULL(@istudentid, 
                                                             TSM.I_Student_Detail_ID) 
						--Need to display GK/SUPW
						--AND ISNULL(tecm.B_Exclude_In_Report,0) = 0	--Mainly for GK/SUPW Not to be displayed in ReportCard and Graphical report
                ORDER BY tsd.I_Student_Detail_ID ,tecm.I_Sequence_No, 
                        TBEM.I_Exam_Component_ID 
  
  
  --Update #tblResult SET I_Exam_Total1=isnull(I_Exam_Total1,0)+isnull(I_Exam_Total2,0)+isnull(I_Exam_Total3,0) 
  --  where   I_Exam_Component_ID =24 
    
  --Update #tblResult SET I_Exam_Total2 =null,I_Exam_Total3=NULL 
  --  where   I_Exam_Component_ID =24 
  
        INSERT  INTO #tbltempResult 
                ( I_Center_ID , 
                  I_Batch_Exam_ID , 
                  I_Batch_ID , 
                  I_Course_ID , 
                  courseSequence , 
                  I_Term_ID , 
                  I_Module_ID , 
                  S_Module_Name , 
                  I_Exam_Component_ID , 
                  S_Component_Name , 
                  GradeSequence , 
                  I_Student_Detail_ID , 
                  I_Exam_Total , 
                  ModuleID1 , 
				  ModuleID1FullMarks ,
				  ModuleID1Weightage ,
                  ModuleID1Marks , 
                  ModuleID2 , 
				  ModuleID2FullMarks ,
				  ModuleID2Weightage ,
                  ModuleID2Marks , 
                  ModuleID3 , 
				  ModuleID3FullMarks ,
				  ModuleID3Weightage ,
                  ModuleID3Marks , 
                  ModuleID4 , 
				  ModuleID4FullMarks ,
				  ModuleID4Weightage ,
                  ModuleID4Marks,

				  --Added As Per New Format 2018-19 START
				  ModuleID5 , 
				  ModuleID5FullMarks ,
				  ModuleID5Weightage ,
                  ModuleID5Marks,
				  ModuleID6 , 
				  ModuleID6FullMarks ,
				  ModuleID6Weightage ,
                  ModuleID6Marks,
				  ModuleID7 , 
				  ModuleID7FullMarks ,
				  ModuleID7Weightage ,
                  ModuleID7Marks,
				  ModuleID8 , 
				  ModuleID8FullMarks ,
				  ModuleID8Weightage ,
                  ModuleID8Marks
                  --Added As Per New Format 2018-19 END        
                ) 
                SELECT  TSM.I_Center_ID , 
                        TSM.I_Batch_Exam_ID , 
                        TBEM.I_Batch_ID , 
                        tsbm.I_Course_ID , 
                        ttcm.I_Sequence courseSequence , 
                        TBEM.I_Term_ID , 
                        TBEM.I_Module_ID , 
                        tmm.S_Module_Name , 
                        TBEM.I_Exam_Component_ID , 
                        tecm.S_Component_Name , 
                        tmtm.I_Sequence GradeSequence , 
                        TSM.I_Student_Detail_ID , 
                        TSM.I_Exam_Total , 

						--Changed/Added As Per New Format 2018-19 START
						CASE WHEN tmtm.I_Sequence = 1 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID1 ,
						CASE WHEN tmtm.I_Sequence = 1 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN MES.I_TotMarks
                             ELSE NULL 
                        END ModuleID1FullMarks ,
						CASE WHEN tmtm.I_Sequence = 1 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN MES.N_Weightage
                             ELSE NULL 
                        END ModuleID1Weightage ,
						CASE WHEN tmtm.I_Sequence = 1 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID1Marks , 
						CASE WHEN tmtm.I_Sequence = 2 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID2 , 
						CASE WHEN tmtm.I_Sequence = 2 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID2FullMarks ,
						CASE WHEN tmtm.I_Sequence = 2 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN MES.N_Weightage 

                             ELSE NULL 
                        END ModuleID2Weightage ,
						CASE WHEN tmtm.I_Sequence = 2 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID2Marks , 
						CASE WHEN tmtm.I_Sequence = 3 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID3 ,
					   CASE WHEN tmtm.I_Sequence = 3 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID3FullMarks ,
						CASE WHEN tmtm.I_Sequence = 3 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn) THEN MES.N_Weightage 
                             ELSE NULL 
                        END ModuleID3Weightage ,
						CASE WHEN tmtm.I_Sequence = 3 AND TBEM.I_Module_ID NOT IN (SELECT I_Module_ID FROM @ModulesForFirstColumn)  THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID3Marks , 
                       CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 1 AND I_Term_Id = tmtm.I_Term_ID) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID4 , 
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 1 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID4FullMarks ,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 1 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.N_Weightage
                             ELSE NULL 
                        END ModuleID4Weightage ,
                        CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 1 AND I_Term_Id = tmtm.I_Term_ID) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID4Marks,

						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 2 AND I_Term_Id = tmtm.I_Term_ID) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID5 , 
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 2 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID5FullMarks ,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 2 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.N_Weightage
                             ELSE NULL 
                        END ModuleID5Weightage ,
                        CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 2 AND I_Term_Id = tmtm.I_Term_ID) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID5Marks,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 3 AND I_Term_Id = tmtm.I_Term_ID) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID6 , 
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 3 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID6FullMarks ,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 3 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.N_Weightage 
                             ELSE NULL 
                        END ModuleID6Weightage ,
                        CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 3 AND I_Term_Id = tmtm.I_Term_ID) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID6Marks,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 4 AND I_Term_Id = tmtm.I_Term_ID) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID7 , 
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 4 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID7FullMarks ,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 4 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.N_Weightage
                             ELSE NULL 
                        END ModuleID7Weightage ,
                        CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 4 AND I_Term_Id = tmtm.I_Term_ID) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID7Marks,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 5 AND I_Term_Id = tmtm.I_Term_ID) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID8 , 
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 5 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID8FullMarks ,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 5 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.N_Weightage 
                             ELSE NULL 
                        END ModuleID8Weightage ,
                        CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 5 AND I_Term_Id = tmtm.I_Term_ID) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID8Marks
						--Changed/Added As Per New Format 2018-19 END 
						

                FROM    EXAMINATION.T_Student_Marks TSM WITH ( NOLOCK ) 
                        INNER JOIN EXAMINATION.T_Batch_Exam_Map TBEM WITH ( NOLOCK ) ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID AND TBEM.I_Status=1
                        INNER JOIN dbo.T_Exam_Component_Master AS tecm WITH ( NOLOCK ) ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID 
                        INNER JOIN dbo.T_Module_Master AS tmm WITH ( NOLOCK ) ON TBEM.I_Module_ID = tmm.I_Module_ID 
                        INNER JOIN dbo.T_Module_Term_Map AS tmtm WITH ( NOLOCK ) ON tbem.I_Module_ID = tmtm.I_Module_ID 
                                                              AND tbem.I_Term_ID = tmtm.I_Term_ID 
                                                              AND tmtm.I_Status = 1 
                        INNER JOIN dbo.T_Term_Course_Map AS ttcm WITH ( NOLOCK ) ON tmtm.I_Term_ID = ttcm.I_Term_ID 
                                                              AND ttcm.I_Status = 1 
                        INNER JOIN dbo.T_Student_Batch_Master tsbm WITH ( NOLOCK ) ON tsbm.I_Batch_ID = tbem.I_Batch_ID 
                        INNER JOIN #tblResult A ON TSM.I_Student_Detail_ID = A.I_Student_Detail_ID 
								AND A.I_Exam_Component_ID = tecm.I_Exam_Component_ID
								AND A.I_Term_ID = tmtm.I_Term_ID
								
						--Added As Per New Format 2018-19 [To Pick as per weightage] 
						INNER JOIN T_Module_Eval_Strategy MES WITH ( NOLOCK ) ON MES.I_Course_ID = ttcm.I_Course_ID AND MES.I_Status=1
							AND MES.I_Module_ID = tmtm.I_Module_ID
							AND MES.I_Term_ID = tmtm.I_Term_ID
							AND MES.I_Exam_Component_ID = tecm.I_Exam_Component_ID
							AND MES.I_Status = 1
							AND MES.N_Weightage > 0
						  
                WHERE   ttcm.I_Course_ID = @iCourseID 
  
--SELECT * FROM #tbltempResult AS TR


 
			/*
			SELECT * FROM #tbltempResult 
			WHERE I_Exam_Component_id = 19
			 --AND GradeSequence  IN (1,5,6,7,8)
			 AND I_Term_Id = 1257
			 --AND I_Module_ID = 6459
			ORDER BY S_Module_Name, I_Term_ID
			*/
			
  
		--Changed/Added As Per New Format 2018-19 START 
        UPDATE  T 
        SET     I_Module_ID1 = V.ModuleID1 ,
				ModuleID1FullMarks = ISNULL(V.ModuleID1FullMarks,0),
				ModuleID1Weightage = ISNULL(V.ModuleID1Weightage ,0),
                I_Exam_Total1 = V.ModuleID1Marks 
        FROM    #tblResult T 
                INNER JOIN (SELECT 
							I_Course_ID
							,I_Term_ID
							,I_Student_Detail_ID 
							,I_Exam_Component_ID,
							(SELECT DISTINCT ModuleID1 
								FROM #tbltempResult 
								WHERE I_Course_ID = T.I_Course_ID 
									AND I_Term_ID = T.I_Term_ID 
									AND I_Student_Detail_ID = T.I_Student_Detail_ID						
									AND I_Exam_Component_ID = T.I_Exam_Component_ID 
								AND GradeSequence = 1 ) AS ModuleID1
							,SUM(ModuleID1FullMarks) AS ModuleID1FullMarks
							,SUM(ModuleID1Weightage) AS ModuleID1Weightage
							,SUM(ModuleID1Marks) AS ModuleID1Marks
				FROM (SELECT I_Course_ID,I_Term_ID,I_Student_Detail_ID ,I_Exam_Component_ID,ISNULL(ModuleID1FullMarks,0) AS ModuleID1FullMarks,ISNULL(ModuleID1Weightage,0) AS ModuleID1Weightage,ModuleID1Marks AS ModuleID1Marks
						FROM #tbltempResult
						WHERE GradeSequence = 1
						UNION ALL
						SELECT I_Course_ID,I_Term_ID,I_Student_Detail_ID ,I_Exam_Component_ID,ISNULL(ModuleID4FullMarks,0),ISNULL(ModuleID4Weightage,0),ModuleID4Marks
						FROM #tbltempResult T
						WHERE GradeSequence IN (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 1 AND I_Term_Id = T.I_Term_ID)
						UNION ALL
						SELECT I_Course_ID,I_Term_ID,I_Student_Detail_ID ,I_Exam_Component_ID,ISNULL(ModuleID5FullMarks,0),ISNULL(ModuleID5Weightage,0),ModuleID5Marks
						FROM #tbltempResult T
						WHERE GradeSequence IN  (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 2 AND I_Term_Id = T.I_Term_ID)
						UNION ALL
						SELECT I_Course_ID,I_Term_ID,I_Student_Detail_ID ,I_Exam_Component_ID,ISNULL(ModuleID6FullMarks,0),ISNULL(ModuleID6Weightage,0),ModuleID6Marks
						FROM #tbltempResult T
						WHERE GradeSequence IN  (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 3 AND I_Term_Id = T.I_Term_ID)
						UNION ALL
						SELECT I_Course_ID,I_Term_ID,I_Student_Detail_ID ,I_Exam_Component_ID,ISNULL(ModuleID7FullMarks,0),ISNULL(ModuleID7Weightage,0),ModuleID7Marks
						FROM #tbltempResult T
						WHERE GradeSequence IN (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 4 AND I_Term_Id = T.I_Term_ID)
						UNION ALL
						SELECT I_Course_ID,I_Term_ID,I_Student_Detail_ID ,I_Exam_Component_ID,ISNULL(ModuleID8FullMarks,0),ISNULL(ModuleID8Weightage,0),ModuleID8Marks
						FROM #tbltempResult T
						WHERE GradeSequence IN (SELECT I_Sequence FROM @ModulesForFirstColumn WHERE I_RID = 5 AND I_Term_Id = T.I_Term_ID)) T
				GROUP BY I_Course_ID,I_Term_ID,I_Student_Detail_ID ,I_Exam_Component_ID) AS V ON T.I_Course_ID = V.I_Course_ID 
                                               AND T.I_Term_ID = V.I_Term_ID 
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID 
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID 				
				
            --SELECT * FROM #tblResult AS TR WHERE TR.I_Student_Detail_ID=2771
				--Changed/Added As Per New Format 2018-19 END 
			
        UPDATE  T 
        SET     I_Module_ID2 = V.ModuleID2 , 
				ModuleID2FullMarks = V.ModuleID2FullMarks ,
				ModuleID2Weightage = V.ModuleID2Weightage ,
                I_Exam_Total2 = V.ModuleID2Marks 
        FROM    #tblResult T 
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID 
                                               AND T.I_Term_ID = V.I_Term_ID 
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID 
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID 
                                               AND V.GradeSequence = 2 											   
                                               --AND T.I_Batch_ID = V.I_Batch_ID
                          
        UPDATE  T 
        SET     I_Module_ID3 = V.ModuleID3 ,
				ModuleID3FullMarks = V.ModuleID3FullMarks ,
				ModuleID3Weightage = V.ModuleID3Weightage ,
                I_Exam_Total3 = V.ModuleID3Marks 
        FROM    #tblResult T 
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID 
                                               AND T.I_Term_ID = V.I_Term_ID 
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID 
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID 
                                               AND V.GradeSequence = 3 
                                              -- AND T.I_Batch_ID = V.I_Batch_ID 
											  AND @sClass IN ('Class 3','Class 4') --Added for Session 2018-19
       
	   --Commented for Session 2018-19  Would have max 3 Modules Mapped for display in ReportCard with Addln to be displayed along with Module in sequence 1
	   --#tblResult updates kept as it is
	    /*                
        UPDATE  T 
        SET     I_Module_ID4 = V.ModuleID4 ,
				ModuleID4FullMarks = V.ModuleID4FullMarks ,
				ModuleID4Weightage = V.ModuleID4Weightage , 
                I_Exam_Total4 = V.ModuleID4Marks 
        FROM    #tblResult T 
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID 
                                               AND T.I_Term_ID = V.I_Term_ID 
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID 
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID 
                                               AND V.GradeSequence = 4 
                                               --AND T.I_Batch_ID = V.I_Batch_ID 
			
        */
  
          
        UPDATE  #tblResult 
        SET     TotalMarks = ROUND(ISNULL(I_Exam_Total1, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total2, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total3, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total4, 0), 0) 
        UPDATE  #tblResult 
        SET     TotalMarks = NULL 
        WHERE   I_Exam_Total1 IS NULL 
                AND I_Exam_Total2 IS NULL 
                AND I_Exam_Total3 IS NULL 
                AND I_Exam_Total4 IS NULL        
  
  
     --Akash Modifications 
      
        --SELECT TR.I_Exam_Total4 FROM #tblResult AS TR
        UPDATE  #tblResult 
        SET     Term1TotalMarks = ROUND(ISNULL(I_Exam_Total1, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total2, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total3, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total4, 0), 0)
        WHERE   I_term_sequence = 1 --I_Term_ID=@t1--(select distinct I_Term_ID from (select ROW_NUMBER() over (order by I_Term_ID asc) as rownumber,I_Term_ID from #tblResult)as foo1 
      --where rownumber=1) 
        UPDATE  #tblResult 
        SET     Term1TotalMarks = NULL 
        WHERE   I_Exam_Total1 IS NULL 
                AND I_Exam_Total2 IS NULL 
                AND I_Exam_Total3 IS NULL 
                AND I_Exam_Total4 IS NULL 
  
        UPDATE  #tblResult 
        SET     Term2TotalMarks = ROUND(ISNULL(I_Exam_Total1, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total2, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total3, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total4, 0), 0) 
        WHERE   I_term_sequence = 2--I_Term_ID=@t2--(select distinct I_Term_ID from (select ROW_NUMBER() over (order by I_Term_ID asc) as rownumber,I_Term_ID from #tblResult)as foo2 
      --where rownumber=2) 
        UPDATE  #tblResult 
        SET     Term2TotalMarks = NULL 
        WHERE   I_Exam_Total1 IS NULL 
                AND I_Exam_Total2 IS NULL 
                AND I_Exam_Total3 IS NULL 
                AND I_Exam_Total4 IS NULL 
  
        UPDATE  #tblResult 
        SET     Term3TotalMarks = ROUND(ISNULL(I_Exam_Total1, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total2, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total3, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total4, 0), 0) 
        WHERE   I_term_sequence = 3--I_Term_ID=@t3--(select distinct I_Term_ID from (select ROW_NUMBER() over (order by I_Term_ID asc) as rownumber,I_Term_ID from #tblResult)as foo3 
    --  where rownumber=3) 
        UPDATE  #tblResult 
        SET     Term3TotalMarks = NULL 
        WHERE   I_Exam_Total1 IS NULL 
                AND I_Exam_Total2 IS NULL 
                AND I_Exam_Total3 IS NULL 
                AND I_Exam_Total4 IS NULL
  
        UPDATE  #tblResult 
        SET     TermOne = #tblResult.Term1TotalMarks         
        
		--Weightage to display/and calculation to be Picked from T_Term_Course_Map in future
        UPDATE  #tblResult 
        SET     Cum1 = ROUND(0.3 * ISNULL(Term1TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     Cum1 = NULL 
        WHERE   Term1TotalMarks IS NULL 
    
        UPDATE  #tblResult 
        SET     cum2 = ROUND(0.2 * ISNULL(Term2TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     cum2 = NULL 
        WHERE   Term2TotalMarks IS NULL
        
        --akash 2.3.2016
        UPDATE  #tblResult 
        SET     Cum40 = ROUND(0.4 * ISNULL(Term1TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     Cum40 = NULL 
        WHERE   Term1TotalMarks IS NULL 
    
        UPDATE  #tblResult 
        SET     cum60 = ROUND(0.6 * ISNULL(Term2TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     cum60 = NULL 
        WHERE   Term2TotalMarks IS NULL
        
        UPDATE  #tblResult 
        SET     cum4060Total = ROUND(ISNULL(Cum40, 0), 0) + ROUND(ISNULL(cum60, 0), 
                                                             0) 
                --+ ROUND(ISNULL(cum3, 0), 0) 
        --akash 2.3.2016 
    
        UPDATE  #tblResult 
        SET     cum3 = ROUND(0.5 * ISNULL(Term3TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     cum3 = NULL 
        WHERE   Term3TotalMarks IS NULL 
    
        UPDATE  #tblResult 
        SET     cumTotal = ROUND(ISNULL(Cum1, 0), 0) + ROUND(ISNULL(cum2, 0), 
                                                             0) 
                + ROUND(ISNULL(cum3, 0), 0) 
    
        UPDATE  #tblResult 
        SET     T2M1 = ROUND(ISNULL(I_Exam_Total1, 0), 0) 
        WHERE   I_term_sequence = 2 
        UPDATE  #tblResult 
        SET     T2M1 = NULL 
        WHERE   I_Exam_Total1 IS NULL 
                AND I_term_sequence = 2 
    
        UPDATE  #tblResult 
        SET     T2M2 = ROUND(ISNULL(I_Exam_Total2, 0), 0) 
        WHERE   I_term_sequence = 2 
        UPDATE  #tblResult 
        SET     T2M2 = NULL 
        WHERE   I_Exam_Total2 IS NULL 
                AND I_term_sequence = 2 
    
        UPDATE  #tblResult 
        SET     T2M3 = ROUND(ISNULL(I_Exam_Total3, 0), 0) 
        WHERE   I_term_sequence = 2 
        UPDATE  #tblResult 
        SET     T2M3 = NULL 
        WHERE   I_Exam_Total3 IS NULL 
                AND I_term_sequence = 2 
    
        UPDATE  #tblResult 
        SET     T2M4 = ROUND(ISNULL(I_Exam_Total4, 0), 0) 
        WHERE   I_term_sequence = 2 
        UPDATE  #tblResult 
        SET     T2M4 = NULL 
        WHERE   I_Exam_Total4 IS NULL 
                AND I_term_sequence = 2 
		
    
    
    ---Akash modifications 
          
        UPDATE  T 
        SET     HighestMarks = VR.Marks 
        FROM    #tblResult T 
                INNER JOIN ( SELECT V.I_Course_ID , 
                                    V.I_Term_ID , 
                                    V.I_Exam_Component_ID , 
                                    MAX(V.Marks) Marks 
                             FROM   ( SELECT    tsbm.I_Course_ID , 
                                                tmtm.I_Term_ID , 
                                                tbem.I_Exam_Component_ID , 
                                                tsm.I_Student_Detail_ID , 
                                                SUM((ROUND(ISNULL(I_Exam_Total, 
                                                              0), 0)*tmes.N_Weightage)/tmes.I_TotMarks ) Marks  --Changed As Per New Format 2018-19
                                      FROM      EXAMINATION.T_Student_Marks AS tsm 
                                                WITH ( NOLOCK ) 
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem 
                                                WITH ( NOLOCK ) ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID AND tbem.I_Status=1
                                                INNER JOIN ( SELECT 
                                                              I_Student_ID , 
                                                              I_Batch_ID , 
                                                              MAX(I_Status) I_Status 
                                                             FROM 
                                                              dbo.T_Student_Batch_Details 
                                                             GROUP BY I_Student_ID , 
                                                              I_Batch_ID 
                                                           ) AS tsbd ON tsbd.I_Batch_ID = tbem.I_Batch_ID 
                                                              AND tsbd.I_Student_ID = tsm.I_Student_Detail_ID 
                                                              AND tsbd.I_Status IN ( 
                                                              0, 1, 2 ) 
                                                INNER JOIN dbo.T_Student_Batch_Master tsbm 
                                                WITH ( NOLOCK ) ON tsbm.I_Batch_ID = tbem.I_Batch_ID 
                                                              AND tsbm.I_Course_ID = @icourseid 
                                                INNER JOIN dbo.T_Module_Term_Map 
                                                AS tmtm WITH ( NOLOCK ) ON tbem.I_Module_ID = tmtm.I_Module_ID 
                                                              AND tbem.I_Term_ID = tmtm.I_Term_ID 
                                                              AND tmtm.I_Status = 1 
                                                INNER JOIN dbo.T_Module_Eval_Strategy 
                                                AS tmes WITH ( NOLOCK ) ON tmes.I_Module_ID = tbem.I_Module_ID 
                                                              AND tmes.I_Term_ID = tbem.I_Term_ID 
                                                              AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID 
                                                              AND tmes.I_Status = 1 
                                                INNER JOIN dbo.T_Exam_Component_Master 
                                                AS tecm WITH ( NOLOCK ) ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID 
                                      GROUP BY  tsbm.I_Course_ID , 
                                                tmtm.I_Term_ID , 
                                                tbem.I_Exam_Component_ID , 
                                                tsm.I_Student_Detail_ID 
                                    ) V 
                             GROUP BY V.I_Course_ID , 
                                    V.I_Term_ID , 
                                    V.I_Exam_Component_ID 
                           ) VR ON T.I_Course_ID = VR.I_Course_ID 
                                   AND T.I_Term_ID = VR.I_Term_ID 
                                   AND VR.I_Exam_Component_ID = T.I_Exam_Component_ID 
          
          
              
    --Update #tblResult SET  I_Exam_Total1 =null,I_Exam_Total2 =null,I_Exam_Total3=NULL,I_Exam_Total4=NULL WHERE B_Optional = 1 


		--Following comment for Session(2018-19)
       /* IF ( UPPER(RTRIM(LTRIM(@sClass))) = UPPER('Class 9') 
             OR UPPER(RTRIM(LTRIM(@sClass))) = UPPER('Class 12') 
             OR UPPER(RTRIM(LTRIM(@sClass))) = UPPER('Class 10') 
             OR UPPER(RTRIM(LTRIM(@sClass))) = UPPER('Class 11') 
           )*/
		   
		   --GK seems to have been introduced from this Session(2018-19) , so making changes in report so that for SUPW and GK, only grades get displayed without contributing to Total 
                         
           --GK, I_Exam_Component_ID : 59 introduced this session below

		    BEGIN 
    
                ------Update #tblResult SET  I_Exam_Total1 =null,I_Exam_Total2 =null,I_Exam_Total3=NULL,I_Exam_Total4=NULL 
                ------where   I_Exam_Component_ID IN (25,46) 
                    
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
                
                UPDATE  #tblResult 
                SET     totalGrade = ( SELECT   Grade 
                                       FROM     #tblGradeMst 
                                       WHERE    CAST(ROUND(TotalMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(TotalMarks, 0) AS INT) < ToMarks 
                                     ) 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                UPDATE  #tblResult 
                SET     totalGrade = 'A+' 
                WHERE   CAST(ROUND(TotalMarks, 0) AS INT) = 100 
                        AND I_Exam_Component_ID IN ( 25, 46, 59 ) 
                UPDATE  #tblResult 
                SET     HighestGrade = ( SELECT Grade 
                                         FROM   #tblGradeMst 
                                         WHERE  CAST(ROUND(HighestMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(HighestMarks, 0) AS INT) < ToMarks 
                                       ) 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                                
                                --Akash Modifications 
                                
				--Commented for Session 2018-19
				/*UPDATE  #tblResult 
                SET     totalgradeT1 = ( SELECT Grade 
                                         FROM   #tblGradeMst 
                                         WHERE  CAST(ROUND(Term1TotalMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(Term1TotalMarks, 
                                                              0) AS INT) < ToMarks 
                                       ) 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                        AND I_Term_ID = @t1 
                
				UPDATE  #tblResult 
                SET     totalgradeT1 = 'A+' 
                WHERE   CAST(ROUND(Term1TotalMarks, 0) AS INT) = 100 
                        AND I_Exam_Component_ID IN ( 25, 46, 59 ) 
                        AND I_Term_ID = @t1 
                                
                                
                UPDATE  #tblResult 
                SET     totalgradeT2 = ( SELECT Grade 
                                         FROM   #tblGradeMst 
                                         WHERE  CAST(ROUND(Term2TotalMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(Term2TotalMarks, 
                                                              0) AS INT) < ToMarks 
                                       ) 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                        AND I_Term_ID = @t2 
                UPDATE  #tblResult 
                SET     totalgradeT2 = 'A+' 
                WHERE   CAST(ROUND(Term2TotalMarks, 0) AS INT) = 100 
                        AND I_Exam_Component_ID IN ( 25, 46, 59 ) 
                        AND I_Term_ID = @t2 
                */

				UPDATE T  
                SET     T.totalgradeT1 = (SELECT totalgrade FROM #tblResult WHERE I_Exam_Component_ID = T.I_Exam_Component_ID AND I_Student_Detail_ID = T.I_Student_Detail_ID  AND I_term_sequence = 1)
						,T.totalgradeT2 = (SELECT totalgrade FROM #tblResult WHERE I_Exam_Component_ID = T.I_Exam_Component_ID AND I_Student_Detail_ID = T.I_Student_Detail_ID  AND I_term_sequence = 2)
                FROM #tblResult T
				WHERE    I_Exam_Component_ID IN ( 25, 46, 59 ) 
                  
                                
                                --Akash Modifications 
    
                UPDATE  #tblResult 
                SET     HighestGrade = 'A+' 
                WHERE   CAST(ROUND(HighestMarks, 0) AS INT) = 100 
                        AND I_Exam_Component_ID IN ( 25, 46, 59 ) 
                
                UPDATE  #tblResult 
                SET     I_Exam_Total1 = 0 , 
                        TotalMarks = 0 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                UPDATE  #tblResult 
                SET     I_Exam_Total1 = 0 , 
                        Term1TotalMarks = 0 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                UPDATE  #tblResult 
                SET     I_Exam_Total1 = 0 , 
                        Term2TotalMarks = 0 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                UPDATE  #tblResult 
                SET     I_Exam_Total1 = 0 , 
                        Term3TotalMarks = 0 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 

            END 
        SELECT  tr.I_Student_Detail_ID , 
                tr.S_Student_ID , 
                tr.S_Student_Name , 
                tr.I_Course_ID , 
                tr.S_Course_Name , 
                tr.I_Batch_ID , 
                tr.S_Batch_Name , 
                tr.I_Term_ID , 
                tr.S_Term_Name , 
                tr.I_Exam_Component_ID , 
                tr.S_Exam_Component_Name , 
                tr.I_Module_ID1 ,
                CAST(ROUND(tr.ModuleID1FullMarks, 0) AS INT) ModuleID1FullMarks , 
				tr.ModuleID1Weightage,
                CAST(ROUND(tr.I_Exam_Total1, 0) AS INT) I_Exam_Total1 , 
                tr.I_Module_ID2 , 
                CAST(ROUND(tr.ModuleID2FullMarks, 0) AS INT) ModuleID2FullMarks ,
				tr.ModuleID2Weightage, 
                CAST(ROUND(tr.I_Exam_Total2, 0) AS INT) I_Exam_Total2 , 
                tr.I_Module_ID3 , 
                CAST(ROUND(tr.ModuleID3FullMarks, 0) AS INT) ModuleID3FullMarks ,
				tr.ModuleID3Weightage, 
                CAST(ROUND(tr.I_Exam_Total3, 0) AS INT) I_Exam_Total3 , 
                tr.I_Module_ID4 , 
                CAST(ROUND(tr.ModuleID4FullMarks, 0) AS INT) ModuleID4FullMarks , 
				tr.ModuleID4Weightage,
                CAST(ROUND(tr.I_Exam_Total4, 0) AS INT) I_Exam_Total4 , 

				
                CAST(ROUND(tr.TotalMarks, 0) AS INT) TotalMarks , 
                CAST(ROUND(tr.Term1TotalMarks, 0) AS INT) Term1TotalMarks , 
                CAST(ROUND(tr.Term2TotalMarks, 0) AS INT) Term2TotalMarks , 
                CAST(ROUND(tr.Term3TotalMarks, 0) AS INT) Term3TotalMarks , 
                CAST(ROUND(tr.Cum1, 0) AS INT) Cumulative1 , 
                CAST(ROUND(tr.cum2, 0) AS INT) Cumulative2 , 
                CAST(ROUND(tr.cum3, 0) AS INT) Cumulative3 , 
                CAST(ROUND(tr.cumTotal, 0) AS INT) CumulativeTotal ,
                --akash 2.3.2016
                CAST(ROUND(tr.Cum40, 0) AS INT) Cumulative40 , 
                CAST(ROUND(tr.cum60, 0) AS INT) Cumulative60 ,
                CAST(ROUND(tr.cum4060Total, 0) AS INT) Cumulative4060Total ,
                --akash 2.3.2016 
                CAST(ROUND(tr.T2M1, 0) AS INT) T2M1 , 
                CAST(ROUND(tr.T2M2, 0) AS INT) T2M2 , 
                CAST(ROUND(tr.T2M3, 0) AS INT) T2M3 , 
                CAST(ROUND(tr.T2M4, 0) AS INT) T2M4 ,
                CAST(ROUND(tr.TermOne, 0) AS INT) TermOne , 
                tr.totalGrade , 
                tr.totalgradeT1 , 
                tr.totalgradeT2 , 
                CAST(ROUND(tr.HighestMarks, 0) AS INT) HighestMarks , 
                tr.HighestGrade , 
                tr.classname , 
                REPORT.fnGetStudentAttendanceDetails(tr.I_Student_Detail_ID, 
                                                     tr.I_Term_ID, tr.I_Batch_ID) AS Attendance , 
                REPORT.fnGetStudentConductDetails(tr.I_Student_Detail_ID, 
                                                  tr.I_Term_ID, tr.I_Batch_ID) AS Conduct , 
                tr.B_Optional , 
                tr.I_term_sequence , 
				ECM.I_Sequence_No AS I_Exam_Component_Sequence,
				ISNULL(TNPL.PromotedStatus,'Granted')+' ('+ISNULL(SBM.S_Batch_Name,'Batch Not Assigned')+')' AS PromotionStatus
        FROM    #tblResult AS tr 
		INNER JOIN T_Exam_Component_Master ECM ON ECM.I_Exam_Component_ID = TR.I_Exam_Component_ID
		LEFT JOIN dbo.T_NotPromotedList_2019 AS TNPL ON tr.S_Student_ID=TNPL.StudentID
		LEFT JOIN
		(
		SELECT TSBD.I_Student_ID,TSBM.S_Batch_Name FROM dbo.T_Student_Batch_Details AS TSBD
		INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
		INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
		WHERE TCM.I_Brand_ID=107 AND TCM.S_Course_Name LIKE '%2020%' AND TCM.I_Status=1 AND TSBD.I_Status IN (1,3)
		) SBM ON tr.I_Student_Detail_ID=SBM.I_Student_ID
        ORDER BY I_Term_ID DESC --added to get the highestmasrks and attendance   
        
        
                              
    END
