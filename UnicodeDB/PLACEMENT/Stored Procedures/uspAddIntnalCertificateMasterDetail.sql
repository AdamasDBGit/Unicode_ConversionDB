CREATE PROCEDURE [PLACEMENT].[uspAddIntnalCertificateMasterDetail]
(
	@iInternationalCertificateID     INT
)
AS
BEGIN

   SELECT 
        S_Certificate_Name, S_Certificate_Vender_Name
     FROM [PLACEMENT].T_Intnal_Certificate_Master
       WHERE I_International_Certificate_ID = @iInternationalCertificateID
         AND I_Status = 1
END
