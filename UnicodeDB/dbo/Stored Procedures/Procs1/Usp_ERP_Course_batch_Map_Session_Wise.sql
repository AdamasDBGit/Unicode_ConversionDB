
CREATE Proc [dbo].[Usp_ERP_Course_batch_Map_Session_Wise]
(
 --   @ClassID Int,
 --   @BrandID int,
 --   @streamID Int = Null,
	--@isessionID int = NULL
	@iReadmissionRequestID int = null
)
as
Begin

    --Declare @ClassID Int=1,@ClassName Varchar(100),@BrandID int=1 ,@sessionID int

	DECLARE @ClassID Int=null, @BrandID int=null, @streamID Int = Null,@isessionID int = NULL,@iCenterID int=null,
	@StudentID  varchar(max)=null,@StudentDetailID int=null,@SourceBatchID int=null


	select top 1
	@ClassID=I_Destination_Class_ID,
	@streamID=I_Destination_Stream_ID,
	@isessionID=I_Destination_Academic_Session,
	@BrandID=I_Brand_ID,
	@iCenterID=I_Center_ID,
	@StudentID=SD.S_Student_ID,
	@StudentDetailID=SD.I_Student_Detail_ID,
	@SourceBatchID=SPHH.I_Source_Batch_ID
	from T_ERP_Student_Promotion_History_Header as SPHH
	inner join T_Student_Detail as SD on SPHH.I_Student_DetailID=SD.I_Student_Detail_ID
	where  I_Student_Promotion_History_Header_ID=@iReadmissionRequestID



    Declare @CourseID int,
            @coursename varchar(50),
            @Currentdate datetime = GETDATE(),
            @SessionStartDt date,
            @SessionEndDt date,
            @ClassName Varchar(100),
            @sessionID int,
            @CurrentYear Varchar(5)
    Set @CurrentYear = Year(@Currentdate)
    --SET @sessionID =
    --(
    --    select Top 1
    --        I_School_Session_ID
    --    from T_School_Academic_Session_Master
    --    where I_Brand_ID = @BrandID
    --          and Year(Dt_Session_Start_Date) = @CurrentYear
    --)


	SET @sessionID=@isessionID


    Select @SessionStartDt = Convert(date, Dt_Session_Start_Date),
           @SessionEndDt = convert(date, Dt_Session_End_Date)
    from T_School_Academic_Session_Master ASM
        Inner Join T_Brand_Master BM
            on Bm.I_Brand_ID = asm.I_Brand_ID
    where I_School_Session_ID = @sessionID
          and Bm.I_Brand_ID = @BrandID

    Select @ClassName = S_Class_Name
    from T_Class
    where I_Class_ID = @ClassID

    SET @coursename = Concat(@ClassName, ' ', '(', Year(@SessionStartDt), ')')
    --Select @coursename
    If Not Exists
    (
        select 1
        from T_Course_Master
        where S_Course_Name = @coursename
              and I_Brand_ID = @BrandID
    )
    Begin
        Insert Into T_Course_Master
        (
            I_Brand_ID,
            I_CourseFamily_ID,
            S_Course_Code,
            S_Course_Name,
            S_Course_Desc,
            I_Document_ID,
            I_Is_Editable,
            I_Status,
            S_Crtd_By,
            S_Upd_By,
            Dt_Crtd_On,
            Dt_Upd_On
        )
        values
        (@BrandID, 1
		, @coursename
		, @coursename
		, @coursename
		, 1
		, 1
		, 1
		, 'dba'
		, 'dba'
		, Getdate()
		, getdate()
		)
        Set @CourseID = SCOPE_IDENTITY()
    End
    ELSE
    Begin
        SET @CourseID =
        (
            select Top 1
                I_Course_ID
            from T_Course_Master
            where S_Course_Name = @coursename
                  and I_Brand_ID = @BrandID
        )
    End
    -----------Checking batch Against Course-------------
    Declare @BatchID Int,
            @batchname varchar(50)
    SET @batchname = @coursename
    IF Not exists
    (
        select 1
        from T_Student_Batch_Master
        where S_Batch_Name = @batchname
              and I_Course_ID = @CourseID
    )
    Begin
        Insert Into T_Student_Batch_Master
        (
            S_Batch_Code,
            I_Course_ID,
            I_Delivery_Pattern_ID,
            Dt_BatchStartDate,
            I_Status,
            Dt_Course_Expected_End_Date,
            S_Crtd_By,
            Dt_Crtd_On,
            b_IsHOBatch,
            S_Batch_Name,
            b_IsApproved,
            I_Admission_GraceDays,
            b_IsCorporateBatch,
            I_Latefee_Grace_Day,
            Admission_AfterStartDate
        )
        Select @batchName,
               @courseID,
               1,
               @SessionStartDt,
               2,
               @SessionEndDt,
               'dba',
               GETDATE(),
               0,
               @batchName,
               1,
               365,
               0,
               0,
               0

        SET @BatchID = SCOPE_IDENTITY()
    End
    ELSE
    Begin
        Set @BatchID =
        (
            select I_Batch_ID
            from T_Student_Batch_Master
            where S_Batch_Name = @batchname
                  and I_Course_ID = @CourseID
        )
    End

    IF NOT Exists
    (
        select 1
        from T_Course_Group_Class_Mapping
        where I_Course_ID = @CourseID
              and I_Brand_ID = @BrandID
              and I_Class_ID = @ClassID
              and I_School_Session_ID = @sessionID
              and I_Batch_ID = @BatchID
              and (
                      I_Stream_ID = @streamID
                      Or @streamID IS NULL
                  )
    )
    Begin
        Insert Into T_Course_Group_Class_Mapping
        (
            I_Course_ID,
            I_Brand_ID,
            I_Class_ID,
            Dt_Create_Dt,
            I_School_Session_ID,
            I_Stream_ID,
            I_Batch_ID
        )
        Values
        (@CourseID, @BrandID, @ClassID, Getdate(), @sessionID, @streamID, @BatchID)
    End



	select I_Batch_ID as BatchID,I_Course_ID CourseID ,@SessionStartDt BatchStartDate,
	@iCenterID CenterID,@StudentID StudentID,@StudentDetailID StudentDetailID, @SourceBatchID SourceBatchID
	from T_Course_Group_Class_Mapping where 
	I_Brand_ID=@BrandID and I_Class_ID=@ClassID and I_School_Session_ID=@sessionID and (I_Stream_ID IS NULL OR I_Stream_ID=ISNULL(@streamID,I_Stream_ID))



End
