CREATE TABLE [dbo].[T_Center_Hierarchy_Details] (
    [I_Center_Hierarchy_Detail_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Center_Id]                  INT      NOT NULL,
    [I_Hierarchy_Detail_ID]        INT      NOT NULL,
    [I_Hierarchy_Master_ID]        INT      NOT NULL,
    [Dt_Valid_From]                DATETIME NULL,
    [Dt_Valid_To]                  DATETIME NULL,
    [I_Status]                     INT      NULL,
    CONSTRAINT [PK__T_Center_Hierarc__1427CB6C] PRIMARY KEY CLUSTERED ([I_Center_Hierarchy_Detail_ID] ASC)
);

