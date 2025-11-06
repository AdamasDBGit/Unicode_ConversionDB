--exec usp_ERP_GetAdhocPaymentScheduleDetailsByID 1
CREATE PROCEDURE [dbo].[usp_ERP_GetAdhocPaymentScheduleDetailsByID]
(
    @AdhocPaymentScheduleHeaderID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- ✅ Fetch Ad-Hoc Payment Schedule Header Details
    SELECT 
        inAdhocPaymentScheduleHeaderID AdhocPaymentScheduleHeaderID,
        inAdHocFeeComponentID adHocFeeComponentID,
        nAmount Amount,
        inSchoolProgramID SchoolProgramID,
        dtStartDate StartDate,
        dtEndDate EndDate,
        sDescription Description
    FROM 
        T_ERP_AdhocPaymentScheduleHeader
    WHERE 
        inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID;

    -- ✅ Fetch Distinct Classes Associated with the Payment Schedule
    SELECT DISTINCT 
        inClassID  ClassID
    FROM 
        T_ERP_AdhocPaymentScheduleHeaderDetail  
    WHERE 
        inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID;

    -- ✅ Fetch Section, Stream, and Class in Concatenated Format
    SELECT 
        CONCAT(inSectionID, '-', COALESCE(inStreamID, 0), '-', inClassID) AS SectionStreamClass
    FROM 
        T_ERP_AdhocPaymentScheduleHeaderDetail
    WHERE 
        inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID;
END;

