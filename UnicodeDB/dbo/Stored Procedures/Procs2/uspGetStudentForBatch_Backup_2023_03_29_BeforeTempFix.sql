
CREATE PROCEDURE [dbo].[uspGetStudentForBatch_Backup_2023_03_29_BeforeTempFix] -- [dbo].[uspGetStudentForBatch] 36
    (
      @iBatchID INT                   
    )
AS 
    BEGIN   
        SELECT  TSD.I_Student_Detail_ID,TSD.S_Student_ID, TSD.S_First_Name,ISNULL(TSD.S_Middle_Name,'') AS S_Middle_Name,TSD.S_Last_Name,TSBD.I_Batch_ID,TSBD.I_Status
        FROM    dbo.t_student_detail AS TSD 
                INNER JOIN dbo.t_student_batch_details AS TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID                        
        WHERE   TSBD.I_Batch_Id=@iBatchID
    END
