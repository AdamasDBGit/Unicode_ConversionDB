CREATE TABLE [dbo].[T_ERP_Fee_Structure_AcademicSession_Map] (
    [I_Fee_Structure_AcademicSession_Map_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]                             INT      NOT NULL,
    [I_School_Session_ID]                    INT      NOT NULL,
    [I_Fee_Structure_ID]                     INT      NOT NULL,
    [Is_Active]                              BIT      NOT NULL,
    [I_Created_By]                           INT      NULL,
    [Dt_Created_At]                          DATETIME NULL,
    [I_Updated_By]                           INT      NULL,
    [Dt_Updated_At]                          DATETIME NULL
);

