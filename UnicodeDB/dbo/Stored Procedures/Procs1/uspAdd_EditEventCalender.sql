-- =============================================          
-- Author:  <Parichoy Nandi>          
-- Create date: <30th August 2023>          
-- Description: <to add event>          
        
-- =============================================          
CREATE PROCEDURE [dbo].[uspAdd_EditEventCalender]          
 -- Add the parameters for the stored procedure here          
 @sEventName nvarchar(100),          
 @iEventCatagory int = null,          
 @EventForTeacher int = null,        
 @EventForStudent int = null,        
 @dtFormDate datetime,          
 @dtToDate datetime,          
 @tToTime time(0) =null,          
 @tFromTime time(0) = null,          
 @UTEvents UT_Events readonly,          
 @sCreatedBy nvarchar(50),          
 @iEventID int = null,          
 @brandid int           
           
AS          
begin transaction          
BEGIN TRY           
Begin          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;         
         
 --SELECT 1 AS StatusFlag, @UTEvents AS Message        
        
 DECLARE @ApplicableFor INT        
 IF @EventForTeacher IS null AND @EventForStudent = 1        
 Begin        
  SET @ApplicableFor = 1        
 End        
 ELSE IF @EventForTeacher = 1 AND @EventForStudent IS null        
 Begin        
  SET @ApplicableFor = 2        
 End        
 ELSE IF @EventForTeacher = 1 AND @EventForStudent = 1        
 Begin        
  SET @ApplicableFor = 3        
 End        
        
 IF @iEventID IS null   ------------------New Entry-----------------        
 Begin        
        
  Insert into T_Event        
  (I_Brand_ID, I_Event_Category_ID, S_Event_Name, Dt_StartDate, Dt_EndDate, I_Status, I_EventFor, S_CreatedBy, Dt_CreatedOn)        
  Select @brandid, @iEventCatagory, @sEventName, @dtFormDate, @dtToDate, 1, @ApplicableFor, @sCreatedBy, GETDATE()        
        
  SET @iEventID = SCOPE_IDENTITY()        
        
  IF @EventForTeacher IS null AND @EventForStudent = 1  ------------For Student----------------        
  Begin        
           
   INSERT INTO T_Event_Class (          
     [I_Event_ID],          
     [I_School_Group_ID],          
     [I_Class_ID],         
     [Is_Active]        
    )          
    SELECT         
     @iEventID,          
     SchoolGroupID,      
     ClassID,        
     1        
    FROM @UTEvents        
        
    SELECT 1 AS StatusFlag, 'Event Added' AS Message        
  End        
  ELSE IF @EventForTeacher = 1 AND @EventForStudent IS null ----------For Teacher-------------------        
  Begin        
   Insert into T_ERP_Event_Faculty (        
    I_Event_ID,        
    I_Faculty_Master_ID,        
    Is_Active        
   )        
   Select @iEventID, I_Faculty_Master_ID, 1        
   From T_Faculty_Master WHERE I_Brand_ID = @brandid        
   SELECT 1 AS StatusFlag, 'Event Added' AS Message        
  End        
  ELSE IF @EventForTeacher = 1 AND @EventForStudent = 1 --------------For Both (Teacher & Student)--------------------        
  Begin        
   INSERT INTO T_Event_Class (          
     [I_Event_ID],          
     [I_School_Group_ID],          
     [I_Class_ID],          
     [Is_Active]        
    )          
    SELECT         
     @iEventID,          
     SchoolGroupID,      
     ClassID,        
     1         
    FROM @UTEvents        
        
    Insert into T_ERP_Event_Faculty (        
    I_Event_ID,        
    I_Faculty_Master_ID,        
    Is_Active        
   )        
   Select @iEventID, I_Faculty_Master_ID, 1        
   From T_Faculty_Master WHERE I_Brand_ID = @brandid        
        
   SELECT 1 AS StatusFlag, 'Event Added' AS Message        
  End        
  ELSE        
  BEGIN         
   SELECT 1 AS StatusFlag, 'Need to select atleast one Applicable For' AS Message        
  END        
        
  --SELECT 1 AS StatusFlag, 'Event Updated' AS Message        
 End        
 Else ----------------Edit Entry-------------        
 Begin        
  IF @EventForStudent = 1 AND @EventForTeacher IS null        
  Begin     
        
    MERGE T_Event_Class AS tgt        
    USING @UTEvents AS src        
        ON (tgt.I_Class_ID = src.ClassID AND tgt.I_School_Group_ID = src.SchoolGroupID     
  AND tgt.I_Event_ID = @iEventID  )        
    WHEN MATCHED      
        THEN        
            UPDATE        
            SET Is_Active = 1, dt_Modified_dt = GETDATE()     
   WHEN NOT MATCHED BY TARGET      
   THEN    
    INSERT  (          
      [I_Event_ID],          
      [I_School_Group_ID],          
      [I_Class_ID],         
      Is_Active        
     )          
     Values (      
     @iEventID,          
     Src.SchoolGroupID,      
     Src.ClassID,        
     1      
  )  ;  
  --WHEN NOT MATCHED BY SOURCE      
  --THEN    
  --UPDATE        
  --          SET Is_Active = 0, dt_Modified_dt = GETDATE();    
     
  -- End     
  -----Deactivating Teacher Association-----    
   IF EXISTS ( SELECT 1 FROM T_ERP_Event_Faculty TEF        
   WHERE I_Event_ID = @iEventID)        
   Begin        
    UPDATE T_ERP_Event_Faculty SET Is_Active = 0, dt_Modified_dt = GETDATE()         
    WHERE I_Event_ID = @iEventID          
        
   End     
   ----------Deactivating Teacher Association------------    
 --    IF EXISTS ( SELECT 1 FROM T_Event_Class TEC         
 --  inner join @UTEvents ut ON TEC.I_Class_ID = ut.ClassID AND TEC.I_School_Group_ID = ut.SchoolGroupID        
 --  WHERE I_Event_ID = @iEventID and TEC.Is_Active = 0)        
 --  Begin        
 --   UPDATE TEC SET Is_Active = 1, dt_Modified_dt = GETDATE()        
 --   FROM T_Event_Class TEC     
 --inner join @UTEvents UT         
 --   ON  TEC.I_Class_ID = UT.ClassID  AND TEC.I_School_Group_ID = UT.SchoolGroupID         
 --   WHERE I_Event_ID = @iEventID AND TEC.Is_Active = 0        
 --  End        
 --   --MERGE T_Event_Class AS tgt        
 --   --USING @UTEvents AS src        
 --   --    ON (tgt.I_Class_ID = src.ClassID AND tgt.I_School_Group_ID = src.SchoolGroupID AND tgt.I_Event_ID = @iEventID)        
 --   --WHEN MATCHED        
 --   --    THEN        
 --   --        UPDATE        
 --   --        SET Is_Active = 1, dt_Modified_dt = GETDATE();        
        
  End        
  ELSE IF @EventForStudent IS null AND @EventForTeacher = 1        
  Begin        
   --IF NOT EXISTS (Select 1 from T_ERP_Event_Faculty     
   --WHERE I_Event_ID = @iEventID )        
  -- Begin        
    Insert into T_ERP_Event_Faculty (        
     I_Event_ID,        
     I_Faculty_Master_ID,        
     Is_Active        
    )        
    Select @iEventID, I_Faculty_Master_ID, 1        
    From T_Faculty_Master FM WHERE I_Brand_ID = @brandid  and Not exists(  
 Select 1 from T_ERP_Event_Faculty EF where EF.I_Event_ID=@iEventID   
 and EF.I_Faculty_Master_ID=FM.I_Faculty_Master_ID   
 )     
 If Exists (Select 1 from T_ERP_Event_Faculty where Is_Active=0 and I_Event_ID=@iEventID)  
 Begin  
 Update T_ERP_Event_Faculty set Is_Active=1 where I_Event_ID=@iEventID  
    End        
   IF EXISTS ( SELECT 1 FROM T_Event_Class WHERE I_Event_ID = @iEventID AND Is_Active = 1)        
   Begin        
    UPDATE T_Event_Class SET Is_Active = 0 WHERE I_Event_ID = @iEventID        
   End        
        
  End        
  ELSE IF @EventForStudent = 1 AND @EventForTeacher = 1        
  Begin        
   IF EXISTS (Select 1 from T_ERP_Event_Faculty WHERE I_Event_ID = @iEventID AND Is_Active = 0)        
   Begin        
    UPDATE T_ERP_Event_Faculty SET Is_Active = 1, dt_Modified_dt = GETDATE()         
    WHERE I_Event_ID = @iEventID AND Is_Active = 0         
   End        
   ELSE        
   Begin        
    Insert into T_ERP_Event_Faculty (        
     I_Event_ID,        
     I_Faculty_Master_ID,        
     Is_Active        
    )        
    Select @iEventID, I_Faculty_Master_ID, 1        
    From T_Faculty_Master FM WHERE Fm.I_Brand_ID = @brandid  and Not exists(  
 Select 1 from T_ERP_Event_Faculty EF where EF.I_Event_ID=@iEventID   
 and EF.I_Faculty_Master_ID=FM.I_Faculty_Master_ID and EF.Is_Active=1  
 )  
    End      
   ------------Merge Event_Class------    
   --IF EXISTS ( SELECT 1 FROM T_Event_Class TEC         
   --inner join @UTEvents ut ON TEC.I_Class_ID = ut.ClassID AND TEC.I_School_Group_ID = ut.SchoolGroupID        
   --WHERE I_Event_ID = @iEventID and Is_Active = 0)        
   --Begin        
   -- UPDATE TEC SET Is_Active = 1, dt_Modified_dt = GETDATE()        
   -- FROM T_Event_Class TEC inner join @UTEvents UT         
   -- ON UT.ClassID = TEC.I_Class_ID AND UT.SchoolGroupID = TEC.I_School_Group_ID        
   -- WHERE I_Event_ID = @iEventID AND TEC.Is_Active = 0        
   --End        
   --IF NOT EXISTS ( SELECT 1 FROM T_Event_Class TEC         
   --inner join @UTEvents ut ON TEC.I_Class_ID = ut.ClassID AND TEC.I_School_Group_ID = ut.SchoolGroupID        
   --WHERE I_Event_ID = @iEventID and Is_Active = 1)        
   --Begin        
   -- INSERT INTO T_Event_Class (          
   --   [I_Event_ID],          
   --   [I_School_Group_ID],          
   --   [I_Class_ID],        
   --   [Is_Active]        
   --  )          
   --  SELECT         
   --   @iEventID,            
   --   SchoolGroupID,       
   --ClassID,      
   --   1        
   --  FROM @UTEvents        
   --End       
    MERGE T_Event_Class AS tgt        
    USING @UTEvents AS src        
        ON (tgt.I_Class_ID = src.ClassID AND tgt.I_School_Group_ID = src.SchoolGroupID     
  AND tgt.I_Event_ID = @iEventID  )        
    WHEN MATCHED      
        THEN        
            UPDATE        
            SET Is_Active = 1, dt_Modified_dt = GETDATE()     
   WHEN NOT MATCHED BY TARGET      
   THEN    
    INSERT  (          
      [I_Event_ID],          
      [I_School_Group_ID],          
      [I_Class_ID],         
      Is_Active        
     )          
     Values (      
     @iEventID,          
     Src.SchoolGroupID,      
     Src.ClassID,        
     1      
  )    ;
  --WHEN NOT MATCHED BY SOURCE      
  --THEN    
  --UPDATE        
  --          SET Is_Active = 0, dt_Modified_dt = GETDATE();    
  End        
  Update T_Event        
  Set I_Brand_ID = @brandid, I_Event_Category_ID = @iEventCatagory,        
  S_Event_Name = @sEventName, Dt_StartDate = @dtFormDate, Dt_EndDate = @dtToDate,        
  I_Status = 1, I_EventFor = @ApplicableFor, S_CreatedBy = @sCreatedBy, Dt_CreatedOn = GETDATE()        
  WHERE I_Event_ID = @iEventID AND I_Brand_ID = @brandid        
        
  SELECT 1 AS StatusFlag, 'Event Updated' AS Message        
 END          
End        
END TRY          
BEGIN CATCH          
 rollback transaction          
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int          
          
 SELECT @ErrMsg = ERROR_MESSAGE(),          
   @ErrSeverity = ERROR_SEVERITY()          
select 0 StatusFlag,@ErrMsg Message          
END CATCH          
commit transaction 
