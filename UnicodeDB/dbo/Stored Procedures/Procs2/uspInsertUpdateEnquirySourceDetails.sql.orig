-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Nov-21>
-- Description:	<Save Enquiry Source Details>
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertUpdateEnquirySourceDetails] 
	-- Add the parameters for the stored procedure here
	@iinfoSourceId INT,
	@iEnquiryId INT,
	@sRefererName varchar(max)=null,
	@sRefererMobileNo varchar(20)=null,
	@sCreatedBy varchar(max) = null,
	@sUpdatedBy varchar(max) = null,
	@dt_CreatedAt datetime = null,
	@dt_UpdatedAt datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	if not exists(select * from Enquiry_Source_Details where I_Enquiry_ID=@iEnquiryId)
	BEGIN

		insert into Enquiry_Source_Details
				(
				I_Info_Source_ID,
				I_Enquiry_ID,
				S_Referer_Name,
				S_Referer_Mobile_No,
				I_Status,
				S_Created_By,
				Dt_Created_At
				)
				select @iinfoSourceId,@iEnquiryId,@sRefererName,@sRefererMobileNo,1,@sCreatedBy,GETDATE()

	
	END

	ELSE
	BEGIN

			
			if Exists(select * from Enquiry_Source_Details where I_Enquiry_ID=@iEnquiryId and I_Info_Source_ID=@iinfoSourceId and I_Status=1)
			BEGIN

				update Enquiry_Source_Details set S_Referer_Name=@sRefererName,S_Referer_Mobile_No=@sRefererMobileNo
				,S_Updated_By=@sUpdatedBy,Dt_Updated_At=GETDATE()
				where I_Enquiry_ID=@iEnquiryId and I_Info_Source_ID=@iinfoSourceId and I_Status=1 

			END

		else

			BEGIN


				update Enquiry_Source_Details set I_Status=0
				,S_Updated_By=@sUpdatedBy,Dt_Updated_At=GETDATE()
				where I_Enquiry_ID=@iEnquiryId

				insert into Enquiry_Source_Details
				(
				I_Info_Source_ID,
				I_Enquiry_ID,
				S_Referer_Name,
				S_Referer_Mobile_No,
				I_Status,
				S_Created_By,
				Dt_Created_At
				)
				select @iinfoSourceId,@iEnquiryId,@sRefererName,@sRefererMobileNo,1,@sCreatedBy,GETDATE()


			END
	


	END




END
