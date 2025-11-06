CREATE TYPE [dbo].[UT_Student_Document_Map] AS TABLE (
    [I_Enquiry_Regn_ID]      INT           NOT NULL,
    [I_Document_StudRegn_ID] INT           NULL,
    [R_I_Document_Type_ID]   INT           NOT NULL,
    [I_Seq_No]               INT           NOT NULL,
    [S_Imagepath]            VARCHAR (500) NOT NULL,
    [Is_Active]              BIT           NULL);

