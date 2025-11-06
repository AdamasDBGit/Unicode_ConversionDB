CREATE PROCEDURE [dbo].[usp_ERP_Exam_scheduledetails_Insert_update](
@I_Result_Exam_Schedule_ID Int,
@UTExam_Schedule_Subject_Details dbo.UT_Exam_Schedule_Subject_Details READONLY
)
As 
Begin
 SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

If Exists(select 1 from T_ERP_Result_Exam_Schedule 
where I_Result_Exam_Schedule_ID=@I_Result_Exam_Schedule_ID
)
Begin
MERGE INTO T_ERP_Exam_Schedule_Subject_Detail AS target
        Using @UTExam_Schedule_Subject_Details AS Source
        ON target.I_Result_Exam_Schedule_ID = @I_Result_Exam_Schedule_ID
           And target.I_Schedule_Subject_Detail = Source.I_Schedule_Subject_Detail
        WHEN MATCHED THEN
            UPDATE SET I_Subject_Type_ID=Source.I_Subject_Type_ID
                      ,I_Subject_ID=Source.I_Subject_ID
                      ,I_Subject_Component_ID=source.I_Subject_Component_ID
                      ,I_Slot_ID=source.I_Slot_ID
                      ,i_Faculty_ID=source.i_Faculty_ID
                      ,N_Total_Marks=Source.N_Total_Marks
                      ,N_Pass_Marks=source.N_Pass_Marks
                      ,Is_PassMandatory=source.Is_PassMandatory
                      ,Weightage=source.Weightage
                      ,dt_Start_date=source.dt_Start_date
                      ,dt_End_date=source.dt_End_date
                      ,Is_Display_App=source.Is_Display_App
                      ,I_Subject_Sequence=source.I_Subject_Sequence
					  ,Dt_Modified_dt=getdate()
					  ,Is_Active = 1
        WHEN NOT MATCHED THEN
            INSERT
            (
                I_Result_Exam_Schedule_ID
               ,I_Subject_Type_ID
               ,I_Subject_ID
               ,I_Subject_Component_ID
               ,I_Slot_ID
               ,i_Faculty_ID
               ,N_Total_Marks
               ,N_Pass_Marks
               ,Is_PassMandatory
               ,Weightage
               ,dt_Start_date
               ,dt_End_date
               ,Is_Display_App
               ,I_Subject_Sequence
               ,dt_Createdt
               ,Is_Active
            )
            Values
            (@I_Result_Exam_Schedule_ID
           , Source.I_Subject_Type_ID
           , Source.I_Subject_ID
           , Source.I_Subject_Component_ID
		   ,Source.I_Slot_ID
           , Source.i_Faculty_ID
           , source.N_Total_Marks
		   , Source.N_Pass_Marks
		   ,source.Is_PassMandatory
		   ,source.Weightage
		   ,source.dt_Start_date
		   ,source.dt_End_date
		   ,source.Is_Display_App
		   ,source.I_Subject_Sequence
           , Getdate()
           , 1
            )
        WHEN NOT MATCHED BY SOURCE 
		and target.I_Result_Exam_Schedule_ID=@I_Result_Exam_Schedule_ID
		THEN
            Update SET Is_Active = 0
                     , Dt_Modified_dt = GETDATE();

        select 1                       StatusFlag
             , 'Exam Schedule Details Updated' Message

Print 'Start Details Insert Update'
End
Else
Begin
select 1 StatusFlag
             , 'Exam Schedule Not valid' Message
End 

Print ''
  COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        DECLARE @ErrMsg NVARCHAR(max)
              , @ErrSeverity int

        SELECT ERROR_MESSAGE() as Message
             , 0               StatusFlag

        RAISERROR(@ErrMsg, @ErrSeverity, 1)

    END CATCH;
End

