-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <>
-- Description:	<to get the class>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetFineRangeTagID]
	
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select FRD.I_FineRangeTagID as FineRangeTagID,
FRD.S_Fine_Range_Code as RangeCode
from T_ERP_Fee_FineRangeDetails as FRD
	END
