CREATE PROCEDURE [REPORT].[uspGetStudentAbsentReport]
    (
      -- Add the parameters for the stored procedure here 
      -- [REPORT].[uspGetStudentAbsentReport] '88',109,0, '2013-08-12', '2013-08-12'
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @iBatchID INT ,
      @dtFromDate DATETIME ,
      @dtToDate DATETIME
    )
AS 
    BEGIN
    
--        CREATE table #temp
--(
--StudentID varchar(20),
--sName varchar(100),
--sBatch varchar(100),
--iRoll int,
--ContactNo varchar(50),
--sMessage varchar(4000),
--IsOnLeave int
--)

--INSERT into #temp(StudentID,sName,sBatch,iRoll,ContactNo,sMessage)
--SELECT A.S_Student_ID,ISNULL(A.S_First_Name,'')+' '+ISNULL(A.S_Middle_Name,'')+' '+ISNULL(A.S_Last_Name,''),
--C.S_Batch_Name,A.I_RollNo,A.S_Mobile_No,

--'Dear Student: You were absent in the class at '+ E.S_Center_Name + ' from ' + CAST(@dtFromDate AS VARCHAR(12)) + ' to '+  CAST(@dtToDate AS VARCHAR(12))
-- + 'without prior intimation. Please contact SRO Dept at 9674335197 - RICE'               
    
--FROM T_Student_Detail A
--inner join T_Student_Batch_Details B on A.I_Student_Detail_ID=B.I_Student_ID
--inner join T_Student_Batch_Master C on B.I_Batch_ID=C.I_Batch_ID
--inner join T_Center_Batch_Details D on C.I_Batch_ID=D.I_Batch_ID
--inner join T_Centre_Master E on D.I_Centre_Id=E.I_Centre_Id
----left outer join T_Student_Attendance_Details F on A.I_Student_Detail_ID=F.I_Student_Detail_ID
--where
--A.I_Student_Detail_ID not in
--(
--SELECT  DISTINCT I_Student_Detail_ID  
--                FROM    T_Student_Attendance_Details  
--                WHERE   I_TimeTable_ID IN 
--                (  
--                        SELECT  I_TimeTable_ID  
--                        FROM    T_TimeTable_Master TM 
--                        WHERE   DATEDIFF(dd,TM.Dt_Schedule_Date, @dtFromDate) <= 0  
--        AND DATEDIFF(dd,TM.Dt_Schedule_Date, @dtToDate) >= 0  
--                                AND TM.I_Center_ID IN 
--                                (  
--                                SELECT  fgcfr.centerID  
--                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,  
--                                                              @iBrandID) AS fgcfr 
--                                ) 
--                                and 
--								TM.I_Batch_ID=@iBatchID
--								and
--								TM.I_Status=1
--                ) 
                                                                
--)
--and 
--B.I_Batch_ID=@iBatchID
--and
--B.I_Status=1

--order by A.I_RollNo

--update TT
--SET TT.IsOnLeave=1
--FROM #temp TT
--inner join (select * from T_Student_Leave_Request where DATEDIFF(dd,Dt_From_Date,@dtFromDate)<=0 and DATEDIFF(dd,Dt_To_Date,@dtToDate)>=0
--and
--I_Status=1) TTT on TT.StudentID=TTT.S_Crtd_By


--select * from #temp order by iRoll      


        CREATE TABLE #temp1
            (
              InstanceChain VARCHAR(MAX) ,
              CenterName VARCHAR(MAX) ,
              BatchName VARCHAR(MAX) ,
              CourseName VARCHAR(MAX) ,
              StdDetailID INT ,
              StudentID VARCHAR(MAX) ,
              Roll INT ,
              FirstName VARCHAR(MAX) ,
              MiddleName VARCHAR(MAX) ,
              LastName VARCHAR(MAX) ,
              Scheduled INT ,
              Attended INT ,
              ContactNo VARCHAR(MAX) ,
              Percentage DECIMAL ,
              GuardianPhNo VARCHAR(MAX)
            )

        INSERT  INTO #temp1
                ( InstanceChain ,
                  CenterName ,
                  BatchName ,
                  CourseName ,
                  StdDetailID ,
                  StudentID ,
                  Roll ,
                  FirstName ,
                  MiddleName ,
                  LastName ,
                  Scheduled ,
                  Attended ,
                  ContactNo ,
                  Percentage ,
                  GuardianPhNo
                )
                EXEC REPORT.uspGetAttendanceData @sHierarchyList = @sHierarchyList, -- varchar(max)
                    @sBrandID = @iBrandID, -- varchar(max)
                    @sBatchIDs = @iBatchID, -- varchar(max)
                    @dtStartDate = @dtFromDate, -- datetime
                    @dtEndDate = @dtToDate -- datetime
    
        SELECT  '91'+CAST(ContactNo AS VARCHAR(20)) AS ContactNo ,
                'Dear Student: You have been absent in '
                + CAST(( Scheduled - Attended ) AS VARCHAR(12))
                + ' classes out of ' + CAST(Scheduled AS VARCHAR(6))
                + ' classes held on ' + CAST(@dtFromDate AS VARCHAR(12))
                + ' in ' + CenterName + ' branch' AS MessageText
        FROM    #temp1 T
        WHERE   T.Scheduled > T.Attended

    END
