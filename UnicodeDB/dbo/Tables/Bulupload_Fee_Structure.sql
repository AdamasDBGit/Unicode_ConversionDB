CREATE TABLE [dbo].[Bulupload_Fee_Structure] (
    [Brand]                                  NVARCHAR (255) NULL,
    [S_Fee_Structure_Name]                   NVARCHAR (255) NULL,
    [S_Fee_Code]                             NVARCHAR (255) NULL,
    [Dt_StartDt]                             DATETIME       NULL,
    [Dt_EndDt]                               DATETIME       NULL,
    [School Programme]                       NVARCHAR (255) NULL,
    [Class Name]                             NVARCHAR (255) NULL,
    [Total_OneTime_Amount]                   FLOAT (53)     NULL,
    [N_Total_Installment_Amount]             FLOAT (53)     NULL,
    [Is_Late_Fine_Applicable]                FLOAT (53)     NULL,
    [Fee_Component_Name]                     NVARCHAR (255) NULL,
    [I_Seq_No]                               FLOAT (53)     NULL,
    [N_Component_Actual_Total_Annual_Amount] FLOAT (53)     NULL,
    [Is_OneTime]                             FLOAT (53)     NULL,
    [Installment_Frequency]                  NVARCHAR (255) NULL,
    [ID]                                     INT            IDENTITY (1, 1) NOT NULL
);

