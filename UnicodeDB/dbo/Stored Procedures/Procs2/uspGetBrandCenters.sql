--*********************
--Created By: Debman Mukherjee
--Created Date : 02/03/07
-- Gets all centers for the brands
--**********************


CREATE PROCEDURE [dbo].[uspGetBrandCenters]
 
AS
BEGIN

	select	bc.I_Brand_ID,
			ch.I_Center_Id,
			ch.I_Hierarchy_Detail_ID,
			ch.I_Hierarchy_Master_ID,
			bm.S_Brand_Code,
			bm.S_Brand_Name
		from T_Brand_Center_Details bc
		inner join T_Center_Hierarchy_Details ch
		on bc.I_Centre_Id = ch.I_Center_Id 
		inner join dbo.T_Brand_Master bm
		on bc.I_Brand_ID = bm.I_Brand_ID
		where bc.I_Status <> 0
		and ch.I_Status <> 0
		and bm.I_Status <> 0
		and getdate() >= isnull(bc.Dt_Valid_From, getdate())
		and getdate() <= isnull(bc.Dt_Valid_To, getdate())
		and getdate() >= isnull(ch.Dt_Valid_From, getdate())
		and getdate() <= isnull(ch.Dt_Valid_To, getdate())

END
