CREATE PROCEDURE [REPORT].[uspGetCenterVisitStatusReport]
(
-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@iAcademicRepresentativeID varchar(100),
	@sAcademicRepresentativeName varchar(300) = null
)
AS

BEGIN TRY

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT  AV.I_Academics_Visit_ID,
				LTRIM(ISNULL(UM.S_Title,'') + ' ') + UM.S_First_Name + ' ' + LTRIM(ISNULL(UM.S_Middle_Name,'') + ' ' + ISNULL(UM.S_Last_Name,'')) as PersonVisited,
				AV.Dt_Planned_Visit_From_Date,
				AV.Dt_Planned_Visit_To_Date,
				AV.Dt_Actual_Visit_From_Date,
				AV.Dt_Actual_Visit_To_Date,
				CA.S_Description,
				CA.Dt_Target_Date,
				CA.Dt_Actual_Date,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain
			FROM 
				ACADEMICS.T_Academics_Visit AV
				LEFT OUTER JOIN ACADEMICS.T_Concern_Areas CA
				ON AV.I_Academics_Visit_ID = CA.I_Academics_Visit_ID
				AND AV.I_User_ID = ISNULL(@iAcademicRepresentativeID,AV.I_User_ID)
				INNER JOIN dbo.T_User_Master UM
				ON AV.I_User_ID=UM.I_User_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON AV.I_Center_Id = FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
				WHERE AV.Dt_Planned_Visit_From_Date>=@dtStartDate
				AND AV.Dt_Planned_Visit_To_Date<=@dtEndDate

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
