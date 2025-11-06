-- =============================================================================================================  
-- Author:Ujjwal Sinha  
-- Create date:19/06/2007   
-- Description:Insert and Update Certificate record in T_Certificate_Logistic and T_Student_PS_Certificate table   
-- =============================================================================================================  
CREATE PROCEDURE [PSCERTIFICATE].[uspPrintPSCertificate]   
(  
 @iStudentCertificateID  int         ,  
 @sLogisticSerialNo  varchar(100)     ,  
 @iStatus   int  ,  
 @sCrtdBy   varchar(20) ,  
 @DtCrtdOn    datetime   
)  
AS  
BEGIN TRY  
    SET NOCOUNT OFF;  
  
IF EXISTS( SELECT * FROM [PSCERTIFICATE].T_Certificate_Logistic WHERE I_Student_Certificate_ID = @iStudentCertificateID)  
BEGIN  
 UPDATE [PSCERTIFICATE].T_Certificate_Logistic  
 SET I_Status       =-1   
 WHERE I_Student_Certificate_ID = @iStudentCertificateID  
END  
  
    INSERT INTO [PSCERTIFICATE].T_Certificate_Logistic  
      (  
  I_Student_Certificate_ID,  
  S_Logistic_Serial_No,  
  I_Status,  
  S_Crtd_By,  
     Dt_Crtd_On  
      )  
 VALUES  
      (  
  @iStudentCertificateID,  
  @sLogisticSerialNo,  
  1,  
  @sCrtdBy,  
  @DtCrtdOn   
 )  
  
 UPDATE [PSCERTIFICATE].T_Student_PS_Certificate  
 SET I_Status       = @iStatus,  
  [Dt_Certificate_Issue_Date] = @DtCrtdOn  
 WHERE I_Student_Certificate_ID = @iStudentCertificateID  
        
END TRY  
  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
