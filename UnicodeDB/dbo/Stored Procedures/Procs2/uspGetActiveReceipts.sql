-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetActiveReceipts]   
	-- Add the parameters for the stored procedure here
	@StudentDetailsID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select SD.S_Student_ID,SD.I_Student_Detail_ID,
	LTRIM(ISNULL(SD.S_First_Name, '') + ' ')
                + LTRIM(ISNULL(SD.S_Middle_Name, '') + ' '
                        + ISNULL(SD.S_Last_Name, '')) as FullName ,
	RH.I_Receipt_Header_ID,RH.S_Receipt_No
	from T_Student_Detail SD with (nolock) 
	inner join
	T_Receipt_Header as RH  with (nolock) on SD.I_Student_Detail_ID=RH.I_Student_Detail_ID
	where SD.I_Student_Detail_ID=@StudentDetailsID and RH.I_Status=1

	union 

	select SD.S_Student_ID,SD.I_Student_Detail_ID,
	LTRIM(ISNULL(SD.S_First_Name, '') + ' ')
                + LTRIM(ISNULL(SD.S_Middle_Name, '') + ' '
                        + ISNULL(SD.S_Last_Name, '')) as FullName ,
	RH.I_Receipt_Header_ID,RH.S_Receipt_No
	from T_Student_Detail SD with (nolock) 
	inner join
	T_Enquiry_Regn_Detail as ERD with (nolock) on ERD.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID
	inner join
	T_Receipt_Header as RH  with (nolock) on ERD.I_Enquiry_Regn_ID=RH.I_Enquiry_Regn_ID 
	where SD.I_Student_Detail_ID=@StudentDetailsID and RH.I_Status=1


END
