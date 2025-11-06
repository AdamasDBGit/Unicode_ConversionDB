--------------------------------------------------------------------------------------------            
--Issue No 278            
--------------------------------------------------------------------------------------------            
            
CREATE PROCEDURE [EXAMINATION].[uspGetStudentsForInternalRemarksTermLevel] --[EXAMINATION].[uspGetStudentsForInternalMarks] 746,3,9,17,NULL,1           
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
			
				--Added on 8.2.2021
				IF(@iExamComponentID=0)
					SET @iExamComponentID=NULL
				--Added on 8.2.2021


				IF (@iExamComponentID is not null)

				begin
                SELECT DISTINCT          
                        SD.I_Student_Detail_ID ,          
                        SCD.I_Centre_Id ,          
                        ISNULL(SD.S_Student_ID, '') AS S_Student_ID ,          
                        ISNULL(SD.S_First_Name, '') AS S_First_Name ,          
                        ISNULL(SD.S_Middle_Name, '') AS S_Middle_Name ,          
                        ISNULL(SD.S_Last_Name, '') AS S_Last_Name ,          
						ISNULL(TSM.S_Remarks,'') AS Remarks
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
                        LEFT OUTER JOIN EXAMINATION.T_Student_Internal_Remarks AS TSM WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = TSM.I_Student_Detail_ID --AND TSM.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
																										AND TBEM.I_Term_ID=TSM.I_Term_ID
                WHERE   TSBD.I_Batch_ID = @iBatchID          
      AND TSBD.I_Status =1            
                        AND STD.I_Term_ID = @iTermID          
                        AND SD.I_Status <> 0          
                        AND SD.I_Student_Detail_ID = ISNULL(@iStudentDetailID,          
                                                            SD.I_Student_Detail_ID)          
                ORDER BY S_First_Name 
				end
				else
				begin

					SELECT DISTINCT          
                        SD.I_Student_Detail_ID ,          
                        SCD.I_Centre_Id ,          
                        ISNULL(SD.S_Student_ID, '') AS S_Student_ID ,          
                        ISNULL(SD.S_First_Name, '') AS S_First_Name ,          
                        ISNULL(SD.S_Middle_Name, '') AS S_Middle_Name ,          
                        ISNULL(SD.S_Last_Name, '') AS S_Last_Name ,          
						ISNULL(TSM.S_Remarks,'') AS Remarks
                FROM    dbo.T_Student_Detail SD WITH ( NOLOCK )          
      INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON SD.I_Student_Detail_ID = TSBD.I_Student_ID          
                        INNER JOIN dbo.T_Student_Term_Detail STD WITH ( NOLOCK ) ON STD.I_Student_Detail_ID = SD.I_Student_Detail_ID          
                        INNER JOIN dbo.T_Student_Center_Detail SCD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID          
                                                              AND SCD.I_Status = 1          
      --LEFT OUTER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON          
      --                                                        TBEM.I_Batch_ID = ISNULL(@iBatchID,          
      --                                                        TBEM.I_Batch_ID)          
      --                                                        AND TBEM.I_Term_ID = ISNULL(@iTermID,          
      --                                                        TBEM.I_Term_ID)          
      --                                                        AND TBEM.I_Exam_Component_ID = ISNULL(@iExamComponentID,          
      --                                                        TBEM.I_Exam_Component_ID)                                                                        
                        LEFT OUTER JOIN EXAMINATION.T_Student_Internal_Remarks AS TSM WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = TSM.I_Student_Detail_ID --AND TSM.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
																										AND STD.I_Term_ID=TSM.I_Term_ID
                WHERE   TSBD.I_Batch_ID = @iBatchID          
      AND TSBD.I_Status =1            
                        AND STD.I_Term_ID = @iTermID          
                        AND SD.I_Status <> 0          
                        AND SD.I_Student_Detail_ID = ISNULL(@iStudentDetailID,          
                                                            SD.I_Student_Detail_ID)          
                ORDER BY S_First_Name	

				end
            END
