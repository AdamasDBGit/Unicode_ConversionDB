

/*******************************************************
Description : Get E-Project Query List
Author	:     Soma Pal
Date	:	  09-NOV-2022
*********************************************************/

CREATE PROCEDURE [ECOMMERCE].[uspGetCustomerPaidStatus_BKPFEB2023] 
(
	@sCustomerID Nvarchar(20)=null
)

AS

		declare @I_Enquiry_Regn_ID int=null;
		declare @I_Student_Detail_ID int=null;
		declare @sMobileNo Nvarchar(20)=null;


		Select @sMobileNo=TR.MobileNo from [ECOMMERCE].[T_Registration] TR where TR.CustomerID=@sCustomerID-- '2223000508'--
		--Select @sMobileNo
		IF (@sMobileNo is not null)
		begin
				Select @I_Enquiry_Regn_ID=TRD.I_Enquiry_Regn_ID from  T_Enquiry_Regn_Detail TRD where TRD.S_Mobile_No=@sMobileNo --'7908075011'
				--Select @I_Enquiry_Regn_ID
				IF (@I_Enquiry_Regn_ID is not null)
				begin
						declare @I_Student_Detail_ID_Temp int=null;
						 Select @I_Student_Detail_ID_Temp= I_Student_Detail_ID from [T_Student_Detail] as x where x.S_Mobile_No=@sMobileNo

						 IF (@I_Student_Detail_ID_Temp is not null)
						begin


						
						Select distinct--TR.RegID,TRD.I_Enquiry_Regn_ID,TR.MobileNo,TSD.I_Student_Detail_ID,
						x.I_Course_ID 
						from [ECOMMERCE].[T_Registration] TR 
								left join T_Enquiry_Regn_Detail TRD on TR.MobileNo=TRD.S_Mobile_No
								left join [dbo].[T_Student_Detail]  TSD on  TSD.I_Enquiry_Regn_ID=TRD.I_Enquiry_Regn_ID
								left join (	Select TSM.I_Course_ID,TSBD.I_Student_ID from [dbo].[T_Student_Batch_Details] TSBD
											inner join  [dbo].[T_Student_Batch_Master] TSM  on TSBD.I_Batch_ID=TSM.I_Batch_ID
											where TSBD.I_Status in (0,1,2,3)) x  on x.I_Student_ID=TSD.I_Student_Detail_ID --susmita Paul 2022-12-12 : for getting all assigned or will be assigned batch courses
				
						where TR.CustomerID=@sCustomerID    and x.I_Course_ID is not null--'2223000508'--@sCustomerID

						end 
						else
						begin
							Select null I_Course_ID
						end

						--Select  @I_Student_Detail_ID =TSD.I_Student_Detail_ID from [dbo].[T_Student_Detail] TSD where  TSD.I_Enquiry_Regn_ID=@I_Enquiry_Regn_ID
						--IF (@I_Student_Detail_ID is not null)
						--begin

						--		Select TSM.I_Course_ID from [dbo].[T_Student_Batch_Details] TSBD
						--		inner join  [dbo].[T_Student_Batch_Master] TSM  on TSBD.I_Batch_ID=TSM.I_Batch_ID
						--		where TSBD.I_Student_ID=-@I_Student_Detail_ID and TSBD.I_Status=1

						--end
						--else
						--begin
						--		Select null I_Course_ID
						--end
						
				end
				else  
				begin
					Select null I_Course_ID
				end
		End
		else
		begin
				Select null I_Course_ID
		end
