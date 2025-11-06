-- =============================================
-- Author:		Shankha Roy
-- Create date: 23/08/2007
-- Description:	This SP for getting the template name for
--				Certificate or PS 
-- =============================================

CREATE PROCEDURE [PSCERTIFICATE].[uspGetTemplate]--406,208
(
@iCourseID INT,
@iTermID INT = NULL,
@iPSCert INT = NULL

)
AS
BEGIN

	IF @iTermID IS NULL
		BEGIN
			-- This for Certificate Template
			SELECT S_Template_Code,S_File_Location FROM dbo.T_Template_Master TM
			INNER JOIN dbo.T_Certificate_Master CM 
			ON TM.I_Template_ID = CM.I_Template_ID
			INNER JOIN dbo.T_Course_Master COM
			ON CM.I_Certificate_ID = COM.I_Certificate_ID
			WHERE COM.I_Course_ID = @iCourseID 
			AND TM.I_Status = 1
			ORDER BY TM.Dt_Crtd_On DESC
		END
	ELSE
		BEGIN
			
			IF(@iPSCert = 1)
			BEGIN 
					--THIS IS FOR TERM LAVEL CERTIFICATE
					SELECT S_Template_Code,S_File_Location FROM dbo.T_Template_Master TM
					INNER JOIN dbo.T_Certificate_Master CM 
					ON TM.I_Template_ID = CM.I_Template_ID
					INNER JOIN dbo.T_Term_Course_Map TCM
					ON CM.I_Certificate_ID = TCM.I_Certificate_ID
					WHERE 
					TCM.I_Course_ID =  @iCourseID 
					AND TCM.I_Term_ID = @iTermID	
					AND TM.I_Status = 1
					AND CM.S_Certificate_Type = 'Term'
			END 
			ELSE
				BEGIN
						-- This For PS Template
					SELECT DISTINCT S_Template_Code,S_File_Location FROM dbo.T_Template_Master TM
					INNER JOIN 	dbo.T_Term_Eval_Strategy TES
					ON TM.I_Template_ID = TES.I_Template_ID
					WHERE TES.I_Course_ID = @iCourseID
					AND   TES.I_Term_ID = @iTermID	
					AND TM.I_Status = 1	
					--ORDER BY TM.Dt_Crtd_On DESC	
				END


		END



END
