CREATE  PROCEDURE [dbo].[SPCheckExistingInternalStudentRegistration_SmsDb_INT]
(
    @mobileNo  varchar(50),
    @RegistrationLoginId    varchar(50),
	@Status            int out,
    @Message           nvarchar(100) out
	 
)
AS
BEGIN
 
    Declare @UserId INT=0
	Declare @IsPaymentCompleted BIT=1
    
	
	IF(@RegistrationLoginId<>'')
	BEGIN

	   If EXISTS (SELECT 1 FROM T_Student_Detail WHERE S_Student_ID=@RegistrationLoginId AND I_Status=1)
	      BEGIN
		        --User registered is smsdb
				SET @Status=1
                
	      END	

    If NOT EXISTS (SELECT 1 FROM T_Student_Detail WHERE S_Mobile_No=@MobileNo AND  I_Status=1)
            Begin

			      SET @Status=-2 --mobile number is not registered
				  SET @Message = 'Mobile number is not registered'  
            End
	  --ELSE

	  --     BEGIN
		 --       --User not registered is smsdb
			--	SET @Status=-1
                
	  --      END	

	  If NOT EXISTS (SELECT 1 FROM T_Student_Detail WHERE S_Student_ID=@RegistrationLoginId AND I_Status=1)
            Begin

			      SET @Status=-1
			        SET @Message = 'Invalid User'      
          
            End
	  								   
END	
	 	   
	
END
