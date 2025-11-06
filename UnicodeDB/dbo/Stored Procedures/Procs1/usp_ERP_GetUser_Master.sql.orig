
--exec [dbo].[User_Master_parameters] 
CREATE PROCEDURE [dbo].[usp_ERP_GetUser_Master] 
-- =============================================
-------      Author: Tridip Chatterjee
--      Create date: 13-09-2023
--      Description: Parameters listing for User Master Table
-- =============================================

--      Add the parameters for the stored procedure here
-- =============================================
@User_ID int=null,  
@Username varchar(255)=null,  
@Email varchar(255)=null,  
@Name varchar(255)=null,    
@Mobile varchar(255)=null,  
@Status int =null



AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	
	SET NOCOUNT ON;
	
	select 
	       EU.I_User_ID As ID,
	       S_Username As Username,
		   S_Password As Password,
		   S_Email as Email,
		   S_First_Name as First_Name,
		   S_Middle_Name as Middle_Name,
		   S_Last_Name as Last_Name,
		   ISNULL(S_First_Name,'')+''+ISNULL(S_Middle_Name,' ')+''+ISNULL(S_Last_Name,'') as Name,
		   S_Mobile as MobileNo,
		   EU.I_Status Status,
		   --(Case WHEN I_Status=1 THEN 'ACTIVE' else 'Inactive' end) as Status,
		   EU.I_Created_By AS CrtdBy,
		   EU.Dt_CreatedAt as CrtdOn,
		   EU.Dt_Last_Login as Last_Login,
		   EU.S_Email Email
		    ,EUP.S_EMP_Type EMPType
			,EUP.Dt_DOJ DOJ
			,EUP.Dt_DOB DOB
			,EUP.S_Gender Gender
			,EUP.I_Religion_ID ReligionID
			,EUP.I_Maritial_ID MaritalID
			,EUP.S_Photo Photo
			,EUP.S_Signature Signature
			,EUP.S_PAN PAN
			,EUP.S_Aadhaar Aadhaar
			,EUP.S_Present_Address PresentAddress
			,EUP.S_Permanent_Address PermanentAddress
			,EU.Is_Teaching_Staff
			,EU.Is_Non_Teaching_Staff
			
	
	from 
	
	T_ERP_User  as EU
	left join
	T_ERP_User_Profile as EUP on EU.I_User_ID=EUP.I_User_ID
	
	where 
-- =============================================
     ---Dynamic Parameter Selection
-- =============================================

	
	(EU.I_User_ID =ISNULL(@User_ID,EU.I_User_ID)) 
	and 
	(EU.S_Username =ISNULL(@Username,EU.S_Username)) 
	and 
	(EU.S_Email =ISNULL(@Email,EU.S_Email))
	and 
	(EU.S_First_Name++ISNULL(EU.S_Middle_Name,' ')++EU.S_Last_Name) = ISNULL(@Name,(EU.S_First_Name++ISNULL(EU.S_Middle_Name,' ')++EU.S_Last_Name))
	and 
	(EU.S_Mobile = ISNULL(@Mobile,EU.S_Mobile))
    and 
	(EU.I_Status = ISNULL(@Status,EU.I_Status) )
END
