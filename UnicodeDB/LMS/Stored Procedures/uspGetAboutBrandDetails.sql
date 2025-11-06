CREATE PROCEDURE [LMS].[uspGetAboutBrandDetails](@ToBeDisplayedIn VARCHAR(MAX),@BrandID INT=109)
AS
BEGIN

	select TOP 1 * from LMS.T_AboutBrand where BrandID=@BrandID and StatusID=1 and ToBeDisplayedIn=@ToBeDisplayedIn


END
