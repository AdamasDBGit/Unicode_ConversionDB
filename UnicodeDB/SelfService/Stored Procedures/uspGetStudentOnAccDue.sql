CREATE PROCEDURE [SelfService].[uspGetStudentOnAccDue](@BrandID INT,@mobileNo VARCHAR(MAX))
AS
BEGIN


	/*select DISTINCT A.StudentID,C.S_First_Name+' '+ISNULL(C.S_Middle_Name,'')+' '+C.S_Last_Name as StudentName,C.S_Mobile_No,D.I_Center_ID,D.S_Center_Name 
	from SelfService.T_OnAccount_Due A
	inner join T_Status_Master B on B.I_Status_Value=A.OnAccReceiptTypeID
	inner join T_Student_Detail C on A.StudentID=C.S_Student_ID
	inner join T_Center_Hierarchy_Name_Details D on A.CenterID=D.I_Center_ID
	where
	A.StatusID=1 and A.DueOn<=GETDATE() and A.PaidOn IS NULL and A.ReceiptHeaderID IS NULL
	and A.StudentID=@StudentID and A.BrandID=@BrandID



	select A.*,B.S_Status_Desc
	from SelfService.T_OnAccount_Due A
	inner join T_Status_Master B on B.I_Status_Value=A.OnAccReceiptTypeID
	where
	A.StatusID=1 and A.DueOn<=GETDATE() and A.PaidOn IS NULL and A.ReceiptHeaderID IS NULL
	and A.StudentID=@StudentID and A.BrandID=@BrandID 
	*/
	



	select C.S_Student_ID,A.DueOn,B.S_Status_Desc,A.TotalAmount
	from SelfService.T_OnAccount_Due A
	inner join T_Status_Master B on B.I_Status_Value=A.OnAccReceiptTypeID
	inner join T_Student_Detail C on A.I_Student_Detail_ID=C.I_Student_Detail_ID
	where
	A.StatusID=1 and A.DueOn<=GETDATE() and A.PaidOn IS NULL and A.ReceiptHeaderID IS NULL
	-- and A.I_Student_Detail_ID=@StudentID
	and C.S_Mobile_No = @mobileNo
	and A.BrandID=@BrandID 

END
