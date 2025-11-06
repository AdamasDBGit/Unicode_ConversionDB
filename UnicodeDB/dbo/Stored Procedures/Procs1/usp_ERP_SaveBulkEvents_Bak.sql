-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_SaveBulkEvents_Bak] 
 -- Add the parameters for the stored procedure here  
 (  
  @BulkUploadEventTables UT_BulkUploadEventTable readonly  
 )  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 DECLARE @ID INT = 1, @lst INT   
 DECLARE @I_event_ID INT  
  
 DECLARE @I_Barnd_Id INT, @S_Event_Name VARCHAR(500), @S_Event_For VARCHAR(500), @S_Event_Desc VARCHAR(500),  
 @S_CreatedBy VARCHAR(500), @S_Event_Category_Name VARCHAR(500), @S_Address VARCHAR(500),  
 @S_School_Group_Name VARCHAR(500), @S_Class VARCHAR(500), @S_Faculty_Name VARCHAR(500),  
 @Dt_StartDate DATE, @Dt_EndDate DATE, @S_Status INT  
    
 SELECT @S_Event_Name = S_Event_Name, @S_Event_For = S_Event_For, @S_Event_Desc = S_Event_Desc,  
 @S_CreatedBy = S_CreatedBy, @S_Event_Category_Name = S_Event_Category_Name, @S_Address = S_Address,  
 @S_School_Group_Name = S_School_Group_Name, @S_Class = S_Class, @S_Faculty_Name = S_Faculty_Name,  
 @Dt_StartDate = Dt_StartDate, @Dt_EndDate = Dt_EndDate, @I_Barnd_Id = I_Brand_Id, @S_Status = S_Status  
 FROM @BulkUploadEventTables WHERE ID = @ID  
  
 DECLARE @I_Event_Category_ID INT  
  
 IF EXISTS (  
  SELECT 1 FROM T_Event_Category WHERE S_Event_Category = @S_Event_Category_Name  
 )  
 Begin  
 SET @I_Event_Category_ID=(SELECT I_Event_Category_ID FROM T_Event_Category WHERE S_Event_Category = @S_Event_Category_Name)  
 End  
 Else  
 Begin  
 INSERT INTO T_Event_Category ( I_Brand_ID, S_Event_Category, I_Status, S_CreatedBy, Dt_CreatedOn, Dt_UpdatedOn)   
 SELECT I_Brand_Id, @S_Event_Category_Name, null, null, null, null FROM @BulkUploadEventTables WHERE ID = @ID  
 SET @I_Event_Category_ID = SCOPE_IDENTITY()  
 End  
  
 DECLARE @I_School_Group_ID INT  
  
 IF EXISTS (  
  SELECT 1 FROM T_School_Group WHERE S_School_Group_Name = @S_School_Group_Name  
 )  
 Begin  
 SET @I_School_Group_ID=(SELECT I_School_Group_ID FROM T_School_Group WHERE S_School_Group_Name = @S_School_Group_Name)  
 End  
 Else  
 Begin  
 SET @I_School_Group_ID = null  
 End  
  
 DECLARE @I_Class_ID INT  
  
 IF EXISTS (  
  SELECT 1 FROM T_Class WHERE S_Class_Name = @S_Class  
 )  
 Begin  
 SET @I_Class_ID=(SELECT I_Class_ID FROM T_Class WHERE S_Class_Name = @S_Class)  
 End  
 Else  
 Begin  
 SET @I_Class_ID= null  
 end  
  
 -- Student = 1 ; Taecher = 2; Both = 3 for I_Event 165676  
 DECLARE @I_Event_For INT  
  
 IF @S_Event_For = 'Student'   
 Begin  
  SET @I_Event_For = 1  
 End  
 ELSE IF @S_Event_For = 'Teacher'  
 Begin  
  SET @I_Event_For = 2  
 End  
 ELSE IF @S_Event_For = 'Both'  
 Begin  
  SET @I_Event_For = 3  
 End  
  
 DECLARE @I_Status_ID INT  
  
 IF @S_Status = 'Active'  
 Begin   
  SET @I_Status_ID = 1  
 End  
 ELSE   
 Begin  
  SET @I_Status_ID = 0  
 End  
  
  
 CREATE TABLE #Temp_T_Event (  
  [I_Brand_ID]INT NOT NULL, --  
  [S_Event_Name] VARCHAR(500) NOT NULL, --  
  [I_EventFor] INT NOT NULL,  
  [S_Event_Desc] VARCHAR(500) NOT NULL,  
  [S_CreatedBy] VARCHAR(500) NOT NULL,  
  [I_Event_Category_ID]INT NOT NULL, --  
  [S_Address] VARCHAR(500) NOT NULL,  
  [Dt_StartDate]DATE NOT NULL, --  
  [Dt_EndDate]DATE NOT NULL, --  
  [I_Status]INT NOT NULL, --  
  --ID INT IDENTITY(1,1)  
 )  
    
  INSERT INTO #Temp_T_Event (  
   [I_Brand_ID], --  
   [S_Event_Name],  
   [I_EventFor],  
   [S_Event_Desc],  
   [S_CreatedBy],  
   [I_Event_Category_ID], --  
   [S_Address],  
   [Dt_StartDate], --  
   [Dt_EndDate], --  
   [I_Status] --  
  )  
  VALUES (  
   @I_Barnd_Id,--  
   @S_Event_Name,--  
   @I_Event_For,--  
   @S_Event_Desc,--  
   @S_CreatedBy,  
   @I_Event_Category_ID,  
   @S_Address,  
   @Dt_StartDate,  
   @Dt_EndDate,  
   @I_Status_ID  
  )  
  
 --Event Name and other info is already inserted or not else insert  
 IF EXISTS (  
  SELECT 1  
        FROM T_Event e  
        INNER JOIN #Temp_T_Event TempTE ON e.I_Brand_ID = TempTE.I_Brand_ID  
                    AND e.S_Event_Name = TempTE.S_Event_Name  
     AND e.I_EventFor = TempTE.I_EventFor  
     AND e.S_Event_Desc = TempTE.S_Event_Desc  
     AND e.S_CreatedBy = TempTE.S_CreatedBy  
     AND e.I_Event_Category_ID = TempTE.I_Event_Category_ID  
     AND e.S_Address = TempTE.S_Address  
                    AND e.Dt_StartDate = TempTE.Dt_StartDate  
                    AND e.Dt_EndDate = TempTE.Dt_EndDate  
                    AND e.I_Status = TempTE.I_Status  
     --WHERE b.ID = @ID  
            )  
   Begin  
    SET @I_event_ID = (SELECT DISTINCT TOP 1 e.I_Event_ID FROM T_Event e  
      INNER JOIN #Temp_T_Event TempTE ON e.I_Brand_ID = TempTE.I_Brand_ID  
      AND e.S_Event_Name = TempTE.S_Event_Name  
      AND e.I_EventFor = TempTE.I_EventFor  
      AND e.S_Event_Desc = TempTE.S_Event_Desc  
      AND e.S_CreatedBy = TempTE.S_CreatedBy  
      AND e.I_Event_Category_ID = TempTE.I_Event_Category_ID  
      AND e.S_Address = TempTE.S_Address  
      AND e.Dt_StartDate = TempTE.Dt_StartDate  
      AND e.Dt_EndDate = TempTE.Dt_EndDate  
      AND e.I_Status = TempTE.I_Status  
     )  
   end  
   Else  
   Begin  
    --Inserting into T_Event and T_Event_Class  
    INSERT INTO T_Event (I_Brand_ID, S_Event_Name, I_EventFor, S_Event_Desc, S_CreatedBy,  
    I_Event_Category_ID, S_Address, Dt_StartDate, Dt_EndDate, I_Status)  
    Values ( @I_Barnd_Id, @S_Event_Name, @I_Event_For, @S_Event_Desc, @S_CreatedBy,  
    @I_Event_Category_ID, @S_Address, @Dt_StartDate, @Dt_EndDate, @I_Status_ID )  
  
    --DECLARE @I_event_ID INT  
    SET @I_event_ID = SCOPE_IDENTITY()  
  
     CREATE TABLE #Temp_T_Event_Class (  
        [I_Event_ID][INT],  
       [I_School_Group_ID][INT],  
       [I_Class_ID][INT]  
     )  
     INSERT INTO #Temp_T_Event_Class (  
      [I_Event_ID],  
      [I_School_Group_ID],  
      [I_Class_ID]  
     )  
     VALUES (  
      @I_event_ID,  
      @I_School_Group_ID,  
      @I_Class_ID  
     )  
  
    --T_Class check if not exists   
    IF NOT EXISTS (  
                SELECT 1  
                FROM T_Event_Class TEC  
                INNER JOIN #Temp_T_Event_Class b ON TEC.I_Event_ID = b.I_Event_ID  
     AND TEC.I_School_Group_ID = b.I_School_Group_ID  
     AND TEC.I_Class_ID = b.I_Class_ID  
     --WHERE b.ID = @ID  
    )  
    Begin  
      INSERT INTO T_Event_Class (I_Event_ID, I_School_Group_ID, I_Class_ID)  
      Values (@I_event_ID, @I_School_Group_ID, @I_Class_ID)  
    End  
  
   end  
END
