CREATE TABLE [dbo].[T_ERP_Fee_Structure] (
    [I_Fee_Structure_ID]           INT             IDENTITY (1, 1) NOT NULL,
    [I_School_Session_ID]          INT             NULL,
    [S_Fee_Structure_Name]         NVARCHAR (MAX)  NULL,
    [S_Fee_Code]                   NVARCHAR (MAX)  NULL,
    [Dt_StartDt]                   DATE            NULL,
    [Dt_EndDt]                     DATE            NULL,
    [I_Fee_Structure_Category_ID]  INT             NULL,
    [I_School_Group_ID]            INT             NULL,
    [I_Class_ID]                   INT             NULL,
    [I_Stream_ID]                  INT             NULL,
    [I_Section_ID]                 INT             NULL,
    [N_Total_OneTime_Amount]       NUMERIC (18, 2) NULL,
    [N_Total_Installment_Amount]   NUMERIC (18, 2) NULL,
    [Is_Late_Fine_Applicable]      BIT             NULL,
    [R_I_FineRangeTagID]           INT             CONSTRAINT [DF__T_ERP_Fee__R_I_F__782BA85D] DEFAULT ((0)) NULL,
    [I_Currency_Type_ID]           INT             NULL,
    [Is_Active]                    BIT             CONSTRAINT [DF__T_ERP_Fee__Is_Ac__791FCC96] DEFAULT ((1)) NULL,
    [I_CreatedBy]                  INT             NULL,
    [Dtt_CreatedAt]                DATETIME        CONSTRAINT [DF__T_ERP_Fee__Dtt_C__7A13F0CF] DEFAULT (getdate()) NULL,
    [I_UpdatedBy]                  INT             NULL,
    [Dtt_UpdatedAt]                DATETIME        NULL,
    [Start_Period_Month]           INT             NULL,
    [End_Period_Month]             INT             NULL,
    [Payment_Schedule]             INT             NULL,
    [I_ERP_Fee_Category_Master_ID] INT             NULL,
    [I_Brand_ID]                   INT             NULL,
    CONSTRAINT [PK__T_ERP_Fe__381CEBA8B69BBFE0] PRIMARY KEY CLUSTERED ([I_Fee_Structure_ID] ASC)
);


GO
CREATE TRIGGER [dbo].[trg_AfterInsert_Fee_Structure]
ON [dbo].[T_ERP_Fee_Structure]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @LastInsertedID INT;

    SELECT @LastInsertedID = I_Fee_Structure_ID
    FROM INSERTED;

    INSERT INTO T_Course_Fee_Plan
    (
        S_Fee_Plan_Name,
        I_Course_Delivery_ID,
        I_Course_ID,
        I_Currency_ID,
        S_Crtd_By,
        C_Is_LumpSum,
        Dt_Valid_To,
        Dt_Crtd_On,
        N_TotalLumpSum,
        Dt_Upd_On,
        N_TotalInstallment,
        I_Status,
        N_No_Of_Installments,
        I_New_I_Fee_Structure_ID,
        I_Schhol_Group_ID
    )
    SELECT i.S_Fee_Structure_Name,
           NULL,
           1,
           i.I_Currency_Type_ID,
           IsNull(um.S_Login_ID, 'dba'),
           Null,
           i.Dt_EndDt,
           Getdate(),
           i.N_Total_Installment_Amount,
           Null,
           i.N_Total_Installment_Amount,
           i.Is_Active,
           0,
           @LastInsertedID,
           SCG.I_School_Group_Class_ID
           FROM inserted i
           Left Join T_User_Master UM
           on um.I_User_ID = i.I_CreatedBy
           Left Join [T_School_Group_Class] SCG
            on SCG.I_School_Group_ID = i.I_School_Group_ID
           and SCG.I_Class_ID = i.I_Class_ID
    DECLARE @I_Course_Fee_Plan_ID INT;
    SET @I_Course_Fee_Plan_ID = SCOPE_IDENTITY();
    ------Inserting Fee Component mapping table-----
    Insert Into T_Course_Fee_Plan_Detail
    (
        I_Fee_Component_ID,
        I_Course_Fee_Plan_ID,
        I_Item_Value,
        N_CompanyShare,
        I_Sequence,
        I_Installment_No,
        S_Crtd_By,
        C_Is_LumpSum,
        I_Display_Fee_Component_ID,
        S_Upd_By,
        Dt_Crtd_On,
        I_Status,
        Dt_Upd_On
    )
    Select FC.R_I_Fee_Component_ID,
           @I_Course_Fee_Plan_ID,
           N_Component_Actual_Total_Annual_Amount,
           0,
           FC.I_Seq_No,
           FPT.I_Pay_InstallmentNo,
           IsNull(um.S_Login_ID, 'dba'),
           Case
               When FC.Is_OneTime = 1 Then
                   'Y'
               When FC.Is_OneTime = 0 Then
                   'N'
               Else
                    Null
            End,
           FC.R_I_Fee_Component_ID,
           Null,
           FC.Dtt_Created_At,
           FC.Is_Active,
           Null
           from Inserted i
        Inner Join T_ERP_Fee_Structure_Installment_Component FC WITH(NOLOCK)
            ON i.I_Fee_Structure_ID = FC.R_I_Fee_Structure_ID
        Left Join T_ERP_Fee_PaymentInstallment_Type FPT WITH(NOLOCK)
            ON FPT.I_Fee_Pay_Installment_ID = FC.R_I_Fee_Pay_Installment_ID
        Left Join T_User_Master UM WITH(NOLOCK)
            ON um.I_User_ID = i.I_CreatedBy
			--If Exists(Select 1 from T_ERP_Fee_Structure_AcademicSession_Map mp
			--Inner
			--Where I_Fee_Structure_ID=i.I_Fee_Structure_ID)
			--Begin
		--	Declare @brandID int,@SessionID int,@CourseID int,@classID int,@streamID int
		--	Select @brandID=mp.I_Brand_ID ,@SessionID=mp.I_School_Session_ID,
		--	@classID=i.I_Class_ID,@streamID=i.I_Stream_ID
		--	from T_ERP_Fee_Structure_AcademicSession_Map Mp
		--	Inner Join inserted i  on i.I_Fee_Structure_ID=mp.I_Fee_Structure_ID
		--	  SET @CourseID=(select Top 1 I_Course_ID from T_Course_Group_Class_Mapping 
		--	  where I_Brand_ID=@brandID
  --and I_Class_ID=@classID and I_School_Session_ID=@SessionID
  --And (I_Stream_ID=@streamID or I_Stream_ID Is null)
  --)
  --Update T_Course_Fee_Plan set I_Course_ID=@CourseID where I_Course_Fee_Plan_ID=@I_Course_Fee_Plan_ID
  --End
--Insert Into tEst(Test) 
--   Select concat(@I_Course_Fee_Plan_ID,i.S_Fee_Structure_Name)
--   From Inserted i
END;
GO
DISABLE TRIGGER [dbo].[trg_AfterInsert_Fee_Structure]
    ON [dbo].[T_ERP_Fee_Structure];

