-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 July 14>
-- Description:	<Get Result exam Schedule>
--exec uspGetResultExamSchedule 107,null,'AManna'
-- =============================================
CREATE PROCEDURE [dbo].[uspGetResultExamSchedule] 
	-- Add the parameters for the stored procedure here
	(
	@iBrandID INT,
	@iExamScheduleID int = null,
	@sUserID nvarchar(50) = null,
	@sEmailID nvarchar(200)=null
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @recordExist int=0

	SET @recordExist = (SELECT top 1 count(I_School_Group_Class_ID)  
	from T_School_Class_Teacher where sms_user_id = ISNULL(@sUserID,sms_user_id) 
	and (S_Email is NULL OR  S_Email= ISNULL(@sEmailID,S_Email))
	group by I_School_Group_Class_ID,I_Stream_ID,sms_user_id)

	select RES.I_Result_Exam_Schedule_ID ExamScheduleId,
	SG.I_Brand_Id BrandID,
	RES.Title,
	RES.I_Course_ID  CourseID,
	RES.I_Term_ID TermID,
	RES.S_Principal_Name PrincipalName,
	RES.S_Class_Teacher_Name TeacherName,
	RES.I_School_Session_ID AcademicSessionID,
	SG.I_School_Group_ID SchoolGroupID,
	CAST(CONVERT(DATE,SASM.Dt_Session_Start_Date) as varchar(max))+ ' To ' +CAST(CONVERT(DATE,SASM.Dt_Session_End_Date) as varchar(max)) AcademicSession,
	 FORMAT(RES.Dt_Exam_End_Date,'yyyy-MM-dd') ExamStartDate,
	RES.Dt_Exam_End_Date ExamEndDate,
	SG.S_School_Group_Name SchoolGroupName,
	TC.S_Class_Name +' '+ISNULL(STREAM.S_Stream,'') ClassName,
	TC.I_Class_ID ClassID,
	TM.S_Term_Name TermName,
	UM.S_Login_ID CreatedBy,
	RES.Dt_CreatedAt CreatedOn,
	RES.I_Result_Process_Status ResultProcessStatus,
	RES.I_Result_Publish_Status ResultPublishStatus,
	ISNULL(RES.Dt_Result_Publish_Date,'') ResultPublishDate
	,RES.S_Principal_Signature as PrincipalSignatureImageName
	,RES.S_Class_Teacher_Signature as TeacherSignatureImageName
	,TSCM.sms_user_id
	,TSCM.I_School_Group_Class_ID
	,ISNULL(TSCM.I_Stream_ID,0)
	,ISNULL(RES.I_Is_Freezed,0) IsFreezed
	from T_Result_Exam_Schedule as RES
	inner join
	T_School_Group_Class as SGC on SGC.I_School_Group_Class_ID=RES.I_School_Group_Class_ID
	inner join
	T_School_Group as SG on SG.I_School_Group_ID=SGC.I_School_Group_ID
	inner join
	T_Class as TC on TC.I_Class_ID=SGC.I_Class_ID
	inner join
	T_School_Academic_Session_Master as SASM on SASM.I_School_Session_ID=RES.I_School_Session_ID and SASM.I_Status=1
	inner join 
	T_Course_Master as CM on CM.I_Course_ID=RES.I_Course_ID
	inner join
	T_Term_Master as TM on TM.I_Term_ID=RES.I_Term_ID
	left join
	T_User_Master as UM on UM.I_User_ID=RES.I_Created_By and UM.I_Status=1
	left join 
	T_Stream STREAM ON STREAM.I_Stream_ID = RES.I_Stream_ID
	left join 
	(
		SELECT I_School_Group_Class_ID,I_Stream_ID,sms_user_id from T_School_Class_Teacher where 
		sms_user_id = ISNULL(@sUserID,sms_user_id)
		and (S_Email is NULL OR  S_Email= ISNULL(@sEmailID,S_Email))
		group by I_School_Group_Class_ID,I_Stream_ID,sms_user_id
	) TSCM 
	 ON TSCM.I_School_Group_Class_ID = RES.I_School_Group_Class_ID AND (ISNULL(TSCM.I_Stream_ID,0)=ISNULL(RES.I_Stream_ID,0))
	where 
	SG.I_Status=1 and SGC.I_Status=1 and TC.I_Status=1 and CM.I_Status=1 and TM.I_Status=1 
	and SG.I_Brand_Id=@iBrandID and RES.I_Result_Exam_Schedule_ID = ISNULL(@iExamScheduleID,RES.I_Result_Exam_Schedule_ID)
	--and TSCM.sms_user_id = ISNULL(@sUserID,TSCM.sms_user_id)
	and ((TSCM.sms_user_id is null) or ( TSCM.sms_user_id = CASE 
			WHEN @recordExist=1
				THEN ISNULL(@sUserID,TSCM.sms_user_id)
				ELSE  TSCM.sms_user_id
			END))
	and RES.I_School_Group_Class_ID = CASE 
			WHEN @recordExist=1
				THEN TSCM.I_School_Group_Class_ID
				ELSE RES.I_School_Group_Class_ID
			END
	and ISNULL(RES.I_Stream_ID,0) = CASE 
			WHEN @recordExist=1
				THEN ISNULL(TSCM.I_Stream_ID,0)
				ELSE ISNULL(RES.I_Stream_ID,0)
			END


    
END
