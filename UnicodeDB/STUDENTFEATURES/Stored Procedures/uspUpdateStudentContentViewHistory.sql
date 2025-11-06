CREATE PROCEDURE [STUDENTFEATURES].[uspUpdateStudentContentViewHistory]
(
@I_studentId INT,
@I_BatchContentDetailsID INT,
@Dt_Content_Viewed_On DATETIME
)
AS
BEGIN
	BEGIN TRY
		
		INSERT INTO STUDENTFEATURES.T_Student_Content_View_History
		        ( I_Batch_Content_Details_ID ,
		          I_Student_Detail_ID ,
		          Dt_Content_Viewed_On
		        )
		VALUES  ( @I_BatchContentDetailsID , -- I_Batch_Content_Details_ID - int
		          @I_studentId , -- I_Student_Detail_ID - int
		          @Dt_Content_Viewed_On  -- Dt_Content_Viewed_On - datetime
		        )
	END TRY
	BEGIN CATCH	
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
		SELECT @ErrMsg = ERROR_MESSAGE(),  
		@ErrSeverity = ERROR_SEVERITY()  

		RAISERROR(@ErrMsg, @ErrSeverity, 1) 		
	END CATCH	
END
