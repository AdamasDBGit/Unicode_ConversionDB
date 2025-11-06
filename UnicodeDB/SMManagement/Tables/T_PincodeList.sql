CREATE TABLE [SMManagement].[T_PincodeList] (
    [Pincode]  VARCHAR (10) NULL,
    [StatusID] INT          CONSTRAINT [DF__T_Pincode__Statu__523972F1] DEFAULT ((1)) NULL
);

