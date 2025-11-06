CREATE TYPE [dbo].[UT_Bulk_Events] AS TABLE (
    [I_Brand_ID]          INT           NOT NULL,
    [I_Event_Category_ID] INT           NOT NULL,
    [S_Event_Name]        VARCHAR (500) NOT NULL,
    [Dt_StartDate]        DATE          NOT NULL,
    [Dt_EndDate]          DATE          NOT NULL,
    [I_Status]            INT           NOT NULL,
    [I_School_Group_ID]   INT           NOT NULL,
    [I_Class_ID]          INT           NOT NULL);

