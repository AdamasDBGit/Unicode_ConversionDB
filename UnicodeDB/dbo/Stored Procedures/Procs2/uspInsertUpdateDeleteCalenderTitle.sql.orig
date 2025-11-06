-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023May23>
-- Description:	<Insert/Update/Delete Calender Title>
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertUpdateDeleteCalenderTitle] 
	-- Add the parameters for the stored procedure here
	@HolidayCalenderTitleID INT =null,
	@Title varchar(max),
	@AcademicSessionID INT,
	@HolidayCalenderTitleCategoryID INT,
	@Status INT,
	@Weekdays varchar(max),
	@CreatedOn datetime=null,
	@CreatedBy varchar(max)=null,
	@UpdatedOn datetime=null,
	@UpdatedBy varchar(max)=null,
	@OperationId INT 
AS
BEGIN

	BEGIN TRY  
		BEGIN TRANSACTION 
			IF(@OperationId>0)
			BEGIN
				IF (@HolidayCalenderTitleID=0)
				BEGIN
					IF NOT EXISTS(select * from T_NotificationTemplate where S_Title = @Title)
					BEGIN

						insert into Holiday_Calender_Title_Master
						(
						Calender_Title_Name,
						Title_Category,
						CreatedBy,
						CreatedOn
						)
						values
						(
						@Title,
						@HolidayCalenderTitleCategoryID,
						@CreatedBy,
						GETDATE()
						)
						
						select @HolidayCalenderTitleID=SCOPE_IDENTITY()
					
						insert into Weekly_Off_Master
						(
						I_Week_Day_ID,
						I_Holiday_Calender_Title_ID,
						I_Academic_session_ID,
						I_Status,
						CreatedBy,
						CreatedOn
						)
						select CAST(Val as INT),@HolidayCalenderTitleID,@AcademicSessionID,1,@CreatedBy,GETDATE() from fnString2Rows(@Weekdays,',') AS WK
										
						select 1 as statusFlag,'Holiday Calender Title with Weekly Off Created Successfully' as Message
					
					END
					ELSE
						BEGIN
						select 0 as statusFlag,'Duplicate Holiday Calender Title !' as Message
						END
				END
			END
		COMMIT TRANSACTION
	END TRY  
	BEGIN CATCH
	IF @@TRANCOUNT > 0  
		ROLLBACK TRANSACTION  
		select 0 as statusFlag,'Something went wrong!' as Message,ERROR_MESSAGE() as errorMessage
 
	END CATCH 

END
