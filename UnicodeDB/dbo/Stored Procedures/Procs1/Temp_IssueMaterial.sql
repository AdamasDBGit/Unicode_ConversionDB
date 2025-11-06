

CREATE PROCEDURE [dbo].[Temp_IssueMaterial]


AS

BEGIN TRY 

	DECLARE @BRANCH_ID INT 
	DECLARE @StudentBarCodeNo NVARCHAR(max)
	DECLARE @Student_Detail_ID INT
	DECLARE @SM_BARCODE NVARCHAR(max)
	DECLARE @ITEM_CODE NVARCHAR(max)
	DECLARE @GENID INT

	DECLARE @INSTALLMENTNO INT

	DECLARE @Count INT
	DECLARE @RowCount INT

	SET @Count=1
	SELECT @RowCount = count(1) from  TempMigration where [status] = 'N'
	print @RowCount
	WHILE(@Count<=@RowCount)
	BEGIN
		set @BRANCH_ID = '';
		set @StudentBarCodeNo = '';
		set @SM_BARCODE = '';
		set @ITEM_CODE = '';
		set @INSTALLMENTNO = '';
		set @Student_Detail_ID = '';
		Select @BRANCH_ID = BranchID, @StudentBarCodeNo = StudentID, @SM_BARCODE = SMBarcode, @ITEM_CODE = ItemCode
		 from TempMigration where ID = @Count  
		
		
		
		SELECT @INSTALLMENTNO=Fld_KPMG_I_Installment_No FROM  Tbl_KPMG_SM_List where Fld_KPMG_ItemCode=@ITEM_CODE
		
		SELECT @Student_Detail_ID = I_Student_Detail_ID from T_Student_Detail where S_Student_ID=@StudentBarCodeNo
		
		IF NOT EXISTS( SELECT 1 FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_Barcode=@SM_BARCODE AND 
				Fld_KPMG_StudentId=@Student_Detail_ID AND Fld_KPMG_Context='ISSUE')
			BEGIN
			print @INSTALLMENTNO	
			INSERT INTO Tbl_KPMG_StockMaster (Fld_KPMG_ItemCode,Fld_KPMG_Branch_Id,Fld_KPMG_IsMo,Fld_KPMG_FromBranch_Id,Fld_KPMG_LastRecvDate,Fld_KPMG_Mo_Id)
				VALUES(@ITEM_CODE,@BRANCH_ID,1,@BRANCH_ID,GETDATE(),-1)
				SELECT @GENID=@@IDENTITY 
				
				
			INSERT INTO Tbl_KPMG_SM_Issue ( Fld_KPMG_Barcode, Fld_KPMG_Context,Fld_KPMG_I_Installment_No,Fld_KPMG_IssueDate,Fld_KPMG_ItemCode,Fld_KPMG_StudentId)
			VALUES
			(
				@SM_BARCODE,'ISSUE',@INSTALLMENTNO,GETDATE(),@ITEM_CODE ,@Student_Detail_ID
			)	
			
			UPDATE Tbl_KPMG_StockDetails set Fld_KPMG_isIssued='1',Fld_KPMG_Stock_Id=@GENID, Fld_KPMG_Status=3 
			WHERE Fld_KPMG_Barcode=@SM_BARCODE
			END
		Update TempMigration set [status] = 'Y' where ID = @Count 
		SET @Count = @Count + 1 
		
		

	END


END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
--exec Temp_IssueMaterial

