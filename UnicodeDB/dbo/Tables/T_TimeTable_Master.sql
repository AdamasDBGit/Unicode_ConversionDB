CREATE TABLE [dbo].[T_TimeTable_Master] (
    [I_TimeTable_ID]                     INT            IDENTITY (1, 1) NOT NULL,
    [I_Center_ID]                        INT            NOT NULL,
    [Dt_Schedule_Date]                   DATETIME       NOT NULL,
    [I_TimeSlot_ID]                      INT            NOT NULL,
    [I_Batch_ID]                         INT            NULL,
    [I_Room_ID]                          INT            NOT NULL,
    [I_Skill_ID]                         INT            NULL,
    [I_Status]                           INT            NOT NULL,
    [S_Crtd_By]                          NVARCHAR (MAX) NOT NULL,
    [Dt_Crtd_On]                         DATETIME       NOT NULL,
    [S_Updt_By]                          NVARCHAR (MAX) NULL,
    [Dt_Updt_On]                         DATETIME       NULL,
    [S_Remarks]                          NVARCHAR (MAX) NULL,
    [I_Session_ID]                       INT            NULL,
    [I_Term_ID]                          INT            NULL,
    [I_Module_ID]                        INT            NULL,
    [S_Session_Name]                     NVARCHAR (MAX) NULL,
    [S_Session_Topic]                    NVARCHAR (MAX) NULL,
    [Dt_Actual_Date]                     DATETIME       NULL,
    [I_Is_Complete]                      INT            NULL,
    [I_Sub_Batch_ID]                     INT            NULL,
    [I_SessionTopic_Completed_Status_ID] INT            CONSTRAINT [Df_DefaultValue] DEFAULT ((2)) NULL,
    [I_ClassTest_Status_ID]              INT            CONSTRAINT [Df_ClassTest] DEFAULT ((2)) NULL,
    [I_ClassType]                        INT            NULL,
    CONSTRAINT [PK_T_TimeTable_Master] PRIMARY KEY CLUSTERED ([I_TimeTable_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NC_TIMETBLE_CNTR_STST_DT]
    ON [dbo].[T_TimeTable_Master]([I_Center_ID] ASC, [I_Status] ASC, [Dt_Schedule_Date] ASC)
    INCLUDE([I_TimeTable_ID], [I_TimeSlot_ID]);


GO
CREATE TRIGGER [dbo].[trgAfterInsertTimetableMaster] ON [dbo].[T_TimeTable_Master]
    AFTER INSERT
AS
    DECLARE @timetableid INT ;
    DECLARE @centerid INT ;
    DECLARE @scheduledate DATETIME ;
    DECLARE @timeslotid INT ;
    DECLARE @batchid INT ;
    DECLARE @roomid INT ;
    DECLARE @skillid INT ;
    DECLARE @istatus INT ;
    DECLARE @crtdby VARCHAR(20) ;
    DECLARE @dtcrtdon DATETIME ;
    DECLARE @supdby VARCHAR(20) ;
    DECLARE @dtupdon DATETIME ;
    DECLARE @remarks VARCHAR(500) ;
    DECLARE @sessionid INT ;
    DECLARE @termid INT ;
    DECLARE @moduleid INT ;
    DECLARE @sessionname VARCHAR(500) ;
    DECLARE @sessiontopic VARCHAR(500) ;
    DECLARE @dtactual DATETIME ;
    DECLARE @iiscomplete INT ;
    DECLARE @employeeid INT ;
    DECLARE @bisactual BIT ;

    SELECT  @timetableid = i.I_TimeTable_ID
    FROM    inserted i ;	
    SELECT  @centerid = i.I_Center_ID
    FROM    inserted i ;	
    SELECT  @scheduledate = i.Dt_Schedule_Date
    FROM    inserted i ;	
    SELECT  @timeslotid = i.I_TimeSlot_ID
    FROM    inserted i ;	
    SELECT  @batchid = i.I_Batch_ID
    FROM    inserted i ;	
    SELECT  @roomid = i.I_Room_ID
    FROM    inserted i ;	
    SELECT  @skillid = i.I_Skill_ID
    FROM    inserted i ;
    SELECT  @istatus = i.I_Status
    FROM    INSERTED i ;	
    SELECT  @crtdby = i.S_Crtd_By
    FROM    inserted i ;	
    SELECT  @dtcrtdon = i.Dt_Crtd_On
    FROM    inserted i ;	
    SELECT  @supdby = i.S_Updt_By
    FROM    inserted i ;	
    SELECT  @dtupdon = i.Dt_Updt_On
    FROM    inserted i ;	
    SELECT  @remarks = i.S_Remarks
    FROM    inserted i ;	
    SELECT  @sessionid = i.I_Session_ID
    FROM    inserted i ;	
    SELECT  @termid = i.I_Term_ID
    FROM    inserted i ;
    SELECT  @moduleid = i.I_Module_ID
    FROM    inserted i ;	
    SELECT  @sessionname = i.S_Session_Name
    FROM    inserted i ;	
    SELECT  @sessiontopic = i.S_Session_Topic
    FROM    inserted i ;	
    SELECT  @dtactual = i.Dt_Actual_Date
    FROM    inserted i ;	
    SELECT  @iiscomplete = i.I_Is_Complete
    FROM    inserted i ;	
    

    INSERT  INTO dbo.T_TimeTable_Master_Planned
            ( I_TimeTable_ID ,
              I_Center_ID ,
              Dt_Schedule_Date ,
              I_TimeSlot_ID ,
              I_Batch_ID ,
              I_Room_ID ,
              I_Skill_ID ,
              I_Status ,
              S_Crtd_By ,
              Dt_Crtd_On ,
              S_Updt_By ,
              Dt_Updt_On ,
              S_Remarks ,
              I_Session_ID ,
              I_Term_ID ,
              I_Module_ID ,
              S_Session_Name ,
              S_Session_Topic ,
              Dt_Actual_Date ,
              I_Is_Complete,
              I_Employee_ID,
              B_Is_Actual
	            
	          
            )
    VALUES  ( @timetableid ,
              @centerid ,
              @scheduledate ,
              @timeslotid ,
              @batchid ,
              @roomid ,
              @skillid ,
              @istatus ,
              @crtdby ,
              @dtcrtdon ,
              @supdby ,
              @dtupdon ,
              @remarks ,
              @sessionid ,
              @termid ,
              @moduleid ,
              @sessionname ,
              @sessiontopic ,
              @dtactual ,
              @iiscomplete,
              0,
              1
	        
            ) ;
            
    --SELECT  @employeeid = ( SELECT  I_Employee_ID
    --                        FROM    dbo.T_TimeTable_Faculty_Map
    --                        WHERE   I_TimeTable_ID = @timetableid
    --                      )
    --SELECT  @bisactual = ( SELECT   B_Is_Actual
    --                       FROM     dbo.T_TimeTable_Faculty_Map
    --                       WHERE    I_TimeTable_ID = @timetableid
    --                     )
                         
    --UPDATE dbo.T_TimeTable_Master_Planned SET I_Employee_ID=@employeeid,B_Is_Actual=@bisactual WHERE I_TimeTable_ID=@timetableid
GO
DISABLE TRIGGER [dbo].[trgAfterInsertTimetableMaster]
    ON [dbo].[T_TimeTable_Master];

