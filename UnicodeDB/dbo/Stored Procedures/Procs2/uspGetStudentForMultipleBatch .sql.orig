CREATE PROCEDURE [dbo].[uspGetStudentForMultipleBatch ] -- [dbo].[uspGetStudentForMultipleBatch] '178,'
( 
	@iBatchID VARCHAR(MAX) 
)
AS 
    BEGIN          
       
        SELECT DISTINCT
                STD.S_Student_ID ,
                STD.I_RollNo ,
                STD.S_First_Name ,
                ISNULL(STD.S_Middle_Name, '') AS S_Middle_Name ,
                STD.S_Last_Name ,
                TSBM.S_Batch_Name,
                TSBM.I_Batch_ID,
                STBD.I_Student_ID
        FROM    T_Student_Batch_Details STBD
                INNER JOIN T_Student_Detail STD ON STD.I_Student_Detail_ID = STBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = STBD.I_Batch_ID
        WHERE   STBD.I_Batch_ID IN ( SELECT CAST(VAL AS INT)
                                     FROM   fnString2Rows(@iBatchID, ',') )
                AND STBD.I_Status = 1 
        ORDER BY STD.S_Student_ID
    END
