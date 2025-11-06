
CREATE PROCEDURE [EXAMINATION].[uspGetHomeworkSubmissionDetails_BKP2023June05_BeforeFilterStu]    --[EXAMINATION].[uspGetHomeworkSubmissionDetails] 1,22,18
    (
      @iHomeworkId INT ,
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
                THS.Dt_Submission_Date AS SubmissionDate ,
                THS.Dt_CCO_Submission_Date AS CCOSubmissionDate ,
                THS.Dt_Faculty_Submission_Date AS FacultySubmissionDate ,
                THS.Dt_Return_Date AS ReturnDate ,
                THS.S_Material_BarCode AS MaterialBarCode ,
                THS.N_Marks AS S_Remarks ,
                THS.I_Employee_ID AS Faculty_ID ,
                TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name, '') + ' '
                + TED.S_Last_Name AS [EmployeeName]
        FROM    dbo.T_Student_Batch_Master AS TSBM
                INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
                INNER JOIN dbo.T_Student_Detail TSD ON TSBD.I_Student_ID = TSD.I_Student_Detail_ID
                INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                                              AND TCBD.I_Centre_Id = @iCenterId
                INNER JOIN T_Student_Center_Detail TSCD ON TSBD.I_Student_ID = TSCD.I_Student_Detail_ID
                LEFT OUTER JOIN EXAMINATION.T_Homework_Submission THS ON THS.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                              AND I_Homework_ID = @iHomeworkId
                LEFT OUTER JOIN dbo.T_Employee_Dtls AS TED ON THS.I_Employee_ID = TED.I_Employee_ID
        WHERE   TSBD.I_Status = 1 --AND TSD.I_Status=1
                AND TSBD.I_Batch_ID = @iBatchId
                AND TSCD.I_Centre_Id = @iCenterId
                AND ( THS.I_Homework_ID = @iHomeworkId
                      OR THS.I_Homework_ID IS NULL
                    )
        ORDER BY ISNULL(TSBD.I_RollNo,TSD.I_RollNo) --Akash--
 --SELECT TSBD.I_Student_ID AS Student_ID,TSD.S_Student_ID,TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name,'') + ' ' + TSD.S_Last_Name AS [StudentName],  
 --TSD.I_RollNo AS RollNo,
 --THS.Dt_Submission_Date AS SubmissionDate ,
 --THS.Dt_CCO_Submission_Date AS CCOSubmissionDate ,
 --THS.Dt_Faculty_Submission_Date AS FacultySubmissionDate,
 -- THS.Dt_Return_Date AS ReturnDate,
 -- --THS.S_Material_BarCode as MaterialBarCode,
 -- SMIS.Fld_KPMG_Barcode as MaterialBarCode,
 -- THS.S_Remarks ,THS.I_Employee_ID AS Faculty_ID , 
 --TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name,'') + ' ' + TED.S_Last_Name AS [EmployeeName]
 
 --FROM dbo.T_Student_Batch_Master AS TSBM        
 --INNER JOIN dbo.T_Student_Batch_Details AS TSBD        
 --ON TSBM.I_Batch_ID = TSBD.I_Batch_ID                 
 --INNER JOIN dbo.T_Student_Detail TSD            
 --ON TSBD.I_Student_ID= TSD.I_Student_Detail_ID              
 --INNER JOIN dbo.T_Center_Batch_Details TCBD                  
 --ON TSBM.I_Batch_ID = TCBD.I_Batch_ID                  
 --AND TCBD.I_Centre_Id = @iCenterId                  
 --INNER JOIN T_Student_Center_Detail TSCD                
 --ON TSBD.I_Student_ID = TSCD.I_Student_Detail_ID     
 --LEFT OUTER JOIN EXAMINATION.T_Homework_Submission THS    
 --ON THS.I_Student_Detail_ID = TSCD.I_Student_Detail_ID     
 --AND I_Homework_ID = @iHomeworkId 
 
 --INNER JOIN Tbl_KPMG_SM_Issue as SMIS on TSD.I_Student_Detail_ID  = SMIS.Fld_KPMG_StudentId 
 --INNER JOIN Tbl_KPMG_SM_List as LI on LI.Fld_KPMG_ItemCode = SMIS.Fld_KPMG_ItemCode 
 
 --LEFT OUTER JOIN dbo.T_Employee_Dtls AS TED                  
 --ON THS.I_Employee_ID = TED.I_Employee_ID  
    
 --WHERE TSBD.I_Status = 1                  
 --AND TSBD.I_Batch_ID = @iBatchID           
 --AND TSCD.I_Centre_Id =  @iCenterId              
 --AND (THS.I_Homework_ID = @iHomeworkId OR THS.I_Homework_ID IS NULL) 
 --AND SMIS.Fld_KPMG_Context = 'ISSUE' and LI.Fld_KPMG_ItemType = 2 
    END TRY        
    BEGIN CATCH        
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT        
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()        
        
        RAISERROR(@ErrMsg, @ErrSeverity, 1)        
    END CATCH
