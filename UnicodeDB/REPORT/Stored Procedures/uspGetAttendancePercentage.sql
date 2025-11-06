CREATE PROCEDURE [REPORT].[uspGetAttendancePercentage]  --195,107,56,'1-1-2012','1-3-2013'
    (
      @sHierarchyID VARCHAR(MAX) ,
      @sBrandID VARCHAR(MAX) ,
      @sBatchIDs VARCHAR(MAX) = NULL ,
      @date1 DATETIME ,
      @date2 DATETIME  
    )
AS 
    BEGIN 
    
    --PRINT LEN(@sBatchIDs); 

        DECLARE @S_Instance_Chain VARCHAR(500)
	
        SELECT TOP 1
                @S_Instance_Chain = FN2.instanceChain
        FROM    [dbo].[fnGetInstanceNameChainForReports](@sHierarchyID,
                                                         @sBrandID) FN2
        WHERE   FN2.HierarchyDetailID IN (
                SELECT  HierarchyDetailID
                FROM    [fnGetCentersForReports](@sHierarchyID, @sBrandID) ) 

        SELECT  chn.S_Center_Name ,
                sb.S_Batch_Name ,
                table1.Attendance ,
                table2.Total_Attendance ,
                cm.S_Course_Name ,
                table1.Dt_Attendance_Date,
                1 AS DateCount,
                @S_Instance_Chain AS S_Instance_Chain
        FROM    T_Center_Hierarchy_Name_Details chn
                INNER JOIN T_Center_Batch_Details cb ON chn.I_Center_ID = cb.I_Centre_ID
                INNER JOIN T_Student_Batch_Master sb ON sb.I_Batch_ID = cb.I_Batch_ID
                LEFT JOIN ( SELECT  COUNT(DISTINCT I_Student_Detail_ID) AS Attendance ,
                                    I_Batch_ID ,
                                    I_Course_ID ,
                                    Dt_Attendance_Date
                            FROM    T_Student_Attendance_Details
                            WHERE Dt_Attendance_Date BETWEEN @date1 AND @date2
                            GROUP BY I_Batch_ID ,
                                    I_Course_ID ,
                                    Dt_Attendance_Date
                          ) table1 ON table1.I_Batch_ID = sb.I_Batch_ID
                INNER JOIN ( SELECT COUNT(DISTINCT I_Student_ID) AS Total_Attendance ,
                                    I_Batch_ID
                             FROM   T_Student_Batch_Details
                             WHERE I_Status=1 ---AKASH 15/10/2014
                             GROUP BY I_Batch_ID
                           ) table2 ON table2.I_Batch_ID = sb.I_Batch_ID
                LEFT JOIN T_Course_Master cm ON cm.I_Course_ID = sb.I_Course_ID
        WHERE   --sb.I_Batch_ID LIKE COALESCE(@ibatchID,sb.I_Batch_ID) and chn.I_Center_ID LIKE COALESCE(@icenterID,I_Centre_ID)  
                ( 
                --@sBatchIDs IS NULL
                --  OR 
                  sb.I_Batch_ID IN (
                  SELECT    Val
                  FROM      dbo.fnString2Rows(@sBatchIDs, ',') )
                )
                AND I_Center_ID IN (
                SELECT  CenterList.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyID,
                                                   CAST(@sBrandID AS INT)) CenterList )
                AND DATEDIFF(dd, table1.Dt_Attendance_Date, @date1) <= 0
                AND DATEDIFF(dd, table1.Dt_Attendance_Date, @date2) >= 0  
  
    END
