--SPCheckExistingInternalStudentRegDetails '1819/RICE/874'
CREATE  PROCEDURE [dbo].[SPCheckExistingInternalStudentRegDetails_INT]
(
    @RegistrationLoginId    varchar(50) 
	 
	 
)
AS
BEGIN
 
    Declare @UserId INT=0
	Declare @IsPaymentCompleted BIT=1
    --Select @UserId=I_User_ID from T_User_Master Where S_Login_ID=@RegistrationLoginId 
	   --                                   					      AND I_Status=1	
				--												  AND S_User_Type='ST'
	
	IF(@RegistrationLoginId<>'')
	BEGIN
	  Select I_Student_Detail_ID
	  ,[S_Student_Id]
	  ,[S_Title]
      ,[S_First_Name]
      ,[S_Middle_Name]
	  ,[S_Last_Name]
	  ,[S_Email_ID]
	  ,[S_Mobile_No]
	  ,[S_Curr_Address1]
      ,[I_Curr_Country_ID]
	  ,[I_Curr_State_ID]
      ,[I_Curr_City_ID]
      ,[S_Curr_Pincode]
	   FROM
	  
	
	   T_Student_Detail  where S_Student_ID=@RegistrationLoginId
	   AND I_Status=1 
	END									   
		
	 			   
	--IF(	@UserId>0)
	--BEGIN
	
	--  Select U.I_User_ID
	--  ,U.S_Login_ID
	--  ,U.S_Password
	--  ,U.S_Title
	--  ,U.S_First_Name
	--  ,U.S_Middle_Name
	--  ,U.S_Last_Name
	--  ,U.S_Email_ID
	--  ,U.S_User_Type
	--  ,U.Dt_Date_Of_Birth
	--  ,U.I_Status
	--  ,U.S_Forget_Pwd_Qtn
	--  ,U.S_Forget_Pwd_Answer
	--  ,U.B_Force_Password_Change
	--  ,S.S_Mobile_No
	--   FROM
	--  T_User_Master U
	
	--  LEFT JOIN T_Student_Detail S ON U.S_Login_ID=S.S_Student_ID
	--  Where U.I_User_ID=@UserId 
	--END								   	 
			
END
