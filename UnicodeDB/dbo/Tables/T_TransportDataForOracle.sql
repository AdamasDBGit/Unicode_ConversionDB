CREATE TABLE [dbo].[T_TransportDataForOracle] (
    [I_Center_ID]         INT             NULL,
    [S_Center_Name]       NVARCHAR (MAX)  NULL,
    [I_Student_Detail_ID] INT             NULL,
    [I_Route_ID]          INT             NULL,
    [I_PickUpPoint_ID]    INT             NULL,
    [S_Route_Name]        NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]          DATE            NULL,
    [I_Rank_ID]           INT             NULL,
    [Dt_StartDate]        DATE            NULL,
    [Dt_EndDate]          DATE            NULL,
    [N_Collectable]       NUMERIC (18, 2) NULL
);

