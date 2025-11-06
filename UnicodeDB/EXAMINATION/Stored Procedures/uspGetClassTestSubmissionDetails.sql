CREATE PROCEDURE [EXAMINATION].[uspGetClassTestSubmissionDetails]    --[EXAMINATION].[uspGetHomeworkSubmissionDetails] 1,22,18
    (
      @iClassTestId INT ,
      @iBatchId INT ,
      @iCenterId INT    
    
    )
AS 
    SET NOCOUNT OFF    
    BEGIN TRY     
        SELECT  TSBD.I_Student_ID AS Student_ID ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS [StudentName] ,
                ISNULL(TSBD.I_RollNo,TSD.I_RollNo) AS RollNo ,
                TCTS.Dt_Submission_Date AS SubmissionDate ,
                --TCTS.Dt_CCO_Submission_Date AS CCOSubmissionDate ,
                --TCTS.Dt_Faculty_Submission_Date AS FacultySubmissionDate ,
                TCTS.Dt_Return_Date AS ReturnDate ,
                --TCTS.S_Material_BarCode AS MaterialBarCode ,
                TCTS.N_Marks ,
                TCTS.I_Employee_ID AS Faculty_ID ,
                TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name, '') + ' '
                + TED.S_Last_Name AS [EmployeeName],
                TCTS.N_Total_Marks,
                TTTFM.I_Employee_ID AS SchFacID
        FROM    dbo.T_Student_Batch_Master AS TSBM
                INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TSBD.I_Student_ID = TSD.I_Student_Detail_ID
                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                                              AND TCBD.I_Centre_Id = @iCenterId
                INNER JOIN T_Student_Center_Detail TSCD ON TSBD.I_Student_ID = TSCD.I_Student_Detail_ID
                LEFT OUTER JOIN
                EXAMINATION.T_ClassTest_Submission TCTS ON TSCD.I_Student_Detail_ID = TCTS.I_Student_Detail_ID AND TCTS.I_ClassTest_ID=@iClassTestId
                --LEFT OUTER JOIN EXAMINATION.T_ClassTest_Submission TCTS ON TCTS.I_Student_Detail_ID = TSCD.I_Student_Detail_ID
                --                                              AND TCTS.I_ClassTest_ID = @iClassTestId
                LEFT OUTER JOIN dbo.T_Employee_Dtls AS TED ON TCTS.I_Employee_ID = TED.I_Employee_ID 
                LEFT OUTER JOIN EXAMINATION.T_ClassTest_Master TCTM2 ON TSCD.I_Centre_Id=TCTM2.I_Center_ID AND TCTM2.I_ClassTest_ID=@iClassTestId
                LEFT JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TCTM2.I_TimeTable_ID = TTTFM.I_TimeTable_ID AND TTTFM.B_Is_Actual=1                                            
                --LEFT OUTER JOIN EXAMINATION.T_ClassTest_Master TCTM ON TCTS.I_ClassTest_ID = TCTM.I_ClassTest_ID
                --LEFT OUTER JOIN dbo.T_TimeTable_Master TTTM ON TCTM.I_TimeTable_ID = TTTM.I_TimeTable_ID
                --LEFT OUTER JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TTTM.I_TimeTable_ID = TTTFM.I_TimeTable_ID AND TTTFM.B_Is_Actual=1 AND TTTFM.I_TimeTable_ID=TCTM.I_TimeTable_ID                                              
                
        WHERE   TSBD.I_Status = 1 AND TSD.I_Status=1
                AND TSBD.I_Batch_ID = @iBatchID
                AND TSCD.I_Centre_Id = @iCenterId
                AND ( TCTS.I_ClassTest_ID = @iClassTestId
                      OR TCTS.I_ClassTest_ID IS NULL
                    )
        ORDER BY ISNULL(TSBD.I_RollNo,TSD.I_RollNo)

    END TRY        
    BEGIN CATCH        
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT        
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()        
        
        RAISERROR(@ErrMsg, @ErrSeverity, 1)        
    END CATCH
