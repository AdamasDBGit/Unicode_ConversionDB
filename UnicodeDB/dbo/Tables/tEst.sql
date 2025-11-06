CREATE TABLE [dbo].[tEst] (
    [Test]  NVARCHAR (MAX) NULL,
    [Cr_Dt] DATETIME       CONSTRAINT [DF__tEst__Cr_Dt__00ABDFC5] DEFAULT (getdate()) NULL
);

