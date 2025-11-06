CREATE TABLE [dbo].[T_ERP_Enquiry_Regn_Guardian_Master] (
    [I_Enquiry_Regn__Guardian_Master_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Enquiry_Regn_ID]                  INT            NULL,
    [I_Relation_ID]                      INT            NULL,
    [S_Mobile_No]                        NVARCHAR (50)  NULL,
    [S_First_Name]                       NVARCHAR (100) NULL,
    [S_Middile_Name]                     NVARCHAR (100) NULL,
    [S_Last_Name]                        NVARCHAR (100) NULL,
    [S_Guardian_Email]                   NVARCHAR (100) NULL,
    [I_Qualification_ID]                 INT            NULL,
    [I_Occupation_ID]                    INT            NULL,
    [I_Business_Type_ID]                 INT            NULL,
    [S_Company_Name]                     NVARCHAR (200) NULL,
    [S_Designation]                      NVARCHAR (200) NULL,
    [I_Income_Group_ID]                  INT            NULL,
    [S_Address]                          NVARCHAR (MAX) NULL,
    [S_Profile_Picture]                  NVARCHAR (200) NULL,
    [S_Pin_Code]                         NVARCHAR (50)  NULL,
    [S_CreatedBy]                        INT            NULL,
    [Dt_CreatedAt]                       DATETIME       NULL,
    [Dt_UpdatedAt]                       DATETIME       NULL,
    [I_Status]                           INT            NULL
);

