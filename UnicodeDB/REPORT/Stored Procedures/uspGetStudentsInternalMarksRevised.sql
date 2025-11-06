

CREATE PROCEDURE [REPORT].[uspGetStudentsInternalMarksRevised] --[REPORT].[uspGetStudentsInternalMarksRevised] 1067,372,17,1,107,1       
    (      
	  @iBatchID INT ,      
      @iTermID INT ,      
      @iExamComponentID INT = NULL ,      
      @iCenterID INT,
      @iBrandId INT,    
	  @sHierarchyList VARCHAR(MAX)      
    )      
AS       
BEGIN  
SELECT DISTINCT      
                        SD.I_Student_Detail_ID ,      
                        SCD.I_Centre_Id , 
                        TCHND.S_Brand_Name ,     
                        ISNULL(SD.S_Student_ID, '') AS S_Student_ID ,      
                        ISNULL(SD.S_First_Name, '') AS S_First_Name ,      
                        ISNULL(SD.S_Middle_Name, '') AS S_Middle_Name ,      
                        ISNULL(SD.S_Last_Name, '') AS S_Last_Name , 
                        TSM.I_Exam_Total,    
                        TMES.I_TotMarks,
                        TECM.S_Component_Name,
                        ISNULL(NULL, SMD.I_Module_ID) AS I_Module_ID ,  
                        TMM.S_Module_Name,
                        TSBM.S_Batch_Name ,
                        TCM.S_Course_Name ,
                        TCFM.S_CourseFamily_Name
                FROM    dbo.T_Student_Detail SD WITH ( NOLOCK )      
      INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON SD.I_Student_Detail_ID = TSBD.I_Student_ID      
      INNER JOIN dbo.T_Student_Module_Detail SMD WITH ( NOLOCK ) ON SMD.I_Student_Detail_ID = SD.I_Student_Detail_ID      
      INNER JOIN dbo.T_Student_Center_Detail SCD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID      
                                                              AND SCD.I_Status = 1      
	  INNER JOIN T_Student_Batch_Master AS TSBM ON tsbd.I_Batch_ID=TSBM.I_Batch_ID
	  INNER JOIN T_Course_Master AS TCM ON TCM.I_Course_ID=TSBM.I_Course_ID
                                                              
      INNER JOIN T_Module_Eval_Strategy AS TMES ON  TSBM.I_Course_ID=TMES.I_Course_ID AND SMD.I_Module_ID=TMES.I_Module_ID
      INNER JOIN T_Exam_Component_Master AS TECM ON TMES.I_Exam_Component_ID=TECM.I_Exam_Component_ID
      LEFT OUTER JOIN T_Module_Master AS TMM ON SMD.I_Module_ID=TMM.I_Module_ID 
      INNER JOIN T_CourseFamily_Master AS TCFM ON TCM.I_CourseFamily_ID=TCFM.I_CourseFamily_ID
      INNER JOIN T_Center_Hierarchy_Name_Details AS TCHND ON SCD.I_Centre_Id=TCHND.I_Center_ID
      
      LEFT OUTER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TMM.I_Module_ID=TBEM.I_Module_ID AND TECM.I_Exam_Component_ID=TBEM.I_Exam_Component_ID
      LEFT OUTER JOIN EXAMINATION.T_Student_Marks AS TSM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
      
                WHERE   TSBD.I_Batch_ID = @iBatchID      
						AND TSBD.I_Status <> 0      
                        AND SMD.I_Term_ID = @iTermID  
                        AND TECM.I_Exam_Component_ID =ISNULL(@iExamComponentID,TECM.I_Exam_Component_ID)
                        AND SD.I_Status <> 0                              
and SCD.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)          
                
                ORDER BY S_First_Name ,TMM.S_Module_Name     
                
                
END
