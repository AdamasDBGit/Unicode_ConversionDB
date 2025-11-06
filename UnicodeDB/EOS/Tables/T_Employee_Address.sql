CREATE TABLE [EOS].[T_Employee_Address] (
    [I_Employee_Address_ID] INT           IDENTITY (1, 1) NOT NULL,
    [I_Employee_ID]         INT           NULL,
    [I_Country_ID]          INT           NULL,
    [I_State_ID]            INT           NULL,
    [I_City_ID]             INT           NULL,
    [S_District_Name]       VARCHAR (50)  NULL,
    [S_Address_Line1]       VARCHAR (200) NULL,
    [S_Address_Line2]       VARCHAR (200) NULL,
    [S_Zip_Code]            VARCHAR (20)  NULL,
    [S_Address_Phone_No]    VARCHAR (50)  NULL,
    [I_Address_Type]        INT           NULL,
    [S_Crtd_By]             VARCHAR (20)  NULL,
    [I_Status]              INT           NULL,
    [S_Upd_By]              VARCHAR (20)  NULL,
    [Dt_Crtd_On]            DATETIME      NULL,
    [Dt_Upd_On]             DATETIME      NULL,
    CONSTRAINT [PK__T_Employee_Addre__32581828] PRIMARY KEY CLUSTERED ([I_Employee_Address_ID] ASC)
);

