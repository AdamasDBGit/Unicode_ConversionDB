-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ECOMMERCE].[TempExistingStudentLMSSMSQueueMap]

	@CustomerID VARCHAR(MAX),
	@EnquiryID INT=0
AS
BEGIN


  	IF((SELECT I_Enquiry_Status_Code FROM dbo.T_Enquiry_Regn_Detail WHERE I_Enquiry_Regn_ID=@EnquiryID)=3)
	BEGIN

		UPDATE LMS.T_Student_Details_Interface_API SET CustomerID=@CustomerID WHERE (ActionType!='STATUS UPDATE' and ActionType!='UPDATE STUDENT') 
		--AND ActionStatus=0 AND StatusID=1 AND (CustomerID='' OR CustomerID IS NULL)
		AND StudentDetailID IN
		(
			SELECT I_Student_Detail_ID FROM dbo.T_Student_Detail WHERE I_Enquiry_Regn_ID=@EnquiryID
		)


	END
END
