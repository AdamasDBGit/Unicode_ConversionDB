/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description:Insert Employer Contact record in T_Employer_Contact table 
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspAddEmployerContact]
(
		@iEmployerID INT,
		@sCreatedBy VARCHAR(20),
		@DtCreatedOn DATETIME,
--XML file for contact detail data
	   @sEmployerContact XML
)
 
 AS
BEGIN TRY
      
--	Insert values into the T_Employer_Contact table from xml file


			       INSERT INTO PLACEMENT.T_Employer_Contact
			            (
						I_Employer_ID, 
						S_Contact_Name, 
						S_Contact_Designation, 
						S_Contact_Address, 
						S_Email, 
						S_Telephone, 
						S_Cellphone, 
						S_Fax, 
						B_Is_Primary,
						I_Status, 
			            S_Crtd_By,						
						Dt_Crtd_On							
						)
						SELECT @iEmployerID,
						T.c.value('@sContactName','varchar(50)'),
						T.c.value ('@sContactDesignation','varchar(50)'),
						T.c.value ('@sContactAddress','varchar(150)'),
						T.c.value ('@sEmail','varchar(50)'),
						T.c.value ('@sTelephone','varchar(20)'),
						T.c.value ('@sCellphone','varchar(20)'),
						T.c.value ('@sFax','varchar(20)'),
						T.c.value ('@bIsPrimary','bit'),
						1,
						@sCreatedBy,
						@DtCreatedOn
						FROM   @sEmployerContact.nodes('/Contact/EmployerContact') T(c)		
			
						
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
