CREATE TYPE [dbo].[UT_SubjectStructure] AS TABLE (
    [StructureName]  VARCHAR (255) NOT NULL,
    [SequenceNumber] INT           NOT NULL,
    [IsLeaf]         INT           NULL);

