-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_ERP_SaveBulkEvents]    
 -- Add the parameters for the stored procedure here    
 (    
  @Is_Through_Bulk_upload INT,  
  @I_Barnd_Id INT,  
  @BulkUploadEventTables UT_BulkUploadEventTableEx readonly    
 )    
AS    
Begin    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
  
  CREATE TABLE #Temp_T_Event (    
  
   [ID] [int] IDENTITY(1,1) NOT NULL,  
 --[I_Brand_Id] [int] NOT NULL,  
 [S_Event_Name] [varchar](500) NULL,  
 [S_Event_For] [varchar](500) NULL,  
 [S_Event_Desc] [varchar](500) NULL,  
 [S_CreatedBy] [varchar](500) NULL,  
 [S_Event_Category_Name] [varchar](500) NULL,  
 [S_Address] [varchar](500) NULL,  
 [S_School_Group_Name] [varchar](500) NULL,  
 [S_Class] [varchar](500) NULL,  
 [S_Faculty_Name] [varchar](500) NULL,  
 [Dt_StartDate] [date] NULL,  
 [Dt_EndDate] [date] NULL,  
 [S_Status] [varchar](225) NULL  
 )    
      
  INSERT INTO #Temp_T_Event (    
   [S_Event_Name], --    
   [S_Event_For],    
   [S_Event_Desc],    
   [S_CreatedBy],    
   [S_Event_Category_Name],    
   [S_Address], --    
   [S_School_Group_Name],    
   [S_Class], --    
   [S_Faculty_Name], --    
   [Dt_StartDate],  
   [Dt_EndDate],  
   [S_Status]--    
  )    
  SELECT    
   [S_Event_Name], --    
   [S_Event_For],    
   [S_Event_Desc],    
   [S_CreatedBy],    
   [S_Event_Category_Name],    
   [S_Address], --    
   [S_School_Group_Name],    
   [S_Class], --    
   [S_Faculty_Name], --    
   [Dt_StartDate],  
   [Dt_EndDate],  
   [S_Status]--   
   FROM  @BulkUploadEventTables  
  
 DECLARE @ID INT = 1, @lst INT   -----------Declare var for loop  
 DECLARE @I_event_ID INT         -----------Declare var for event_ID  
 SET @lst=(SELECT Max(ID) from #Temp_T_Event) -------setting the last element to @lst  
  
 ---------Daclaring all the event parameters  
 DECLARE  @S_Event_Name VARCHAR(500), @S_Event_For VARCHAR(500), @S_Event_Desc VARCHAR(500),    
 @S_CreatedBy VARCHAR(500), @S_Event_Category_Name VARCHAR(500), @S_Address VARCHAR(500),    
 @S_School_Group_Name VARCHAR(500), @S_Class VARCHAR(500), @S_Faculty_Name VARCHAR(500),    
 @Dt_StartDate DATE, @Dt_EndDate DATE, @S_Status VARCHAR(500)    
  
 ---------Declaring all the ID parameters  
  DECLARE @I_School_Group_ID INT,  @I_Class_ID INT, @I_Event_For INT, @I_Status_ID INT    
  
 ------Starting While Loop--------------  
  WHILE   @ID<=@lst  
  Begin  
  
 SELECT @S_Event_Name = S_Event_Name, @S_Event_For = S_Event_For, @S_Event_Desc = S_Event_Desc,    
 @S_CreatedBy = S_CreatedBy, @S_Event_Category_Name = S_Event_Category_Name, @S_Address = S_Address,    
 @S_School_Group_Name = S_School_Group_Name, @S_Class = S_Class, @S_Faculty_Name = S_Faculty_Name,    
 @Dt_StartDate = Dt_StartDate, @Dt_EndDate = Dt_EndDate, @S_Status = S_Status    
 FROM #Temp_T_Event WHERE ID = @ID    
    
 ----------Getting the I_Event_Category_ID--------------  
 DECLARE @I_Event_Category_ID INT  
    
  ----------If category ID exists then get the Id else add category-----------  
 IF EXISTS (    
  SELECT 1 FROM T_Event_Category WHERE S_Event_Category = @S_Event_Category_Name    
 )    
 Begin    
 SET @I_Event_Category_ID=(SELECT TOP 1 I_Event_Category_ID FROM T_Event_Category WHERE S_Event_Category = @S_Event_Category_Name)    
 End    
 Else    
 Begin    
 INSERT INTO T_Event_Category ( I_Brand_ID, S_Event_Category, I_Status, S_CreatedBy, Dt_CreatedOn, Dt_UpdatedOn)     
 SELECT @I_Barnd_Id, @S_Event_Category_Name, null, null, null, null FROM #Temp_T_Event WHERE ID = @ID    
 SET @I_Event_Category_ID = SCOPE_IDENTITY()    
 End    
  
  
 -------------Defining the I_Event_For ID----------------  
  IF @S_Event_For = 'Student'     
 Begin    
  SET @I_Event_For = 1    
 End    
 ELSE IF (@S_Event_For = 'Teacher') --OR @S_Event_For = 'Faculty')    
 Begin    
  SET @I_Event_For = 2    
 End    
 ELSE   
 Begin    
  SET @I_Event_For = 3    
 End    
     
