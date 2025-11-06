
--Procedure: usp_ERP_Saving_Exam_Component                  
-- Ref Used: UT_EXAM_Component_Conf                 
-- Author:      Abhik Porel                  
-- Create date: 26.07.2024    
-- Modified date:Null    
-- Reason: Exam Component Savings    
-- Description: Savings Exam Component ;                 
-- =============================================                  

CREATE PROCEDURE [dbo].[usp_ERP_Saving_Exam_Component]
    @brand_ID int,
    @groupid int,
    @Classid int,
    @streamid int,
    @sectionid int,
    @I_School_Session_ID int,
    @I_Created_By int,
    @componentStatus int,
    @ExamcomponentName NVARCHAR(MAX),
    @h_I_Exam_Comp_Header_ID int,
    @Is_Active bit,
    @Exam_Component_Details [UT_EXAM_Component_Conf] READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

		Declare @messageInsert int,@messageUpdate int
        IF @h_I_Exam_Comp_Header_ID IS NULL
        Begin
            INSERT INTO T_ERP_Exam_Component_Header
            (
                S_Exam_Component_Name,
                I_School_Session_ID,
                I_Brand_ID,
                I_School_Group_ID,
                I_Class_ID,
                I_Stream_ID,
                I_Section_ID,
                Is_Active,
                Component_Status,
                Dt_Created_At,
                Dt_Modified_At,
                I_Created_By,
                I_Modified_By
            )
            Values
            (@ExamcomponentName,
             @I_School_Session_ID,
             @brand_ID,
             @groupid,
             @Classid,
             @streamid,
             @sectionid,
             @Is_Active,
             Null,
             GETDATE(),
             Null,
             @I_Created_By,
             Null
            )
            SET @h_I_Exam_Comp_Header_ID = SCOPE_IDENTITY();
			 --select 1 StatusFlag,
    --           'Exam Component Added' Message
	SET @messageInsert=1
        END
        ELSE
        Begin

            UPDATE T_ERP_Exam_Component_Header
            SET S_Exam_Component_Name = @ExamcomponentName,
                I_School_Group_ID = @groupid,
                I_Class_ID = @Classid,
                I_Stream_ID = @streamid,
                I_Section_ID = @sectionid,
                Is_Active = @Is_Active,
                Dt_Modified_At = Getdate(),
                I_Modified_By = @I_Created_By
            Where I_Exam_Comp_Header_ID = @h_I_Exam_Comp_Header_ID
        End

        MERGE INTO T_ERP_Exam_Component_Mapping AS target
        Using @Exam_Component_Details AS Source
        ON target.I_Exam_Comp_Map_ID = source.I_Exam_Comp_Map_ID
           And target.I_Exam_Comp_Header_ID = @h_I_Exam_Comp_Header_ID
        WHEN MATCHED THEN
            UPDATE SET I_Subject_ID = Source.I_Subject_ID,
                       I_Subject_Component_ID = Source.I_Subject_Component_ID,
                       N_Total_Marks = Source.N_Total_Marks,
                       N_Pass_Marks = Source.N_Pass_Marks,
                       Is_PassMandatory = Source.Is_PassMandatory,
                       Is_Active = Source.Is_Active_Details,
                       S_Weightage = Source.S_Weightage,
                       Dt_Modified_At = Getdate()
        WHEN NOT MATCHED THEN
            INSERT
            (
                I_Exam_Comp_Header_ID,
                I_Subject_ID,
                I_Subject_Component_ID,
                N_Total_Marks,
                N_Pass_Marks,
                Is_PassMandatory,
                S_Weightage,
                Is_Active,
                Dt_Created_At,
                Dt_Modified_At,
                I_Created_By,
                I_Modified_By
            )
            Values
            (@h_I_Exam_Comp_Header_ID,
             Source.I_Subject_ID,
             Source.I_Subject_Component_ID,
             Source.N_Total_Marks,
             Source.N_Pass_Marks,
             Source.Is_PassMandatory,
             Source.S_Weightage,
             source.Is_Active_Details,
             Getdate(),
             Null,
             @I_Created_By,
             NUll
            )
            WHEN NOT MATCHED BY SOURCE and target.I_Exam_Comp_Header_ID = @h_I_Exam_Comp_Header_ID THEN
            Update SET Is_Active = 0,
                       Dt_Modified_At = GETDATE();
          SET @messageUpdate=1
        --select 1 StatusFlag,
        --       'Exam Component Updated' Message
		If (@messageInsert=1 and @messageUpdate=1)
		Begin 
		select 1 StatusFlag,
             'Exam Component Added' Message
		End
		Else If (@messageUpdate=1 and @messageInsert is null)
		Begin
		select 1 StatusFlag,
             'Exam Component Updated' Message
		End 
		Else
		Begin
		Print 'Action Not Taken '
		End
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        DECLARE @ErrMsg NVARCHAR(4000),
                @ErrSeverity int

        SELECT ERROR_MESSAGE() as Message,
               0 StatusFlag

        RAISERROR(@ErrMsg, @ErrSeverity, 1)

    END CATCH;
END;

