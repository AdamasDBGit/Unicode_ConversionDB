CREATE PROCEDURE [REPORT].[uspGetStudentBatchScheduling]     
(    
 -- Add the parameters for the stored procedure here    
 @iBrandID Int,    
 @sHierarchyList varchar (MAX),    
 @EndDate DateTime,    
 @iCourseID Varchar(800)=NULL,
 @StartDate DATETIME    
)    
AS    
BEGIN TRY    
    
IF @iCourseID IS NULL    
 BEGIN    
  SELECT [TBCD].[I_Brand_ID],    
    TBM.S_Brand_Code,    
    [TCM].centerName as S_Center_Name,    
    [TSBM].[S_Batch_Code],    
    [TSBM].S_Batch_Name,    
    CM.S_Course_Name,    
    CFM.S_CourseFamily_Name,    
    [TSBM].[Dt_BatchStartDate],    
    [TSBM].[Dt_Course_Expected_End_Date],    
    [TSBM].[Dt_Course_Actual_End_Date],    
    [TSBM].[b_IsHOBatch],    
    ISNULL([TCBD].[I_Status],    
    [TSBM].[I_Status]) AS [Status],    
    (
    select SUM(A.I_Total_Session_Count) TotSeasonCount from T_Term_Master A
inner join T_Term_Course_Map B on A.I_Term_ID=B.I_Term_ID
inner join T_Course_Master C on B.I_Course_ID=C.I_Course_ID
where
C.I_Course_ID=@iCourseID
and
C.I_Brand_ID=@iBrandID
    ) AS PlannedSessionCount,    
    (
    SELECT COUNT(*)     
    FROM dbo.T_TimeTable_Master TM
    Where      
    TM.Dt_Schedule_Date between @StartDate and @EndDate    
    AND TM.I_Batch_ID=TCBD.I_Batch_ID    
    AND (TM.I_Center_ID = TCBD.I_Centre_Id OR TM.I_Center_ID is NULL)
    ) AS  PlannedSessionCountBeforeEndDate,    
    (  
    Select MIN(Dt_Actual_Date)   
    from dbo.T_TimeTable_Master TM   
    Where TM.I_Batch_ID=[TSBM].[I_Batch_ID]  
    and TM.I_Center_ID=TCBD.I_Centre_Id  
    ) as FirstAttendanceDate,    
      
    (  
    Select COUNT(I_Student_ID)   
    from dbo.T_Student_Batch_Details SBD  
    INNER JOIN dbo.T_Student_Detail SD ON SBD.I_Student_ID=SD.I_Student_Detail_ID  
    INNER JOIN T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID  
    WHERE SBD.I_Batch_ID=TCBD.I_Batch_ID AND SBD.I_Status = 1 AND ERD.I_Centre_Id=TCBD.I_Centre_Id  
    )   
    StudentEnrolled,  
        
    (  
    SELECT COUNT(SRD.I_Enquiry_Regn_ID)   
    FROM T_Student_Registration_Details SRD  
    INNER JOIN T_Enquiry_Regn_Detail ERD ON SRD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID   
    WHERE SRD.I_Batch_ID=TCBD.I_Batch_ID   
    AND I_Status = 1   
    AND ERD.I_Centre_Id=TCBD.I_Centre_Id  
    )   
    StudentRegistered,   
  
    ISNULL(ED.S_First_Name,'')+' '+ISNULL(ED.S_Middle_Name,'')+' '+ISNULL(ED.S_Last_Name,'') as Faculty,    
      
    (    
    SELECT COUNT(*)     
    FROM dbo.T_TimeTable_Master TM
    Where TM.Dt_Actual_Date IS NOT NULL     
    AND TM.Dt_Schedule_Date<=GETDATE()    
    AND TM.I_Batch_ID=TCBD.I_Batch_ID    
    AND (TM.I_Center_ID = TCBD.I_Centre_Id OR TM.I_Center_ID is NULL)    
    ) as ActualSessionCount,    
       (    
select SUM(A.I_Total_Session_Count) TotSeasonCount from T_Term_Master A
inner join T_Term_Course_Map B on A.I_Term_ID=B.I_Term_ID
inner join T_Course_Master C on B.I_Course_ID=C.I_Course_ID
where
C.I_Course_ID=@iCourseID
and
C.I_Brand_ID=@iBrandID    
       ) as TotalSessionCount    
        
  FROM [dbo].[T_Center_Batch_Details] AS TCBD    
    INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) AS TCM    
    ON [TCBD].[I_Centre_Id] = [TCM].centerID    
    INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM    
    ON [TCBD].[I_Batch_ID] = [TSBM].[I_Batch_ID]    
    INNER JOIN [dbo].[T_Brand_Center_Details] AS TBCD    
    ON [TCBD].[I_Centre_Id] = [TBCD].[I_Centre_Id]    
    INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID=TBM.I_Brand_ID    
    INNER JOIN dbo.T_Course_Master CM on TSBM.I_Course_ID=CM.I_Course_ID    
    INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID=CFM.I_CourseFamily_ID    
    LEFT OUTER JOIN dbo.T_Employee_Dtls ED ON TCBD.I_Employee_ID = ED.I_Employee_ID    
  ORDER BY [TBCD].[I_Brand_ID],[TBCD].[I_Centre_Id]    
 END    
