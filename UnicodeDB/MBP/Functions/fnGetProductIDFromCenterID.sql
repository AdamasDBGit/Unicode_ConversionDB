-- =============================================
-- Author:		Shankha Roy
-- Create date: '08/08/2007'
-- Description:	This Function return a table 
-- consisting of product id of given Center ID
-- Return: Table
-- =============================================
CREATE FUNCTION [MBP].[fnGetProductIDFromCenterID]
(
	@iCenterID INT,
	@iMonth INT,
	@iYear INT
)
RETURNS  @rtnTable TABLE
(
	iStudentID INT,
	iProductID INT,
	iCenterID INT
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
	DECLARE @iStudentID INT
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


	INSERT INTO @temStudent(iStudentID)
	SELECT I_Student_Detail_ID FROM dbo.T_Student_Center_Detail
	WHERE I_Centre_Id = @iCenterID
	AND (DATEPART(mm,Dt_Valid_From))  = @iMonth
	AND (DATEPART(yy,Dt_Valid_From))  = @iYear
	--AND (DATEPART(mm,Dt_Crtd_On))  = @iMonth
	--AND (DATEPART(yy,Dt_Crtd_On))  = @iYear
	
	SET @iRow = (SELECT COUNT(ID) FROM @temStudent)	


WHILE (@iCount <= @iRow )
			 BEGIN
				SET @iStudentID =(SELECT iStudentID FROM @temStudent WHERE ID = @iCount )

					INSERT INTO @temCourse(iCourseID)
					SELECT DISTINCT(I_Course_ID) 
					FROM dbo.T_Student_Course_Detail
					WHERE I_Student_Detail_ID = @iStudentID
									
					
					SET @iRow2 = (SELECT COUNT(*) FROM @temCourse)
					--SELECT @iRow2
					SET @iCount2 = 1
					WHILE (@iCount2 <= @iRow2 )
					BEGIN 
						SET @iCourseID =( SELECT iCourseID FROM @temCourse WHERE ID = @iCount)								

								INSERT INTO @temProduct(iProductID)
								SELECT iProductID FROM [MBP].[fnGetProductIDFromCourseID](@iCourseID)							
								SET @iCount2 = @iCount2 +1

					 END 

						INSERT INTO @rtnTable (iProductID,iStudentID,iCenterID)
					    SELECT  DISTINCT(iProductID), @iStudentID,@iCenterID  FROM @temProduct
						DELETE FROM @temProduct

           SET @iCount = @iCount +1
	END	

	RETURN;
END