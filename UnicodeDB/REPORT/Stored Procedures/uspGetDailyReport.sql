 
-- =============================================    
-- Author:  Shubhrangshu Nag    
-- Create date: 08/12/2013    
-- Description: To get Daily Report  
-- =============================================    
    
CREATE PROCEDURE [REPORT].[uspGetDailyReport]  --'88',109,435,'Bhaktipada','2013-05-02','2013-08-31'  
    (  
      -- Add the parameters for the stored procedure here    
      @sHierarchyList VARCHAR(MAX) ,  
      @iBrandID INT ,  
      @EmployeeID INT ,  
      @sEmployeeName VARCHAR(MAX) = NULL ,  
      @FromDate DATETIME ,  
      @ToDate DATETIME      
    )  
AS   
    BEGIN TRY    
        BEGIN     
   
    
     
     
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
            SET NOCOUNT ON ;    
  
            DECLARE @temp TABLE  
                (  
                  No_St INT ,  
                  s_batch_name VARCHAR(100) ,  
                  dt DATETIME  
                )  
            DECLARE @temp1 TABLE  
                (  
                  No_St INT ,  
                  s_batch_name VARCHAR(100) ,  
                  dt DATETIME  
                )  
            DECLARE @month TABLE ( dt DATETIME )  
            DECLARE @S_Instance_Chain VARCHAR(500)  
   
            SELECT TOP 1  
                    @S_Instance_Chain = FN2.instanceChain  
            FROM    [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,  
                                                             @iBrandID) FN2  
            WHERE   FN2.HierarchyDetailID IN (  
                    SELECT  HierarchyDetailID  
                    FROM    [fnGetCentersForReports](@sHierarchyList,  
                                                     @iBrandID) )  
  
            DECLARE @d DATETIME  
            DECLARE @counter INT  
            SET @d = @FromDate  
            WHILE @d <= @ToDate   
                BEGIN  
    
                    INSERT  INTO @temp  
                            ( No_St ,  
                              s_batch_name ,  
                              dt  
                            )  
                            SELECT  COUNT(DISTINCT SD.S_Student_ID) AS No_Atteded_Student ,  
                                    TSBM.S_Batch_Name ,  
                                    @d  
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
                                    INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,  
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID  
                                    INNER JOIN [dbo].[T_TimeTable_Master] TM ON TM.I_Center_ID = FN1.CenterID  
                                                              AND TM.I_Batch_ID = TSBM.I_Batch_ID  
    INNER JOIN [dbo].[T_TimeTable_Faculty_Map] TFM ON TM.I_TimeTable_ID = TFM.I_TimeTable_ID  
                                    INNER JOIN [dbo].[T_Student_Attendance] SA ON SA.I_TimeTable_ID = TM.I_TimeTable_ID  
                                                              AND SA.I_Student_Detail_ID = TSBD.[I_Student_ID]  
                            WHERE   TM.Dt_Schedule_Date = @d  
                                    AND TFM.I_Employee_ID = @EmployeeID  
                            GROUP BY TSBM.S_Batch_Name  
  
                    INSERT  INTO @temp1  
                            ( No_St ,  
                              s_batch_name ,  
                              dt  
                            )  
                            SELECT  COUNT(DISTINCT SD.S_Student_ID) AS No_Atteded_Student ,  
                                    TSBM.S_Batch_Name ,  
                                    @d  
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
                                    INNER JOIN dbo.T_TimeTable_Master TTTM ON TSBD.I_Batch_ID=TTTM.I_Batch_ID ---Akash
                                    INNER JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TTTM.I_TimeTable_ID = TTTFM.I_TimeTable_ID  ---Akash                         
                                    INNER JOIN [EXAMINATION].[T_Homework_Submission] HS ON HS.I_Student_Detail_ID = SD.I_Student_Detail_ID  
                                    INNER JOIN [EXAMINATION].[T_Homework_Master] HM ON HS.I_Homework_ID = HM.I_Homework_ID AND TTTM.I_Session_ID=HM.I_session_ID  
                            WHERE 
                            TTTM.Dt_Schedule_Date=@d 
                            AND HS.I_Status=1
                            --HM.Dt_Submission_Date = @d 
                            --HM.Dt_Crtd_On=@d--Akash 
                                    --AND HS.I_Employee_ID = @EmployeeID
                                     AND TTTFM.I_Employee_ID=@EmployeeID---Akash
                            GROUP BY TSBM.S_Batch_Name  
  
                    INSERT  INTO @month  
                            ( dt )  
                    VALUES  ( @d )  
                    SET @d = @d + 1   
  
                END  
  
            SELECT  s_batch_name ,  
                    m.dt ,  
                    No_St ,  
                    No_ht ,  
                    @S_Instance_Chain AS S_Instance_Chain  
            FROM    @month m  
                    LEFT OUTER JOIN ( SELECT    s_batch_name ,  
                                                dt ,  
                                                SUM(m1) No_St ,  
                                                SUM(m2) No_ht  
                                      FROM      ( SELECT    s_batch_name ,  
                                                            dt ,  
                                                            No_St m1 ,  
                                                            0 m2  
                                                  FROM      @temp  
                                                  UNION  
                                                  SELECT    s_batch_name ,  
                                                            dt ,  
                                                            0 m1 ,  
                                                            No_St m2  
   FROM      @temp1  
                                                ) a  
                                      GROUP BY  s_batch_name ,  
                                                dt  
                                    ) b ON m.dt = b.dt  
  
  
        END    
    END TRY    
    
    BEGIN CATCH    
     
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT    
    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH
