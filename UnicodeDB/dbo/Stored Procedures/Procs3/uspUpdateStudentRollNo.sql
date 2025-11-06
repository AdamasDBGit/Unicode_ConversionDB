CREATE PROC [dbo].[uspUpdateStudentRollNo] --'G-68','Coochbehar',29
(
	@sBatchName NVARCHAR(MAX),
	@sCenterName NVARCHAR(MAX),
	@iStudentRollNo INT
)
as 
BEGIN
	declare @iCenterID INT,@iStudentID INT
	select @iCenterID = I_Centre_Id from T_Centre_Master where S_Center_Name like @sCenterName+'%'
	
	
	select @iStudentID = B.I_Student_Detail_ID from T_Student_Batch_Details A
inner join T_Student_Detail B
on A.I_Student_ID = B.I_Student_Detail_ID
where I_Batch_ID IN 
(
select A.I_Batch_ID from T_Student_Batch_Master A
inner join T_Center_Batch_Details B
on A.I_Batch_ID = B.I_Batch_ID
where S_Batch_Name IN (
@sBatchName
)
and I_Centre_Id  =@iCenterID
)

UPDATE dbo.T_Student_Detail SET I_RollNo = @iStudentRollNo WHERE I_Student_Detail_ID = @iStudentID

select S_Student_ID,I_RollNo from T_Student_Detail where I_Student_Detail_ID = @iStudentID

END

