-- =============================================
-- Author:		Shankha Roy
-- Create date: 19/07/2007
-- Description:	This sp use for save data in MBP.T_Product_Master Table 
-- =============================================
CREATE PROCEDURE [MBP].[uspCheckCourseInCourseFamily]
(  
@sProductComponent			XML
,@blReturn					BIT  OUTPUT
			
)
AS
	BEGIN TRY 
SET @blReturn = 0

		DECLARE @tblTemp TABLE
		(
			ID INT IDENTITY(1,1)
			,CourseID INT
			,CourseFamilyID INT
		)
		-- code enter course id in T_Product_Component from xml
		INSERT INTO @tblTemp(CourseID,CourseFamilyID)
		SELECT  T.c.value('@CourseID','int'),
				T.c.value('@CourseFamilyID','int')
		FROM @sProductComponent.nodes('/Product/ProductComponent')T(c)


		--SELECT * FROM  @tblTemp
		DECLARE @iCounter INT,@iRowCount INT,@iCrsIDTemp INT ,@iCrsFamilyIDTemp INT
		SET @iRowCount =0
		SET @iCounter =0
		SET @iCrsIDTemp =0
		SET @iCrsFamilyIDTemp =0

		DECLARE @tblCourse TABLE (CourseID INT)
		DECLARE @tblCourseFamily TABLE (CourseFamilyID INT)

		SET @iRowCount = (Select Count(*) FROM @tblTemp)
		WHILE (@iCounter <= @iRowCount)
		BEGIN
			SET @iCrsIDTemp = (SELECT CourseID FROM @tblTemp WHERE ID=@iCounter)
			IF @iCrsIDTemp <> 0
			BEGIN
				INSERT INTO @tblCourse(CourseID) VALUES (@iCrsIDTemp)
			END
			SET @iCrsFamilyIDTemp = (SELECT CourseFamilyID FROM @tblTemp WHERE ID=@iCounter)
			IF @iCrsFamilyIDTemp <> 0
			BEGIN
				INSERT INTO @tblCourseFamily(CourseFamilyID) VALUES (@iCrsFamilyIDTemp)
			END

			SET @iCounter = @iCounter + 1
		END

		DECLARE @tblCourseIDChk TABLE (ChkCourseID INT)
		INSERT INTO @tblCourseIDChk(ChkCourseID)
		SELECT I_Course_ID FROM dbo.T_Course_Master WHERE I_CourseFamily_ID IN (SELECT CourseFamilyID FROM @tblCourseFamily)

/*SELECT * FROM  @tblCourse
SELECT * FROM  @tblCourseFamily
SELECT * FROM  @tblCourseIDChk
SELECT COUNT(*) FROM  @tblCourse
SELECT COUNT(*) FROM  @tblCourseFamily*/
IF (SELECT COUNT(*) FROM  @tblCourse)<>0 AND (SELECT COUNT(*) FROM  @tblCourseFamily)<>0
BEGIN
		IF (SELECT COUNT(ChkCourseID)  FROM @tblCourseIDChk WHERE ChkCourseID IN (SELECT CourseID FROM  @tblCourse)) >0
		BEGIN
				SET @blReturn = 0
				
				DECLARE @tblReturn TABLE (ID INT IDENTITY(1,1), CrsName VARCHAR(2000),CrsFamilyName VARCHAR(2000))
				INSERT INTO @tblReturn (CrsName,CrsFamilyName) 
				(SELECT 
					CRS.S_Course_Name
					,CFM.S_CourseFamily_Name

				 FROM dbo.T_Course_Master CRS
				LEFT OUTER JOIN dbo.T_CourseFamily_Master CFM
				ON CRS.I_CourseFamily_ID = CFM.I_CourseFamily_ID
				WHERE CRS.I_Course_ID IN(
				SELECT ChkCourseID  FROM @tblCourseIDChk WHERE ChkCourseID IN (SELECT CourseID FROM  @tblCourse)))
				
				SET @iRowCount = (Select Count(*) FROM @tblReturn)
				DECLARE @Cname VARCHAR (2000),@CFname VARCHAR(2000) ,@oupput VARCHAR(5000)
				IF @iRowCount>0 
				BEGIN
					SELECT CrsName,CrsFamilyName FROM @tblReturn
				END
--				SET @iCounter =0
--				SET @oupput = '#'
--				SET @sOutput = '#'
--				WHILE(@iCounter <= @iRowCount)
--				BEGIN
--					SET @Cname= (SELECT CrsName FROM @tblReturn WHERE ID=@iCounter)
--					SET @CFname = (SELECT CrsFamilyName FROM @tblReturn WHERE ID=@iCounter)
--					SET @sOutput = @sOutput  + ',' + @Cname
--					SET @oupput =((SELECT CrsName FROM @tblReturn WHERE ID=@iCounter) + ',' +(SELECT CrsFamilyName FROM @tblReturn WHERE ID=@iCounter)+ '#')
--				SELECT  @oupput
--				SET @iCounter =@iCounter +1
--				END
		END
		ELSE
		BEGIN
			SET @blReturn = 1
		END	
END
ELSE
BEGIN
	SET @blReturn = 1
END

END TRY


	BEGIN CATCH
	--Error occurred:  
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
