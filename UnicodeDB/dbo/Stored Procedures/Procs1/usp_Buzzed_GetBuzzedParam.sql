-- =============================================
-- Author:		<Arijit Manna>
-- Create date: <18-09-23>
-- Description:	<Get buzzed class id by sms erp class id>
--exec [dbo].[usp_Buzzed_GetBuzzedParam] '04-0124'
-- =============================================
CREATE PROCEDURE [dbo].[usp_Buzzed_GetBuzzedParam]
	-- Add the parameters for the stored procedure here
	@ErpId NVARCHAR(MAX),
	@erpayid int=null
AS
BEGIN
DECLARE @buzzedClassId int
DECLARE @buzzedAyId int
DECLARE @buzzedSectionID int

DECLARE @studentDetailID int
DECLARE @smsClassId int 
set @studentDetailID = (select I_Student_Detail_ID from T_Student_Detail where S_Student_ID = @ErpId)
set @smsClassId = (select  t2.I_Class_ID from T_Student_Class_Section t1 inner join T_School_Group_Class t2 On t2.I_School_Group_Class_ID = t1.I_School_Group_Class_ID
where I_Student_Detail_ID = @studentDetailID)
	set @buzzedClassId =
	(select 
	id 
	from [dbo].T_buzzedDB_class_masters where erp_class_id= @smsClassId
	)

	select @buzzedClassId ClassID,1 SessionID,null SectionID
END

--select * from T_buzzedDB_class_section_masters

