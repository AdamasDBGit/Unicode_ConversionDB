CREATE  PROCEDURE [dbo].[SPCheckExistingInternalStudentRegDetails_SmsDb_INT]
(
    @RegistrationLoginId    varchar(50)
	--@Status            int out
  
	 
)
AS
BEGIN
 
    Declare @UserId INT=0
	Declare @IsPaymentCompleted BIT=1
    
	
	IF(@RegistrationLoginId<>'')
	BEGIN

	   If EXISTS (SELECT 1 FROM T_Student_Detail WHERE S_Student_ID=@RegistrationLoginId AND I_Status=1)
	     BEGIN
	       Select S.I_Student_Detail_ID 
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
	       T_Student_Detail S where S_Student_ID=@RegistrationLoginId
	       AND I_Status=1 

		        --User registered is smsdb
            
	  END	
	  
	  								   
END	
	 	   
	
END