ELSE    
 BEGIN    
  SELECT [TBCD].[I_Brand_ID],    
    TBM.S_Brand_Code,    
    [TCM].centerName as S_Center_Name,    
    [TSBM].[S_Batch_Code],    
    [TSBM].S_Batch_Name,    
    CM.S_Course_Name,    
    CFM.S_CourseFamily_Name,    
    [TSBM].[Dt_BatchStartDate],    
    [TSBM].[Dt_Course_Expected_End_Date],    
    [TSBM].[Dt_Course_Actual_End_Date],    
    [TSBM].[b_IsHOBatch],    
    ISNULL([TCBD].[I_Status],    
    [TSBM].[I_Status]) AS [Status],    
    (
    select SUM(A.I_Total_Session_Count) TotSeasonCount from T_Term_Master A
inner join T_Term_Course_Map B on A.I_Term_ID=B.I_Term_ID
inner join T_Course_Master C on B.I_Course_ID=C.I_Course_ID
where
C.I_Course_ID=@iCourseID
and
C.I_Brand_ID=@iBrandID
    ) AS PlannedSessionCount,    
    (
    SELECT COUNT(*)     
    FROM dbo.T_TimeTable_Master TM
    Where TM.Dt_Schedule_Date between @StartDate and @EndDate     
    AND TM.I_Batch_ID=TCBD.I_Batch_ID    
    AND (TM.I_Center_ID = TCBD.I_Centre_Id OR TM.I_Center_ID is NULL)
    ) AS  PlannedSessionCountBeforeEndDate,   
    (  
    Select MIN(Dt_Actual_Date)   
    from dbo.T_TimeTable_Master TM   
    Where TM.I_Batch_ID=[TSBM].[I_Batch_ID]  
    and TM.I_Center_ID=TCBD.I_Centre_Id  
    ) as FirstAttendanceDate,    
      
    (  
    Select COUNT(I_Student_ID)   
    from dbo.T_Student_Batch_Details SBD  
    INNER JOIN dbo.T_Student_Detail SD ON SBD.I_Student_ID=SD.I_Student_Detail_ID  
    INNER JOIN T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID  
    WHERE SBD.I_Batch_ID=TCBD.I_Batch_ID AND SBD.I_Status = 1 AND ERD.I_Centre_Id=TCBD.I_Centre_Id  
    )   
    StudentEnrolled,  
        
    (  
    SELECT COUNT(SRD.I_Enquiry_Regn_ID)   
    FROM T_Student_Registration_Details SRD  
    INNER JOIN T_Enquiry_Regn_Detail ERD ON SRD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID   
    WHERE SRD.I_Batch_ID=TCBD.I_Batch_ID   
    AND I_Status = 1   
    AND ERD.I_Centre_Id=TCBD.I_Centre_Id  
    )   
    StudentRegistered,   
       
    ISNULL(ED.S_First_Name,'')+' '+ISNULL(ED.S_Middle_Name,'')+' '+ISNULL(ED.S_Last_Name,'') as Faculty,  
    (    
    SELECT COUNT(*)     
    FROM dbo.T_TimeTable_Master TM
    Where TM.Dt_Actual_Date IS NOT NULL     
    AND TM.Dt_Schedule_Date<=GETDATE()    
    AND TM.I_Batch_ID=TCBD.I_Batch_ID    
    AND (TM.I_Center_ID = TCBD.I_Centre_Id OR TM.I_Center_ID is NULL)    
    ) as ActualSessionCount,    
       (    
    select SUM(A.I_Total_Session_Count) TotSeasonCount from T_Term_Master A
inner join T_Term_Course_Map B on A.I_Term_ID=B.I_Term_ID
inner join T_Course_Master C on B.I_Course_ID=C.I_Course_ID
where
C.I_Course_ID=@iCourseID
and
C.I_Brand_ID=@iBrandID  
       ) as TotalSessionCount    
    
  FROM [dbo].[T_Center_Batch_Details] AS TCBD    
    INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) AS TCM    
    ON [TCBD].[I_Centre_Id] = [TCM].centerID    
    INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM    
    ON [TCBD].[I_Batch_ID] = [TSBM].[I_Batch_ID]    
    INNER JOIN [dbo].[T_Brand_Center_Details] AS TBCD    
    ON [TCBD].[I_Centre_Id] = [TBCD].[I_Centre_Id]    
    INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID=TBM.I_Brand_ID    
    INNER JOIN dbo.T_Course_Master CM on TSBM.I_Course_ID=CM.I_Course_ID    
    INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID=CFM.I_CourseFamily_ID    
    LEFT OUTER JOIN dbo.T_Employee_Dtls ED ON TCBD.I_Employee_ID = ED.I_Employee_ID   
  WHERE TSBM.I_Course_ID in (Select Val from fnString2Rows(@iCourseID,','))
  and
  TSBM.Dt_BatchStartDate between @StartDate and @EndDate    
  ORDER BY [TBCD].[I_Brand_ID],[TBCD].[I_Centre_Id],TSBM.Dt_BatchStartDate   
 END    
    
END TRY    
    
BEGIN CATCH    
     
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
