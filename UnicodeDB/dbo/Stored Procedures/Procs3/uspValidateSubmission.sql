
CREATE PROCEDURE [dbo].[uspValidateSubmission]

@StudentBarCodeNo nvarchar(255),
@MaterialBarCode nvarchar(255),
@ReplacedBarCode nvarchar(255),
@ReissueReceiptNo nvarchar(255),
@StudyMaterialName nvarchar(255),
@Context nvarchar(255)

AS
BEGIN TRY 
DECLARE @STUDENTID INT
DECLARE @MATERIAL_STATUS NVARCHAR(255)=''
DECLARE @STATUS NVARCHAR(255)	
DECLARE @TEMP_TABLE TABLE (ItemCode NVARCHAR(255), ItemDescription NVARCHAR(MAX),CourseName NVARCHAR(255)  ,BarCode NVARCHAR(255),Name NVARCHAR(MAX),StudentId INT,DamageStatus INT,OkStatus INT,DuplicateStatus INT,IssueDate DateTime)
DECLARE @damageStatus INT,@OkStatus INT,@DuplicateStatus INT	
	
			
		
	IF (ISNULL(@StudentBarCodeNo,'')<>'')
		BEGIN 
		
		
		SELECT @STUDENTID= I_Student_Detail_ID from T_Student_Detail where S_Student_ID=@StudentBarCodeNo
		PRINT @Context
		IF(@Context='ISSUE')
		BEGIN 
			EXEC KPMG_uspCheckStudyMateialStatus @MaterialBarCode,@STUDENTID,@StudyMaterialName, @MATERIAL_STATUS OUTPUT
			PRINT @MATERIAL_STATUS
		END
		
		
		ELSE IF @Context='REPLACE'
				BEGIN
				 PRINT 11111
					DECLARE @DATE_OF_ISSUE DATETIME
					IF EXISTS (SELECT 1 FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_Barcode=@MaterialBarCode AND Fld_KPMG_StudentId=@STUDENTID)
					BEGIN
						SELECT @DATE_OF_ISSUE= Fld_KPMG_IssueDate FROM Tbl_KPMG_SM_Issue WHERE Fld_KPMG_Barcode=@MaterialBarCode AND Fld_KPMG_StudentId=@STUDENTID
					IF( DATEDIFF(DAY,GETDATE(), @DATE_OF_ISSUE)>15)
						BEGIN
							PRINT 2222332
							SET @MATERIAL_STATUS='The Exchange priod has over.'
						
						END
						ELSE
						PRINT 123
							INSERT INTO @TEMP_TABLE
							EXEC uspGetStudyMaterialDetails @MaterialBarCode
							
							IF EXISTS(SELECT 1 FROM @TEMP_TABLE WHERE BarCode= @MaterialBarCode)
							BEGIN
								
								SELECT @damageStatus= DamageStatus,@OkStatus=OkStatus,@DuplicateStatus=DuplicateStatus FROM @TEMP_TABLE WHERE  BarCode= @MaterialBarCode
								
								IF(ISNULL(@damageStatus,0)<>1)
								BEGIN
								PRINT 'SOUMYA'
									SET @MATERIAL_STATUS='The issued Study Material is not a damaged material.'
								END
								ELSE
								BEGIN
									SET @MATERIAL_STATUS='SUCCESS'
								END
								
							END
							
							IF(@MATERIAL_STATUS='SUCCESS')
							BEGIN
								INSERT INTO @TEMP_TABLE
								EXEC uspGetStudyMaterialDetails @ReplacedBarCode
								IF EXISTS(SELECT 1 FROM @TEMP_TABLE WHERE BarCode= @ReplacedBarCode)
								BEGIN
									
									SELECT @damageStatus= DamageStatus,@OkStatus=OkStatus,@DuplicateStatus=DuplicateStatus FROM @TEMP_TABLE WHERE  BarCode= @MaterialBarCode
									IF(ISNULL(@OkStatus,0)<>1)
									BEGIN
										SET @MATERIAL_STATUS='The Study Material is not in Ok State in repository'
									END
									ELSE
									BEGIN
										SET @MATERIAL_STATUS='SUCCESS'
									END
									
								END
								EXEC KPMG_uspCheckStudyMateialStatus @ReplacedBarCode,@STUDENTID,@StudyMaterialName, @MATERIAL_STATUS OUTPUT
							END
						END
					ELSE
					BEGIN					 
						SET @MATERIAL_STATUS='The Study Material is not issued to this student.'
					END
					END
					--ELSE
					--BEGIN
					 
					--	SET @MATERIAL_STATUS='The Study Material is not issued to this student.'
					--END
						
				END
		
		
		 IF @Context='REISSUE'
				BEGIN
					PRINT 'AAAA'
						EXEC KPMG_uspCheckStudyMateialStatus @MaterialBarCode,@STUDENTID,@StudyMaterialName, @MATERIAL_STATUS OUTPUT
						PRINT @MATERIAL_STATUS
				END
		
		 
		IF @MATERIAL_STATUS <> 'SUCCESS'
		BEGIN
			SET @STATUS=@MATERIAL_STATUS
		END
		ELSE
			BEGIN
				PRINT 'AAAAA'
				SET @STATUS='SUCCESS'
			END
		
		SELECT @STATUS AS Status
			
		--END
			
		
	



END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
