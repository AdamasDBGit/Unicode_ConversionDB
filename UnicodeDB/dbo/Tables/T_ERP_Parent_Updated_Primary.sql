CREATE TABLE [dbo].[T_ERP_Parent_Updated_Primary] (
    [ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [S_Student_ID]        NVARCHAR (MAX) NULL,
    [I_Student_Detail_ID] INT            NULL,
    [I_Parent_Master_ID]  INT            NULL,
    [S_Mobile_No]         NVARCHAR (MAX) NULL,
    [S_First_Name]        NVARCHAR (100) NULL,
    [S_Middile_Name]      NVARCHAR (100) NULL,
    [S_Last_Name]         NVARCHAR (100) NULL,
    [I_Relation_ID]       INT            NULL,
    [dt_Createdt]         DATETIME       DEFAULT (getdate()) NULL,
    [dt_lastfrom_update]  DATETIME       NULL,
    [Is_updated_GPS]      BIT            NULL
);

