--sp_helptext 'STUDENTFEATURES.uspGetStudentPerformance'


-- =============================================  
-- Author: Abhisek Bhattacharya  
-- Create date: <08-06-2007>  
-- Description: Gets the Term and Module Evaluation Strategy for a particular Term  
-- =============================================  
CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentPerformance]  
-- Add the parameters for the stored procedure here  
    (
      @iStudentDetailID INT ,
      @iCenterID INT ,
      @iBatchID INT ,
      @iTermID INT ,
      @iCourseID INT
    )
AS 
    BEGIN TRY  
-- SET NOCOUNT ON added to prevent extra result sets from  
-- interfering with SELECT statements.  
  
        BEGIN  
  
            SET NOCOUNT ON ;  
  
            DECLARE @tblEvalStrategy TABLE
                (
                  I_Eval_Strategy_ID INT ,
                  I_Exam_Component_ID INT ,
                  I_Exam_Type_Master_ID INT ,
                  I_IsPSDate INT ,
                  S_Remarks VARCHAR(200) ,
                  I_TotMarks INT ,
                  N_Weightage NUMERIC(8, 2) ,
                  Dt_Exam_Date DATETIME ,
                  I_Exam_Total NUMERIC(8, 2) ,
                  S_Component_Name VARCHAR(50) ,
                  S_Component_Type VARCHAR(10) ,
                  S_Exam_Type_Name VARCHAR(100)
                )  
-- Insert statements for procedure here  
  
-- INSERT DATA FOR TERM EVALUATION STRATEGY  
            INSERT  INTO @tblEvalStrategy
--                    SELECT DISTINCT
--                            TES.I_Term_Strategy_ID ,
--                            TES.I_Exam_Component_ID ,
--                            TES.I_Exam_Type_Master_ID ,
--                            TES.I_IsPSDate ,
--                            TES.S_Remarks ,
--                            TES.I_TotMarks ,
--                            TES.N_Weightage ,
--                            ED.Dt_Exam_Date ,
--                            SM.I_Exam_Total ,
--                            ECM.S_Component_Name ,
--                            ISNULL(ECM.S_Component_Type, 'T') ,
--                            ETM.S_Exam_Type_Name
--                    FROM    dbo.T_Term_Eval_Strategy TES
--                            LEFT OUTER JOIN dbo.T_Exam_Component_Master ECM ON TES.I_Exam_Component_ID = ECM.I_Exam_Component_ID
--                                                              AND ECM.I_Status = 1
--                            LEFT OUTER JOIN dbo.T_Exam_Type_Master ETM ON TES.I_Exam_Type_Master_ID = ETM.I_Exam_Type_Master_ID
--                            LEFT OUTER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID  
----AND TES.I_Course_ID = TBEM.I_Course_ID  
--                                                              AND TES.I_Term_ID = TBEM.I_Term_ID
--                                                              AND TBEM.I_Module_ID IS NULL
--                            LEFT OUTER JOIN EXAMINATION.T_Student_Marks SM ON SM.I_Student_Detail_ID = @iStudentDetailID 
--       LEFT OUTER JOIN EXAMINATION.T_Examination_Detail ED ON TES.I_Exam_Component_ID = ED.I_Exam_Component_ID
--                                                              AND TES.I_Course_ID = ED.I_Course_ID
--                                                              AND TES.I_Term_ID = ED.I_Term_ID
--                                                              AND ED.I_Module_ID IS NULL
--                                                              AND ED.I_Centre_Id = @iCenterID
--                    WHERE   TBEM.I_Batch_ID = @iBatchID
--                            AND TES.I_Term_ID = @iTermID
--                            AND TES.I_Status = 1 

------Akash------
SELECT  TTES.I_Term_Strategy_ID ,
        TTES.I_Exam_Component_ID ,
        TTES.I_Exam_Type_Master_ID ,
        TTES.I_IsPSDate ,
        TTES.S_Remarks ,
        TTES.I_TotMarks ,
        TTES.N_Weightage ,
        TSM.Dt_Exam_Date ,
        SUM(TSM.I_Exam_Total),
        TECM.S_Component_Name ,
        ISNULL(TECM.S_Component_Type, 'T'), 
        'Terminal' AS ExamType
