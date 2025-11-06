CREATE TABLE [dbo].[T_Course_Fee_Plan_Detail] (
    [I_Fee_Component_ID]          INT            NOT NULL,
    [I_Course_Fee_Plan_ID]        INT            NOT NULL,
    [I_Course_Fee_Plan_Detail_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Item_Value]                NUMERIC (18)   NULL,
    [N_CompanyShare]              NUMERIC (18)   NULL,
    [I_Sequence]                  INT            NULL,
    [I_Installment_No]            INT            NULL,
    [S_Crtd_By]                   NVARCHAR (MAX) NULL,
    [C_Is_LumpSum]                CHAR (1)       NULL,
    [I_Display_Fee_Component_ID]  INT            NULL,
    [S_Upd_By]                    NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                  DATETIME       NULL,
    [I_Status]                    INT            NULL,
    [Dt_Upd_On]                   DATETIME       NULL,
    [I_Brand_ID]                  INT            NULL,
    CONSTRAINT [PK__T_Course_Fee_Pla__7721786A] PRIMARY KEY CLUSTERED ([I_Course_Fee_Plan_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_I_Fee_Component_ID]
    ON [dbo].[T_Course_Fee_Plan_Detail]([I_Fee_Component_ID] ASC, [I_Course_Fee_Plan_ID] ASC)
    INCLUDE([I_Course_Fee_Plan_Detail_ID]);

