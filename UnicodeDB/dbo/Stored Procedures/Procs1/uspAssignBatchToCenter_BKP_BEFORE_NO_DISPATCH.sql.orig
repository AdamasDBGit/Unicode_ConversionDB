
CREATE PROCEDURE [dbo].[uspAssignBatchToCenter_BKP_BEFORE_NO_DISPATCH]   
(  
 @iBatchId INT,  
 @CreatedBy VARCHAR(20),  
 @CreatedOn DATETIME,  
 @CenterID INT,  
 @CourseFeePlanID INT,  
 @MaxStrength INT,  
 @MinRegnAmt DECIMAL(10,2),  
 @I_Status INT,  
 @I_FacultyID INT,
 @MinStrength INT,
 @I_CenterDispatchScheme INT,
 @S_ClassDays VARCHAR(MAX)='',
 @S_OfflineClassTime VARCHAR(MAX)='',
 @S_OnlineClassTime VARCHAR(MAX)='',
 @S_HandoutClassTime VARCHAR(MAX)='',
 @S_ClassMode VARCHAR(MAX)='',
 @S_BatchTime VARCHAR(MAX)=''
)  
AS  
BEGIN TRY 

DECLARE @BrandID INT

select @BrandID=I_Brand_ID from T_Center_Hierarchy_Name_Details where I_Center_ID=@CenterID

--if(@BrandID>0 and @BrandID=109 and (@S_ClassDays is null or @S_ClassDays='' or @S_ClassDays=','))
--begin

--	--DELETE FROM T_Student_Batch_Master where I_Batch_ID=@iBatchId and I_Status=1
--	RAISERROR('Class Days is mandatory for RICE',11,1)

--end
if(@S_OfflineClassTime=',')
begin
	set @S_OfflineClassTime=''
end

if(@S_OnlineClassTime=',')
begin
	set @S_OnlineClassTime=''
end

if(@S_HandoutClassTime=',')
begin
	set @S_HandoutClassTime=''
end





if(LEN(@S_ClassDays)>2)
begin
	set @S_ClassDays=LEFT(@S_ClassDays,LEN(@S_ClassDays)-1)
end

if(LEN(@S_OfflineClassTime)>2)
begin
	set @S_OfflineClassTime=LEFT(@S_OfflineClassTime,LEN(@S_OfflineClassTime)-1)
end

if(LEN(@S_OnlineClassTime)>2)
begin
	set @S_OnlineClassTime=LEFT(@S_OnlineClassTime,LEN(@S_OnlineClassTime)-1)
end

if(LEN(@S_HandoutClassTime)>2)
begin
	set @S_HandoutClassTime=LEFT(@S_HandoutClassTime,LEN(@S_HandoutClassTime)-1)
end

 INSERT INTO dbo.T_Center_Batch_Details (  
  I_Batch_ID,  
  I_Centre_Id,  
  I_Course_Fee_Plan_ID,  
  Max_Strength,  
  I_Minimum_Regn_Amt,  
  I_Status,  
  I_Employee_ID,  
  S_Crtd_By,  
  Dt_Crtd_On,
  I_Min_Strength,
  I_Center_Dispatch_Scheme_ID,
  S_ClassDays,
  S_OfflineClassTime,
  S_OnlineClassTime,
  S_HandoutClassTime,
  S_ClassMode,
  S_BatchTime
 ) VALUES (   
  /* I_Batch_ID - int */ @iBatchId,  
  /* I_Centre_Id - int */ @CenterID,  
  /* I_Course_Fee_Plan_ID - int */ @CourseFeePlanID,  
  /* Max_Strength - int */ @MaxStrength,  
  @MinRegnAmt,  
  /* I_Status - int */ @I_Status,  
  @I_FacultyID,  
  /* S_Crtd_By - varchar(20) */ @CreatedBy,  
  /* Dt_Crtd_On - datetime */ @CreatedOn,
  @MinStrength,
  @I_CenterDispatchScheme,
  @S_ClassDays,
  @S_OfflineClassTime,
  @S_OnlineClassTime,
  @S_HandoutClassTime,
  @S_ClassMode,
  @S_BatchTime
  )   
END TRY  
BEGIN CATCH  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
