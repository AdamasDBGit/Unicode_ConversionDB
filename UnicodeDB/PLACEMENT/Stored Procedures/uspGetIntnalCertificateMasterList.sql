CREATE PROCEDURE [PLACEMENT].[uspGetIntnalCertificateMasterList]
AS
BEGIN

   SELECT 
        ISNULL(I_International_Certificate_ID,0) AS I_International_Certificate_ID ,
        ISNULL(S_Certificate_Name,' ') AS S_Certificate_Name ,
        ISNULL(S_Certificate_Vender_Name,' ') AS S_Certificate_Vender_Name
     FROM [PLACEMENT].T_Intnal_Certificate_Master
       WHERE I_Status = 1
END
