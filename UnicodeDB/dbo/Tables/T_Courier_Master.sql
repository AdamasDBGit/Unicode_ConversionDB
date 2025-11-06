CREATE TABLE [dbo].[T_Courier_Master] (
    [I_Courier_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [S_Courier_Code]   NVARCHAR (MAX) NULL,
    [S_Courier_Name]   NVARCHAR (MAX) NULL,
    [Dt_Start_Date]    DATETIME       NULL,
    [Dt_End_Date]      DATETIME       NULL,
    [S_Address_Line1]  NVARCHAR (MAX) NULL,
    [S_Address_Line2]  NVARCHAR (MAX) NULL,
    [I_Country_ID]     INT            NULL,
    [I_State_ID]       INT            NULL,
    [I_City_ID]        INT            NULL,
    [S_Pincode]        NVARCHAR (MAX) NULL,
    [S_Telephone_No]   NVARCHAR (MAX) NULL,
    [S_Contact_Person] NVARCHAR (MAX) NULL,
    [I_Status]         INT            NULL,
    [S_Crtd_By]        NVARCHAR (MAX) NULL,
    [S_Upd_By]         NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]       DATETIME       NULL,
    [Dt_Upd_On]        DATETIME       NULL,
    CONSTRAINT [PK__T_Courier_Master__0663BBFA] PRIMARY KEY CLUSTERED ([I_Courier_ID] ASC)
);

