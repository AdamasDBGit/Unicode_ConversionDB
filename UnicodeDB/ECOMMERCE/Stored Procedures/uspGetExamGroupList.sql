CREATE PROCEDURE [ECOMMERCE].[uspGetExamGroupList](@BrandID INT=109)
AS
BEGIN


	select * from ECOMMERCE.T_ExamGroup_Master where StatusID=1 and BrandID=@BrandID


END
