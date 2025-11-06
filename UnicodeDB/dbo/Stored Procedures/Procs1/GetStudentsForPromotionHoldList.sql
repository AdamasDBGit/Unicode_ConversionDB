CREATE PROCEDURE [dbo].[GetStudentsForPromotionHoldList]
(
    @iAcademicSessionID INT,
    @iBrandID INT,
    @iSchoolGroupID INT,
    @iClassID INT,
    @iSectionID INT,
    @iStreamID INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    /*
        ===================================================================
        Author:      Susmita Paul
        Created On:  2025-Oct-16
        Description: 
            Fetch students from T_ERP_Student_Promotion_History_Header 
            who are on hold (WillOnHold = 1),
            have not yet been academically approved (IsAcademicApproved IS NULL),
            but have promotion status = 1.

            ➕ Includes both Source and Destination details.
            ➕ Includes RollNo and LastRemarks.
            ➕ Derived promotion status:
                - If WillDemoted = 1 → 'Demoted'
                - If WillRetain = 1 → 'Retain'
                - Else → 'Promoted'
        ===================================================================
    */

    SELECT 
        PH.I_Student_Promotion_History_Header_ID,
        SD.S_Student_ID AS StudentID,
		SD.I_Student_Detail_ID as StudentDetailID,
        SD.S_First_Name 
            + ISNULL(' ' + SD.S_Middle_Name, '') 
            + ISNULL(' ' + SD.S_Last_Name, '') AS StudentName,

        -- Source Details
        PH.I_Source_Academic_Session AS SourceAcademicSessionID,
        SAS.S_Label AS SourceAcademicSession,
        SG.S_School_Group_Name AS SourceSchoolGroup,
        C.S_Class_Name AS SourceClass,
		C.I_Class_ID as SourceClassID,
		SEC.I_Section_ID as SourceSectionID,
        SEC.S_Section_Name AS SourceSection,
		ISNULL(STR.I_Stream_ID,0)  as SourceStreamID,
        STR.S_Stream AS SourceStream,
        PH.RollNo AS SourceRollNo,

        -- Destination Details
        PH.I_Destination_Academic_Session AS DestinationAcademicSessionID,
        DAS.S_Label AS DestinationAcademicSession,
        DSG.S_School_Group_Name AS DestinationSchoolGroup,
        DC.S_Class_Name AS DestinationClass,
        DSEC.S_Section_Name AS DestinationSection,
        DSTR.S_Stream AS DestinationStream,
        PH.RollNo AS DestinationRollNo,  -- same roll assumed

        PH.IsDemoted,
        PH.IsPromoted,
        PH.Is_Due_Cleared,
        PH.RemainingDueOfSourceSession,
        PH.IsOverDueSkiped,
        PH.S_Last_Remarks AS LastRemarks,
        PH.IsAcademicApproved,
        PH.IsFinancialApproved,
        PH.CreatedBy,
        PH.Dt_Created_At,
        PH.S_Last_Action_By,
        PH.Dt_Last_Action_At,
        CASE 
            WHEN PH.WillDemoted = 1 THEN 'Demoted'
            WHEN PH.WillRetain = 1 THEN 'Retain'
            ELSE 'Promoted'
        END AS PromotionStatus,
		attendence.AggregateAttendancePercentage
    FROM 
        T_ERP_Student_Promotion_History_Header PH
        INNER JOIN T_Student_Detail SD 
            ON SD.I_Student_Detail_ID = PH.I_Student_DetailID
        LEFT JOIN T_School_Group SG 
            ON PH.I_Source_School_Group_ID = SG.I_School_Group_ID
        LEFT JOIN T_School_Group DSG 
            ON PH.I_Destination_School_Group_ID = DSG.I_School_Group_ID
        LEFT JOIN T_Class C 
            ON PH.I_Source_Class_ID = C.I_Class_ID
        LEFT JOIN T_Class DC 
            ON PH.I_Destination_Class_ID = DC.I_Class_ID
        LEFT JOIN T_Section SEC 
            ON PH.I_Source_SectionID = SEC.I_Section_ID
        LEFT JOIN T_Section DSEC 
            ON PH.I_Destination_SectionID = DSEC.I_Section_ID
        LEFT JOIN T_Stream STR 
            ON PH.I_Source_Stream_ID = STR.I_Stream_ID
        LEFT JOIN T_Stream DSTR 
            ON PH.I_Destination_Stream_ID = DSTR.I_Stream_ID
       LEFT JOIN T_School_Academic_Session_Master SAS 
            ON PH.I_Source_Academic_Session = SAS.I_School_Session_ID
        LEFT JOIN T_School_Academic_Session_Master DAS 
            ON PH.I_Destination_Academic_Session = DAS.I_School_Session_ID
		left join 
		(
		select  CAST(AVG(ESRH.inAttendance) AS DECIMAL(5,2)) AS AggregateAttendancePercentage
		,ESRH.inStudentId,ESRH.sStudentID
		
		from 
		T_ERP_Exam_StudentResultHeader as ESRH		
		inner join
		T_ERP_Exam_SchedulesDetails as ESD on ESRH.inExamScheduleDetailId=ESD.inExamScheduleDetailId
		where ESD.inAcademicSessionId=@iAcademicSessionID 
		and ESD.inSchoolProgramId = @iSchoolGroupID
		group by ESRH.inStudentId,ESRH.sStudentID
		) attendence on attendence.inStudentId=SD.I_Student_Detail_ID
    WHERE 
        PH.I_Brand_ID = @iBrandID
        AND PH.I_Source_Academic_Session = @iAcademicSessionID
        AND PH.I_Promotion_Status = 1
        AND PH.WillOnHold = 1
        AND (PH.IsAcademicApproved IS NULL OR PH.IsAcademicApproved=0)
        AND (@iSchoolGroupID IS NULL OR PH.I_Source_School_Group_ID = @iSchoolGroupID)
        AND (@iClassID IS NULL OR PH.I_Source_Class_ID = @iClassID)
        AND (@iSectionID IS NULL OR PH.I_Source_SectionID = @iSectionID)
        AND (@iStreamID IS NULL OR PH.I_Source_Stream_ID = @iStreamID)
    ORDER BY 
        SD.S_Student_ID;
END
