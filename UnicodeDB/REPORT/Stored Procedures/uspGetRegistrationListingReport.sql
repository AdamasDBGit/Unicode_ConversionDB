CREATE PROCEDURE [REPORT].[uspGetRegistrationListingReport]
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@dtStartDate datetime,
	@dtEndDate datetime,
	@sCounselorCond varchar(20)
)
AS
SET NOCOUNT ON
BEGIN TRY

	IF (@dtEndDate IS NOT NULL)
	BEGIN
		SET @dtEndDate = DATEADD(dd,1,@dtEndDate)
	END
	
	IF @sCounselorCond='ALL'
	BEGIN
	 SELECT DISTINCT 
			ERD.I_Enquiry_Regn_ID,
			ERD.S_Enquiry_No,
			ERD.S_Title,
			ERD.S_First_Name,
			ERD.S_Middle_Name,
			ERD.S_Last_Name,
			ISNULL(RH.N_Receipt_Amount,0.00) AS N_Receipt_Amount,
			CAST (RH.Dt_Receipt_Date AS DATE) AS Dt_Receipt_Date,
			UM.S_Title AS Coun_Title,
			UM.S_First_Name AS Coun_FirstName,
			UM.S_Middle_Name AS Coun_MiddleName,
			UM.S_Last_Name AS Coun_LastName,
			CM.S_Course_Code,
			CM.S_Course_Name,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			CUM.S_Currency_Code
	   FROM	dbo.T_Enquiry_Regn_Detail ERD WITH(NOLOCK)
			INNER JOIN dbo.T_Receipt_Header RH WITH(NOLOCK)
			ON ERD.I_Enquiry_Regn_ID=RH.I_Enquiry_Regn_ID
			INNER JOIN dbo.T_User_Master UM WITH(NOLOCK)
			ON ERD.S_Crtd_By=UM.S_Login_ID
			INNER JOIN [dbo].[T_Student_Registration_Details] AS TSRD
			ON [TSRD].[I_Receipt_Header_ID] = [RH].[I_Receipt_Header_ID]
			AND [TSRD].[I_Enquiry_Regn_ID] = [RH].[I_Enquiry_Regn_ID]
			INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM
			ON [TSRD].[I_Batch_ID] = [TSBM].[I_Batch_ID]
			INNER JOIN dbo.T_Course_Master CM WITH(NOLOCK)
			ON [TSBM].[I_Course_ID] = [CM].[I_Course_ID]
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON ERD.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
			ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			INNER JOIN dbo.T_Centre_Master CEM WITH(NOLOCK)
			ON FN1.CenterID=CEM.I_Centre_Id
			INNER JOIN dbo.T_Country_Master COM WITH(NOLOCK)
			ON CEM.I_Country_ID=COM.I_Country_ID
			INNER JOIN dbo.T_Currency_Master CUM WITH(NOLOCK)
			ON COM.I_Currency_ID=CUM.I_Currency_ID
	  WHERE RH.I_Student_Detail_ID IS NULL
		AND	RH.I_Invoice_Header_ID IS NULL
		AND	RH.I_Receipt_Type=1
		AND	RH.I_Status=1
		AND RH.Dt_Receipt_Date BETWEEN @dtStartDate AND @dtEndDate
		AND [RH].[I_Student_Detail_ID] NOT IN 
		(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)
   ORDER BY FN2.InstanceChain,
			FN1.CenterName,
			UM.S_Title,
			UM.S_First_Name,
			UM.S_Middle_Name,
			UM.S_Last_Name,
			ERD.S_Enquiry_No

	END
	ELSE
	BEGIN
	 SELECT DISTINCT 
			ERD.I_Enquiry_Regn_ID,
			ERD.S_Enquiry_No,
			ERD.S_Title,
			ERD.S_First_Name,
			ERD.S_Middle_Name,
			ERD.S_Last_Name,
			ISNULL(RH.N_Receipt_Amount,0.00) AS N_Receipt_Amount,
			RH.Dt_Receipt_Date,
			UM.S_Title AS Coun_Title,
			UM.S_First_Name AS Coun_FirstName,
			UM.S_Middle_Name AS Coun_MiddleName,
			UM.S_Last_Name AS Coun_LastName,
			CM.S_Course_Code,
			CM.S_Course_Name,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			CUM.S_Currency_Code
	   FROM	dbo.T_Enquiry_Regn_Detail ERD WITH(NOLOCK)
			INNER JOIN dbo.T_Receipt_Header RH WITH(NOLOCK)
			ON ERD.I_Enquiry_Regn_ID=RH.I_Enquiry_Regn_ID
			INNER JOIN dbo.T_User_Master UM WITH(NOLOCK)
			ON ERD.S_Crtd_By=UM.S_Login_ID
			INNER JOIN [dbo].[T_Student_Registration_Details] AS TSRD
			ON [TSRD].[I_Receipt_Header_ID] = [RH].[I_Receipt_Header_ID]
			AND [TSRD].[I_Enquiry_Regn_ID] = [RH].[I_Enquiry_Regn_ID]
			INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM
			ON [TSRD].[I_Batch_ID] = [TSBM].[I_Batch_ID]
			INNER JOIN dbo.T_Course_Master CM WITH(NOLOCK)
			ON [TSBM].[I_Course_ID] = [CM].[I_Course_ID]
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON ERD.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
			ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			INNER JOIN dbo.T_Centre_Master CEM WITH(NOLOCK)
			ON FN1.CenterID=CEM.I_Centre_Id
			INNER JOIN dbo.T_Country_Master COM WITH(NOLOCK)
			ON CEM.I_Country_ID=COM.I_Country_ID
			INNER JOIN dbo.T_Currency_Master CUM WITH(NOLOCK)
			ON COM.I_Currency_ID=CUM.I_Currency_ID
	  WHERE RH.I_Student_Detail_ID IS NULL
		AND	RH.I_Invoice_Header_ID IS NULL
		AND	RH.I_Receipt_Type=1
		AND	RH.I_Status=1
		AND RH.Dt_Receipt_Date BETWEEN @dtStartDate AND @dtEndDate
		AND ERD.S_Crtd_By = @sCounselorCond
		AND [RH].[I_Student_Detail_ID] NOT IN 
		(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)
   ORDER BY FN2.InstanceChain,
			FN1.CenterName,
			UM.S_Title,
			UM.S_First_Name,
			UM.S_Middle_Name,
			UM.S_Last_Name,
			ERD.S_Enquiry_No

	END

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
