CREATE PROCEDURE [dbo].[uspGetStudentID]
	
	@iHCenterId int
				
AS
BEGIN
DECLARE
@iCenterID int,
@iTotalRowCount int,
@iRowCount int

DECLARE @tblTemp TABLE
	(
		[ID] int identity(1,1),
		S_Student_ID varchar(500),		
		I_Student_Detail_ID int
		
	)


SET @iCenterID=(SELECT I_Center_ID FROM T_Center_Hierarchy_Details WHERE I_Hierarchy_Detail_ID=@iHCenterId)

INSERT INTO @tblTemp(I_Student_Detail_ID)
(select I_Student_Detail_ID from T_Student_Transfer_Request where I_Source_Centre_Id=@iCenterID )

SET @iTotalRowCount=(SELECT COUNT(*) FROM @tblTemp)
	SET @iRowCount=1

WHILE (@iRowCount<=@iTotalRowCount)
	BEGIN
	UPDATE @tblTemp
	SET S_Student_ID=(select S_Student_ID from T_Student_Detail where I_Student_Detail_ID=(select I_Student_Detail_ID from @tblTemp WHERE [ID]=@iRowCount))
	WHERE [ID]=@iRowCount
	SET @iRowCount=@iRowCount+1
	END



select S_Student_ID,I_Student_Detail_ID from @tblTemp

END
