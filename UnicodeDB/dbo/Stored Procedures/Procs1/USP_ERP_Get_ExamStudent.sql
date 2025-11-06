--exec USP_ERP_Get_ExamStudent null,31  
CREATE Proc [dbo].[USP_ERP_Get_ExamStudent]   
( @isectionid int = null, @ischeduleid int)  
AS  
BEGIN  
    SELECT DISTINCT   
        COUNT(am.inExamScheduleSubjectDetailId) AS cnt,  
        am.inStudentId AS inStudentId,   
        am.sReportCardUrl,  
  am.inReportCardStatus,  
        SD.S_Student_ID AS sStudentID,  
        Sd.S_First_Name +   
            CASE   
                WHEN sd.S_Middle_Name IS NOT NULL AND sd.S_Middle_Name != ''   
                THEN ' ' + sd.S_Middle_Name   
                ELSE ''   
            END +   
            ' ' + sd.S_Last_Name AS sStudentName,  
        am.inExamScheduleDetailId,  
        TC.I_Class_ID AS inClassId,  
        TC.S_Class_Name AS stClassName,  
        TS.I_Section_ID AS inSectionId,  
        TS.S_Section_Name AS stSectionName,  
        TSS.I_Stream_ID AS inStreamId,  
        TSS.S_Stream AS stStreamName,  
          
        -- PresentStatus Logic  
        CASE   
            WHEN MIN(amSub.inPresent) = 1 AND MAX(amSub.inPresent) = 1   
            THEN 2  
            WHEN MIN(amSub.inPresent) = 0 AND MAX(amSub.inPresent) = 0   
            THEN 0  
            ELSE 1  
        END AS inPresentStatus  
  
    FROM T_ERP_Exam_ScheduleSubjectAttendanceMarks am  
    INNER JOIN T_ERP_Exam_ScheduleSubjectDetails ssd   
        ON ssd.inExamScheduleDetailId = am.inExamScheduleDetailId   
        AND ssd.inExamScheduleSubjectDetailId = am.inExamScheduleSubjectDetailId  
    INNER JOIN T_Student_Detail SD   
        ON SD.I_Student_Detail_ID = am.inStudentId  
    LEFT JOIN T_Class TC   
        ON TC.I_Class_ID = ssd.inClassId  
    LEFT JOIN T_Section TS   
        ON TS.I_Section_ID = ssd.inSectionId  
    LEFT JOIN T_Stream TSS   
        ON TSS.I_Stream_ID = ssd.inStreamId  
  
    -- Join for PresentStatus subquery  
    INNER JOIN (  
        SELECT inStudentId, inExamScheduleDetailId,inPresent, MIN(inPresent) AS minPresent, MAX(inPresent) AS maxPresent  
        FROM T_ERP_Exam_ScheduleSubjectAttendanceMarks  
        WHERE inExamScheduleDetailId = @ischeduleid  
        GROUP BY inStudentId, inExamScheduleDetailId,inPresent  
    ) amSub  
    ON amSub.inStudentId = am.inStudentId AND amSub.inExamScheduleDetailId = am.inExamScheduleDetailId  
  
    WHERE am.inExamScheduleDetailId = @ischeduleid   
    AND ssd.inSectionId = ISNULL(@isectionid, ssd.inSectionId)  
      
    GROUP BY   
        am.inStudentId,   
        SD.S_Student_ID,  
        am.inExamScheduleDetailId,  
        am.sReportCardUrl,  
        TC.I_Class_ID,  
        TC.S_Class_Name,  
        TS.I_Section_ID,  
        TS.S_Section_Name,  
        TSS.I_Stream_ID,  
        TSS.S_Stream,  
  am.inReportCardStatus,  
        Sd.S_First_Name +   
            CASE   
                WHEN sd.S_Middle_Name IS NOT NULL AND sd.S_Middle_Name != ''   
                THEN ' ' + sd.S_Middle_Name   
                ELSE ''   
            END +   
            ' ' + sd.S_Last_Name  
END  