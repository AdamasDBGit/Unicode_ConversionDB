
-- =============================================  
-- Author:  Shubhrangshu Nag  
-- Create date: 09/03/2013  
-- Description: To get HomeWork Details Report BatchWise 
-- =============================================  
  
CREATE PROCEDURE [REPORT].[uspGetHomeworkDetailsReport] --'88',109,1322,'2013-08-01','2013-08-31'
    (
      -- Add the parameters for the stored procedure here  
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @iBatchID INT ,
      @FromDate DATETIME ,
      @ToDate DATETIME    
    )
AS 
    BEGIN TRY  
        BEGIN   
  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
            SET NOCOUNT ON ; 

            SELECT    
	DISTINCT      SD.I_RollNo ,
                    TSBM.S_Batch_Name ,
                    ISNULL(tsm.S_Session_Name, HM.S_Homework_Name) AS S_Homework_Name ,
                    HM.Dt_Submission_Date AS Dt_Crtd_On ,
                    HS.Dt_Submission_Date ,
                    HS.Dt_Return_Date ,
                    FN2.instanceChain
            FROM    dbo.T_Student_Detail SD
                    INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON SD.I_Student_Detail_ID = TSBD.I_Student_ID
                                                              AND TSBD.I_Status = 1
                                                              AND SD.I_Status = 1
                    INNER JOIN dbo.T_Student_Center_Detail SC ON SC.I_Student_Detail_ID = TSBD.I_Student_ID
                                                              AND SC.I_Status = 1
                    INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON TSBD.I_Batch_ID = TCBD.I_Batch_ID
                                                              AND SC.I_Centre_Id = TCBD.I_Centre_Id
                                                              AND ISNULL(TCBD.I_Status,
                                                              2) <> 5
                    INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TCBD.I_Batch_ID = TSBM.I_Batch_ID
                    INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON SC.I_Centre_Id = FN1.CenterID
                    INNER JOIN [EXAMINATION].[T_Homework_Submission] HS ON HS.I_Student_Detail_ID = SD.I_Student_Detail_ID
                    INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                    INNER JOIN [EXAMINATION].[T_Homework_Master] HM ON HS.I_Homework_ID = HM.I_Homework_ID
                    LEFT OUTER JOIN dbo.T_Session_Master AS tsm ON HM.I_session_ID = tsm.I_Session_ID
            WHERE   TSBD.I_Batch_ID = ISNULL(@iBatchID, TSBD.I_Batch_ID)
                    AND HM.Dt_Submission_Date BETWEEN @FromDate
                                              AND     @ToDate
            GROUP BY TSBM.S_Batch_Name ,
                    SD.I_RollNo ,
                    ISNULL(tsm.S_Session_Name, HM.S_Homework_Name) ,
                    HM.Dt_Submission_Date ,
                    HS.Dt_Submission_Date ,
                    HS.Dt_Return_Date ,
                    FN2.instanceChain
        END  
    END TRY  
  
    BEGIN CATCH  
   
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT  
  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()  
  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)  
    END CATCH
