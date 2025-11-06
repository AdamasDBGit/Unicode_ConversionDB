
CREATE PROCEDURE [dbo].[KPMG_GenerateMoveOrderForStudentIssue]

@StudentBarCodeNo nvarchar(255),
@Context NVARCHAR(255),
@MaterialBarCode nvarchar(255)

AS
DECLARE @CENTER_ID INT
DECLARE @STUDENTID INT
DECLARE @GENID INT
DECLARE @ITEM_CODE VARCHAR(255)
BEGIN TRY 
SELECT @STUDENTID= I_Student_Detail_ID from T_Student_Detail where S_Student_ID=@StudentBarCodeNo
SELECT @CENTER_ID= I_Centre_Id FROM T_Invoice_Parent WHERE I_Student_Detail_ID=@STUDENTID
SELECT @ITEM_CODE=Fld_KPMG_ItemCode FROM Tbl_KPMG_StockMaster WHERE Fld_KPMG_Stock_Id=(SELECT Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Barcode=@MaterialBarCode)
INSERT INTO Tbl_KPMG_MoMaster(Fld_KPMG_Branch_Id,Fld_KPMG_Context,Fld_KPMG_ISCollected) SELECT @CENTER_ID,'BRANCH_TO_STUDENT','Y'
	Select @GENID = @@IDENTITY

	INSERT INTO Tbl_KPMG_MoItems(Fld_KPMG_Mo_Id,Fld_KPMG_Itemcode,Fld_KPMG_Quantity)
	SELECT @GENID,@ITEM_CODE,1
	
	SELECT  Mm.Fld_KPMG_Mo_Id,
				Mm.Fld_KPMG_Branch_Id,
				TBR.fld_kpmg_OracleBranchName AS S_Center_Name,		
				Mm.[Fld_KPMG_Created Date],
				Mm.Fld_KPMG_RequiredDate,
				Mm.Fld_KPMG_Context,
				TBR.fld_kpmg_OracleBranchName AS Fld_KPMG_From_Branch
				
				
		FROM	dbo.Tbl_KPMG_MoMaster Mm 
		INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON Mm.Fld_KPMG_Branch_Id=TCHND.I_Center_ID
		INNER JOIN Tbl_KPMG_BranchConfiguration TBR ON TCHND.S_Center_Name=TBR.fld_kpmg_BranchName
		WHERE Mm.Fld_KPMG_Mo_Id = @GENID
		
		--select * from @TEMP_MovIdTbl
		
		SELECT  Fld_KPMG_MoItem_Id,
				Fld_KPMG_Mo_Id,
				A.Fld_KPMG_Itemcode,
				Fld_KPMG_Quantity,
				B.Fld_KPMG_ItemType
				FROM dbo.Tbl_KPMG_MoItems A
				INNER JOIN Tbl_KPMG_SM_List B
				ON A.Fld_KPMG_Itemcode=B.Fld_KPMG_ItemCode
				--INNER JOIN @TEMP_MovIdTbl C ON A.Fld_KPMG_Mo_Id=C.MovId
				WHERE Fld_KPMG_Mo_Id =@GENID
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
