CREATE PROCEDURE [dbo].[uspDeleteStudent]
(
	@iStudentDetailID INT,
	@iDeleteOtherReceiptsFlag int, -- Flag = 1, delete other types of receipt, 
	@iReturningStudentFlag int -- Flag = 1 for returning students
)

AS

BEGIN TRY

BEGIN TRANSACTION
IF @iReturningStudentFlag = 0

BEGIN

	-- 1. Delete from Receipt Tax Details
	DELETE FROM T_Receipt_Tax_Detail
	WHERE I_Invoice_Detail_ID
	IN (SELECT I_Invoice_Detail_ID 
		FROM T_Invoice_Child_Detail 
		WHERE I_Invoice_Child_Header_ID 
			IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_Child_Header 
				WHERE I_Invoice_Header_ID 
				IN	(SELECT I_Invoice_Header_ID FROM T_Invoice_Parent
					WHERE I_Student_Detail_ID = @iStudentDetailID)
			 )
		) 
		
	-- 2. Delete from Receipt Component Details
	DELETE FROM T_Receipt_Component_Detail
	WHERE I_Invoice_Detail_ID
	IN (SELECT I_Invoice_Detail_ID 
		FROM T_Invoice_Child_Detail 
		WHERE I_Invoice_Child_Header_ID 
			IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_Child_Header 
				WHERE I_Invoice_Header_ID 
				IN	(SELECT I_Invoice_Header_ID FROM T_Invoice_Parent
					WHERE I_Student_Detail_ID = @iStudentDetailID)
			 )
		) 

	-- 3. Delete from Invoice Tax Deatils
	DELETE FROM T_Invoice_Detail_Tax 
	WHERE I_Invoice_Detail_ID
	IN (SELECT I_Invoice_Detail_ID 
		FROM T_Invoice_Child_Detail 
		WHERE I_Invoice_Child_Header_ID 
			IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_Child_Header 
				WHERE I_Invoice_Header_ID 
				IN	(SELECT I_Invoice_Header_ID FROM T_Invoice_Parent
					WHERE I_Student_Detail_ID = @iStudentDetailID)
			 )
		)		
	
		
	-- 4. Delete from Invoice Child Detail
	DELETE FROM T_Invoice_Child_Detail 
	WHERE I_Invoice_Child_Header_ID 
			IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_Child_Header 
				WHERE I_Invoice_Header_ID 
				IN	(SELECT I_Invoice_Header_ID FROM T_Invoice_Parent
					WHERE I_Student_Detail_ID = @iStudentDetailID)
			 )
			 
	-- 5. Update Receipt Header	Table
	UPDATE T_Receipt_Header 
	SET I_Student_Detail_ID = NULL,
		I_Invoice_Header_ID = NULL,
		I_Receipt_Type = 1  -- Receipt Type = 1, Registration Receipt
	
	-- 5a. Delete Other Types of Receipts from Receipt Header	
	if( @iDeleteOtherReceiptsFlag = 1)
		BEGIN
			DELETE FROM T_Receipt_Header 
			WHERE I_Student_Detail_ID = @iStudentDetailID
			AND I_Receipt_Type <> 1
		END
			 
	-- 6. Delete from Invoice Child Header
	DELETE FROM T_Invoice_Child_Header 
	WHERE I_Invoice_Header_ID 
	IN	(SELECT I_Invoice_Header_ID FROM T_Invoice_Parent
		 WHERE I_Student_Detail_ID = @iStudentDetailID)
	
	-- 7. Delete from Invoice Parent
	DELETE FROM dbo.T_Invoice_Parent
	WHERE I_Student_Detail_ID = @iStudentDetailID
	
	-- 8. Delete from Student Module Detail
	DELETE FROM T_Student_Module_Detail
	WHERE I_Student_Detail_ID = @iStudentDetailID
	
	-- 9. Delete from Student Term Detail
	DELETE FROM T_Student_Term_Detail
	WHERE I_Student_Detail_ID = @iStudentDetailID
	
	-- 10. Delete from Student Course Detail
	DELETE FROM T_Student_Course_Detail
	WHERE I_Student_Detail_ID = @iStudentDetailID
	
	-- 11. Delete from Student Center Detail
	DELETE FROM T_Student_Center_Detail
	WHERE I_Student_Detail_ID = @iStudentDetailID
	
	-- 12. Delete from User Role Details
	DELETE FROM T_User_Role_Details
	WHERE I_User_ID IN
		(SELECT TURD.I_User_ID FROM T_User_master TUM, T_User_Role_Details TURD
			WHERE TURD.I_User_ID = TUM.I_User_ID
			AND TUM.I_Reference_ID = @iStudentDetailID)

    -- 13. Delete from User Hierarchy Details
	DELETE FROM T_User_Hierarchy_Details
	WHERE I_User_ID IN
		(SELECT TUHD.I_User_ID FROM T_User_master TUM, T_User_Hierarchy_Details TUHD
			WHERE TUHD.I_User_ID = TUM.I_User_ID
			AND TUM.I_Reference_ID = @iStudentDetailID)

	-- 14. Delete from User Master
	DELETE FROM T_User_Master
	WHERE I_Reference_ID = @iStudentDetailID
	
	-- 15. Delete from Student Detail
	DELETE FROM T_Student_Detail
	WHERE I_Student_Detail_ID = @iStudentDetailID
	
	
END

