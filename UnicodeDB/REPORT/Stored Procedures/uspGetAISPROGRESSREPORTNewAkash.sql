
--exec [REPORT].[uspGetAISPROGRESSREPORTNewAkash] 127,109,754
CREATE PROCEDURE [REPORT].[uspGetAISPROGRESSREPORTNewAkash]
    (
      @sHierarchyList varchar(MAX),
      @iBrandID int,
      @iBatchID INT, 
      @iTermID int =Null,
      @iStudentID int =Null
   
    )
AS 
    BEGIN
    Declare @iCourseID INT,
			@sCourierName varchar(50),
			@sBatchName varchar(100),
			@sClass Varchar(10),
			@iBatchExamID Int,
			@iModuleID int,
			@iExamComponentID int,
			@sStudentName VARCHAR(250),
			@sStudentID VARCHAR(250),
			@t1 int=375,--Akash
			@t2 int=376,--Akash
			@t3 int=NULL--Akash

	SELECT  @iCourseID=tsbm.I_Course_ID,
			@sBatchName=tsbm.S_Batch_Name,
			@sCourierName=tcm.S_Course_Name,
			@sClass=tcm.s_course_desc
	FROM dbo.T_Student_Batch_Master AS tsbm
	INNER JOIN T_Course_Master tcm on tcm.I_Course_ID=tsbm.I_Course_ID
	where tsbm.I_Batch_ID=@iBatchID

  CREATE TABLE #tbltempResult 
            (
              I_Center_ID INT ,
              I_Batch_Exam_ID INT,
              I_Batch_ID INT,
              I_Course_ID INT,
              courseSequence INT,
              I_Term_ID INT,
              I_Module_ID INT,
              S_Module_Name Varchar(250),
              I_Exam_Component_ID INT,
              S_Component_Name varchar(250),
              GradeSequence INT,
              I_Student_Detail_ID INT,
              I_Exam_Total Numeric(8,2),
              ModuleID1 INT,
              ModuleID1Marks Numeric(8,2),
			  ModuleID2 INT,
			  ModuleID2Marks Numeric(8,2),
			  ModuleID3 INT,
		      ModuleID3Marks Numeric(8,2),
		      ModuleID4 INT,
	 	     ModuleID4Marks Numeric(8,2),
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
              I_Module_ID1 INT,
              ModuleID1FullMarks INT,
			  I_Exam_Total1 Numeric(8,2),
			  I_Module_ID2 INT,
			  ModuleID2FullMarks INT,
			  I_Exam_Total2 Numeric(8,2),
			  I_Module_ID3 INT,
			  ModuleID3FullMarks INT,
			  I_Exam_Total3 Numeric(8,2),
			  I_Module_ID4 INT,
			  ModuleID4FullMarks INT,
			  I_Exam_Total4 Numeric(8,2),
			  TotalMarks Numeric(8,2),
			 totalGrade varchar(5),
			  HighestMarks Numeric(8,2),
			  HighestGrade varchar(5),
			  classname varchar(15) ,
			  Term1TotalMarks numeric(8,2),
			  Term2TotalMarks numeric(8,2),
			  Term3TotalMarks numeric(8,2),
			  Cum1 numeric(8,2),
			  cum2 numeric(8,2),
			  cum3 numeric(8,2),
			  cumTotal numeric(8,2),
			  T2M1 numeric(8,2),
			  T2M2 numeric(8,2),
			  T2M3 numeric(8,2),
			  T2M4 numeric(8,2),
			  TermOne numeric(8,2),
			  
			  totalgradeT1 varchar(5),
			  totalgradeT2 varchar(5),
              B_Optional BIT
            )
            
            
            INSERT INTO #tblResult(
            I_Student_Detail_ID  ,
              S_Student_ID  ,
              S_Student_Name  ,
              I_Course_ID  ,
              S_Course_Name  ,
              I_Batch_ID  ,
              S_Batch_Name , 
              I_Term_ID  ,
              S_Term_Name  ,
              I_Exam_Component_ID  ,
              S_Exam_Component_Name ,
              classname,
			  B_Optional
            )
            SELECT distinct tsd.I_Student_Detail_ID,
            TSD.S_Student_ID,
            TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')+ ' ' + TSD.S_Last_Name StudentName,
            @iCourseID,
            @sCourierName,
            @iBatchID,
            @sBatchName,
            TBEM.I_Term_ID,
			TTM.S_Term_Name,
			TBEM.I_Exam_Component_ID,
			tecm.S_Component_Name,
            @sClass,
            tbem.B_Optional     
            
  FROM EXAMINATION.T_Batch_Exam_Map AS tbem with(NOLOCK)
  INNER JOIN EXAMINATION.T_Student_Marks TSM with(NOLOCK) ON tsm.I_Batch_Exam_ID=tbem.I_Batch_Exam_ID
  INNER JOIN dbo.T_Student_Detail AS tsd with(NOLOCK) ON tsm.I_Student_Detail_ID=tsd.I_Student_Detail_ID
  INNER JOIN dbo.T_Student_Batch_Details TSBD WITH (NOLOCK) ON  TSD.I_Student_Detail_ID=TSBD.I_Student_ID AND TSBD.I_Status=1
  INNER JOIN dbo.T_Term_Master TTM with(NOLOCK) ON TBEM.I_Term_ID=TTM.I_Term_ID
  INNER JOIN dbo.T_Exam_Component_Master  AS tecm with(NOLOCK) ON TBEM.I_Exam_Component_ID = tecm.I_Exam_Component_ID
  where tbem.I_Batch_ID=@iBatchID and tbem.I_Term_ID=ISNULL(@iTermID,tbem.I_Term_ID) and TSM.I_Student_Detail_ID=ISNULL(@istudentid,TSM.I_Student_Detail_ID)
  ORDER BY tsd.I_Student_Detail_ID,TBEM.I_Exam_Component_ID
  
  
  --Update #tblResult SET I_Exam_Total1=isnull(I_Exam_Total1,0)+isnull(I_Exam_Total2,0)+isnull(I_Exam_Total3,0)
  --  where   I_Exam_Component_ID =24
    
  --Update #tblResult SET I_Exam_Total2 =null,I_Exam_Total3=NULL
  --  where   I_Exam_Component_ID =24
  
  INSERT INTO #tbltempResult 
            (
              I_Center_ID  ,
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
			  ModuleID1Marks ,
			  ModuleID2 ,
			  ModuleID2Marks ,
			  ModuleID3 ,
		      ModuleID3Marks ,
		      ModuleID4 ,
		     ModuleID4Marks 
                         
            )
 select  TSM.I_Center_ID,
		TSM.I_Batch_Exam_ID,
		TBEM.I_Batch_ID, 
		tsbm.I_Course_ID,
		ttcm.I_Sequence courseSequence,
		TBEM.I_Term_ID,
		TBEM.I_Module_ID,
		tmm.S_Module_Name,
		TBEM.I_Exam_Component_ID,
		tecm.S_Component_Name, 
		 tmtm.I_Sequence GradeSequence,
		TSM.I_Student_Detail_ID,
		TSM.I_Exam_Total ,
		Case when tmtm.I_Sequence=1 then TBEM.I_Module_ID else Null end ModuleID1,
		Case when tmtm.I_Sequence=1 then TSM.I_Exam_Total else Null end ModuleID1Marks,
		Case when tmtm.I_Sequence=2 then TBEM.I_Module_ID else Null end ModuleID2,
		Case when tmtm.I_Sequence=2 then TSM.I_Exam_Total else Null end ModuleID2Marks,
		Case when tmtm.I_Sequence=3 then TBEM.I_Module_ID else Null end ModuleID3,
		Case when tmtm.I_Sequence=3 then TSM.I_Exam_Total else Null end ModuleID3Marks,
		Case when tmtm.I_Sequence=4 then TBEM.I_Module_ID else Null end ModuleID4,
		Case when tmtm.I_Sequence=4 then TSM.I_Exam_Total else Null end ModuleID4Marks
		from EXAMINATION.T_Student_Marks TSM with(NOLOCK)
		INNER JOIN EXAMINATION.T_Batch_Exam_Map TBEM with(NOLOCK) ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm with(NOLOCK) ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		INNER JOIN  dbo.T_Module_Master AS tmm with(NOLOCK) ON TBEM.I_Module_ID =tmm.I_Module_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm with(NOLOCK) ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID	 AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm with(NOLOCK) ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Student_Batch_Master tsbm with(NOLOCK) ON tsbm.I_Batch_ID = tbem.I_Batch_ID	
		INNER JOIN #tblResult A ON TSM.I_Student_Detail_ID=A.I_Student_Detail_ID
  
  
  
  --select * from #tbltempResult
  
  UPDATE T SET  I_Module_ID1 =V.ModuleID1,
			  I_Exam_Total1 =V.ModuleID1Marks  FROM #tblResult T INNER JOIN #tbltempResult V ON T.I_Course_ID=V.I_Course_ID and T.I_Term_ID =V.I_Term_ID and T.I_Student_Detail_ID=V.I_Student_Detail_ID and T.I_Exam_Component_ID=V.I_Exam_Component_ID and V.GradeSequence=1 AND T.I_Batch_ID = V.I_Batch_ID
            
 
  UPDATE T SET  I_Module_ID2 =V.ModuleID2,
			  I_Exam_Total2 =V.ModuleID2Marks  FROM #tblResult T INNER JOIN #tbltempResult V ON T.I_Course_ID=V.I_Course_ID and T.I_Term_ID =V.I_Term_ID and T.I_Student_Detail_ID=V.I_Student_Detail_ID and T.I_Exam_Component_ID=V.I_Exam_Component_ID and V.GradeSequence=2 AND T.I_Batch_ID = V.I_Batch_ID
			  
  UPDATE T SET  I_Module_ID3 =V.ModuleID3,
			  I_Exam_Total3 =V.ModuleID3Marks  FROM #tblResult T INNER JOIN #tbltempResult V ON T.I_Course_ID=V.I_Course_ID and T.I_Term_ID =V.I_Term_ID and T.I_Student_Detail_ID=V.I_Student_Detail_ID and T.I_Exam_Component_ID=V.I_Exam_Component_ID and V.GradeSequence=3 AND T.I_Batch_ID = V.I_Batch_ID
			  
  UPDATE T SET  I_Module_ID4 =V.ModuleID4,
			  I_Exam_Total4 =V.ModuleID4Marks  FROM #tblResult T INNER JOIN #tbltempResult V ON T.I_Course_ID=V.I_Course_ID and T.I_Term_ID =V.I_Term_ID and T.I_Student_Detail_ID=V.I_Student_Detail_ID and T.I_Exam_Component_ID=V.I_Exam_Component_ID and V.GradeSequence=4 AND T.I_Batch_ID = V.I_Batch_ID
  
          
 UPDATE #tblResult SET   TotalMarks=ROUND(ISNULL(I_Exam_Total1,0),0)+ROUND(ISNULL(I_Exam_Total2,0),0)+ROUND(ISNULL(I_Exam_Total3,0),0)+ROUND(ISNULL(I_Exam_Total4,0),0)
 UPDATE #tblResult SET   TotalMarks= NULL WHERE I_Exam_Total1 IS NULL AND I_Exam_Total2 IS NULL AND I_Exam_Total3 IS NULL AND I_Exam_Total4 IS NULL	
 
 
     --Akash Modifications
     
        
      UPDATE  #tblResult SET   Term1TotalMarks=ROUND(ISNULL(I_Exam_Total1,0),0)+ROUND(ISNULL(I_Exam_Total2,0),0)+ROUND(ISNULL(I_Exam_Total3,0),0)+ROUND(ISNULL(I_Exam_Total4,0),0) where I_Term_ID=@t1--(select distinct I_Term_ID from (select ROW_NUMBER() over (order by I_Term_ID asc) as rownumber,I_Term_ID from #tblResult)as foo1
      --where rownumber=1)
 UPDATE #tblResult SET   Term1TotalMarks= NULL WHERE I_Exam_Total1 IS NULL AND I_Exam_Total2 IS NULL AND I_Exam_Total3 IS NULL AND I_Exam_Total4 IS NULL
 
  UPDATE  #tblResult SET   Term2TotalMarks=ROUND(ISNULL(I_Exam_Total1,0),0)+ROUND(ISNULL(I_Exam_Total2,0),0)+ROUND(ISNULL(I_Exam_Total3,0),0)+ROUND(ISNULL(I_Exam_Total4,0),0) where I_Term_ID=@t2--(select distinct I_Term_ID from (select ROW_NUMBER() over (order by I_Term_ID asc) as rownumber,I_Term_ID from #tblResult)as foo2
      --where rownumber=2)
 UPDATE #tblResult SET   Term2TotalMarks= NULL WHERE I_Exam_Total1 IS NULL AND I_Exam_Total2 IS NULL AND I_Exam_Total3 IS NULL AND I_Exam_Total4 IS NULL
 
  UPDATE  #tblResult SET   Term3TotalMarks=ROUND(ISNULL(I_Exam_Total1,0),0)+ROUND(ISNULL(I_Exam_Total2,0),0)+ROUND(ISNULL(I_Exam_Total3,0),0)+ROUND(ISNULL(I_Exam_Total4,0),0) where I_Term_ID=@t3--(select distinct I_Term_ID from (select ROW_NUMBER() over (order by I_Term_ID asc) as rownumber,I_Term_ID from #tblResult)as foo3
    --  where rownumber=3)
 UPDATE #tblResult SET   Term3TotalMarks= NULL WHERE I_Exam_Total1 IS NULL AND I_Exam_Total2 IS NULL AND I_Exam_Total3 IS NULL AND I_Exam_Total4 IS NULL
 
 update #tblResult set TermOne=#tblResult.Term1TotalMarks	
        
    update #tblResult set Cum1=ROUND(0.5*isnull(Term1TotalMarks,0),0)
    update #tblResult set Cum1=NULL where Term1TotalMarks is null
    
    update #tblResult set cum2=ROUND(0.5*isnull(Term2TotalMarks,0),0)
    update #tblResult set cum2=NULL where Term2TotalMarks is null
    
   update #tblResult set cum3=ROUND(0.5*isnull(Term3TotalMarks,0),0)
    update #tblResult set cum3=NULL where Term3TotalMarks is null
    
    update #tblResult set cumTotal=ROUND(ISNULL(Cum1,0),0)+ROUND(ISNULL(cum2,0),0)+ROUND(ISNULL(cum3,0),0)
    
    update #tblResult set T2M1=round(isnull(I_Exam_Total1,0),0) where I_Term_ID=@t2
    update #tblResult set T2M1=null where I_Exam_Total1 is null and I_Term_ID=@t2
    
    update #tblResult set T2M2=round(isnull(I_Exam_Total2,0),0) where I_Term_ID=@t2
    update #tblResult set T2M2=null where I_Exam_Total2 is null and I_Term_ID=@t2
    
    update #tblResult set T2M3=round(isnull(I_Exam_Total3,0),0) where I_Term_ID=@t2
    update #tblResult set T2M3=null where I_Exam_Total3 is null and I_Term_ID=@t2
    
    update #tblResult set T2M4=round(isnull(I_Exam_Total4,0),0) where I_Term_ID=@t2
    update #tblResult set T2M4=null where I_Exam_Total4 is null and I_Term_ID=@t2
    
    
    ---Akash modifications
         
       Update T set HighestMarks =VR.Marks FROM #tblResult    T INNER JOIN 
         (select V.I_Course_ID,V.I_Term_ID,V.I_Exam_Component_ID,MAX(V.Marks)Marks  from ( 
         SELECT tsbm.I_Course_ID,tmtm.I_Term_ID,tbem.I_Exam_Component_ID ,tsm.I_Student_Detail_ID,sum(ROUND(ISNULL(I_Exam_Total,0),0)) Marks
		FROM EXAMINATION.T_Student_Marks AS tsm with(NOLOCK)
		INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem with(NOLOCK) ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
		INNER JOIN dbo.T_Student_Batch_Details AS tsbd ON tsbd.I_Batch_ID = tbem.I_Batch_ID AND tsbd.I_Student_ID = tsm.I_Student_Detail_ID AND tsbd.I_Status = 1
		INNER JOIN dbo.T_Student_Batch_Master tsbm with(NOLOCK) ON tsbm.I_Batch_ID = tbem.I_Batch_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm with(NOLOCK) ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes with(NOLOCK) ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID and tmes.I_Status=1
		INNER JOIN dbo.T_Exam_Component_Master AS tecm with(NOLOCK) ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		Group BY  tsbm.I_Course_ID,tmtm.I_Term_ID,tbem.I_Exam_Component_ID,tsm.I_Student_Detail_ID)V 
		Group BY V.I_Course_ID,V.I_Term_ID,V.I_Exam_Component_ID ) VR
		ON T.I_Course_ID=VR.I_Course_ID and T.I_Term_ID=VR.I_Term_ID
		and VR.I_Exam_Component_ID=T.I_Exam_Component_ID
          
          
              
    --Update #tblResult SET  I_Exam_Total1 =null,I_Exam_Total2 =null,I_Exam_Total3=NULL,I_Exam_Total4=NULL WHERE B_Optional = 1


    IF(upper(rtrim(ltrim(@sClass)))=upper('Class 9') or upper(rtrim(ltrim(@sClass)))=upper('Class 12') or upper(rtrim(ltrim(@sClass)))=upper('Class 10') or upper(rtrim(ltrim(@sClass)))=upper('Class 11') )
    BEGIN
    
		------Update #tblResult SET  I_Exam_Total1 =null,I_Exam_Total2 =null,I_Exam_Total3=NULL,I_Exam_Total4=NULL
		------where   I_Exam_Component_ID IN (25,46)
		    
		CREATE TABLE #tblGradeMst 
            (
              ID INT identity,
              FromMarks Numeric(8,2),
              ToMarks Numeric(8,2),
              Grade varchar(5)
              )
              
              
		INSERT INTO  #tblGradeMst  (FromMarks ,ToMarks ,Grade ) Values(0,40,'F')
		INSERT INTO  #tblGradeMst  (FromMarks ,ToMarks ,Grade ) Values(40,50,'C')
		INSERT INTO  #tblGradeMst  (FromMarks ,ToMarks ,Grade ) Values(50,60,'C+')
		INSERT INTO  #tblGradeMst  (FromMarks ,ToMarks ,Grade ) Values(60,70,'B')
		INSERT INTO  #tblGradeMst  (FromMarks ,ToMarks ,Grade ) Values(70,80,'B+')
		INSERT INTO  #tblGradeMst  (FromMarks ,ToMarks ,Grade ) Values(80,90,'A')
		INSERT INTO  #tblGradeMst  (FromMarks ,ToMarks ,Grade ) Values(90,100,'A+')
		
		UPDATE #tblResult SET  totalGrade= (select Grade from #tblGradeMst where cast(round(TotalMarks,0) as int)>=FromMarks and cast(round(TotalMarks,0) as int)<ToMarks) where       I_Exam_Component_ID IN (25,46)
				UPDATE #tblResult SET  totalGrade= 'A+' where cast(round(TotalMarks,0) as int)=100 and I_Exam_Component_ID IN (25,46)
				UPDATE #tblResult SET  HighestGrade= (select Grade from #tblGradeMst where cast(round(HighestMarks,0) as int)>=FromMarks and cast(round(HighestMarks,0) as int)<ToMarks) where       I_Exam_Component_ID IN (25,46)
				
				--Akash Modifications
				
				UPDATE #tblResult SET  totalgradeT1= (select Grade from #tblGradeMst where cast(round(Term1TotalMarks,0) as int)>=FromMarks and cast(round(Term1TotalMarks,0) as int)<ToMarks) where       I_Exam_Component_ID IN (25,46) and I_Term_ID=@t1
				UPDATE #tblResult SET  totalgradeT1= 'A+' where cast(round(Term1TotalMarks,0) as int)=100 and I_Exam_Component_ID IN (25,46) and I_Term_ID=@t1
				
				
				UPDATE #tblResult SET  totalgradeT2= (select Grade from #tblGradeMst where cast(round(Term2TotalMarks,0) as int)>=FromMarks and cast(round(Term2TotalMarks,0) as int)<ToMarks) where       I_Exam_Component_ID IN (25,46) and I_Term_ID=@t2
				UPDATE #tblResult SET  totalgradeT2= 'A+' where cast(round(Term2TotalMarks,0) as int)=100 and I_Exam_Component_ID IN (25,46) and I_Term_ID=@t2
		
				
				--Akash Modifications
   
				UPDATE #tblResult SET  HighestGrade= 'A+' where cast(round(HighestMarks,0) as int)=100 and I_Exam_Component_ID IN (25,46)
		
		UPDATE #tblResult SET I_Exam_Total1 = 0, TotalMarks = 0 WHERE I_Exam_Component_ID IN (25,46)
		UPDATE #tblResult SET I_Exam_Total1 = 0, Term1TotalMarks = 0 WHERE I_Exam_Component_ID IN (25,46)
		UPDATE #tblResult SET I_Exam_Total1 = 0, Term2TotalMarks = 0 WHERE I_Exam_Component_ID IN (25,46)
		UPDATE #tblResult SET I_Exam_Total1 = 0, Term3TotalMarks = 0 WHERE I_Exam_Component_ID IN (25,46)

   END 
		SELECT     I_Student_Detail_ID  ,
              S_Student_ID  ,
              S_Student_Name  ,
              I_Course_ID  ,
              S_Course_Name  ,
              I_Batch_ID ,
              S_Batch_Name  ,
              I_Term_ID  ,
              S_Term_Name  ,
              I_Exam_Component_ID  ,
              S_Exam_Component_Name  ,
              I_Module_ID1 ,
			  cast(round(ModuleID1FullMarks,0) as int) ModuleID1FullMarks,
			  cast(round(I_Exam_Total1,0) as int) I_Exam_Total1,
			  I_Module_ID2 ,
			  cast(round(ModuleID4FullMarks,0) as int) ModuleID2FullMarks,
			  cast(round(I_Exam_Total2,0) as int) I_Exam_Total2,
			  I_Module_ID3 ,
			  cast(round(ModuleID3FullMarks,0) as int) ModuleID3FullMarks,
			  cast(round(I_Exam_Total3,0) as int) I_Exam_Total3,
			  I_Module_ID4 ,
			  cast(round(ModuleID4FullMarks,0) as int) ModuleID4FullMarks,
			  cast(round(I_Exam_Total4,0) as int) I_Exam_Total4,
			  
			  
			  cast(round(TotalMarks,0) as int) TotalMarks,
			  cast(round(Term1TotalMarks,0) as int) Term1TotalMarks,
			  cast(round(Term2TotalMarks,0) as int) Term2TotalMarks,
			  cast(round(Term3TotalMarks,0) as int) Term3TotalMarks,
			  cast(round(Cum1,0) as int) Cumulative1,
			  cast(round(cum2,0) as int) Cumulative2,
			  cast(round(cum3,0) as int) Cumulative3,
			  cast(round(cumTotal,0) as int) CumulativeTotal,
			  CAST(round(T2M1,0) as int) T2M1,
			  CAST(round(T2M2,0) as int) T2M2,
			  CAST(round(T2M3,0) as int) T2M3,
			  CAST(round(T2M4,0) as int) T2M4,
			  CAST(round(TermOne,0) as int) TermOne,
			  totalGrade ,
			  totalgradeT1,
			  totalgradeT2,
			  cast(round(HighestMarks,0) as int) HighestMarks,
			  HighestGrade ,
			  classname,
			  REPORT.fnGetStudentAttendanceDetails(I_Student_Detail_ID,I_Term_ID,I_Batch_ID) AS Attendance,
			  REPORT.fnGetStudentConductDetails(I_Student_Detail_ID,I_Term_ID,I_Batch_ID) AS Conduct,
			  B_Optional
			   FROM #tblResult AS tr   
			   order by I_Term_ID desc --added to get the highestmasrks and attendance                         
    END
