CREATE PROCEDURE [dbo].[uspGetTaxCenterAll] 
	@iCenterID INT
AS
BEGIN

	/*DECLARE @dtCurrentFinYearEnd DATETIME
	SET @dtCurrentFinYearEnd = CONVERT(DATETIME,'03/31/' + CONVERT(VARCHAR(4),DATEPART(yyyy,GETDATE())))
	IF (DATEDIFF(dd,GETDATE(),@dtCurrentFinYearEnd) < 0)
		SET @dtCurrentFinYearEnd = CONVERT(DATETIME,'03/31/' + CONVERT(VARCHAR(4),DATEPART(yyyy,GETDATE()) + 1))*/

	SELECT * FROM dbo.T_Fee_Component_Tax
	WHERE I_Centre_Id = @iCenterID
		
END
