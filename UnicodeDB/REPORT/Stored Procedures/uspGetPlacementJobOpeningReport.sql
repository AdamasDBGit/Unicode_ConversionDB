-- ===============================================================
-- Author: Shankha Roy
-- Create date: 07/11/2007
-- Description: This sp return return list summary Job Opening List. 
--				
-- Parameter: @CompanyName,@RoleDesignation,@dtStartDate,@dtEndDate
-- ================================================================

CREATE PROCEDURE [REPORT].[uspGetPlacementJobOpeningReport] 
(
	@dtStartDate DATETIME,
	@dtEndDate DATETIME,
	@sCompanyName VARCHAR(250)= NULL,
	@sRoleDesignation VARCHAR(50)= NULL,
	@iBrandID INT = null
)
AS
BEGIN TRY
	BEGIN 

DECLARE @CompanyName VARCHAR(250)
DECLARE @RoleDesignation VARCHAR(50)

IF(@sRoleDesignation IS NOT NULL)
SET @RoleDesignation = @sRoleDesignation +'%'


			SELECT   
			ED.S_Company_Name AS S_Company_Name,
			VD.S_Role_Designation AS S_Role_Designation,
			VD.I_No_Of_Openings AS Openings,
			(CONVERT(NUMERIC(18,2), VD.S_Pay_Scale)) AS S_Pay_Scale,
			Count(SS.I_Student_Detail_ID) AS VacancyFill
			FROM PLACEMENT.T_Vacancy_Detail VD
			INNER JOIN PLACEMENT.T_Employer_Detail ED
			ON VD.I_Employer_ID= ED.I_Employer_ID
			INNER JOIN dbo.T_User_Master UM
			ON UM.I_Reference_ID = ED.I_Employer_ID
			AND UM.S_User_Type = 'EM'
			LEFT OUTER JOIN PLACEMENT.T_Shortlisted_Students SS
			ON SS.I_Vacancy_ID =VD.I_Vacancy_ID
			AND [SS].[C_Interview_Status] = 'S'
			WHERE
			[ED].[I_Employer_ID] = ISNULL(@sCompanyName,[ED].[I_Employer_ID])
			AND S_Role_Designation LIKE COALESCE(@RoleDesignation,S_Role_Designation)
			AND DATEDIFF(dd, ISNULL(@dtStartDate,VD.Dt_Crtd_On), VD.Dt_Crtd_On) >= 0
			AND DATEDIFF(dd, ISNULL(@dtEndDate,VD.Dt_Crtd_On), VD.Dt_Crtd_On) <= 0 
			AND UM.I_User_ID IN (SELECT I_User_ID FROM [Placement].[fnGetUserIDFormBrand](@iBrandID))
			GROUP BY SS.I_Vacancy_ID,
			ED.S_Company_Name,
			VD.S_Role_Designation,
			VD.I_No_Of_Openings,
			VD.S_Pay_Scale

	END
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
