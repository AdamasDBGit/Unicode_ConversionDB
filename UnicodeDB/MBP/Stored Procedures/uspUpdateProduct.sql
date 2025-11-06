-- =============================================
-- Author:		Shankha Roy
-- Modified:	Babin
-- Create date: 07/31/2007
-- Description:	This sp use for Update data in MBP.T_Product_Master Table 
-- =============================================
CREATE PROCEDURE [MBP].[uspUpdateProduct]
(  
@iProductID	INT,
@sProductName VARCHAR(50),
@sProductDescription VARCHAR (200),
@sProductComponent XML,
@S_Upd_By	VARCHAR(20)	,
@Dt_Upd_On	DATETIME
			
)
AS
	BEGIN TRY  

		/*UPDATE PRODUCT MASTER TABLE*/
		UPDATE MBP.T_Product_Master
		SET		
		S_Product_Name = COALESCE(@sProductName,S_Product_Name),
		S_Product_Description  = COALESCE(@sProductDescription,S_Product_Description),
		S_Upd_By   = COALESCE(@S_Upd_By,S_Upd_By),
		Dt_Upd_On  = COALESCE(@Dt_Upd_On,Dt_Upd_On)
		WHERE
		I_Product_ID = @iProductID


		DECLARE @iChk INT
		DECLARE @iCount INT
		DECLARE @iCountStatusChange INT
		DECLARE @iRows INT
		DECLARE @iRowsStatusChange INT
		DECLARE @iProductID2 INT
		DECLARE @iProductComponentID INT
		DECLARE @iCourseID INT
		DECLARE @iCourseFamilyID INT




		DECLARE @tempProduct TABLE
		(
		 ID INT IDENTITY(1,1),
		 I_Product_Component_ID INT,
		 I_Product_ID INT,
		 I_Course_ID INT,
		 I_Course_Family_ID INT
		)
		INSERT INTO @tempProduct
		SELECT T.c.value('@ProductComponentID','int'),
			   T.c.value('@ProductID','int'),
			   T.c.value('@CourseID','int'),
			   T.c.value('@CourseFamilyID','int')
		FROM @sProductComponent.nodes('/Product/ProductComponent')T(c)
		SET @iRows = (SELECT COUNT(ID) FROM @tempProduct)
		SET @iCount =0	
		SET @iCountStatusChange =0	


/********** UPDATE STATUS OF PRODUCT COMPONENT WHICH ARE NOT PRESENT IN XML -> STARTS **********/
		DECLARE @tblPCmpIDStatusUpdate TABLE
		(
			ID INT IDENTITY(1,1),
			I_PCmpID_Status_Change INT
		)
		INSERT INTO @tblPCmpIDStatusUpdate
		SELECT I_Product_Component_ID FROM MBP.T_Product_Component WHERE I_Product_Component_ID NOT IN (SELECT I_Product_Component_ID From @tempProduct) AND I_Product_ID = @iProductID
	
SELECT I_Product_Component_ID FROM MBP.T_Product_Component WHERE I_Product_Component_ID NOT IN (SELECT I_Product_Component_ID From @tempProduct) AND I_Product_ID = @iProductID	
SELECT * FROM @tblPCmpIDStatusUpdate

		SET @iRowsStatusChange = (SELECT COUNT(I_PCmpID_Status_Change) FROM @tblPCmpIDStatusUpdate)
SELECT @iRowsStatusChange

		WHILE (@iCountStatusChange <= @iRowsStatusChange)
		BEGIN
			 SELECT @iProductComponentID = I_PCmpID_Status_Change FROM @tblPCmpIDStatusUpdate WHERE ID=@iCountStatusChange
			 UPDATE MBP.T_Product_Component SET I_Status_ID = 0  WHERE I_Product_Component_ID = @iProductComponentID
			SET @iCountStatusChange= @iCountStatusChange +1 
		END
/********** UPDATE STATUS OF PRODUCT COMPONENT WHICH ARE NOT PRESENT IN XML -> ENDS **********/




		WHILE(@iCount <= @iRows)
		BEGIN
				--PRINT '@iCount->'+STR(@iCount)
				SELECT 
					@iProductComponentID = I_Product_Component_ID,
					@iProductID2 = I_Product_ID,
					@iCourseID= I_Course_ID,
					@iCourseFamilyID= I_Course_Family_ID
					FROM @tempProduct
					WHERE ID = @iCount

				--PRINT STR(@iProductComponentID)
				IF @iProductComponentID = 0 
				BEGIN
							INSERT INTO MBP.T_Product_Component
							(I_Product_ID
							,I_Course_ID
							,I_Course_Family_ID
							,I_Status_ID
							,S_Crtd_By
							,S_Upd_By
							,Dt_Crtd_On
							,Dt_Upd_On )
							VALUES(
							 @iProductID
							,@iCourseID
							,@iCourseFamilyID
							,1
							,@S_Upd_By
							,@S_Upd_By
							,@Dt_Upd_On
							,@Dt_Upd_On 
							)
				END
			
		SET @iCount = @iCount+1;
		END

--		IF @@ERROR = 0 
--		BEGIN
--			COMMIT TRANSACTION Tra_Updt_Product
--		END
--		ELSE
--		BEGIN
--			ROLLBACK TRANSACTION Tra_Updt_Product
--		END



	END TRY
			BEGIN CATCH
			--Error occurred:  
				DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
				SELECT	@ErrMsg = ERROR_MESSAGE(),
						@ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			END CATCH
