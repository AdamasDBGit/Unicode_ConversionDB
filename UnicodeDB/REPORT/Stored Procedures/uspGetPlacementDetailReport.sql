-- =============================================
-- Author: Shankha Roy
-- Create date: 07/10/2007
-- Description: This sp return return list of student 
--				details who are selected in placment. 
--				It returns data for report placment 
--				details report.
-- Parameter: @iBrandID ,@dtStartDate ,@dtEndDate , @sHierarchyList
-- =============================================


CREATE PROCEDURE [REPORT].[uspGetPlacementDetailReport] 
(
-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@sHierarchyList VARCHAR(MAX),
	@dtStartDate DATETIME,
	@dtEndDate DATETIME
)
AS

BEGIN TRY
	BEGIN



					DECLARE @cStudentID INT -- user in temp student id
					-- temp table to store selected student id
					DECLARE @temStudent TABLE 
					(
					 ID INT IDENTITY(1,1),
					 I_Student_Detail_ID INT,
					 I_Vacancy_ID INT
					)
					-- temp table for store student details
					DECLARE @temStudentDetail TABLE 
					(
					Dt_Placement DATETIME,
					S_Placement_Executive VARCHAR(50),
					S_Designation VARCHAR(50),
					S_StudentName VARCHAR(200),
					N_Annual_Salary NUMERIC(18,2),
					S_CompanyName VARCHAR(250),
					S_Courses VARCHAR(2000),
					S_Center_Name VARCHAR(100),
					CenterCode VARCHAR(100),			
					InstanceChain VARCHAR(5000)
					)

				
				INSERT INTO @temStudent
				SELECT				
				SS.I_Student_Detail_ID AS I_Student_Detail_ID,
				SS.I_Vacancy_ID AS  I_Vacancy_ID
				FROM
				PLACEMENT.T_Shortlisted_Students SS 
				INNER JOIN dbo.T_Student_Detail SD 
				ON SS.I_Student_Detail_ID = SD.I_Student_Detail_ID 
				INNER JOIN dbo.T_Student_Center_Detail SCD 
				ON SS.I_Student_Detail_ID = SCD.I_Student_Detail_ID 
				INNER JOIN dbo.T_Centre_Master CM 
				ON CM.I_Centre_Id = SCD.I_Centre_Id 
				WHERE 
				DATEDIFF(dd, ISNULL(@dtStartDate,SS.[Dt_Crtd_On]), SS.[Dt_Crtd_On]) >= 0
				AND DATEDIFF(dd, ISNULL(@dtEndDate,SS.[Dt_Crtd_On]), SS.[Dt_Crtd_On]) <= 0
				AND CM.I_Centre_Id IN 
				(
				SELECT centerID FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID)
				)
				AND SS.C_Interview_Status = 'S'

				DECLARE @iRow INT 
				DECLARE @iCount INT
				SET @iCount =1
				SET @iRow = (SELECT COUNT(I_Student_Detail_ID)AS I_Student_Detail_ID  FROM
				@temStudent)

				
						WHILE (@iCount <=  @iRow)
						BEGIN
						
							SET @cStudentID = (SELECT I_Student_Detail_ID FROM  @temStudent  WHERE ID = @iCount)
								
								INSERT INTO @temStudentDetail(Dt_Placement,S_Placement_Executive,
								S_Designation,N_Annual_Salary,S_StudentName,S_CompanyName,
								S_Center_Name,S_Courses,
								CenterCode,InstanceChain								
								)

								SELECT 
								SS.Dt_Placement AS Dt_Placement,
								SS.S_Placement_Executive AS S_Placement_Executive , 
								SS.S_Designation AS S_Designation,
								SS.N_Annual_Salary AS N_Annual_Salary,
								ISNULL(SD.S_Title,'') + ' ' + SD.S_First_Name + ' ' + LTRIM(isnull(SD.S_Middle_Name,'') + ' ' + SD.S_Last_Name) as StudentName,
								ED.S_Company_Name AS S_Company_Name, 
								CM.S_Center_Name AS S_Center_Name,
								FN3.Courses,
								FN1.CenterCode,				
								FN2.InstanceChain 
								FROM
								PLACEMENT.T_Shortlisted_Students SS 
								INNER JOIN dbo.T_Student_Detail SD 
								ON SS.I_Student_Detail_ID = SD.I_Student_Detail_ID 
								INNER JOIN [dbo].[fnGetStudentCoursesList](@cStudentID) FN3
								ON SS.I_Student_Detail_ID = FN3.I_Student_Detail_ID
								INNER JOIN dbo.T_Student_Center_Detail SCD 
								ON SS.I_Student_Detail_ID = SCD.I_Student_Detail_ID 
								INNER JOIN dbo.T_Centre_Master CM 
								ON CM.I_Centre_Id = SCD.I_Centre_Id
								INNER JOIN PLACEMENT.T_Vacancy_Detail VD
								ON VD.I_Vacancy_ID = SS.I_Vacancy_ID
								INNER JOIN PLACEMENT.T_Employer_Detail ED
								ON ED.I_Employer_ID = VD.I_Employer_ID
								INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
								ON CM.I_Centre_Id=FN1.CenterID
								INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
								ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
 
								WHERE 
								SS.I_Student_Detail_ID = @cStudentID
								AND SS.C_Interview_Status = 'S'

							SET @iCount = @iCount + 1
								
						END

				 
		-- select the data for report
				SELECT
				DISTINCT(S_StudentName) AS S_StudentName ,  
				--CONVERT(VARCHAR(12),Dt_Placement,106) AS Dt_Placement,
				--DATEPART(mm,Dt_Placement) AS Dt_Placement,
				(DATENAME(m,Dt_Placement) +'-'+ DATENAME(yy,Dt_Placement))AS Dt_Placement,
				S_Placement_Executive ,
				S_Designation ,				
				N_Annual_Salary ,
				S_CompanyName,
				S_Courses,
				S_Center_Name,
				CenterCode,
				InstanceChain
				FROM @temStudentDetail


	END
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
