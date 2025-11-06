CREATE TABLE [dbo].[Tbl_KPMG_MoMaster] (
    [Fld_KPMG_Mo_Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_GrnNumber]    VARCHAR (20)   CONSTRAINT [DF_T_MoMaster_GrnNumber] DEFAULT ((0)) NOT NULL,
    [Fld_KPMG_Branch_Id]    INT            NOT NULL,
    [Fld_KPMG_Created Date] DATETIME       CONSTRAINT [DF_T_MoMaster_Created Date] DEFAULT (getdate()) NOT NULL,
    [Fld_KPMG_RequiredDate] DATETIME       CONSTRAINT [DF_T_MoMaster_RequiredDate] DEFAULT (dateadd(day,(15),getdate())) NOT NULL,
    [Fld_KPMG_IsMo]         INT            CONSTRAINT [DF_Tbl_KPMG_MoMaster_Fld_KPMG_IsMo] DEFAULT ((1)) NOT NULL,
    [Fld_KPMG_Status]       INT            CONSTRAINT [DF_Tbl_KPMG_MoMaster_Fld_KPMG_Status] DEFAULT ((0)) NOT NULL,
    [Fld_KPMG_ISCollected]  CHAR (1)       CONSTRAINT [DF__Tbl_KPMG___Fld_K__18C3FA05] DEFAULT ('N') NULL,
    [Fld_KPMG_Context]      NVARCHAR (255) NULL,
    [Fld_KPMG_MoLineId]     INT            NULL,
    [Fld_KPMG_MoLineNumber] INT            NULL,
    CONSTRAINT [PK_T_MoMaster] PRIMARY KEY CLUSTERED ([Fld_KPMG_Mo_Id] ASC)
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER trg_KPMG_MOUpdate 
   ON  Tbl_KPMG_MoMaster
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
    DECLARE @MO_ID INT
    DECLARE @BRANCH_ID	INT
	DECLARE @BRANCH_NAME varchar(255)
	DECLARE @Mo_Context varchar(255)
			
    SELECT @MO_ID = i.Fld_KPMG_Mo_Id
    FROM INSERTED i join DELETED d on i.Fld_KPMG_Mo_Id = d.Fld_KPMG_Mo_Id
    
    IF EXISTS (SELECT 1 FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id = ISNULL(@MO_ID,0))
    BEGIN
		IF EXISTS(SELECT 1 FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id = ISNULL(@MO_ID,0) AND ISNULL(Fld_KPMG_Status,-1) = 0 AND ISNULL(Fld_KPMG_GrnNumber,0) <> 0)
			AND NOT EXISTS(SELECT 1 FROM tbl_KPMG_Notifications WHERE UniqueKey = 'Tbl_KPMG_MoMaster' + CONVERT(varchar(50),@MO_ID) AND BranchId = @BRANCH_ID)
		BEGIN
			
			SELECT @BRANCH_ID = Fld_KPMG_Branch_Id, @Mo_Context = Fld_KPMG_Context FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id = ISNULL(@MO_ID,0)
			SELECT @BRANCH_NAME = S_Center_Name FROM T_Center_Hierarchy_Name_Details WHERE I_Center_ID = @BRANCH_ID
			DECLARE @msg varchar(max)
			IF ISNULL(@Mo_Context,'') = 'BRANCH_TO_CCT'
			BEGIN
				SET @msg = 'A new MoveOrder( MOV_'+ CONVERT(varchar(50),@MO_ID) +') has been generated from Branch' + @BRANCH_NAME
			END
			ELSE IF ISNULL(@Mo_Context,'') = 'REV_MO'
			BEGIN
				SET @msg = 'A reverse MoveOrder( MOV_'+ CONVERT(varchar(50),@MO_ID) +') has been generated from Branch' + @BRANCH_NAME
			END
			
			IF ISNULL(@msg,'') <> ''
			BEGIN
				INSERT INTO tbl_KPMG_Notifications (NotificationMessage,TaskMessage,UniqueKey,BranchId)
				values ( @msg,
						'Load Materials from Central WareHouse for Branch' + @BRANCH_NAME,
						'Tbl_KPMG_MoMaster' + CONVERT(varchar(50),@MO_ID),
					@BRANCH_ID)
			END
		END
		ELSE IF EXISTS (SELECT 1 FROM Tbl_KPMG_MoMaster WHERE Fld_KPMG_Mo_Id = ISNULL(@MO_ID,0) AND ISNULL(Fld_KPMG_Status,-1) = 1 AND ISNULL(Fld_KPMG_GrnNumber,0) <> 0)
		BEGIN						
		
			DELETE FROM tbl_KPMG_Notifications WHERE UniqueKey = 'Tbl_KPMG_MoMaster' + CONVERT(varchar(50),@MO_ID) AND BranchId = @BRANCH_ID					
		END
    END
    

END