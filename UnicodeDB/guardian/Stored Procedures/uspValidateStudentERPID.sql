-- =============================================
-- Author:		<Parichoy Nandi	>
-- Create date: <21st August 2023>
-- Description:	<for validating student erp id>
-- exec [guardian].[uspValidateStudentERPID] '11-0012'
-- =============================================
CREATE PROCEDURE [guardian].[uspValidateStudentERPID] 
	-- Add the parameters for the stored procedure here
	@StudentID varchar(50)  
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 1
	 t1.I_Student_Detail_ID StudentDetailID
	, t1.S_Student_ID StudentID
	,ISNULL( t1.S_First_Name,'')+' '+ISNULL( t1.S_Middle_Name,'')+' '+ISNULL( t1.S_Last_Name,'') Name
	, t1.S_Mobile_No MobileNo
	, t1.S_Phone_No PhonenNo
	,t1.I_buzzedDB_Slot_ID  SlotID
	, case when t2.S_Student_ID is null then 0
	else 1 end as IsBuzzed
	from T_Student_Detail t1 
	left join T_Student_Parent_Maps t2 on t1.S_Student_ID = t2.S_Student_ID
	where  t1.S_Student_ID=@StudentID
END
