CREATE TYPE [dbo].[UT_StudentPromotionDetails] AS TABLE (
    [I_Student_DetailID]             INT            NULL,
    [I_Source_Academic_Session]      INT            NULL,
    [I_Destination_Academic_Session] INT            NULL,
    [I_Source_Class_ID]              INT            NULL,
    [I_Source_Stream_ID]             INT            NULL,
    [I_Source_SectionID]             INT            NULL,
    [I_Destination_Class_ID]         INT            NULL,
    [I_Destination_Stream_ID]        INT            NULL,
    [I_Destination_SectionID]        INT            NULL,
    [I_Promotion_Status]             INT            NULL,
    [RollNo]                         INT            NULL,
    [Remarks]                        NVARCHAR (MAX) NULL,
    [I_Source_School_Group_ID]       INT            NULL,
    [I_Destination_School_Group_ID]  INT            NULL,
    [WillDemoted]                    BIT            NULL,
    [WillOnHold]                     BIT            NULL,
    [WillRetain]                     BIT            NULL);

