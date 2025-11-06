CREATE PROCEDURE [dbo].[USP_ERP_getExamCategoryDropdownList]
(
	@BrandID INT,
	@SchoolGroupID INT,
	@SessionID INT,
	@inExamTypeId INT
)
As 
BEGIN
	SELECT
		 EC.inExamCategoryId AS iExamCategoryId
		,EC.stExamCategoryName AS ExamCategoryName
	FROM
		T_ERP_EXAM_CATEGORY EC
		JOIN T_ERP_Exam_Type_Master ETM ON ETM.inExamTypeID=EC.inExamTypeID
	WHERE
		EC.inExamTypeID = @inExamTypeId AND
		EC.inSchoolGroupID = @SchoolGroupID AND
		EC.inSchoolSessionID = @SessionID AND
		EC.inBrandID = @BrandID 
End

