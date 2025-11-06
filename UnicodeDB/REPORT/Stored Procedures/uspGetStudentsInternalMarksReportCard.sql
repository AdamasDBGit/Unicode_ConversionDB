
CREATE PROCEDURE [REPORT].[uspGetStudentsInternalMarksReportCard] -- [REPORT].[uspGetStudentsInternalMarksReportCard] 1,1,107,'2012-13',1
    (      
      @iCourseFamilyID INT ,      
      @iCenterID INT,
      @iBrandId INT,    
      @session varchar(MAX),
	  @sHierarchyList VARCHAR(MAX)      
    )      
AS       
BEGIN        

SELECT DISTINCT      
						@session as 'Session',
                        SD.I_Student_Detail_ID ,      
                        SCD.I_Centre_Id ,
                        TCHND.I_Brand_ID, 
                        TCHND.S_Brand_Name ,     
                        SD.S_Student_ID ,      
                        ISNULL(SD.S_First_Name, '') AS S_First_Name ,      
                        ISNULL(SD.S_Middle_Name, '') AS S_Middle_Name ,      
                        ISNULL(SD.S_Last_Name, '') AS S_Last_Name ,      
                        TSM.I_Exam_Total,
                        TMES.I_TotMarks as "FullMarks",
                        TECM.I_Exam_Component_ID,
                        TECM.S_Component_Name,
                        TBEM.I_Term_ID,
                        (select S_Term_Name from T_Term_Master where I_Term_ID=TBEM.I_Term_ID) as S_Term_Name,
                        TBEM.I_Module_ID,      
                        TMM.S_Module_Name,
                        TSM.I_Batch_Exam_ID,      
						TSM.S_Remarks,
						TBEFM.I_Employee_ID,
						ISNULL(TED.S_First_Name, '') AS F_First_Name ,      
                        ISNULL(TED.S_Middle_Name, '') AS F_Middle_Name ,      
                        ISNULL(TED.S_Last_Name, '') AS F_Last_Name ,
                        TSBM.I_Batch_ID,
                        TSBM.S_Batch_Name,
                        TCM.I_Course_ID,
                        TCM.S_Course_Name,
                        TCFM.I_CourseFamily_ID,
                        TCFM.S_CourseFamily_Name
                FROM    dbo.T_Student_Detail SD WITH ( NOLOCK )      
      INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON SD.I_Student_Detail_ID = TSBD.I_Student_ID      
                        INNER JOIN dbo.T_Student_Module_Detail SMD WITH ( NOLOCK ) ON SMD.I_Student_Detail_ID = SD.I_Student_Detail_ID      
                        INNER JOIN dbo.T_Student_Center_Detail SCD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID      
                                                              AND SCD.I_Status = 1      
      LEFT OUTER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON      
                                                              TBEM.I_Batch_ID in (select I_Batch_ID from T_Student_Batch_Master 
where I_Course_ID in (select I_Course_ID from T_Course_Master 
where I_CourseFamily_ID=@iCourseFamilyID and I_Brand_ID=@iBrandId and I_Status=1) and I_Status=2)     
                                                              AND TBEM.I_Term_ID in (select T_Term_Master.I_Term_ID from T_Term_Master 
inner join T_Term_Course_Map on T_Term_Master.I_Term_ID=T_Term_Course_Map.I_Term_ID 
where T_Term_Master.I_Brand_ID=@iBrandId and T_Term_Master.I_Status=1 
and T_Term_Course_Map.I_Course_ID in (select I_Course_ID from T_Course_Master 
where I_CourseFamily_ID=@iCourseFamilyID and I_Brand_ID=@iBrandId and I_Status=1)) 
                                                              AND TBEM.I_Module_ID = ISNULL(null,      
                                                              TBEM.I_Module_ID)      
                                                              AND TBEM.I_Exam_Component_ID = ISNULL(null,      
                                                              TBEM.I_Exam_Component_ID)                                                                  
                        LEFT OUTER JOIN EXAMINATION.T_Student_Marks TSM WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = TSM.I_Student_Detail_ID    
                        AND TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID AND I_Center_ID = @iCenterID       
      LEFT OUTER JOIN EXAMINATION.T_Batch_Exam_Faculty_Map AS TBEFM ON TBEM.I_Batch_Exam_ID=TBEFM.I_Batch_Exam_ID                           
      LEFT OUTER JOIN T_Employee_Dtls AS TED ON TBEFM.I_Employee_ID=TED.I_Employee_ID
      INNER JOIN T_Student_Batch_Master AS TSBM ON TBEM.I_Batch_ID=TSBM.I_Batch_ID
      INNER JOIN T_Module_Master AS TMM ON TBEM.I_Module_ID=TMM.I_Module_ID 
      INNER JOIN T_Module_Eval_Strategy AS TMES ON TBEM.I_Module_ID=TMES.I_Module_ID AND TBEM.I_Exam_Component_ID=TMES.I_Exam_Component_ID
      INNER JOIN T_Exam_Component_Master AS TECM ON TBEM.I_Exam_Component_ID=TECM.I_Exam_Component_ID
      INNER JOIN T_Course_Master AS TCM ON TSBM.I_Course_ID=TCM.I_Course_ID
      INNER JOIN T_CourseFamily_Master AS TCFM ON TCM.I_CourseFamily_ID=TCFM.I_CourseFamily_ID
      INNER JOIN T_Center_Hierarchy_Name_Details AS TCHND ON SCD.I_Centre_Id=TCHND.I_Center_ID
                WHERE   TSBD.I_Batch_ID in (select I_Batch_ID from T_Student_Batch_Master 
where I_Course_ID in (select I_Course_ID from T_Course_Master 
where I_CourseFamily_ID=@iCourseFamilyID and I_Brand_ID=@iBrandId and I_Status=1) and I_Status=2)
      AND TSBD.I_Status =1 AND TSM.I_Batch_Exam_ID IS NOT NULL     
                        AND SMD.I_Term_ID in (select T_Term_Master.I_Term_ID from T_Term_Master 
inner join T_Term_Course_Map on T_Term_Master.I_Term_ID=T_Term_Course_Map.I_Term_ID 
where T_Term_Master.I_Brand_ID=@iBrandId and T_Term_Master.I_Status=1 
and T_Term_Course_Map.I_Course_ID in (select I_Course_ID from T_Course_Master 
where I_CourseFamily_ID=@iCourseFamilyID and I_Brand_ID=@iBrandId and I_Status=1))      
                        AND SMD.I_Module_ID = ISNULL(null,TBEM.I_Module_ID)      
                        AND SD.I_Status <> 0                              
                        AND SD.I_Student_Detail_ID = ISNULL(null,      
                                                            SD.I_Student_Detail_ID)      
and SCD.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandId AS INT)) CenterList)          
    
    GROUP BY  TCFM.S_CourseFamily_Name,TCM.S_Course_Name ,TSBM.S_Batch_Name ,SD.I_Student_Detail_ID ,
    SD.S_Student_ID,SCD.I_Centre_Id ,TCHND.S_Brand_Name,SD.S_First_Name,SD.S_Middle_Name,
    SD.S_Last_Name,TSM.I_Exam_Total,TMES.I_TotMarks,TECM.S_Component_Name,TBEM.I_Module_ID,TMM.S_Module_Name,
    TSM.I_Batch_Exam_ID,TSM.S_Remarks ,TBEFM.I_Employee_ID ,TED.S_First_Name,TED.S_Middle_Name,TED.S_Last_Name,
    TCHND.I_Brand_ID,TECM.I_Exam_Component_ID,TSBM.I_Batch_ID,TCM.I_Course_ID,TCFM.I_CourseFamily_ID,TBEM.I_Term_ID
						      
    ORDER BY S_First_Name ,TMM.S_Module_Name          
END
