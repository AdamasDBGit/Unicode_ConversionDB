-- =============================================
-- Author: Sandeep Acharyya
-- Create date: 03/02/2011
-- Description: This function returns the next student no for that particular brand
-- Return: student no (varchar)
-- =============================================
CREATE FUNCTION [dbo].[fnGetStudentNo]
(
@iCenterID INT
)
RETURNS VARCHAR(20)
AS

BEGIN

DECLARE @iBrandID INT, @BrandCode VARCHAR(20), @iMaxStudentID INT, @iMaxStudentNo INT, @sStudentNo VARCHAR(20)

SELECT TOP 1 @iBrandID = [TBCD].[I_Brand_ID] FROM [dbo].[T_Brand_Center_Details] AS TBCD
WHERE [TBCD].[I_Centre_Id] = @iCenterID

SELECT @BrandCode = [TBM].[S_Brand_Code]
FROM [dbo].[T_Brand_Master] AS TBM
WHERE [TBM].[I_Brand_ID] = @iBrandID

-- To be Removed
-- SET @BrandCode = 'Student'

--SELECT @iMaxStudentID = MAX([tsd].[I_Student_Detail_ID])
--FROM [dbo].[T_Student_Detail] AS TSD
--WHERE [TSD].[S_Student_ID] LIKE '' + @BrandCode + '%'

SELECT @iMaxStudentID = MAX([tscd].[I_Student_Detail_ID]) FROM [dbo].[T_Student_Center_Detail] AS TSCD
INNER JOIN [dbo].[T_Brand_Center_Details] AS TBCD
ON [TSCD].[I_Centre_Id] = [TBCD].[I_Centre_Id]
WHERE [TBCD].[I_Brand_ID] = @iBrandID

IF (@iMaxStudentID IS NOT NULL)
BEGIN
SELECT @iMaxStudentNo = CAST(REPLACE([TSD].[S_Student_ID],@BrandCode,'') AS INT)
FROM [dbo].[T_Student_Detail] AS TSD
WHERE [TSD].[I_Student_Detail_ID] = @iMaxStudentID

SET @iMaxStudentNo = @iMaxStudentNo + 1
END
ELSE
BEGIN
SET @iMaxStudentNo = 1
END

SET @sStudentNo = @BrandCode + CAST(@iMaxStudentNo AS VARCHAR(20))

IF (@sStudentNo IS NULL)
SET @sStudentNo = ''

RETURN @sStudentNo

END