--------------Defining the I_Status_ID--------------------  
 IF @S_Status = 'Active'    
 Begin     
  SET @I_Status_ID = 1    
 End    
 ELSE     
 Begin    
  SET @I_Status_ID = 0    
 End    
  
---------------------------- Declaring SchoolGroup and Class ----------------------------------  
IF EXISTS (    
  SELECT 1 FROM T_School_Group WHERE S_School_Group_Name = @S_School_Group_Name    
 )    
 Begin    
 SET @I_School_Group_ID=(SELECT TOP 1 I_School_Group_ID FROM T_School_Group 
 WHERE S_School_Group_Name = @S_School_Group_Name and I_Brand_Id=@I_Barnd_Id)    
 End    
 Else    
 Begin    
 SET @I_School_Group_ID = null    
 End    
    
    
 IF EXISTS (    
  SELECT 1 FROM T_Class WHERE S_Class_Name = @S_Class    
 )    
 Begin    
 SET @I_Class_ID=(SELECT TOP 1 I_Class_ID FROM T_Class WHERE S_Class_Name = @S_Class and I_Brand_Id=@I_Barnd_Id)    
 End    
 Else    
 Begin    
 SET @I_Class_ID= null    
 end   
  
  
---------------- Student Start-------------------  
 If @S_Event_For='Student'   
 Begin  
    
  If(@I_School_Group_ID IS NOT null AND @I_Class_ID IS NOT null)  
 BEGIN  
  
   --Event Name and other info is already inserted or not else insert    
  IF EXISTS (    
  SELECT 1    
   FROM T_Event WITH(NOLOCK) WHERE I_Brand_ID=@I_Barnd_Id and I_Event_Category_ID=@I_Event_Category_ID  
   and S_Event_Name=@S_Event_Name and Dt_StartDate=@Dt_StartDate And  
   Dt_EndDate=@Dt_EndDate and I_Status=1   
    )    
  Begin    
  SET @I_event_ID = (  
  SELECT Top 1 I_Event_ID    
   FROM T_Event WHERE I_Brand_ID=@I_Barnd_Id and I_Event_Category_ID=@I_Event_Category_ID  
   and S_Event_Name=@S_Event_Name and Dt_StartDate=@Dt_StartDate And  
   Dt_EndDate=@Dt_EndDate and I_Status=1  
   )    
  end    
  Else    
  Begin    
  --Inserting into T_Event and T_Event_Class    
   INSERT INTO T_Event (I_Brand_ID, S_Event_Name, I_EventFor, S_Event_Desc, S_CreatedBy,    
   I_Event_Category_ID, S_Address, Dt_StartDate, Dt_EndDate, I_Status, Is_Through_Bulk_upload)    
   Values ( @I_Barnd_Id, @S_Event_Name, @I_Event_For, @S_Event_Desc, @S_CreatedBy,    
   @I_Event_Category_ID, @S_Address, @Dt_StartDate, @Dt_EndDate, 1, @Is_Through_Bulk_upload )    
     
   SET @I_event_ID = SCOPE_IDENTITY()    
    END  
    IF NOT EXISTS (Select 1 from T_Event_Class WITH(NOLOCK) Where [I_Event_ID]=@I_event_ID  
    And [I_School_Group_ID]=@I_School_Group_ID  
    And [I_Class_ID]=@I_Class_ID)  
    Begin  
    INSERT INTO T_Event_Class (    
     [I_Event_ID],    
     [I_School_Group_ID],    
     [I_Class_ID]  ,
	 Is_Active
    )    
    VALUES (    
     @I_event_ID,    
     @I_School_Group_ID,    
     @I_Class_ID  
	 ,1
    )    
  End  
 END   
 ELSE  
 BEGIN  
 print' GROUP AND CLASS NOT FOUND'  
 END  
 End -------End Of 'Student'-------------------  
  
 ELse If @S_Event_For='Teacher' ----------------------------Faculty Start-----------------------------  
 Begin  
    
 --Event Name and other info is already inserted or not else insert    
 IF EXISTS (    
  SELECT 1    
        FROM T_Event WITH(NOLOCK) WHERE I_Brand_ID=@I_Barnd_Id and I_Event_Category_ID=@I_Event_Category_ID  
  and S_Event_Name=@S_Event_Name and Dt_StartDate=@Dt_StartDate And  
  Dt_EndDate=@Dt_EndDate and I_Status=1  
            )    
   Begin    
    SET @I_event_ID = (  
 SELECT Top 1 I_Event_ID    
        FROM T_Event WITH(NOLOCK) WHERE I_Brand_ID=@I_Barnd_Id and I_Event_Category_ID=@I_Event_Category_ID  
  and S_Event_Name=@S_Event_Name and Dt_StartDate=@Dt_StartDate And  
  Dt_EndDate=@Dt_EndDate and I_Status=1  
     )    
   end    
   Else    
   Begin    
    --Inserting into T_Event and T_Event_Class    
 INSERT INTO T_Event (I_Brand_ID, S_Event_Name, I_EventFor, S_Event_Desc, S_CreatedBy,    
    I_Event_Category_ID, S_Address, Dt_StartDate, Dt_EndDate, I_Status, Is_Through_Bulk_upload)    
    Values ( @I_Barnd_Id, @S_Event_Name, @I_Event_For, @S_Event_Desc, @S_CreatedBy,    
    @I_Event_Category_ID, @S_Address, @Dt_StartDate, @Dt_EndDate, 1, @Is_Through_Bulk_upload )    
    
    --DECLARE @I_event_ID INT    
    SET @I_event_ID = SCOPE_IDENTITY()    
    
     --CREATE TABLE #Temp_T_Event_Class (    
     --   [I_Event_ID][INT],    
     --  [I_School_Group_ID][INT],    
     --  [I_Class_ID][INT]    
     --)   
 End  
  --Inserting in Event Faculty   
 Insert into T_ERP_Event_Faculty (  
  I_Event_ID,  
  I_Faculty_Master_ID  
 )  
 Select @I_event_ID, I_Faculty_Master_ID  
 From T_Faculty_Master WHERE I_Brand_ID = @I_Barnd_Id  
  
 End -------End Of 'Faculty'-------------  
 Else  
  
 Begin --------------------------Start of Both ( Student and faculty )---------------  
    
 --Event Name and other info is already inserted or not else insert    
 IF EXISTS (    
 SELECT 1    
  FROM T_Event WITH(NOLOCK) WHERE I_Brand_ID=@I_Barnd_Id and I_Event_Category_ID=@I_Event_Category_ID  
  and S_Event_Name=@S_Event_Name and Dt_StartDate=@Dt_StartDate And  
  Dt_EndDate=@Dt_EndDate and I_Status=1  
            )    
 Begin    
  SET @I_event_ID = (  
   SELECT Top 1 I_Event_ID    
   FROM T_Event WHERE I_Brand_ID=@I_Barnd_Id and I_Event_Category_ID=@I_Event_Category_ID  
   and S_Event_Name=@S_Event_Name and Dt_StartDate=@Dt_StartDate And  
   Dt_EndDate=@Dt_EndDate and I_Status=1  
  )    
   end    
   Else    
   Begin    
    --Inserting into T_Event and T_Event_Class    
  INSERT INTO T_Event (I_Brand_ID, S_Event_Name, I_EventFor, S_Event_Desc, S_CreatedBy,    
  I_Event_Category_ID, S_Address, Dt_StartDate, Dt_EndDate, I_Status, Is_Through_Bulk_upload)    
  Values ( @I_Barnd_Id, @S_Event_Name, @I_Event_For, @S_Event_Desc, @S_CreatedBy,    
  @I_Event_Category_ID, @S_Address, @Dt_StartDate, @Dt_EndDate, 1, @Is_Through_Bulk_upload )    
    
    --DECLARE @I_event_ID INT    
  SET @I_event_ID = SCOPE_IDENTITY()    
 End  
  
 Insert into T_ERP_Event_Faculty (  
  I_Event_ID,  
  I_Faculty_Master_ID  
 )  
 Select @I_event_ID, I_Faculty_Master_ID   
 From T_Faculty_Master EF1 WHERE I_Brand_ID = @I_Barnd_Id  
 AND NOT EXISTS (SELECT 1 FROM T_ERP_Event_Faculty EF WHERE I_Event_ID = @I_event_ID AND EF.I_Faculty_Master_ID = EF1.I_Faculty_Master_ID)  
  
 IF(@I_School_Group_ID IS NOT NULL AND @I_Class_ID IS NOT NULL)  
 BEGIN  
  IF NOT EXISTS (Select 1 from T_Event_Class WITH(NOLOCK) Where [I_Event_ID]=@I_event_ID  
   And [I_School_Group_ID]=@I_School_Group_ID  
   And [I_Class_ID]=@I_Class_ID)  
  Begin  
  
   INSERT INTO T_Event_Class (    
    [I_Event_ID],    
    [I_School_Group_ID],    
    [I_Class_ID] 
	,Is_Active
   )    
   VALUES (    
    @I_event_ID,    
    @I_School_Group_ID,    
    @I_Class_ID 
	,1
   )    
  End  
 END  
  
 End --------------End of both-------------  
  
 SET @id=@id+1  
 End  
  
 SELECT 1 AS StatusFlag, 'Events Successfully Uploaded' AS Message  
  
END
