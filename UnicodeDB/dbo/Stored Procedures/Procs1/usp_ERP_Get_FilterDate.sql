--exec [dbo].[uspGetComponentMaster] 110,1
CREATE PROCEDURE [dbo].[usp_ERP_Get_FilterDate]

AS
BEGIN
select DateFilter_Type Filter,I_Value Value from T_ERP_Filter_Dateformat
END
