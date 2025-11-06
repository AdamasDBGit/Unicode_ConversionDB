-- SPGetAllStudentInfoFromSMSDb 466049

CREATE  proc [dbo].[SPGetAllStudentInfoFromSMSDb_INT]

@UserId  int
--@Output  int out  
as
begin



Declare @StudentloginId varchar(50)

      select @StudentloginId=S_Login_ID 
      from T_User_Master 
      where I_User_ID=@UserId  
      AND I_Status=1 
      AND S_User_Type='ST'

	 PRINT(@StudentloginId)
	    If(@StudentloginId <> '')
      Begin
	    IF EXISTS (SELECT 1 FROM T_Student_Detail WHERE S_Student_ID=@StudentloginId AND I_Status=1 )
	    Begin
		PRINT('A')
	       select 
	       [S_Title],
           [S_First_Name],
           [S_Middle_Name],
	       [S_Last_Name],
	       [S_Email_ID],
	       [S_Mobile_No],
	       [S_Curr_Address1],
           [I_Curr_Country_ID],
	       [I_Curr_State_ID],
           [I_Curr_City_ID],
           [S_Curr_Pincode]
	       from T_Student_Detail where  S_Student_ID=@StudentloginId AND I_Status=1
		    -- set @Output=1
		End
		-- Else
		     --set @Output=2
	End

	-- Else 
            -- set @Output=-1
end
