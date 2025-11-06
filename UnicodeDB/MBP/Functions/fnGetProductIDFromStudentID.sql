-- =============================================
-- Author:		Shankha Roy
-- Create date: '08/08/2007'
-- Description:	This Function return a table 
-- consisting of product id of given Center ID
-- Return: Table
-- =============================================
CREATE FUNCTION [MBP].[fnGetProductIDFromStudentID]
(
	@iStudentID INT

)
RETURNS  @rtnTable TABLE
(
	iStudentID INT,
	iProductID INT	
)

AS 
-- Returns the Table containing the Course details.
BEGIN
	DECLARE @iRow INT
	DECLARE @iCount INT
	DECLARE @iRow2 INT
	DECLARE @iCount2 INT
	SET @iCount = 1
	SET @iCount2 = 1

	DECLARE @iCourseID INT
	
	--for store temp student id 
	DECLARE @temStudent TABLE
	(
	ID INT IDENTITY(1,1),
	iStudentID INT
	)
	DECLARE @temCourse TABLE
	(
	ID INT IDENTITY(1,1),
	iCourseID INT
	)
	DECLARE @temProduct TABLE
	(
	ID INT IDENTITY(1,1),
	iProductID INT
	)


					INSERT INTO @temCourse(iCourseID)
					SELECT DISTINCT(I_Course_ID) 
					FROM dbo.T_Student_Course_Detail
					WHERE I_Student_Detail_ID = @iStudentID
									
					
					SET @iRow2 = (SELECT COUNT(*) FROM @temCourse)
					SET @iCount2 = 1
					WHILE (@iCount2 <= @iRow2 )

					BEGIN 
						SET @iCourseID =( SELECT iCourseID FROM @temCourse WHERE ID = @iCount)
								
								INSERT INTO @temProduct(iProductID)
								SELECT DISTINCT(PC.I_Product_ID) FROM MBP.T_Product_Component PC
--								INNER JOIN dbo.T_Course_Master CM
--								ON PC.I_Course_ID= CM.I_Course_ID
--								INNER JOIN dbo.T_CourseFamily_Master CFM
--								ON CM.I_CourseFamily_ID= CFM.I_CourseFamily_ID
								WHERE PC.I_Course_ID = @iCourseID
								--AND PC.I_Course_Family_ID IS NULL

								INSERT INTO @temProduct(iProductID)
								SELECT DISTINCT(PC.I_Product_ID) FROM MBP.T_Product_Component PC
--								INNER JOIN dbo.T_Course_Master CM
--								ON PC.I_Course_ID= CM.I_Course_ID
--								INNER JOIN dbo.T_CourseFamily_Master CFM
--								ON CM.I_CourseFamily_ID= CFM.I_CourseFamily_ID
								WHERE PC.I_Course_Family_ID = (	SELECT I_CourseFamily_ID FROM dbo.T_Course_Master
																WHERE I_Course_ID = @iCourseID)	
								--AND PC.I_Course_ID IS NULL							
							
								SET @iCount2 = @iCount2 +1

					 END 

						INSERT INTO @rtnTable (iProductID,iStudentID)
					    SELECT  DISTINCT(iProductID), @iStudentID  FROM @temProduct
						WHERE iProductID NOT IN (SELECT I_Product_ID FROM MBP.T_Product_Master WHERE S_Product_Name ='MBP_DUMMY_PRODUCT_FOR_ENQUIRY')
						
						DELETE FROM @temProduct


	RETURN;
END