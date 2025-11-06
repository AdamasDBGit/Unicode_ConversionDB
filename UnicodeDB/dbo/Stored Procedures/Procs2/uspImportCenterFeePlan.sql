
-- =============================================
-- Author:		<susmita Paul>
-- Create date: <2023-March-13>
-- Description:	<Get the Center-Feeplan Details and insert into Log Table>
-- =============================================
CREATE PROCEDURE [dbo].[uspImportCenterFeePlan] 
	@iBatchId INT
AS
BEGIN

	SET NOCOUNT ON;
	 
	/*Added by susmita : 2023March13 : Added for get the value of new selected fee plan and reason of modify and passing to procedure for log and modify */

	Declare @iFeePlanID INT=NULL,@actionstatus varchar(max)=NULL,@Approveddate datetime=NULL;
	Declare @istatus INT = NULL,@BrandID INT =NULL,@CenterID INT=NULL;
	Declare @sCreatedBy varchar(max)=NULL,@sCreatedOn datetime=NULL,@sUpdatedBy varchar(max)=NULL,@sUpdatedOn datetime=NULL

	select @istatus=I_Status,@CenterID=I_Centre_Id,@iFeePlanID=I_Course_Fee_Plan_ID,@sCreatedBy=S_Crtd_By,
	@sCreatedOn=Dt_Crtd_On,@sUpdatedBy=S_Updt_By,@sUpdatedOn=Dt_Upd_On
	from T_Center_Batch_Details where I_Batch_ID=@iBatchId
	select @BrandID = I_Brand_ID from T_Brand_Center_Details where I_Centre_Id=@CenterID and I_Status=1

	if (@istatus = 4 OR @istatus = 5 OR @istatus = 6 OR @istatus IS NULL)
	BEGIN

		IF @istatus = 4
			BEGIN
				set @actionstatus='Currently Active Fee Plan with Batch(Initial Import) and Can Enroll'
				set @Approveddate=CONVERT(DATE,@sUpdatedOn)
			END
		IF @istatus = 5
			BEGIN
				set @actionstatus='Currently Active Fee Plan with Batch(Intial Import) and completed'
			END
		IF @istatus = 6
			BEGIN
				set @actionstatus='Currently Active Fee Plan with Batch(Intial Import) and Enrollment Full'
			END

		IF @istatus IS NULL
			BEGIN
				IF (@sUpdatedBy IS NULL AND @sUpdatedOn IS NULL And @sCreatedOn IS NOT NULL AND @sCreatedBy IS NOT NULL)
					BEGIN
						set @actionstatus='Created(Intial Import)'
					END

				ELSE
					BEGIN
						if (@sCreatedOn IS NOT NULL AND @sCreatedBy IS NOT NULL)

							BEGIN
								set @actionstatus='REJECTED(Intial Import)'
							END
					END
			END


	declare @BatchFeeplanJson varchar(Max)
	SELECT @BatchFeeplanJson ='['+ STUFF((
                SELECT ',{"I_Batch_ID":"' + CONVERT(NVARCHAR(MAX),t1.I_Batch_ID) + '",'+
							+'"I_Centre_Id":"'+CONVERT(NVARCHAR(MAX),t1.I_Centre_Id) + '",'+
							+'"I_Course_Fee_Plan_ID":"'+CONVERT(NVARCHAR(MAX),t1.I_Course_Fee_Plan_ID) + '",'+
							+'"I_Minimum_Regn_Amt":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.I_Minimum_Regn_Amt),'NULL') + '",'+
							+'"Max_Strength":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.Max_Strength),'NULL') + '",'+
							+'"I_Status":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.I_Status),'NULL') + '",'+
							+'"S_Crtd_By":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.S_Crtd_By),'NULL') + '",'+
							+'"S_Updt_By":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.S_Updt_By),'NULL') + '",'
							+'"Dt_Crtd_On":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.Dt_Crtd_On),'NULL') + '",'+
							+'"Dt_Upd_On":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.Dt_Upd_On),'NULL') + '",'+
							+'"I_Employee_ID":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.I_Employee_ID),'NULL')  + '",'+
							+'"B_Is_Eligibility_List_Prepared":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.B_Is_Eligibility_List_Prepared),'NULL') + '",'+
							+'"I_Min_Strength":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.I_Min_Strength),'NULL') + '",'+
							+'"I_Center_Dispatch_Scheme_ID":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.I_Center_Dispatch_Scheme_ID),'NULL') + '",'+
							+'"S_ClassDays":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.S_ClassDays),'NULL') + '",'+
							+'"S_OfflineClassTime":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.S_OfflineClassTime),'NULL') + '",'+
							+'"S_OnlineClassTime":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.S_OnlineClassTime),'NULL') + '",'+
							+'"S_HandoutClassTime":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.S_HandoutClassTime),'NULL') + '",'+
							+'"S_ClassMode":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.S_ClassMode),'NULL') + '",'+
						+'"S_BatchTime":"'+ISNULL(CONVERT(NVARCHAR(MAX),t1.S_BatchTime),'NULL') + '"}'
				   FROM (select * from T_Center_Batch_Details where I_Batch_ID=@iBatchId) t1 
					FOR XML PATH(''), TYPE
                  ).value('.', 'varchar(max)'),1,1,''
              ) + ']' ;


		Insert into Batch_Feeschedule_Log
		(
		BrandID,
		ActionDate,
		ApproveDate,
		BatchID,
		CourseFeePlanID,
		BatchFeePlanDetailJson,
		Actionstatus,
		BatchFeePlanCreatedBy,
		BatchFeePlanCreatedOn,
		BatchFeePlanUpdatedBy,
		BatchFeePlanUpdatedOn
		)
		values
		(
		@BrandID,
		getdate(),
		@Approveddate,
		@iBatchId,
		@iFeePlanID,
		@BatchFeeplanJson,
		@actionstatus,
		@sCreatedBy,
		@sCreatedOn,
		@sUpdatedBy,
		@sUpdatedOn
		)
	END
/*------------------------------------------------------------------ */
   
END
