CREATE PROCEDURE [ERP].[uspUploadOracleReconData]
(
@OU VARCHAR(MAX),
@MonthYear VARCHAR(MAX),
@Type VARCHAR(MAX),
@AccCode INT,
@AccDesc VARCHAR(MAX),
@Amount DECIMAL(14,2)
)

AS

BEGIN

IF EXISTS (SELECT * FROM ERP.T_SMS_Oracle_Recon_Result AS TSORR WHERE TSORR.BrandName=@OU AND TSORR.MonthYear=@MonthYear AND [TSORR].[Type]=@Type AND TSORR.AccCode=@AccCode AND TSORR.AccDesc=@AccDesc)

BEGIN

UPDATE ERP.T_SMS_Oracle_Recon_Result SET OracleAmount=@Amount,Status=1 WHERE BrandName=@OU AND MonthYear=@MonthYear AND [Type]=@Type AND AccCode=@AccCode AND AccDesc=@AccDesc

END

ELSE

BEGIN

INSERT INTO ERP.T_SMS_Oracle_Recon_Result
        ( BrandName ,
          MonthYear ,
          Type ,
          AccCode ,
          AccDesc ,
          OracleAmount ,
          SMSAmount ,
          DifferenceAmount ,
          CreatedOn ,
          Status
        )
VALUES  ( '' , -- BrandName - varchar(max)
          '' , -- MonthYear - varchar(max)
          '' , -- Type - varchar(50)
          0 , -- AccCode - int
          '' , -- AccDesc - varchar(max)
          NULL , -- OracleAmount - decimal
          NULL , -- SMSAmount - decimal
          NULL , -- DifferenceAmount - decimal
          GETDATE() , -- CreatedOn - datetime
          0  -- Status - int
        )

END




END
