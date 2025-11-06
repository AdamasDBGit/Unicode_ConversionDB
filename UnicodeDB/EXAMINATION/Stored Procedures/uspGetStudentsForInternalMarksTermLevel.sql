--------------------------------------------------------------------------------------------            
--Issue No 278            
--------------------------------------------------------------------------------------------            
            
CREATE PROCEDURE [EXAMINATION].[uspGetStudentsForInternalMarksTermLevel] --[EXAMINATION].[uspGetStudentsForInternalMarks] 746,3,9,17,NULL,1           
    (          
      @iBatchID INT ,          
      @iTermID INT ,          
      --@iModuleID INT = NULL ,          
      @iExamComponentID INT = NULL ,          
      @iStudentDetailID INT = NULL ,        
      @iCenterID INT          
    )          
AS           
            BEGIN            
                SELECT DISTINCT          
                        SD.I_Student_Detail_ID ,          
                        SCD.I_Centre_Id ,          
                        ISNULL(SD.S_Student_ID, '') AS S_Student_ID ,          
                        ISNULL(SD.S_First_Name, '') AS S_First_Name ,          
                        ISNULL(SD.S_Middle_Name, '') AS S_Middle_Name ,          
                        ISNULL(SD.S_Last_Name, '') AS S_Last_Name ,          
                        TSM.I_Exam_Total AS I_Exam_Total ,          
                        --ISNULL(@iModuleID, 0) AS I_Module_ID ,          
                        ISNULL(TSM.I_Batch_Exam_ID, 0) AS I_Batch_Exam_ID ,          
                        TSM.S_Remarks                                  
                FROM    dbo.T_Student_Detail SD WITH ( NOLOCK )          
      INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON SD.I_Student_Detail_ID = TSBD.I_Student_ID          
                        INNER JOIN dbo.T_Student_Term_Detail STD WITH ( NOLOCK ) ON STD.I_Student_Detail_ID = SD.I_Student_Detail_ID          
                        INNER JOIN dbo.T_Student_Center_Detail SCD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID          
                                                              AND SCD.I_Status = 1          
      LEFT OUTER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON          
                                                              TBEM.I_Batch_ID = ISNULL(@iBatchID,          
                                                              TBEM.I_Batch_ID)          
                                                              AND TBEM.I_Term_ID = ISNULL(@iTermID,          
                                                              TBEM.I_Term_ID)          
                                                              AND TBEM.I_Exam_Component_ID = ISNULL(@iExamComponentID,          
                                                              TBEM.I_Exam_Component_ID)                                                                        
                        LEFT OUTER JOIN EXAMINATION.T_Student_Marks TSM WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = TSM.I_Student_Detail_ID          
                        AND TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID AND I_Center_ID = @iCenterID         
                WHERE   TSBD.I_Batch_ID = @iBatchID          
      AND TSBD.I_Status =1            
                        AND STD.I_Term_ID = @iTermID          
                        AND SD.I_Status <> 0          
                        AND SD.I_Student_Detail_ID = ISNULL(@iStudentDetailID,          
                                                            SD.I_Student_Detail_ID)          
                ORDER BY S_First_Name            
            END
