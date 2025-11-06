CREATE PROCEDURE [dbo].[uspUpdateEnquiryRelevence]
(
@sEnquiryNo NVARCHAR(MAX),
@UpdBy NVARCHAR(MAX)
)
AS
BEGIN
	CREATE TABLE #temp
	(
	EnquiryNo INT
	)
	INSERT INTO #temp
	        ( EnquiryNo )
	SELECT * FROM dbo.fnString2Rows(@sEnquiryNo,',') FSR
	
	
	IF ((SELECT COUNT(*) FROM #temp)>0)
	BEGIN
		UPDATE dbo.T_Enquiry_Regn_Detail SET I_Relevence_ID=1-I_Relevence_ID,S_Upd_By=@UpdBy,Dt_Upd_On=GETDATE() WHERE I_Enquiry_Regn_ID IN
		(
		SELECT EnquiryNo FROM #temp T
		)
	END
	
END

