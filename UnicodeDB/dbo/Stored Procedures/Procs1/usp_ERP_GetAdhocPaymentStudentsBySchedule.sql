--exec [usp_ERP_GetAdhocPaymentStudentsBySchedule] 1,2,null,1,1,107,35
CREATE PROCEDURE [dbo].[usp_ERP_GetAdhocPaymentStudentsBySchedule]
    @inAdhocPaymentScheduleHeaderID INT = NULL,  
    @inClassID INT,
    @inStreamID INT = NULL,
    @inSchoolProgramID INT,
    @inSectionID INT,
    @iBrandID INT,
    @iSessionID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF (@inStreamID = 0)
        SET @inStreamID = NULL;

    -- CASE 1: Fetch students when creating a new schedule (All CheckStatus = 0)
    IF @inAdhocPaymentScheduleHeaderID IS NULL
    BEGIN
        SELECT 
            sc.I_Student_Class_Section_ID AS StudentClassSectionID,
            sc.I_Student_Detail_ID AS StudentDetailID,
            sc.S_Student_ID AS StudentID,
            -- Concatenate student name while handling NULL middle names
            RTRIM(LTRIM(ISNULL(sd.S_First_Name, '') + 
                        CASE WHEN sd.S_Middle_Name IS NOT NULL THEN ' ' + sd.S_Middle_Name ELSE '' END + 
                        ' ' + ISNULL(sd.S_Last_Name, ''))) AS StudentName,
            0 AS CheckStatus  -- Default FALSE when no schedule exists
        FROM T_Student_Class_Section sc
        INNER JOIN T_School_Group_Class sgc 
            ON sc.I_School_Group_Class_ID = sgc.I_School_Group_Class_ID
            AND sgc.I_Class_ID = @inClassID
            AND sgc.I_School_Group_ID = @inSchoolProgramID
            AND sgc.I_Status = 1
        INNER JOIN T_Student_Detail sd
            ON sd.I_Student_Detail_ID = sc.I_Student_Detail_ID
        WHERE sc.I_Status = 1
          AND sc.I_Brand_ID = @iBrandID
          AND sc.I_School_Session_ID = @iSessionID
          AND (sc.I_Stream_ID = @inStreamID OR @inStreamID IS NULL)
          AND (sc.I_Section_ID = @inSectionID OR @inSectionID IS NULL);
    END
    ELSE
    BEGIN
        -- CASE 2: Fetch students when editing an existing schedule (Check if students exist in payment schedule)
        SELECT 
            sc.I_Student_Class_Section_ID AS StudentClassSectionID,
            sc.I_Student_Detail_ID AS StudentDetailID,
            sc.S_Student_ID AS StudentID,
            -- Concatenate student name while handling NULL middle names
            RTRIM(LTRIM(ISNULL(sd.S_First_Name, '') + 
                        CASE WHEN sd.S_Middle_Name IS NOT NULL THEN ' ' + sd.S_Middle_Name ELSE '' END + 
                        ' ' + ISNULL(sd.S_Last_Name, ''))) AS StudentName,
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM T_ERP_AdhocPaymentScheduleStudentDetail apsd
                    JOIN T_ERP_AdhocPaymentScheduleHeaderDetail aphd
                        ON apsd.inAdhocPaymentScheduleHeaderDetailID = aphd.inAdhocPaymentScheduleHeaderDetailID
                    WHERE apsd.inStudentDetailID = sc.I_Student_Detail_ID
                      AND aphd.inClassID = @inClassID
                      AND (aphd.inStreamID = @inStreamID OR aphd.inStreamID IS NULL)
                      AND aphd.inSectionID = @inSectionID
                      AND aphd.inAdhocPaymentScheduleHeaderID = @inAdhocPaymentScheduleHeaderID
                ) THEN 1 
                ELSE 0 
            END AS CheckStatus
        FROM T_Student_Class_Section sc
        INNER JOIN T_School_Group_Class sgc 
            ON sc.I_School_Group_Class_ID = sgc.I_School_Group_Class_ID
            AND sgc.I_Class_ID = @inClassID
            AND sgc.I_School_Group_ID = @inSchoolProgramID
            AND sgc.I_Status = 1
        INNER JOIN T_Student_Detail sd
            ON sd.I_Student_Detail_ID = sc.I_Student_Detail_ID
        WHERE sc.I_Status = 1
          AND sc.I_Brand_ID = @iBrandID
          AND sc.I_School_Session_ID = @iSessionID
          AND (sc.I_Stream_ID = @inStreamID OR @inStreamID IS NULL)
          AND (sc.I_Section_ID = @inSectionID OR @inSectionID IS NULL);
    END
END;

