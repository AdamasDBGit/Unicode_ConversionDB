CREATE PROCEDURE [dbo].[uspArchiveSMSList]
AS
BEGIN	
	
DECLARE @ArchivalDayNo INT
DECLARE @noofAttempt INT
SELECT  @ArchivalDayNo = S_PARAM_VALUE
FROM    dbo.T_SMS_PARAM_MASTER
WHERE   I_PARAM_ID = 7	


SELECT  @noofAttempt = S_PARAM_VALUE
FROM    dbo.T_SMS_PARAM_MASTER
WHERE   I_PARAM_ID = 6	 

INSERT  INTO dbo.T_SMS_SEND_DETAILS_ARCHIVE
        ( I_SMS_SEND_DETAILS_ID ,
          S_MOBILE_NO ,
          I_SMS_STUDENT_ID ,
          I_SMS_TYPE_ID ,
          S_SMS_BODY ,
          I_IS_SUCCESS ,
          I_NO_OF_ATTEMPT ,
          S_RETURN_CODE_FROM_PROVIDER ,
          I_REFERENCE_ID ,
          I_REFERENCE_TYPE_ID ,
          Dt_SMS_SEND_ON ,
          I_Status ,
          S_Crtd_By ,
          S_Upd_By ,
          Dt_Crtd_On ,
          Dt_Upd_On ,
          Dt_Archived_On
        )
        SELECT  I_SMS_SEND_DETAILS_ID ,
                S_MOBILE_NO ,
                I_SMS_STUDENT_ID ,
                I_SMS_TYPE_ID ,
                S_SMS_BODY ,
                I_IS_SUCCESS ,
                I_NO_OF_ATTEMPT ,
                S_RETURN_CODE_FROM_PROVIDER ,
                I_REFERENCE_ID ,
                I_REFERENCE_TYPE_ID ,
                Dt_SMS_SEND_ON ,
                I_Status ,
                S_Crtd_By ,
                S_Upd_By ,
                Dt_Crtd_On ,
                Dt_Upd_On ,
                GETDATE()
        FROM    dbo.T_SMS_SEND_DETAILS
        WHERE   (I_Status = 0 OR I_NO_OF_ATTEMPT>=@noofAttempt )
                        AND CONVERT(DATE, Dt_Crtd_On) < CONVERT(DATE, DATEADD(dd,
                                                              -@ArchivalDayNo,
                                                              GETDATE()))
                                                              
                                                              
                                                              
     DELETE M
      FROM dbo.T_SMS_SEND_DETAILS M
     INNER JOIN dbo.T_SMS_SEND_DETAILS_ARCHIVE A
     ON M.I_SMS_SEND_DETAILS_ID = A.I_SMS_SEND_DETAILS_ID

	
END
