-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp return the detail of upload document
-- =============================================
CREATE PROCEDURE [MBP].[uspGetDocumentDetailFromMBPDetail]
(  
	--@iCenterID	VARCHAR(2000) = null
	 @iHierarchyDetailID INT	 = NULL	
	,@iMBPPlanType	INT	 = NULL	
	,@iProduct INT = NULL 
	,@iMonth INT = NULL
	,@iYear INT = NULL

)
AS
	BEGIN TRY  
	

	
	DECLARE @tblHierarchyDetailID TABLE	
	(
		ID INT IDENTITY(1,1)
		,HkeyDetailID INT
		,Chain VARCHAR(1000)
	)
	INSERT INTO  @tblHierarchyDetailID(HkeyDetailID,Chain) 
	 SELECT I_Hierarchy_Detail_ID, '#'+ REPLACE(S_Hierarchy_Chain,',','#') + '#'  FROM dbo.T_Hierarchy_Mapping_Details

--SELECT HkeyDetailID FROM @tblHierarchyDetailID WHERE Chain Like '#65#'
--PRINT '%#' + LTRIM(STR(@iHierarchyDetailID)) + '#%'
--SELECT * FROM @tblHierarchyDetailID WHERE Chain LIKE '%#' + LTRIM(STR(@iHierarchyDetailID)) + '#%'

	

	SELECT 
	ISNULL(MBP.I_MBP_Detail_ID,0) AS I_MBP_Detail_ID
	,ISNULL(DOC.I_Document_ID,0) AS I_Document_ID_File
	,ISNULL(DOC.S_Document_Name,'')AS S_Document_Name
	,ISNULL(DOC.S_Document_Type,'') AS S_Document_Type
	,ISNULL(DOC.S_Document_Path,'') AS S_Document_Path
	,ISNULL(DOC.S_Document_URL,'') AS S_Document_URL
	,ISNULL(MBP.I_Product_ID,0) AS I_Product_ID
	,PROD.S_Product_Name  AS S_Product_Name
	,ISNULL(I_Center_ID,0) AS I_Center_ID
	,ISNULL(I_Year,0) AS I_Year
	,ISNULL(I_Month,0) AS I_Month
	,CONVERT(VARCHAR,MBP.Dt_Crtd_On ,110) AS Dt_MBPDate
	,CONVERT(VARCHAR,DOC.Dt_Crtd_On,110) AS Dt_FileCreateDate
	--,'' AS 'S_Center_Name'
	
	FROM MBP.T_MBP_Detail MBP
	LEFT OUTER JOIN dbo.T_Upload_Document DOC
	ON MBP.I_Document_ID = DOC.I_Document_ID
	LEFT OUTER JOIN MBP.T_Product_Master PROD
	ON MBP.I_Product_ID = PROD.I_Product_ID

	--WHERE MBP.I_Center_ID IN (SELECT HkeyDetailID FROM @tblHierarchyDetailID) AND MBP.I_Type_ID = COALESCE(@iMBPPlanType,MBP.I_Type_ID)
	WHERE 
	--MBP.I_Hierarchy_Detail_ID IN (SELECT HkeyDetailID FROM @tblHierarchyDetailID WHERE Chain LIKE '%#' + LTRIM(STR(@iHierarchyDetailID)) + '#%') AND MBP.I_Type_ID = COALESCE(@iMBPPlanType,MBP.I_Type_ID)
	--AND
	 MBP.I_Year = COALESCE( @iYear,I_Year)
	AND MBP.I_Month = COALESCE(@iMonth,I_Month)	
	AND MBP.I_Product_ID = COALESCE(@iProduct,MBP.I_Product_ID)
	AND MBP.I_Type_ID=@iMBPPlanType
	END TRY
			BEGIN CATCH
			--Error occurred:  
				DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
				SELECT	@ErrMsg = ERROR_MESSAGE(),
						@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			END CATCH
