CREATE TABLE [dbo].[T_FollowUPStageSequence] (
    [I_FollowUpStage_Sequence]     INT           IDENTITY (1, 1) NOT NULL,
    [S_Enquiry_Lead_Drop_Stage]    NVARCHAR (50) NULL,
    [S_Conversion_Priority_Stages] NVARCHAR (50) NULL,
    [S_Follow_up_Stage]            NVARCHAR (50) NULL
);

