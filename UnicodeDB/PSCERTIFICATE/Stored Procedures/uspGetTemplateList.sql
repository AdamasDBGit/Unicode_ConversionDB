-- =============================================
-- Author:		Shankha Roy
-- Create date: 23/08/2007
-- Description:	This SP for getting the template name for
--				Certificate or PS 
-- =============================================

CREATE PROCEDURE [PSCERTIFICATE].[uspGetTemplateList]--406,208
(
@iCourseID INT =NULL,
@iTermID INT = NULL,
@iPSCert INT = NULL,
@iCourseFamilyID INT
)
AS
BEGIN
		DECLARE @TemCourse TABLE
		(
		I_Course_ID INT
		)


		IF(@iCourseID IS NULL)
		BEGIN
			INSERT INTO @TemCourse 
			SELECT I_Course_ID FROM dbo.T_Course_Master
			WHERE I_CourseFamily_ID = @iCourseFamilyID
		END
		ELSE
		BEGIN
			INSERT INTO @TemCourse(I_Course_ID) VALUES(@iCourseID)
		END

		
		-- This for Course Certificate Code
		IF(@iPSCert = 0)
					BEGIN  
							-- This for Certificate Template
					SELECT DISTINCT S_Template_Code,S_File_Location,TM.I_Template_ID AS I_Template_ID FROM dbo.T_Template_Master TM
					INNER JOIN dbo.T_Certificate_Master CM 
					ON TM.I_Template_ID = CM.I_Template_ID
					INNER JOIN dbo.T_Course_Master COM
					ON CM.I_Certificate_ID = COM.I_Certificate_ID
					WHERE 
					--COM.I_Course_ID = @iCourseID 
					COM.I_Course_ID IN (SELECT I_Course_ID FROM @TemCourse)
					AND TM.I_Status = 1
					--ORDER BY TM.Dt_Crtd_On DESC
					END


		-- This for Course PS
		ELSE IF (@iPSCert = 1)
					BEGIN 
						-- This For PS Template
							SELECT DISTINCT S_Template_Code,S_File_Location,TM.I_Template_ID AS I_Template_ID  FROM dbo.T_Template_Master TM
							INNER JOIN 	dbo.T_Term_Eval_Strategy TES
							ON TM.I_Template_ID = TES.I_Template_ID
							WHERE TES.I_Course_ID IN (SELECT I_Course_ID FROM @TemCourse)
							--AND   TES.I_Term_ID = @iTermID	
							AND TM.I_Status = 1	
							AND TM.S_Template_Type = 2
							--ORDER BY TM.Dt_Crtd_On DESC	
					END

		-- This For Term Certificate Code
		ELSE
			BEGIN  
					--THIS IS FOR TERM LAVEL CERTIFICATE
							SELECT DISTINCT S_Template_Code,S_File_Location,TM.I_Template_ID AS I_Template_ID  FROM dbo.T_Template_Master TM
							INNER JOIN dbo.T_Certificate_Master CM 
							ON TM.I_Template_ID = CM.I_Template_ID
							INNER JOIN dbo.T_Term_Course_Map TCM
							ON CM.I_Certificate_ID = TCM.I_Certificate_ID
							WHERE 
							--TCM.I_Course_ID =  @iCourseID 
							TCM.I_Course_ID IN (SELECT I_Course_ID FROM @TemCourse)
							--AND TCM.I_Term_ID = @iTermID	
							AND TM.I_Status = 1
							AND CM.S_Certificate_Type = 'Term'
							AND TM.S_Template_Type = 1

	END
END
