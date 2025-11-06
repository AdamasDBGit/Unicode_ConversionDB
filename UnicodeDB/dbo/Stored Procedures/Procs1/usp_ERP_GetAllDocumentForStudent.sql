--exec [usp_ERP_GetAllDocumentForStudent]  237150
CREATE PROCEDURE [dbo].[usp_ERP_GetAllDocumentForStudent]
	(
	@EnquiryID int
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
	t1.I_Document_Type_ID DocumentTypeID,
t1.S_Document_Type_Name DocumentTypeName
,t3.I_IsMandatory Mandatory
,t2.S_Imagepath Imagepath
,ISNULL(t2.Is_verified,0) Verified
,t2.I_Document_StudRegn_ID  DocumentStudRegnID
,t2.Is_Active IsActive
,t2.I_Seq_No Sequence
,t3.S_Document_Category_Name CategoryName
,t3.I_Document_Category_ID CategoryID
from [T_ERP_Document_Type_Master] t1
inner join T_ERP_Document_Category t3 on t3.I_Document_Category_ID=t1.I_Document_Category_ID
left join T_ERP_Document_Student_Map t2 on t2.R_I_Document_Type_ID=t1.I_Document_Type_ID and t2.R_I_Enquiry_Regn_ID=@EnquiryID
order by t3.I_Document_Category_ID asc
--Where t2.Is_Active = 1 and t2.R_I_Enquiry_Regn_ID=@EnquiryID

END