IF @iReturningStudentFlag = 1

BEGIN

	-- 1. Delete from Receipt Tax Details
	DELETE FROM T_Receipt_Tax_Detail
	WHERE I_Invoice_Detail_ID
	IN (SELECT I_Invoice_Detail_ID 
		FROM T_Invoice_Child_Detail 
		WHERE I_Invoice_Child_Header_ID 
			IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_Child_Header 
				WHERE I_Invoice_Header_ID 
				IN	(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
					WHERE I_Student_Detail_ID = @iStudentDetailID)
			 )
		) 
		
	-- 2. Delete from Receipt Component Details
	DELETE FROM T_Receipt_Component_Detail
	WHERE I_Invoice_Detail_ID
	IN (SELECT I_Invoice_Detail_ID 
		FROM T_Invoice_Child_Detail 
		WHERE I_Invoice_Child_Header_ID 
			IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_Child_Header 
				WHERE I_Invoice_Header_ID 
				IN	(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
					WHERE I_Student_Detail_ID = @iStudentDetailID)
			 )
		) 

	-- 3. Delete from Invoice Tax Deatils
	DELETE FROM T_Invoice_Detail_Tax 
	WHERE I_Invoice_Detail_ID
	IN (SELECT I_Invoice_Detail_ID 
		FROM T_Invoice_Child_Detail 
		WHERE I_Invoice_Child_Header_ID 
			IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_Child_Header 
				WHERE I_Invoice_Header_ID 
				IN	(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
					WHERE I_Student_Detail_ID = @iStudentDetailID)
			 )
		)		
	
		
	-- 4. Delete from Invoice Child Detail
	DELETE FROM T_Invoice_Child_Detail 
	WHERE I_Invoice_Child_Header_ID 
			IN (SELECT I_Invoice_Child_Header_ID FROM T_Invoice_Child_Header 
				WHERE I_Invoice_Header_ID 
				IN	(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
					WHERE I_Student_Detail_ID = @iStudentDetailID)
			 )
			 
	-- 5. Update Receipt Header	Table
	UPDATE T_Receipt_Header 
	SET I_Student_Detail_ID = NULL,
		I_Invoice_Header_ID = NULL,
		I_Receipt_Type = 1 -- Receipt Type = 1, Registration Receipt
	WHERE I_Student_Detail_ID = @iStudentDetailID
					AND I_Receipt_Type <> 1
					AND I_Invoice_Header_ID IN
						(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
							WHERE I_Student_Detail_ID = @iStudentDetailID)	  
	
	-- 5a. Delete Other Types of Receipts from Receipt Header	
	if( @iDeleteOtherReceiptsFlag = 1)
		BEGIN
			DELETE FROM T_Receipt_Header 
				WHERE I_Student_Detail_ID = @iStudentDetailID
					AND I_Receipt_Type <> 1
					AND I_Invoice_Header_ID IN
						(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
							WHERE I_Student_Detail_ID = @iStudentDetailID)
		END
		
	-- 6. Delete from Student Module Detail
	DELETE FROM T_Student_Module_Detail
	WHERE I_Student_Detail_ID = @iStudentDetailID AND I_Term_ID IN
		(SELECT I_Term_ID FROM T_Student_Term_Detail
			WHERE I_Student_Detail_ID = @iStudentDetailID AND I_Course_ID IN
				(SELECT I_Course_ID FROM T_Invoice_Child_Header
					WHERE I_Invoice_Header_ID IN
						(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
							WHERE I_Student_Detail_ID = @iStudentDetailID))) 
	
	-- 7. Delete from Student Term Detail
	DELETE FROM T_Student_Term_Detail
	WHERE I_Student_Detail_ID = @iStudentDetailID AND I_Course_ID IN
			(SELECT I_Course_ID FROM T_Invoice_Child_Header
				WHERE I_Invoice_Header_ID IN
					(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
						WHERE I_Student_Detail_ID = @iStudentDetailID))
	
	-- 8. Delete from Student Course Detail
	DELETE FROM T_Student_Course_Detail
	WHERE I_Student_Detail_ID = @iStudentDetailID AND I_Course_ID IN
			(SELECT I_Course_ID FROM T_Invoice_Child_Header
				WHERE I_Invoice_Header_ID IN
					(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
						WHERE I_Student_Detail_ID = @iStudentDetailID))
	
	-- 9. Delete from Invoice Child Header
	DELETE FROM T_Invoice_Child_Header 
	WHERE I_Invoice_Header_ID 
	IN	(SELECT MAX(I_Invoice_Header_ID) FROM T_Invoice_Parent
		 WHERE I_Student_Detail_ID = @iStudentDetailID)
	
	-- 10. Delete from Invoice Parent
	DELETE FROM dbo.T_Invoice_Parent
	WHERE I_Invoice_Header_ID IN
	(SELECT MAX(I_Invoice_Header_ID) FROM dbo.T_Invoice_Parent
		WHERE I_Student_Detail_ID = @iStudentDetailID)
		
	DELETE FROM dbo.T_Student_Center_Detail WHERE I_Student_Detail_ID = @iStudentDetailID 
	
	DELETE FROM dbo.T_Student_Detail WHERE I_Student_Detail_ID = @iStudentDetailID

			 
END
COMMIT TRANSACTION
END TRY

BEGIN CATCH    
 ROLLBACK TRANSACTION   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    
END CATCH
