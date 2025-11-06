CREATE TABLE [dbo].[T_Enquiry_Course] (
    [I_Enquiry_Course_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Course_ID]         INT      NULL,
    [I_Enquiry_Regn_ID]   INT      NULL,
    [C_Is_Registered]     CHAR (1) NULL,
    [I_TimeSlot_ID]       INT      NULL,
    [C_Is_Enrolled]       CHAR (1) NULL,
    [Dt_Registration]     DATETIME NULL,
    [I_Brand_ID]          INT      NULL,
    CONSTRAINT [PK__T_Enquiry_Course__66EB10A1] PRIMARY KEY CLUSTERED ([I_Enquiry_Course_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ix_I_Enquiry_Regn_ID]
    ON [dbo].[T_Enquiry_Course]([I_Enquiry_Regn_ID] ASC);

