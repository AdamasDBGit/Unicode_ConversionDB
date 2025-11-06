
CREATE PROCEDURE [LMS].[uspInsertEnquiryDataForInterface_BKP_SEP]
(
	@EnquiryID INT,
	@ActionType VARCHAR(MAX)
)
AS
BEGIN

	IF NOT EXISTS(select * from ECOMMERCE.T_Registration_Enquiry_Map where StatusID=1 and EnquiryID=@EnquiryID)
	BEGIN
		
		insert into LMS.T_Enquiry_Customer_Interface
		select A.I_Enquiry_Regn_ID,A.S_First_Name+' '+ISNULL(A.S_Middle_Name,'')+' '+A.S_Last_Name,A.S_Mobile_No,A.S_Email_ID,@ActionType,0,0,1,GETDATE(),NULL,NULL,NULL
		from T_Enquiry_Regn_Detail A
		inner join T_Center_Hierarchy_Name_Details B on A.I_Centre_Id=B.I_Center_ID
		where
		A.I_Enquiry_Regn_ID=@EnquiryID and B.I_Brand_ID=109

	END

END
