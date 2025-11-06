/*****************************************************************************************************************
Created by: Aritra Saha
Date: 29/05/2007
Description: Gets the Discount Scheme Details
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetDiscountList]
(
	@iCenterID int = null,
	@iCourseID int = null
)

AS
BEGIN TRY

	

 CREATE TABLE #tempDiscountScheme
	(
		seq int identity(1,1),
		discountSchemeID int,
		discountSchemeName varchar(250),
		dtValidFrom datetime,
		dtValidTo datetime,
		rangeFrom numeric(18,2),
		rangeTo numeric(18,2),
		discountRate numeric(18,2),
		courseListId int
	)	
 
INSERT INTO #tempDiscountScheme(discountSchemeID,discountSchemeName,dtValidFrom,dtValidTo,rangeFrom,rangeTo,discountRate,courseListId)

	SELECT DISTINCT C.I_Discount_Scheme_ID,
		   C.S_Discount_Scheme_Name,
		   C.Dt_Valid_From,
		   C.Dt_valid_To,
		   B.N_Range_From,
		   B.N_Range_To,
		   B.N_Discount_Rate,
		   B.I_CourseList_ID   
	FROM T_CourseList_Course_Map A
	INNER JOIN T_Discount_Details B
	ON A.I_CourseList_ID = B.I_CourseList_ID
	INNER JOIN T_Discount_Scheme_Master C
	ON C.I_Discount_Scheme_ID = B.I_Discount_Scheme_ID
	INNER JOIN T_Discount_Center_Detail D
	ON D.I_Discount_Scheme_ID = C.I_Discount_Scheme_ID
	WHERE A.I_Course_ID = ISNULL(@iCourseID,A.I_Course_ID)
	AND D.I_Centre_ID = ISNULL(@iCenterID,D.I_Centre_ID)
	AND C.Dt_Valid_To >= GETDATE()
	AND A.I_Status <>0 AND C.I_Status <>0 AND D.I_Status <> 0
		
	-- TABLE[0] - Discount Scheme Details
	SELECT * FROM #tempDiscountScheme
	
	-- Table[1] - CourseList Course Map	
	SELECT A.I_CourseList_ID,A.I_Course_ID,B.S_Course_Name
	FROM T_CourseList_Course_Map A
	INNER JOIN T_Course_Master B
	ON A.I_Course_ID = B.I_Course_ID
	WHERE I_CourseList_ID 
	IN(SELECT courseListId FROM #tempDiscountScheme)	
	ORDER BY I_CourseList_ID

	TRUNCATE TABLE #tempDiscountScheme
	DROP TABLE #tempDiscountScheme
	

END TRY



BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
