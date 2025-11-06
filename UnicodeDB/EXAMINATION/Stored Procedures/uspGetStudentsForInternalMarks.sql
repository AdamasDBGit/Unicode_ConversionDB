  
CREATE PROCEDURE [EXAMINATION].[uspGetStudentsForInternalMarks] --[EXAMINATION].[uspGetStudentsForInternalMarks] 7,69,476,1,null,0      
    (
      @iBatchID INT ,
      @iTermID INT ,
      @iModuleID INT = NULL ,
      @iExamComponentID INT = NULL ,
      @iStudentDetailID INT = NULL ,
      @iCenterID INT      
  
    )
AS
    BEGIN        
		

		--Added Temporarily on 4.11.2020
		--DECLARE @BatchExamID INT
		--SELECT @BatchExamID=MIN(I_Batch_Exam_ID) FROM EXAMINATION.T_Batch_Exam_Map 
		--	WHERE I_Batch_ID= @iBatchID AND I_Term_ID=@iTermID 
		--	AND I_Exam_Component_ID=@iExamComponentID
		--	AND I_Status=1
		--Added Temporarily on 4.11.2020

       
        IF ( @iModuleID IS NULL
             OR @iModuleID = 0
           )
            BEGIN        
  
                SELECT DISTINCT
                        SD.I_Student_Detail_ID ,
                        SCD.I_Centre_Id ,
                        ISNULL(SD.S_Student_ID, '') AS S_Student_ID ,
                        ISNULL(SD.S_First_Name, '') AS S_First_Name ,
                        ISNULL(SD.S_Middle_Name, '') AS S_Middle_Name ,
                        ISNULL(SD.S_Last_Name, '') AS S_Last_Name ,
                        ISNULL(SD.S_First_Name, '') + ' '
                        + ISNULL(SD.S_Middle_Name, '') + ' '
                        + ISNULL(SD.S_Last_Name, '') AS StdName ,
                        TSM.I_Exam_Total AS I_Exam_Total ,
                        ISNULL(@iModuleID, 0) AS I_Module_ID ,
                        ISNULL(TSM.I_Batch_Exam_ID, 0) AS I_Batch_Exam_ID ,
                        TSM.S_Remarks ,
                        TSM.Dt_Exam_Date ,
                        STD.D_Attendance ,
                        STD.I_Conduct_Id
                FROM    dbo.T_Student_Detail SD WITH ( NOLOCK )
                        INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON SD.I_Student_Detail_ID = TSBD.I_Student_ID
                        INNER JOIN dbo.T_Student_Term_Detail STD WITH ( NOLOCK ) ON STD.I_Student_Detail_ID = SD.I_Student_Detail_ID --AND STD.I_Batch_ID=@iBatchID AND STD.I_Term_ID=@iTermID    
                        INNER JOIN dbo.T_Student_Center_Detail SCD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
                                                              AND SCD.I_Status = 1
                        LEFT OUTER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_ID = ISNULL(@iBatchID,
                                                              TBEM.I_Batch_ID)
                                                              AND TBEM.I_Term_ID = ISNULL(@iTermID,
                                                              TBEM.I_Term_ID)
                                                              AND TBEM.I_Exam_Component_ID = ISNULL(@iExamComponentID,
                                                              TBEM.I_Exam_Component_ID)
                                                              AND TBEM.I_Status = 1
                        LEFT OUTER JOIN EXAMINATION.T_Student_Marks TSM WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = TSM.I_Student_Detail_ID
                                                              AND TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
                                                              AND I_Center_ID = @iCenterID
                WHERE   TSBD.I_Batch_ID = @iBatchID --AND STD.I_Batch_ID=@iBatchID      
  
      --AND TSBD.I_Status = 1  
                        AND TSBD.I_Status IN ( 1, 2 )--akash    
                        AND STD.I_Term_ID = @iTermID
                        AND SD.I_Status <> 0
                        AND SD.I_Student_Detail_ID = ISNULL(@iStudentDetailID,
                                                            SD.I_Student_Detail_ID)
                ORDER BY ISNULL(SD.S_First_Name, '') + ' '
                        + ISNULL(SD.S_Middle_Name, '') + ' '
                        + ISNULL(SD.S_Last_Name, '')       
  
            END        
  
        ELSE
            BEGIN        
  
                SELECT DISTINCT
                        SD.I_Student_Detail_ID ,
                        SCD.I_Centre_Id ,
                        ISNULL(SD.S_Student_ID, '') AS S_Student_ID ,
                        ISNULL(SD.S_First_Name, '') AS S_First_Name ,
                        ISNULL(SD.S_Middle_Name, '') AS S_Middle_Name ,
                        ISNULL(SD.S_Last_Name, '') AS S_Last_Name ,
                        ISNULL(SD.S_First_Name, '') + ' '
                        + ISNULL(SD.S_Middle_Name, '') + ' '
                        + ISNULL(SD.S_Last_Name, '') AS StdName ,
                        TSM.I_Exam_Total AS I_Exam_Total ,
                        ISNULL(@iModuleID, 0) AS I_Module_ID ,
                        ISNULL(TSM.I_Batch_Exam_ID, 0) AS I_Batch_Exam_ID ,
                        TSM.S_Remarks ,
                        TSM.Dt_Exam_Date
                FROM    dbo.T_Student_Detail SD WITH ( NOLOCK )
                        INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON SD.I_Student_Detail_ID = TSBD.I_Student_ID
                        INNER JOIN dbo.T_Student_Module_Detail SMD WITH ( NOLOCK ) ON SMD.I_Student_Detail_ID = SD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Center_Detail SCD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
                                                              AND SCD.I_Status = 1
                        LEFT OUTER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_ID = ISNULL(@iBatchID,
                                                              TBEM.I_Batch_ID)
                                                              AND TBEM.I_Term_ID = ISNULL(@iTermID,
                                                              TBEM.I_Term_ID)
                                                              AND TBEM.I_Module_ID = ISNULL(@iModuleID,
                                                              TBEM.I_Module_ID)
                                                              AND TBEM.I_Exam_Component_ID = ISNULL(@iExamComponentID,
                                                              TBEM.I_Exam_Component_ID)
                                                              AND TBEM.I_Status = 1

						--Added Temporarily on 4.11.2020
						--LEFT OUTER JOIN (SELECT  * FROM EXAMINATION.T_Batch_Exam_Map T1 WHERE T1.I_Batch_Exam_ID=@BatchExamID) AS TBEM ON TBEM.I_Batch_ID = ISNULL(@iBatchID,
      --                                                        TBEM.I_Batch_ID)
      --                                                        AND TBEM.I_Term_ID = ISNULL(@iTermID,
      --                                                        TBEM.I_Term_ID)
      --                                                        AND TBEM.I_Module_ID = ISNULL(@iModuleID,
      --                                                        TBEM.I_Module_ID)
      --                                                        AND TBEM.I_Exam_Component_ID = ISNULL(@iExamComponentID,
      --                                                        TBEM.I_Exam_Component_ID)
      --                                                        AND TBEM.I_Status =1
						--Added Temporarily on 4.11.2020
                        LEFT OUTER JOIN EXAMINATION.T_Student_Marks TSM WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = TSM.I_Student_Detail_ID
                                                              AND TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
                                                              AND I_Center_ID = @iCenterID
                WHERE   TSBD.I_Batch_ID = @iBatchID      
  
       --AND TSBD.I_Status = 1  
                        AND TSBD.I_Status IN ( 1, 2 )--akash       
                        AND SMD.I_Term_ID = @iTermID
                        AND SMD.I_Module_ID = @iModuleID
                        AND SD.I_Status <> 0
                        AND SD.I_Student_Detail_ID = ISNULL(@iStudentDetailID,
                                                            SD.I_Student_Detail_ID)
                ORDER BY ISNULL(SD.S_First_Name, '') + ' '
                        + ISNULL(SD.S_Middle_Name, '') + ' '
                        + ISNULL(SD.S_Last_Name, '')      
  
            END         
  
    END
