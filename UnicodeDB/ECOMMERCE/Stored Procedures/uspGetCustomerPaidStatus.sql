

/*******************************************************
Description : Get E-Project Query List
Author	:     Soma Pal
Date	:	  09-NOV-2022
*********************************************************/

CREATE PROCEDURE [ECOMMERCE].[uspGetCustomerPaidStatus] 
(
	@sCustomerID Nvarchar(20)=null
)

AS

		declare @I_Enquiry_Regn_ID int=null;
		declare @I_Student_Detail_ID int=null;
		declare @sMobileNo Nvarchar(20)=null;


		Select @sMobileNo=TR.MobileNo from [ECOMMERCE].[T_Registration] TR where TR.CustomerID=@sCustomerID and TR.StatusID=1-- '2223000508'--status added by susmita : 2023-Jan-27
		--Select @sMobileNo
		IF (@sMobileNo is not null)
		begin
				Select @I_Enquiry_Regn_ID=TRD.I_Enquiry_Regn_ID from  T_Enquiry_Regn_Detail TRD where TRD.S_Mobile_No=@sMobileNo --'7908075011'
				--Select @I_Enquiry_Regn_ID
				IF (@I_Enquiry_Regn_ID is not null)
				begin
						declare @I_Student_Detail_ID_Temp int=null;
						 Select @I_Student_Detail_ID_Temp= I_Student_Detail_ID from [T_Student_Detail] as x where x.S_Mobile_No=@sMobileNo and x.I_Status=1 --susmitapaul : 2023-jan-27 : add active state

						 IF (@I_Student_Detail_ID_Temp is not null)
							begin

							if Exists(
							select * from 
							ECOMMERCE.T_Registration A
							inner join ECOMMERCE.T_Registration_Enquiry_Map B on A.RegID=B.RegID and B.StatusID=1
							inner join T_Enquiry_Regn_Detail C on B.EnquiryID=C.I_Enquiry_Regn_ID
							inner join T_Student_Detail SD on SD.I_Enquiry_Regn_ID=C.I_Enquiry_Regn_ID
							inner join T_Student_Batch_Details as SBD on SBD.I_Student_ID=SD.I_Student_Detail_ID
							inner join T_Student_Batch_Master as SBM on SBM.I_Batch_ID=SBD.I_Batch_ID 
							where A.CustomerID=@sCustomerID and A.StatusID=1 
							and SBD.I_Status in (1,3)
							)---condition added by susmita Paul: 2023-jan-27
								BEGIN
						
									Select distinct--TR.RegID,TRD.I_Enquiry_Regn_ID,TR.MobileNo,TSD.I_Student_Detail_ID,
									x.I_Course_ID 
									from [ECOMMERCE].[T_Registration] TR 
											left join T_Enquiry_Regn_Detail TRD on TR.MobileNo=TRD.S_Mobile_No
											left join [dbo].[T_Student_Detail]  TSD on  TSD.I_Enquiry_Regn_ID=TRD.I_Enquiry_Regn_ID
											left join (	Select TSM.I_Course_ID,TSBD.I_Student_ID from [dbo].[T_Student_Batch_Details] TSBD
														inner join  [dbo].[T_Student_Batch_Master] TSM  on TSBD.I_Batch_ID=TSM.I_Batch_ID
														inner join  T_Course_Master as CM on CM.I_Course_ID=TSM.I_Course_ID --susmita paul: 2023-feb-06 : added for check condition for Brand
														where TSBD.I_Status in (0,1,2,3)
														and CM.I_Brand_ID in (109)--susmita paul: 2023-feb-06 : added for check condition for Brand
														) x  on x.I_Student_ID=TSD.I_Student_Detail_ID --susmita Paul 2022-12-12 : for getting all assigned or will be assigned batch courses: 2023-jan-27:removing inactivestate
				
									where TR.CustomerID=@sCustomerID    and x.I_Course_ID is not null--'2223000508'--@sCustomerID
								END
							ELSE
								BEGIN
									Select null I_Course_ID --added by susmita : 2023-jan-27
								END
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
