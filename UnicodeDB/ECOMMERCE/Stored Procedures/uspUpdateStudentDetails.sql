
-- =============================================
-- Author:		<susmita/soma >
-- Create date: <2022-11-10>
-- Description:	<update student details both free and paid students>
-- =============================================
CREATE PROCEDURE [ECOMMERCE].[uspUpdateStudentDetails] 
	@CustomerID varchar(max),
    @FirstName varchar(max) = NULL,
	@LastName varchar(max) = NULL,
    @HighestEducationQualification varchar(max) = NULL,
    @Gender varchar(max) =NULL,
    @DoB DATETIME = NULL,
    @City varchar(max) = NULL,
    @State varchar(max) = NULL,
	@Pincode varchar(max) = NULL,
	@SecondLanguage varchar(max) = NULL,
	@SocialCategory varchar(max) = NULL,
	@GuardianName varchar(max) = NULL,
    @GuardianMobileNo varchar(max) = NULL,
	@iBrandID int=null


AS
BEGIN


	
	SET NOCOUNT ON;

	--- update Ecom Registration Details 
	
	Declare @iRegID Int=null
	Declare @RAge Nvarchar(10)=Null --added by susmita
	Select @iRegID=TR.RegID  from ECOMMERCE.T_Registration TR where TR.CustomerID=@CustomerID and StatusID=1-- '2223000508'--
		--Select @@iRegID
		IF (@iRegID is not null)
			begin
				IF (@FirstName is not null)
					begin
						update	T_Registration set FirstName=@FirstName 
						where CustomerID=@CustomerID
					end
				IF (@LastName is not null)
					begin
						update	T_Registration set LastName=@LastName
						where CustomerID=@CustomerID
					end

				SET @RAge=(CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),@DoB,112))/10000 --added by susmita
				IF (@DoB is not null and @RAge is not null and @RAge > 0)--add age condition by susmita
					begin
						update	T_Registration set DateofBirth=@DoB 
						where CustomerID=@CustomerID
					end
				--added by susmita : 2022- 11-23 : for paid student data not be updated
				IF NOT EXISTS(Select I_Enquiry_Regn_ID from T_Enquiry_Regn_Detail where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1))
				BEGIN
				IF (@Pincode is not null)
					begin
						update	T_Registration set Pincode=@Pincode 
						where CustomerID=@CustomerID
					end

				END
				--added by susmita : 2022- 11-23 : for paid student data not be updated
				IF (@Gender is not null)
					begin
						update	T_Registration set Gender=@Gender 
						where CustomerID=@CustomerID
					end
				IF (@HighestEducationQualification is not null)
					begin
						update	T_Registration set HighestEducationQualification=@HighestEducationQualification
						where CustomerID=@CustomerID
					end

				--added by susmita : 2022- 11-23 : for paid student data not be updated
				IF NOT EXISTS(Select I_Enquiry_Regn_ID from T_Enquiry_Regn_Detail where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1))
				BEGIN
					IF (@City is not null)
						begin
							update	T_Registration set City=@City,Address=@City -- Susmita : 2022-11-23 hot fix : added for address update
							where CustomerID=@CustomerID
						end
					IF (@State is not null)
						begin
							update	T_Registration set State=@State 
							where CustomerID=@CustomerID
						end
				END
				--added by susmita : 2022- 11-23 : for paid student data not be updated
				IF (@GuardianName is not null)
					begin
						update	T_Registration set GuardianName=@GuardianName 
						where CustomerID=@CustomerID
					end
				IF (@GuardianMobileNo is not null)
					begin
						update	T_Registration set GuardianMobileNo=@GuardianMobileNo
						where CustomerID=@CustomerID
					end
				IF (@SecondLanguage is not null)
					begin
						update	T_Registration set SecondLanguage=@SecondLanguage
						where CustomerID=@CustomerID
					end
				IF (@SocialCategory is not null)
					begin
						update	T_Registration set SocialCategory=@SocialCategory
						where CustomerID=@CustomerID
					end

				select CustomerID,RegID from 
				ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1

			end
		else
			begin
				Select null CustomerID ,null RegID
			end


