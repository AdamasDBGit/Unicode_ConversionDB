
--***************************************
--Description : gets all the courses with valid fee plan
--created By :Debarshi basu
--Created On : 24/08/2007
--***************************************

CREATE PROCEDURE [dbo].[uspGetCourseListForEnrollment]
    (
      @iCenterId INT ,
      @iCourseFamilyID INT = NULL
    )
AS 
    BEGIN
        SET NOCOUNT ON ;
	
        SELECT DISTINCT
                CCD.I_Course_ID COURSE_ID ,
                CM.S_Course_Name COURSE_NAME ,
                CM.S_Course_Code AS COURSE_CODE ,
                CFM.I_CourseFamily_ID ,
                CFM.S_CourseFamily_Name,
				ISNULL(CM.I_Language_ID,0) as I_Langauge_ID,---added by susmita 
				CM.I_Language_Name-- added by susmita
        FROM    dbo.T_Course_Center_Detail CCD
                INNER JOIN dbo.T_Course_Master CM ON CM.I_Course_ID = CCD.I_Course_ID
                INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID = CFM.I_CourseFamily_ID
        WHERE   CCD.I_Centre_Id = @iCenterId
                AND CM.I_CourseFamily_ID = ISNULL(@iCourseFamilyID,
                                                  CM.I_CourseFamily_ID)
                AND CCD.I_Status = 1
                AND GETDATE() >= ISNULL(CCD.Dt_Valid_From, GETDATE())
                AND GETDATE() <= ISNULL(CCD.Dt_Valid_To, GETDATE())
                AND CCD.I_Course_Center_ID IN (
                SELECT  B.I_Course_Center_ID
                FROM    dbo.T_Course_Center_Delivery_FeePlan B
                WHERE   B.I_Status = 1
                        AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())
                        AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE()) )
        ORDER BY CM.S_Course_Name
	
    END
