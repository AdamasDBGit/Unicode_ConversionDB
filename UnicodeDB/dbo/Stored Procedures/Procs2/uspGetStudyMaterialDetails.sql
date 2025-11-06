
CREATE PROCEDURE [dbo].[uspGetStudyMaterialDetails]

@MaterialBarCodeNo nvarchar(255)
--,@ItemCode nvarchar(255) 

AS
BEGIN TRY  



DECLARE @TEMP_TABLE TABLE (ItemCode NVARCHAR(255), ItemDescription NVARCHAR(MAX),CourseName NVARCHAR(255)  ,BarCode NVARCHAR(255),Name NVARCHAR(MAX),StudentId INT,DamageStatus INT,OkStatus INT,DuplicateStatus INT,IssueDate DateTime)
DECLARE @TEMP_STOCKDETAIL TABLE (ItemCode NVARCHAR(255) ,BarCode NVARCHAR(255),Status INT,Issued INT)
DECLARE @ITEM_CODE NVARCHAR(255)
DECLARE @ITEM_DESC NVARCHAR(MAX)
DECLARE @COURSE NVARCHAR(MAX)
--INSERT INTO @TEMP_TABLE (ItemCode,BarCode,DamageStatus,OkStatus,DuplicateStatus)
--SELECT B.Fld_KPMG_ItemCode, Fld_KPMG_MaterialBarCode,Fld_KPMG_DamageStatus,Fld_KPMG_OkStatus,Fld_KPMG_DuplicateStatus
--FROM Tbl_KPMG_StudyMaterialStatus C
--INNER JOIN Tbl_KPMG_StockDetails A 
--ON A.Fld_KPMG_Barcode=C.Fld_KPMG_MaterialBarCode
--INNER JOIN Tbl_KPMG_StockMaster B ON A.Fld_KPMG_Stock_Id=B.Fld_KPMG_Stock_Id  
--AND C.Fld_KPMG_MaterialBarCode=@MaterialBarCodeNo
SELECT @ITEM_CODE = Fld_KPMG_ItemCode FROM Tbl_KPMG_StockMaster WHERE Fld_KPMG_Stock_Id=( SELECT Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Barcode=@MaterialBarCodeNo)
SELECT @ITEM_DESC=Fld_KPMG_ItemCode_Description,@COURSE=B.S_Course_Name FROM Tbl_KPMG_SM_List A
INNER JOIN T_Course_Master B ON A.Fld_KPMG_CourseId=B.I_Course_ID
WHERE Fld_KPMG_ItemCode=@ITEM_CODE
INSERT INTO @TEMP_STOCKDETAIL(ItemCode  ,BarCode ,Status ,Issued)
SELECT @ITEM_CODE, @MaterialBarCodeNo, Fld_KPMG_Status,Fld_KPMG_isIssued FROM Tbl_KPMG_StockDetails
WHERE Fld_KPMG_Barcode=@MaterialBarCodeNo
INSERT INTO @TEMP_TABLE(ItemCode,ItemDescription,CourseName,BarCode,DamageStatus,OkStatus,DuplicateStatus)
VALUES(@ITEM_CODE,@ITEM_DESC,@COURSE, @MaterialBarCodeNo,NULL,NULL,NULL)

IF EXISTS(SELECT 1 FROM @TEMP_STOCKDETAIL WHERE Status IN (4,5))
BEGIN
	IF EXISTS (SELECT 1 FROM @TEMP_STOCKDETAIL WHERE Issued=0)
	BEGIN
		UPDATE @TEMP_TABLE SET DamageStatus=1
	
	END
	ELSE
	BEGIN
		UPDATE @TEMP_TABLE SET DamageStatus=2
	END

END
IF EXISTS(SELECT 1 FROM @TEMP_STOCKDETAIL WHERE Status IN (3))
BEGIN
	IF EXISTS (SELECT 1 FROM @TEMP_STOCKDETAIL WHERE Issued=0)
	BEGIN
		UPDATE @TEMP_TABLE SET OkStatus=1
	
	END
	ELSE
	BEGIN
		UPDATE @TEMP_TABLE SET OkStatus=2
	END

END



IF EXISTS(SELECT 1 FROM Tbl_KPMG_ReverseMOItems WHERE Fld_KPMG_BarCode=@MaterialBarCodeNo) AND EXISTS(SELECT 1 FROM @TEMP_STOCKDETAIL WHERE Status IN (3))
BEGIN
	IF EXISTS (SELECT 1 FROM @TEMP_STOCKDETAIL WHERE Issued=0)
	BEGIN
		UPDATE @TEMP_TABLE SET DuplicateStatus=1
	
	END
	ELSE
	BEGIN
		UPDATE @TEMP_TABLE SET DuplicateStatus=2
	END

END




IF EXISTS( SELECT 1 FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_Barcode=@MaterialBarCodeNo AND Fld_KPMG_Context='ISSUE')
BEGIN
	UPDATE A SET Name=ISNULL(C.S_First_Name+' ','')+ ISNULL(C.S_Middle_Name+' ','')+ISNULL(C.S_Last_Name,''),
	StudentId=I_Student_Detail_ID,
	IssueDate=B.Fld_KPMG_IssueDate
	FROM Tbl_KPMG_SM_Issue B INNER JOIN @TEMP_TABLE A ON A.BarCode=B.Fld_KPMG_Barcode
	INNER JOIN T_Student_Detail C ON B.Fld_KPMG_StudentId=C.I_Student_Detail_ID
	AND B.Fld_KPMG_Context='ISSUE'
END

SELECT * FROM @TEMP_TABLE


END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
