-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================   

CREATE  PROCEDURE [dbo].[usp_ERP_VerifyBulkEvents]    
 -- Add the parameters for the stored procedure here    
 (    
  @Is_Through_Bulk_upload INT Null,  
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
  

Select 
*

from #Temp_T_Event
 SELECT 1 AS StatusFlag, 'Events Successfully Uploaded' AS Message  
  
END
