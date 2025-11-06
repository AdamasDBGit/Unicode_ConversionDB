CREATE TABLE [dbo].[T_ERP_Room_Type_Master] (
    [inRoomTypeId]                   INT              IDENTITY (1, 1) NOT NULL,
    [unRoomTypeId]                   UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [stRoomType]                     NVARCHAR (100)   NOT NULL,
    [inRoomCategory]                 INT              NULL,
    [stDescription]                  NVARCHAR (500)   NULL,
    [inNoofBeds]                     INT              NOT NULL,
    [dcCostPerBed]                   DECIMAL (18, 2)  NOT NULL,
    [flgIsGST]                       BIT              DEFAULT ((0)) NULL,
    [dcCGST]                         DECIMAL (18, 2)  NULL,
    [dcSGST]                         DECIMAL (18, 2)  NULL,
    [dcIGST]                         DECIMAL (18, 2)  NULL,
    [dcFinalCostPerBed]              DECIMAL (18, 2)  NULL,
    [flgIsActive]                    BIT              DEFAULT ((0)) NULL,
    [inCreatedBy]                    INT              NOT NULL,
    [dtCreateBy]                     DATETIME         NULL,
    [I_GST_FeeComponent_Catagory_ID] INT              NULL,
    PRIMARY KEY CLUSTERED ([inRoomTypeId] ASC)
);

