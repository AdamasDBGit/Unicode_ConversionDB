CREATE TABLE [ACADEMICS].[T_Center_E_Project_Manual] (
    [I_Center_E_Proj_ID]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_ID]                  INT            NULL,
    [I_Course_ID]                  INT            NULL,
    [I_Term_ID]                    INT            NULL,
    [I_Module_ID]                  INT            NULL,
    [I_Student_Detail_ID]          INT            NULL,
    [I_E_Proj_Manual_Number]       INT            NULL,
    [I_E_Project_Group_ID]         INT            NULL,
    [Dt_Cancellation_Date]         DATETIME       NULL,
    [S_Cancellation_Reason]        VARCHAR (2000) NULL,
    [N_Marks]                      NUMERIC (8, 2) NULL,
    [I_Status]                     INT            NULL,
    [S_Crtd_By]                    VARCHAR (20)   NULL,
    [S_Upd_By]                     VARCHAR (20)   NULL,
    [Dt_Crtd_On]                   DATETIME       NULL,
    [Dt_Upd_On]                    DATETIME       NULL,
    [I_Valid_Cancellation_Attempt] BIT            NULL,
    CONSTRAINT [PK__T_Center_E_Proje__15660868] PRIMARY KEY CLUSTERED ([I_Center_E_Proj_ID] ASC)
);

