
CREATE PROCEDURE [ECOMMERCE].[uspGetBatchListForProduct](@ProductID INT, @CenterID INT, @AfterDate DATETIME=NULL)
AS
BEGIN

	DECLARE @CourseID INT=0

	BEGIN TRY

		IF NOT EXISTS(select * from ECOMMERCE.T_Product_Center_Map where CenterID=@CenterID and ProductID=@ProductID and StatusID=1)
		BEGIN

			DECLARE @Err VARCHAR(MAX)='Center-Product combination do not exist for ProductID '+@ProductID

			RAISERROR(@Err,11,1)

		END


		select @CourseID=ISNULL(CourseID,0) 
		from 
		ECOMMERCE.T_Product_Master A
		inner join ECOMMERCE.T_Product_Center_Map B on A.ProductID=B.ProductID
		where 
		A.ProductID=@ProductID and A.StatusID=1 and A.IsPublished=1 and ISNULL(A.ValidTo,GETDATE())>=GETDATE()
		and B.CenterID=@CenterID
	
		--PRINT @CourseID
		--add condition for Started batch visiblity : 2022-10-31 : by susmita
		
		select A.*,B.S_OnlineClassTime,B.S_BatchTime
		from T_Student_Batch_Master A
		inner join T_Center_Batch_Details B on A.I_Batch_ID=B.I_Batch_ID
		where
		B.I_Status=4 and A.b_IsApproved=1 and A.I_Status=2
		and A.I_Course_ID=@CourseID and B.I_Centre_Id=@CenterID
		and (Dt_BatchStartDate>ISNULL(@AfterDate,GETDATE()) or Admission_AfterStartDate = 'TRUE')--susmita
		


	END TRY
    BEGIN CATCH
	--Error occurred:  
        --ROLLBACK TRANSACTION
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
    END CATCH


END
