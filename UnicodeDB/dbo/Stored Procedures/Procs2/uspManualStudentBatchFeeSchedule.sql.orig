
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <07 - April 2023>
-- Description:	<For Manual StudentBatchFeeSchedule>
-- =============================================
CREATE PROCEDURE [dbo].[uspManualStudentBatchFeeSchedule] 
	-- Add the parameters for the stored procedure here
	@iBatchId INT,
	@sUpdatedOn Datetime,
	@iNewFeePlanID INT,
	@ReasonOfModify Varchar(Max)=NULL,
	@sUpdatedBy varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	/*Added by susmita : 2023March10 : Added for get the value of new selected fee plan and reason of modify and passing to procedure for log and modify */

if((select count(*) from T_Center_Batch_Details where I_Batch_ID=@iBatchId) > 0)

BEGIN

Declare @CenterFeePlanStatus INT=NULL;
Declare @BatchApprove INT = NULL,@BrandID INT =NULL,@CenterID INT=NULL
Declare @PreviousCourseFeePlanID INT = NULL
select @CenterFeePlanStatus=I_Status,@CenterID=I_Centre_Id,@PreviousCourseFeePlanID=I_Course_Fee_Plan_ID from T_Center_Batch_Details where I_Batch_ID=@iBatchId
select @BatchApprove=b_IsApproved from T_Student_Batch_Master where I_Batch_ID=@iBatchId
select @BrandID = I_Brand_ID from T_Brand_Center_Details where I_Centre_Id=@CenterID and I_Status=1



Declare @actionstatus varchar(max)=null



if (@iNewFeePlanID > 0 and @BrandID = 109)

	begin
		if (@CenterFeePlanStatus = 4 OR @CenterFeePlanStatus = 5)
			begin
				set @actionstatus='NewFeePlan of fully Approved batch and Active Fee Plan has been Updated'
				
			end
		if(@CenterFeePlanStatus IS NULL)
			begin
				set @actionstatus='NewFeePlan of Non Approved batch and Non Active Fee Plan has been Updated'
			end



	update T_Center_Batch_Details set I_Course_Fee_Plan_ID=@iNewFeePlanID,Dt_Upd_On=@sUpdatedOn,S_Updt_By=@sUpdatedBy
	where I_Batch_ID=@iBatchId


	Declare @BatchFeeplanJson varchar(Max)=NULL
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
	BatchFeePlanUpdatedBy,
	BatchFeePlanUpdatedOn,
	CauseOfModify,
	PreviousCourseFeePlanID
	)
	values
	(
	@BrandID,
	getdate(),
	NULL,
	@iBatchId,
	@iNewFeePlanID,
	@BatchFeeplanJson,
	@actionstatus,
	@sUpdatedBy,
	@sUpdatedOn,
	@ReasonOfModify,
	@PreviousCourseFeePlanID
	)


	end



	else
		begin

			set @actionstatus='Batch Has been updated but Fee Plan Not Updated '


	
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
	BatchFeePlanUpdatedBy,
	BatchFeePlanUpdatedOn
	)
	values
	(
	@BrandID,
	getdate(),
	NULL,
	@iBatchId,
	null,
	@BatchFeeplanJson,
	@actionstatus,
	@sUpdatedBy,
	@sUpdatedOn
	)


		end


END


/*--------------------------------------------------------------------------------------------- */

END
