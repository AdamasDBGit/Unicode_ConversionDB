CREATE PROCEDURE [dbo].[Student_Subject_Allocation] 
-- =============================================
     -- Author: Tridip Chatterjee
-- Create date: 14-09-2023
-- Description:	Student_Subject_Insert_And_Delete
-- =============================================
-- Add the parameters for the stored procedure here

@StudentDetailID int,
@Session int,
@Group int,
@class int,
@subject nvarchar(400)




AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	
	---- Delete Subject---

	delete from T_ERP_Student_Subject WHERE I_Student_Detail_ID=@StudentDetailID AND
	I_School_Session_ID=@Session AND I_School_Group_ID=@Group AND I_Class_ID=@class
	----AND I_Subject_ID in (select I_Subject_ID from T_Subject_Master where I_Subject_ID in 
        ---              (SELECT Value FROM VALUE_SPLITING(@SUBJECT,',')))

	
	
	
 ------ Insert Subject----	

    insert into T_ERP_Student_Subject (I_Student_Detail_ID,I_School_Session_ID,
	I_School_Group_ID,I_Class_ID,I_Subject_ID,I_CreatedBy) 
	select  @StudentDetailID,@Session,@Group,@class, I_Subject_ID,1 from 
	       T_Subject_Master where I_Subject_ID in
		   (SELECT Value FROM VALUE_SPLITING(@SUBJECT,','))

	
	Exec Student_Subject_Selection @StudentDetailID,@Session,@Group,@Class
    
	




END
