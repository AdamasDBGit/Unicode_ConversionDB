CREATE  Proc [dbo].[SPUpdateInternalStudentRegistrationInfo_INT]

    @MobileNumber    varchar(50),
	@StudentDetailId  int,
	@Output            int out  
	
AS
Begin
Declare @StudentloginId varchar(50)

      select @StudentloginId=S_Student_ID 
      from T_Student_Detail 
      where I_Student_Detail_ID=@StudentDetailId  
      AND I_Status=1 
     
																	  
      If(@StudentloginId <> '')
      Begin
       IF EXISTS (SELECT 1 FROM T_Student_Detail WHERE S_Student_ID=@StudentloginId AND I_Status=1 )
	     Begin
             Update T_Student_Detail 
             Set S_Mobile_No = @MobileNumber,Dt_Upd_On=getdate() where S_Student_ID=@StudentloginId AND I_Status=1 
             set @Output=1
	     End
       Else
		     set @Output=2
      End
      
      Else 
             set @Output=-1
      
End
