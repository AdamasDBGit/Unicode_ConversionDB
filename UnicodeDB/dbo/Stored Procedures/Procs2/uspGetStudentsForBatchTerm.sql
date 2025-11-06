CREATE PROCEDURE [dbo].[uspGetStudentsForBatchTerm]   --[dbo].[uspGetStudentsForBatchTerm]360,794  
    (
      @iBatchID INT ,
      @iCenterID INT
    )
AS 
    BEGIN                
        SELECT  TSD.I_Student_Detail_ID ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(S_Middle_Name, '') + ' '
                + S_Last_Name AS StudentName
        FROM    dbo.T_Student_Batch_Details AS TSBD
                INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON TSBD.I_Batch_ID = TCBD.I_Batch_ID
                INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TCBD.I_Centre_Id = TSCD.I_Centre_Id
                                                              AND TSBD.I_Student_ID = TSCD.I_Student_Detail_ID
                INNER JOIN dbo.T_Student_Detail AS TSD ON TSBD.I_Student_ID = TSD.I_Student_Detail_ID
        WHERE   TSBD.I_Batch_ID = @iBatchID
                AND TSBD.I_Status = 1
                AND TCBD.I_Centre_Id = @iCenterID
    END
