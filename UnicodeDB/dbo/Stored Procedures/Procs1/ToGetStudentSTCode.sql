CREATE PROCEDURE [dbo].[ToGetStudentSTCode]
-- =============================================
     -- Author: Tridip Chatterjee
-- Create date: 29-09-2023
-- Description:	To get Student ST Code
-- =============================================
-- Add the parameters for the stored procedure here
@BrandName nvarchar(400)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	
	SET NOCOUNT ON;

select distinct TSD.S_Student_ID, ('ST'++convert(varchar, TSD.I_Student_Detail_ID))As STCode,

(TSD.S_First_Name+' '+ISnull (TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name)As Name,
TSD.S_OrgEmailID,
(case when TSD.I_Status=1 then 'Active' else 'Inactive'end ) ST_Status

from T_Student_Detail TSD
left join T_Student_Center_Detail TSCD on TSD.I_Student_Detail_ID=TSCD.I_Student_Detail_ID
left join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TSCD.I_Centre_ID
where I_Brand_ID in (select dbo.BrandValurTC(@BrandName)) and TSD.I_Status=1 and TSCD.I_Status=1 



END