FROM    dbo.T_Term_Eval_Strategy TTES
        INNER JOIN EXAMINATION.T_Batch_Exam_Map TBEM ON TTES.I_Term_ID = TBEM.I_Term_ID
                                                        AND TTES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
        INNER JOIN EXAMINATION.T_Student_Marks TSM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
        INNER JOIN dbo.T_Exam_Component_Master TECM ON TTES.I_Exam_Component_ID = TECM.I_Exam_Component_ID --AND TECM.I_Course_ID=TTES.I_Course_ID 
WHERE   TTES.I_Course_ID = @iCourseID
        AND TTES.I_Term_ID = @iTermID
        AND TTES.I_Status = 1
        AND TBEM.I_Batch_ID = @iBatchID
        AND TSM.I_Student_Detail_ID = @iStudentDetailID
        AND TSM.I_Center_ID = @iCenterID
GROUP BY TTES.I_Term_Strategy_ID ,
        TTES.I_Exam_Component_ID ,
        TTES.I_Exam_Type_Master_ID ,
        TTES.I_IsPSDate ,
        TTES.S_Remarks ,
        TTES.I_TotMarks ,
        TTES.N_Weightage ,
        TSM.Dt_Exam_Date ,
        TECM.S_Component_Name ,
        ISNULL(TECM.S_Component_Type, 'T')
        --'Terminal'
        
        
------Akash--------         
  
-- INSERT DATA FOR MODULE EVALUATION STRATEGY  
            INSERT  INTO @tblEvalStrategy
                    SELECT DISTINCT
                            MES.I_Module_Strategy_ID ,
                            MES.I_Exam_Component_ID ,
                            ECM.I_Exam_Type_Master_ID ,
                            NULL AS I_IsPSDate ,
                            MES.S_Remarks ,
                            MES.I_TotMarks ,
                            MES.N_Weightage ,
                            ED.Dt_Exam_Date ,
                            SM.I_Exam_Total ,
                            ECM.S_Component_Name ,
                            ECM.S_Component_Type ,
                            ETM.S_Exam_Type_Name
                    FROM    dbo.T_Module_Eval_Strategy MES
                            INNER JOIN dbo.T_Exam_Component_Master ECM ON MES.I_Exam_Component_ID = ECM.I_Exam_Component_ID
                                                              AND MES.I_Course_ID = @iCourseID
                                                              AND MES.I_Term_ID = @iTermID
                                                              AND MES.I_Module_ID IN (
                                                              SELECT
                                                              I_Module_ID
                                                              FROM
                                                              dbo.T_Module_Term_Map
                                                              WHERE
                                                              I_Term_ID = @iTermID
                                                              AND GETDATE() >= ISNULL(Dt_Valid_From,
                                                              GETDATE())
                                                              AND GETDATE() <= ISNULL(Dt_Valid_To,
                                                              GETDATE())
                                                              AND I_Status = 1 )
                                                              AND MES.I_Status = 1
                                                              AND ECM.I_Status = 1
                            INNER JOIN dbo.T_Exam_Type_Master ETM ON ECM.I_Exam_Type_Master_ID = ETM.I_Exam_Type_Master_ID
                            LEFT OUTER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON MES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID  
--AND MES.I_Course_ID = TBEM.I_Course_ID  
                                                              AND MES.I_Term_ID = TBEM.I_Term_ID
                                                              AND MES.I_Module_ID = TBEM.I_Module_ID
                            LEFT OUTER JOIN EXAMINATION.T_Student_Marks SM ON SM.I_Student_Detail_ID = @iStudentDetailID
                            LEFT OUTER JOIN EXAMINATION.T_Examination_Detail ED ON MES.I_Exam_Component_ID = ED.I_Exam_Component_ID
                                                              AND MES.I_Course_ID = ED.I_Course_ID
                                                              AND MES.I_Term_ID = ED.I_Term_ID
                                                              AND MES.I_Module_ID = ED.I_Module_ID
                                                              AND ED.I_Centre_Id = @iCenterID
                                                              AND ED.I_Exam_ID = SM.I_Exam_ID  
  
            SELECT  *
            FROM    @tblEvalStrategy  
  
        END  
    END TRY  
    BEGIN CATCH  
--Error occurred:  
  
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()  
  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
    END CATCH  



--select * FROM dbo.T_Term_Eval_Strategy TES
