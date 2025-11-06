-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [usp_GetAllSourseInfo] 9
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAllSourseInfo]
(@EnquiryTypeID int = null)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	t1.I_Info_Source_ID
	,t1.S_Info_Source_Name
	,t1.Is_Show_c
	,t1.Is_DropdownReq
	,t1.S_CRM_Input
	,t2.I_EnqType_Source_Mapping_ID
	FROM [dbo].[T_Information_Source_Master] t1
	inner join T_ERP_EnqType_Source_Mapping t2 ON t1.I_Info_Source_ID = t2.I_Info_Source_ID
	where t1.I_ERP_Status = 1 and t2.I_Enquiry_Type_ID = ISNULL(@EnquiryTypeID,t2.I_Enquiry_Type_ID)
END
