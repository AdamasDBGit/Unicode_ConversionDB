CREATE PROCEDURE [dbo].[uspValidateChequeNo] 
(
	@sChequeNo NVARCHAR(MAX),
	@ChequeDt DATETIME
)  
AS   
    BEGIN  
        DECLARE @Valid BIT  
        IF ( SELECT COUNT(*)  
             FROM   dbo.T_Receipt_Header AS TRH  
             WHERE  S_ChequeDD_No = @sChequeNo  
					AND Dt_ChequeDD_Date = @ChequeDt
					AND Dt_Crtd_On > DATEADD(minute,30,GETDATE()) 
                    AND I_Status = 1  
           ) > 0   
            BEGIN  
                SET @Valid = 0  
            END  
        ELSE   
            BEGIN  
                SET @Valid = 1  
            END  
         SELECT @Valid  
    END

