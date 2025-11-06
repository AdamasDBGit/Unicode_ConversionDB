CREATE FUNCTION [dbo].[GetDiscountSchemeforCenter]
(
	@iCourseId INT,
	@iCentreID INT
)  
RETURNS  VARCHAR(2000)

AS
BEGIN
 
DECLARE @sDiscount varchar(2000)
DECLARE @ItEMP INT
SET @sDiscount = ''

DECLARE @Temptable TABLE 
 (
	S_Discount_Scheme_Name varchar(200)
 )
INSERT INTO @Temptable(S_Discount_Scheme_Name)
	SELECT DISTINCT C.S_Discount_Scheme_Name
	FROM dbo.T_CourseList_Course_Map A
	INNER JOIN dbo.T_Discount_Details B
	ON A.I_CourseList_ID = B.I_CourseList_ID
	INNER JOIN dbo.T_Discount_Scheme_Master C
	ON C.I_Discount_Scheme_ID = B.I_Discount_Scheme_ID
	INNER JOIN dbo.T_Discount_Center_Detail D
	ON D.I_Discount_Scheme_ID = C.I_Discount_Scheme_ID
	WHERE A.I_Course_ID = @iCourseId 
	AND D.I_Centre_ID = @iCentreID
	AND C.Dt_Valid_To >= GETDATE()
	AND A.I_Status <>0 AND C.I_Status <>0 AND D.I_Status <> 0

select @sDiscount = ', ' + S_Discount_Scheme_Name + @sDiscount from @Temptable

RETURN @sDiscount
END