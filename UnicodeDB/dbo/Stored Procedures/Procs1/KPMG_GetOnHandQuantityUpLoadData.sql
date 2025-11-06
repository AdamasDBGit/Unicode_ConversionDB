
CREATE PROCEDURE [dbo].[KPMG_GetOnHandQuantityUpLoadData]
@MaterialBarCode NVARCHAR(max),
@StudentBarCodeNo NVARCHAR(max)

AS

BEGIN TRY 

DECLARE @ITEM_CODE NVARCHAR(max)
DECLARE @BRANCH_ID INT
DECLARE @BRANCH_NAME NVARCHAR(max)
DECLARE @STUDENTID INT
DECLARE @ITEM_TYPE INT
DECLARE @ITEM_ISSUE_ID INT
DECLARE @ERROR NVARCHAR(max)


DECLARE @TEMP_TABLE TABLE (ItemCode NVARCHAR(max), ItemDescription NVARCHAR(max),CourseName NVARCHAR(max)  ,BarCode NVARCHAR(max),Name NVARCHAR(max),StudentId INT,DamageStatus INT,OkStatus INT,DuplicateStatus INT,IssueDate DateTime)
DECLARE @damageStatus INT,@OkStatus INT,@DuplicateStatus INT	
IF EXISTS(SELECT 1 FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_Barcode=@MaterialBarCode)
BEGIN
	SELECT @STUDENTID= I_Student_Detail_ID from T_Student_Detail where S_Student_ID=@StudentBarCodeNo
	IF EXISTS(SELECT 1 FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_StudentId=@STUDENTID AND Fld_KPMG_Barcode=@MaterialBarCode)
					BEGIN
						IF EXISTS(SELECT 1 FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_StudentId=@STUDENTID AND Fld_KPMG_Barcode=@MaterialBarCode AND DATEDIFF(DAY,Fld_KPMG_IssueDate,GETDATE())<=10)
							BEGIN
							--UPDATE Tbl_KPMG_StudyMaterialStatus SET Fld_KPMG_DamageStatus=1 WHERE Fld_KPMG_MaterialBarCode =@MaterialBarCode
							INSERT INTO @TEMP_TABLE
							EXEC uspGetStudyMaterialDetails @MaterialBarCode
							
							IF EXISTS(SELECT 1 FROM @TEMP_TABLE WHERE BarCode= @MaterialBarCode)
							BEGIN
								
								SELECT @damageStatus= DamageStatus,@OkStatus=OkStatus,@DuplicateStatus=DuplicateStatus FROM @TEMP_TABLE WHERE  BarCode= @MaterialBarCode
								
								IF(ISNULL(@damageStatus,0)<>1)
								BEGIN
								PRINT 'SOUMYA'
									SET @ERROR='The issued Study Material is not a damaged material.'
								END
								ELSE
								BEGIN
									SET @ERROR=''
								END
								
							END
								IF (@damageStatus=1)
									BEGIN
										SELECT @ITEM_ISSUE_ID =Fld_KPMG_SMIssue_Id FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_Barcode=@MaterialBarCode
		
										SELECT @ITEM_CODE = Fld_KPMG_ItemCode,@BRANCH_ID=Fld_KPMG_Branch_Id FROM Tbl_KPMG_StockMaster WHERE Fld_KPMG_Stock_Id=(SELECT Fld_KPMG_Stock_Id FROM Tbl_KPMG_StockDetails WHERE Fld_KPMG_Barcode=@MaterialBarCode)

										SELECT  @ITEM_TYPE= Fld_KPMG_ItemType FROM Tbl_KPMG_SM_List  WHERE Fld_KPMG_ItemCode=@ITEM_CODE
										PRINT @BRANCH_ID
										SELECT @BRANCH_NAME  = TBR.fld_kpmg_OracleBranchName FROM T_Center_Hierarchy_Name_Details
										INNER JOIN Tbl_KPMG_BranchConfiguration TBR ON S_Center_Name=TBR.fld_kpmg_BranchName
										 WHERE I_Center_ID=@BRANCH_ID
										PRINT 4
										SET @ERROR='SUCCESS'
									END
								ELSE
									BEGIN
										SET @ERROR='The issued Study Material is not a damaged material.'
									END
								
							END
						ELSE
							BEGIN
								SET @ERROR='Replacement priod has expired.'
							END
					END	
					ELSE
						BEGIN
							SET @ERROR='The material has not been issued for this student.'
						END
					END
					
					

SELECT @ITEM_ISSUE_ID AS ITEM_ISSUE_ID,@ITEM_CODE AS ITEM_CODE,@BRANCH_NAME AS BRANCH_NAME,@ITEM_TYPE AS ITEM_TYPE,@ERROR AS ERROR
		



END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

