
CREATE PROCEDURE [REPORT].[uspGetAttendanceDataNEWBKPFEB23_BeforeLeaveStuEliminate]  
        (
          @sHierarchyList VARCHAR(MAX) ,
          @sBrandID VARCHAR(MAX) ,
          @sBatchIDs VARCHAR(MAX) = NULL ,
          @dtStartDate DATETIME ,
          @dtEndDate DATETIME      
        )
    AS 
        BEGIN    

			DECLARE @iBrandID INT  
  
            SET @iBrandID = CAST(@sBrandID AS INT)
  
            DECLARE @BatchIDs TABLE ( I_Batch_ID INT )  
            INSERT  INTO @BatchIDs
                    ( I_Batch_ID  
                    )
                    SELECT  Val
                    FROM    dbo.fnString2Rows(@sBatchIDs, ',')  
         
            DECLARE @CenterIDs TABLE ( I_Center_ID INT ) --chck this @rtnTable1 has same data  
            INSERT  INTO @CenterIDs
                    ( I_Center_ID  
                    )
                    SELECT  CenterList.centerID
                    FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                       @iBrandID) CenterList  
                                                 
            DECLARE @rtnTable1 TABLE
                (
                  brandID INT ,
                  hierarchyDetailID INT ,
                  centerID INT ,
                  centerCode VARCHAR(20) ,
                  centerName VARCHAR(100)
                )  
            INSERT  INTO @rtnTable1
                    ( hierarchyDetailID ,
                      centerID ,
                      centerCode ,
                      centerName  
                    )
                    SELECT  hierarchyDetailID ,
                            centerID ,
                            centerCode ,
                            centerName
                    FROM    [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                           @iBrandID)  
                                                 
            DECLARE @rtnTable2 TABLE
                (
                  hierarchyDetailID INT ,
                  instanceChain VARCHAR(5000)
                )  
            INSERT  INTO @rtnTable2
                    ( hierarchyDetailID ,
                      instanceChain  
                    )
                    SELECT  hierarchyDetailID ,
                            instanceChain
                    FROM    [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) 

select T1.*,T2.S_Batch_Name as AttendedBatch,T2.ATTENDED,( ISNULL(ROUND(( CONVERT(DECIMAL, T2.Attended)
                                                            / CONVERT(DECIMAL, T1.Scheduled) )
                                                          * 100, 2), 0) ) as PercentageAttended,
DATEDIFF(d,T1.Dt_BatchStartDate,GETDATE()) as Age
from
(
select FN2.instanceChain,TCHND.I_Center_ID,TCHND.S_Center_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,TSD.I_Student_Detail_ID,TSD.S_Student_ID, 
TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name as Student_Name,
ISNULL(TSBD.I_RollNo,TSD.I_RollNo) AS I_RollNo,
ISNULL(ISNULL(TSD.S_Guardian_Phone_No,TSD.S_Guardian_Mobile_No), '') AS S_Guardian_Phone_No,
TSD.S_Mobile_No,ISNULL(COUNT(DISTINCT TTM.I_TimeTable_ID),NULL) as SCHEDULED
from T_TimeTable_Master TTM
inner join T_Student_Batch_Master TSBM on TTM.I_Batch_ID=TSBM.I_Batch_ID
inner join T_Student_Batch_Details TSBD on TTM.I_Batch_ID=TSBD.I_Batch_ID and TSBD.I_Status in (1) -- Modify student status by Susmita : 2023-feb-06: Only active student will be show on this Attendence Report:  TSBD.I_Status in (1,0,2)
											and CONVERT(DATE,TSBD.Dt_Valid_From)<=CONVERT(DATE,TTM.Dt_Schedule_Date)
											and CONVERT(DATE,ISNULL(TSBD.Dt_Valid_To,GETDATE()))>=CONVERT(DATE,TTM.Dt_Schedule_Date)
inner join T_Student_Detail TSD on TSBD.I_Student_ID=TSD.I_Student_Detail_ID
inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TTM.I_Center_ID
INNER JOIN @rtnTable1 FN1 ON TCHND.I_Center_Id = FN1.CenterID
INNER JOIN @rtnTable2 FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
inner join T_Course_Master TCM on TCM.I_Course_ID=TSBM.I_Course_ID
where ( @sBatchIDs IS NULL
OR TSBM.I_Batch_ID IN ( SELECT   I_Batch_ID
                    FROM     @BatchIDs )
) and TTM.I_Status=1 --and TSD.I_Student_Detail_ID=95552
and (TTM.Dt_Schedule_Date>=@dtStartDate and TTM.Dt_Schedule_Date<DATEADD(d,1,@dtEndDate))
and TCHND.I_Brand_ID=@iBrandID and TTM.I_Session_ID is not null
group by TCHND.I_Center_ID,TCHND.S_Center_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,TSBM.Dt_BatchStartDate,TSD.I_Student_Detail_ID,TSD.S_Student_ID, 
TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name,
ISNULL(TSBD.I_RollNo,TSD.I_RollNo),ISNULL(ISNULL(TSD.S_Guardian_Phone_No,TSD.S_Guardian_Mobile_No), ''),
FN2.instanceChain,
TSD.S_Mobile_No
) T1
left join
(
select TSA.I_Student_Detail_ID,A.I_Batch_ID,B.S_Batch_Name,COUNT(DISTINCT A.I_TimeTable_ID) as ATTENDED 
from T_Student_Attendance TSA
inner join T_TimeTable_Master A on TSA.I_TimeTable_ID=A.I_TimeTable_ID and A.I_Batch_ID is not null
inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
where
(A.Dt_Schedule_Date>=@dtStartDate and A.Dt_Schedule_Date<DATEADD(d,1,@dtEndDate))
and A.I_Session_ID is not null
group by TSA.I_Student_Detail_ID,A.I_Batch_ID,B.S_Batch_Name--,CONVERT(DATE,A.Dt_Schedule_Date)
) T2 on T1.I_Student_Detail_ID=T2.I_Student_Detail_ID --and T1.AttendanceDate=T2.AttendedDate

END
