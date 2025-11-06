--create table LMS.T_Student_OrgEmail_Audit
--(
--ID INT NOT NULL IDENTITY(1,1),
--OrgEmail VARCHAR(MAX) NOT NULL,
--IsLicenseAttached BIT,
--CreatedOn DATETIME,
--LicenseAttachedOn DATETIME
--)

CREATE PROCEDURE [LMS].[uspInsertUpdateStudentOrgEmailAudit]
(
@EmailID VARCHAR(MAX),
@IsLicenseAttached BIT=NULL
)
AS
BEGIN

	if not exists(select * from LMS.T_Student_OrgEmail_Audit where OrgEmail=@EmailID)
	begin

		insert into LMS.T_Student_OrgEmail_Audit
		select @EmailID,NULL,GETDATE(),NULL

	end
	else if (@IsLicenseAttached IS NOT NULL)
	begin

		update LMS.T_Student_OrgEmail_Audit set IsLicenseAttached=@IsLicenseAttached,LicenseAttachedOn=GETDATE() where OrgEmail=@EmailID

	end

END
