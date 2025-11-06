CREATE TABLE [CORPORATE].[T_Corporate_Details] (
    [I_Corporate_ID]   INT           IDENTITY (1, 1) NOT NULL,
    [S_Corporate_Name] VARCHAR (50)  NULL,
    [S_Address1]       VARCHAR (200) NULL,
    [S_Address2]       VARCHAR (200) NULL,
    [S_PinCode]        VARCHAR (20)  NULL,
    [S_Area]           VARCHAR (50)  NULL,
    [I_Country_ID]     INT           NULL,
    [I_State_ID]       INT           NULL,
    [I_City_ID]        INT           NULL,
    [S_Contact_Name]   VARCHAR (200) NULL,
    [S_Phone_No]       VARCHAR (20)  NULL,
    [S_Email_ID]       VARCHAR (50)  NULL,
    [S_Fax_No]         VARCHAR (50)  NULL,
    [I_Status]         INT           NULL,
    [S_Crtd_By]        VARCHAR (50)  NULL,
    [Dt_Crtd_On]       DATETIME      NULL,
    [S_Updt_By]        VARCHAR (50)  NULL,
    [S_Updt_On]        DATETIME      NULL,
    CONSTRAINT [PK_T_Corporate_Details] PRIMARY KEY CLUSTERED ([I_Corporate_ID] ASC)
);

