-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_GetAllUnavailabilityHistoryByFacultyMasterID 10
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetAllUnavailabilityHistoryByFacultyMasterID]
(
	@FacultyMasterID INT = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
    TETUH.I_Teacher_Unavailability_Header_ID AS TeacheUnavailabilityHeaderID,
    TETUH.I_Faculty_Master_ID AS FacultyMasterID,
	TFM.S_Faculty_Name AS FacultyName,
    TETUH.Dt_From AS DtFrom,
    TETUH.Dt_To AS DtTo,
    TETUH.Dt_CreatedAt AS DtCreatedAt,
    TETUH.S_Reason AS Reason,
    TETUH.I_CreatedBy AS CreatedBy,
    TETUH.I_Status AS Status,
    TETUH.S_CancelReason AS CancelReason,
    TETUH.Dt_CanceledDate AS DtCanceledDate,
    TETUH.Dt_Approved AS DtApproved,
    TETUH.S_ApprovedRemarks AS ApprovedRemarks,
    TETUH.I_AprrovedBy AS ApprovedBy,
    TETUH.Dt_Rejected AS DtRejected,
    TETUH.S_RejectedRemarks AS RejectedRemarks,
    TETUH.I_RejectedBy AS RejectedBy,
    TETUH.I_RaisedDeleteRequest AS RaisedDeleteRequest,
    TETUH.Dt_RaisedDeleteRequest AS DtRaisedDeleteRequestDate,
    TETUH.S_RaisedDeleteRequestReason AS RaisedDeleteRequestReason
	
	
	FROM T_ERP_Teacher_Unavailability_Header AS TETUH
	INNER JOIN T_Faculty_Master AS TFM ON TETUH.I_Faculty_Master_ID = TFM.I_Faculty_Master_ID
	WHERE (TETUH.I_Faculty_Master_ID = @FacultyMasterID OR @FacultyMasterID IS NULL)
	ORDER BY TETUH.I_Teacher_Unavailability_Header_ID DESC;
END
