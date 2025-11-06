      
--Procedure: usp_ERP_Savings_Fee_Fine_Conf                      
-- Ref Used: [UT_GST_Conf]                     
-- Author:      Parichoy Nandi                      
-- Create date: 15.02.2024        
-- Modified date:Null        
-- Reason: Grading Savings        
-- Description: Savings GST Configuration ;                     
-- =============================================                      
CREATE   PROCEDURE [dbo].[usp_ERP_Savings_GST_Conf]      
    @ComponentCatagoryID INT = NULL      
   ,@ComponentCatagoryType NVARCHAR(MAX)    
   ,@ComponentDesc NVARCHAR(MAX) =null   
   ,@p_I_CreatedBy int      
   ,@brandID int    
   ,@Is_Active Int Null      
   ,@GST_Conf [UT_GST_Conf] READONLY      
AS      
BEGIN      
    SET NOCOUNT ON;      
    BEGIN TRY      
        BEGIN TRANSACTION;      
      
    Declare @messageInsert int,@messageUpdate int  
	IF EXISTS(SELECT 1 
    FROM T_ERP_GST_Item_Category 
    WHERE LOWER(S_GST_FeeComponent_Category_Type) = LOWER(@ComponentCatagoryType) 
    AND (I_GST_FeeComponent_Catagory_ID != @ComponentCatagoryID OR @ComponentCatagoryID IS NULL))
	BEGIN
	   select 0 StatusFlag,    
             'Duplicate GST Component Catagory Type' Message  
	END
	ELSE
	BEGIN
        IF @ComponentCatagoryID IS NULL      
        BEGIN      
            INSERT INTO T_ERP_GST_Item_Category      
            (      
              S_GST_FeeComponent_Category_Type    
             ,S_GST_FeeComponent_Description    
             ,Is_Active     
   ,I_Brand_Id    
   ,I_Created_By  
   ,Dt_Created_At  
            )      
            Values      
            ( @ComponentCatagoryType, @ComponentDesc, @Is_Active,@brandID,@p_I_CreatedBy,GETDATE())      
            SET @ComponentCatagoryID = SCOPE_IDENTITY();    
            SET @messageInsert=1   
        END      
        ELSE      
        Begin      
      
            UPDATE T_ERP_GST_Item_Category      
            SET S_GST_FeeComponent_Category_Type = @ComponentCatagoryType     
              , S_GST_FeeComponent_Description = @ComponentDesc     
     ,Is_Active = @Is_Active    
              , I_Brand_ID = @brandID      
              , I_Updated_By = @p_I_CreatedBy  
     ,Dt_Updated_At = GetDate()  
            Where I_GST_FeeComponent_Catagory_ID = @ComponentCatagoryID      
        End      
      
        MERGE INTO T_ERP_GST_Configuration_Details AS target      
        Using @GST_Conf AS Source      
        ON target.I_GST_Configuration_ID = source.I_GST_Configuration_ID      
           And target.I_GST_FeeComponent_Catagory_ID = Source.I_GST_FeeComponent_Catagory_ID      
        WHEN MATCHED THEN      
            UPDATE SET N_Start_Amount = Source.N_Start_Amount      
                     , N_End_Amount = Source.N_End_Amount      
                     , N_CGST = Source.N_CGST  
      ,N_SGST = Source.N_SGST  
      ,N_IGST = Source.N_IGST  
                     , Is_Active = Source.Is_Active ,
					 I_GST_FeeComponent_Catagory_ID=@ComponentCatagoryID
                       
        WHEN NOT MATCHED THEN      
            INSERT      
            (      
    
               I_GST_FeeComponent_Catagory_ID    
              ,N_Start_Amount    
              ,N_End_Amount    
              ,N_CGST  
     ,N_SGST  
     ,N_IGST  
              ,Is_Active    
            )      
            Values      
            (@ComponentCatagoryID         
           , Source.N_Start_Amount      
           , Source.N_End_Amount      
           , Source.N_CGST    
     ,Source.N_SGST  
     ,Source.N_IGST  
           , Source.Is_Active      
            
            )      
        WHEN NOT MATCHED BY SOURCE       
  and target.I_GST_FeeComponent_Catagory_ID=@ComponentCatagoryID      
  THEN      
            Update SET Is_Active = 0;      
                        
    SET @messageUpdate=1  
	
   If (@messageInsert=1 and @messageUpdate=1)    
  Begin     
  select 1 StatusFlag,    
             'GST Configuration Added' Message    
  End    
  Else If (@messageUpdate=1 and @messageInsert is null)    
  Begin    
  select 1 StatusFlag,    
             'GST Configuration Updated' Message    
  End     
  Else    
  Begin    
  Print 'Action Not Taken '    
  End  
  END
        --select 1                       StatusFlag      
        --     , 'Fine Conf Updated' Message      
        COMMIT;      
    END TRY      
    BEGIN CATCH      
        IF @@TRANCOUNT > 0      
            ROLLBACK;      
      
        DECLARE @ErrMsg NVARCHAR(4000)   
              , @ErrSeverity int      
      
        SELECT ERROR_MESSAGE() as Message      
             , 0               StatusFlag      
      
        RAISERROR(@ErrMsg, @ErrSeverity, 1)      
      
    END CATCH;      
END;

