
CREATE PROCEDURE [dbo].[uspRevokeStudentBatch]    
(  
 @iBatchId INT  
)       
AS  
BEGIN  

/*Added by susmita : 2023March10 : Added for get the value of new selected fee plan and reason of modify and passing to procedure for log and modify */

	Declare @ioldFeePlanID INT=NULL;
	Declare @BatchApprove INT = NULL,@BrandID INT =NULL,@CenterID INT=NULL;
	select @ioldFeePlanID=I_Course_Fee_Plan_ID,@CenterID=I_Centre_Id from T_Center_Batch_Details where I_Batch_ID=@iBatchId
	select @BrandID = I_Brand_ID from T_Brand_Center_Details where I_Centre_Id=@CenterID and I_Status=1

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
	Actionstatus
	)
	values
	(
	@BrandID,
	getdate(),
	NULL,
	@iBatchId,
	@ioldFeePlanID,
	@BatchFeeplanJson,
	'Deleted/Revoked'
	)
/*------------------------------------------------------------------ */

 DELETE FROM dbo.T_Center_Batch_Details WHERE I_Batch_ID = @iBatchId  
 UPDATE dbo.T_Student_Batch_Master SET   
 I_Status = 0 WHERE  
 I_Batch_ID = @iBatchId  
 DELETE FROM dbo.T_Student_Batch_Schedule WHERE I_Batch_ID = @iBatchId
END