--- update Enquiry Registration Details

	Declare @iEnquiry_Regn_ID_Count Int=null
	Declare @Age Nvarchar(10)=Null

	CREATE TABLE #tblI_Enquiry_Regn_ID 
	(
	iI_Enquiry_Regn_ID Int
	) -- added by susmita
	--Declare @tblI_Enquiry_Regn_ID table ( iI_Enquiry_Regn_ID Int)

	
	insert into  #tblI_Enquiry_Regn_ID  
	Select I_Enquiry_Regn_ID from T_Enquiry_Regn_Detail 
	where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)		--'2223000508')--


	Select @iEnquiry_Regn_ID_Count= count(iI_Enquiry_Regn_ID) from #tblI_Enquiry_Regn_ID

	IF (@iEnquiry_Regn_ID_Count > 0) --modified from <> to >

		begin

			IF (@FirstName is not null)
			begin
				update	T_Enquiry_Regn_Detail set S_First_Name=@FirstName
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			end
			IF (@LastName is not null)
			begin
				update	T_Enquiry_Regn_Detail set S_Last_Name=@LastName
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			end
			IF (@GuardianName is not null)
			begin
				update	T_Enquiry_Regn_Detail set S_Guardian_Name=@GuardianName
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			end
			IF (@DoB is not null)
				begin
					SET @Age=(CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),@DoB,112))/10000
					IF (@Age is not null and @Age > 0) --added by susmita
						begin
							update	T_Enquiry_Regn_Detail set Dt_Birth_Date=cast(@DoB as date)
							where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
						end
				end

			IF (@GuardianMobileNo is not null)
			begin
				update	T_Enquiry_Regn_Detail set S_Guardian_Mobile_No=@GuardianMobileNo
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			end
			
			IF (@Age is not null and @Age > 0)
			begin
				update	T_Enquiry_Regn_Detail set S_Age=@Age
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			end

			Declare @iHighestQualificationId int		   			 
			IF (@HighestEducationQualification is not null and @HighestEducationQualification<>'')
				begin
				
					declare @iI_Enquiry_Regn_ID_Local int
					select @iHighestQualificationId= E.I_Education_CurrentStatus_ID from T_Education_CurrentStatus E	where E.S_Education_CurrentStatus_Description=@HighestEducationQualification and E.I_Status=1 and E.I_Brand_ID=isnull(@iBrandID,109) 
					IF (@iHighestQualificationId is not null)
						begin
							update T_Enquiry_Education_CurrentStatus  set I_Education_CurrentStatus_ID=@iHighestQualificationId,S_Upd_By=I_Enquiry_Regn_ID where I_Enquiry_Regn_ID in (select iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID ) 
					
						end
					else
						begin
					
							select top 1  @iI_Enquiry_Regn_ID_Local=  iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID
							insert into T_Education_CurrentStatus (S_Education_CurrentStatus_Description,I_Status,S_Crtd_By,Dt_Crtd_On,I_Brand_ID) values ( @HighestEducationQualification,1,@iI_Enquiry_Regn_ID_Local,Getdate(),isnull(@iBrandID,109))

							SET @iHighestQualificationId=SCOPE_IDENTITY()
					
							IF (@iHighestQualificationId is not null)
								begin
									update T_Enquiry_Education_CurrentStatus  set I_Education_CurrentStatus_ID=@iHighestQualificationId,S_Upd_By=I_Enquiry_Regn_ID where I_Enquiry_Regn_ID in (select iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID )
								end
						end
				end



			Declare @iI_Curr_Country_ID int =null
			Declare @iI_State_ID int =null
			Declare @iI_City_ID int =null

			---*** start of comment by susmita 2022-11-23 for disable paid user city/state update
		
			--if (@State is not null and @State<>'')
			--begin
			--	select top 1  @iI_Curr_Country_ID=  I_Curr_Country_ID from T_Enquiry_Regn_Detail 
			--	where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID  and StatusID=1)
			
			--	--select @iI_State_ID= S.I_State_ID from T_State_Master S	where S.I_Country_ID=@iI_Curr_Country_ID  and S.S_State_Name=SUBSTRING(@State,0,3)
			--	select TOP 1 @iI_State_ID= S.I_State_ID from T_State_Master S	where S.I_Country_ID=@iI_Curr_Country_ID  and S.S_State_Name=@State and S.I_Status=1 order by S.S_State_Name ---susmita paul 2022-11-23: hot fix : from SUBSTRING(@State,0,3) to state
			--	if (@iI_State_ID is not null)
			--	begin
			--		update T_Enquiry_Regn_Detail  set I_Curr_State_ID=@iI_State_ID,I_Perm_State_ID=@iI_State_ID where I_Enquiry_Regn_ID in (select iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID ) --susmita 2022-11-23 :hot fix: permanent Id added
			--	end
			--	else
			--	begin
			--		select top 1  @iI_Enquiry_Regn_ID_Local=  iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID
					
			--		INSERT INTO T_State_Master 
			--		SELECT SUBSTRING(@State,0,3),@State,@iI_Curr_Country_ID,1,@iI_Enquiry_Regn_ID_Local,NULL,GETDATE(),NULL
					
			--		SET @iI_State_ID=SCOPE_IDENTITY()
				
			--		update T_Enquiry_Regn_Detail  set I_Curr_State_ID=@iI_State_ID,I_Perm_State_ID=@iI_State_ID where I_Enquiry_Regn_ID in (select iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID ) --susmita 2022-11-23 :hot fix: permanent Id added

			--	end
				
			--end
			----city
			--if (@City is not null and @City<>'') --modify by susmita from = to <>
			--begin
			--	select top 1  @iI_Curr_Country_ID=  I_Curr_Country_ID from T_Enquiry_Regn_Detail where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			--	--select @iI_City_ID= C.I_City_ID from T_City_Master C where C.I_Country_ID=@iI_Curr_Country_ID and C.I_State_ID=@iI_State_ID and C.S_City_Name=SUBSTRING(@City,0,3)
			--	select Top 1 @iI_City_ID= C.I_City_ID from T_City_Master C where C.I_Country_ID=@iI_Curr_Country_ID and C.I_State_ID=@iI_State_ID and C.S_City_Name=@City and C.I_Status = 1 order by C.S_City_Name---susmita paul 2022-11-23: hot fix : from SUBSTRING(@city,0,3) to @City
			--	if (@iI_City_ID is not null)
			--	begin
			--		update T_Enquiry_Regn_Detail  set I_Curr_City_ID=@iI_City_ID,I_Perm_City_ID=@iI_City_ID,S_Perm_Address1=@City,S_Curr_Address1=@City where I_Enquiry_Regn_ID in (select iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID ) --susmita paul 2022-11-23 : hot fix for updating address as well and permanent as well
			--	end
			--	else
			--	begin
			--		select top 1 @iI_Enquiry_Regn_ID_Local= iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID
			--		INSERT INTO dbo.T_City_Master(S_City_Code,S_City_Name,I_Country_ID,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,I_State_ID)
			--		VALUES(SUBSTRING(@City,0,3),@City,@iI_Curr_Country_ID,1,@iI_Enquiry_Regn_ID_Local,NULL,GETDATE(),NULL,@iI_State_ID)
			--		SET @iI_City_ID=SCOPE_IDENTITY()
			--		update T_Enquiry_Regn_Detail set I_Curr_City_ID=@iI_City_ID,I_Perm_City_ID=@iI_City_ID,S_Perm_Address1=@City,S_Curr_Address1=@City where I_Enquiry_Regn_ID in (select iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID ) --susmita paul 2022-11-23 : hot fix for updating address as well and permanent as well
			--	end			
			--end


			----added by susmita
			--IF (@Pincode is not null)
			--begin
			--	update T_Enquiry_Regn_Detail  set S_Curr_Pincode=@Pincode,S_Perm_Pincode=@Pincode where I_Enquiry_Regn_ID in (select iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID ) --susmita paul 2022-11-23 : hot fix: add perm pincode
			--end

			--- *** end of comment by susmita 2022-11-23 for disable paid user city/state update

			DECLARE @SocialCategoryID INT = null

			IF (@SocialCategory is not null)
			begin
				select @SocialCategoryID=I_Caste_ID from T_Caste_Master  where S_Caste_Name=@SocialCategory and I_Status=1 --added by Soma
				if(@SocialCategoryID > 0 and @SocialCategoryID IS NOT NULL)
					begin
						update T_Enquiry_Regn_Detail  set I_Caste_ID=@SocialCategoryID where I_Enquiry_Regn_ID in (select iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID )
					end
				else --as per sms standard flow
					begin
						if(@SocialCategoryID IS NULL)
							begin
								update T_Enquiry_Regn_Detail  set I_Caste_ID=NULL where I_Enquiry_Regn_ID in (select iI_Enquiry_Regn_ID from #tblI_Enquiry_Regn_ID )
							end
					end
			end


			--added by susmita


			select I_Enquiry_Regn_ID from T_Enquiry_Regn_Detail 
			where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)


			-------------------------------------FOR STUDENT DETAIL UPDATE ( T_Student_Detail )------------------------------
			IF (@FirstName is not null and @FirstName<>'' )
			begin
				update	T_Student_Detail set S_First_Name=@FirstName
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID  and StatusID=1)
			end
			IF (@LastName is not null and @LastName<>'' )
			begin
				update	T_Student_Detail set S_Last_Name=@LastName
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID  and StatusID=1)
			end
			IF (@GuardianName is not null and @GuardianName<>'')
			begin
				update	T_Student_Detail set S_Guardian_Name=@GuardianName
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			end
			IF (@DoB is not null)
			begin
				SET @Age=(CONVERT(int,CONVERT(char(8),GETDATE(),112))-CONVERT(char(8),@DoB,112))/10000
				update	T_Student_Detail set Dt_Birth_Date=cast(@DoB as date)
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			end

			IF (@GuardianMobileNo is not null and @GuardianMobileNo<>'')
			begin
				update	T_Student_Detail set S_Guardian_Mobile_No=@GuardianMobileNo
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			end
			
			IF (@Age is not null and @Age<>0)
			begin
				update	T_Student_Detail set S_Age=@Age
				where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID  and StatusID=1)
			end
			--commented by susmita as it throw error of foreign key in PROD and it will not required : 2022-11-18
			--IF (@iHighestQualificationId is not null)
			--begin
			--	update	T_Student_Detail set I_Qualification_Name_ID=@iHighestQualificationId
			--	where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			--end
			--commented by susmita as it throw error of foreign key in PROD and it will not required : 2022-11-18

			---****** start of comment by susmita 2022-11-23 for disable paid user city/state update

				--IF (@iI_State_ID is not null and @iI_State_ID > 0)--add > by susmita instead of =
				--begin
				--	update	T_Student_Detail set I_Curr_State_ID=@iI_State_ID,I_Perm_State_ID=@iI_State_ID --susmita 2022-11-23 :hot fix: permanent Id added
				--	where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
				--end
				--IF (@iI_City_ID is not null and @iI_City_ID > 0)--add > by susmita instead of =
				--begin
				--	update	T_Student_Detail set I_Curr_City_ID=@iI_City_ID,I_Perm_City_ID=@iI_City_ID,S_Curr_Address1=@City,S_Perm_Address1=@City -- Susmita : 2022-11-23 hot fix : added for address update add permanent city id
				--	where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
				--end


			
				----added by susmita
				--IF (@Pincode is not null)
				--begin
				--	update	T_Student_Detail set S_Curr_Pincode=@Pincode,S_Perm_Pincode=@Pincode  --susmita 2022-11-23 :hot fix: permanent Id added
				--	where S_Mobile_No = (select MobileNo from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
				--end


			--- ********end of comment by susmita 2022-11-23 for disable paid user city/state update

			--added by susmita

			select S_Student_ID from T_Student_Detail 
								where S_Mobile_No = (select MobileNo from 
								ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
		-------------------------------------END----------------------------------------------


		end
		else
		begin
			select null I_Enquiry_Regn_ID
			select null S_Student_ID
		end


END
