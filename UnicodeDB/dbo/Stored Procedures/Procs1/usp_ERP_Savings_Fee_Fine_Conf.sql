    
--Procedure: usp_ERP_Savings_Fee_Fine_Conf                    
-- Ref Used: UT_Fee_Fine_Conf                   
-- Author:      Abhik Porel                    
-- Create date: 29.01.2024      
-- Modified date:Null      
-- Reason: Grading Savings      
-- Description: Savings Fine Configuration ;                   
-- =============================================                    
    
CREATE   PROCEDURE [dbo].[usp_ERP_Savings_Fee_Fine_Conf]    
    @I_Fee_Fine_H_ID INT = NULL    
   ,@Fine_Name NVARCHAR(MAX)  
   ,@FreqType int  
   ,@p_I_CreatedBy int    
   ,@brandID int  
   ,@Is_Active Int Null    
   ,@Fee_Fine_Conf [UT_Fee_Fine_Conf] READONLY    
AS    
BEGIN    
    SET NOCOUNT ON;    
    BEGIN TRY    
        BEGIN TRANSACTION;    
    
    Declare @messageInsert int,@messageUpdate int  
        IF @I_Fee_Fine_H_ID IS NULL    
        BEGIN    
            INSERT INTO T_ERP_Fee_Fine_Header    
            (    
              S_Name  
             ,FreqType  
             ,Is_Active  
             ,Dt_Create_DT   
    ,I_Brand_ID  
            )    
            Values    
            (@Fine_Name, @FreqType, @Is_Active, GETDATE(),@brandID)    
            SET @I_Fee_Fine_H_ID = SCOPE_IDENTITY();  
			 SET @messageInsert=1 
        END    
        ELSE    
        BEGIN    
    
            UPDATE T_ERP_Fee_Fine_Header    
            SET S_Name = @Fine_Name   
              , Dt_Create_DT = Getdate()   
     ,FreqType = @FreqType  
              , I_Brand_ID = @brandID    
              , Is_Active = @Is_Active    
            Where I_Fee_Fine_H_ID = @I_Fee_Fine_H_ID    
        End    
    
        MERGE INTO T_ERP_Fee_Fine_Details AS target    
        Using @Fee_Fine_Conf AS Source    
        ON target.I_Fee_Fine_D_ID = source.I_Fee_Fine_D_ID    
           And target.I_Fee_Fine_H_ID = Source.I_Fee_Fine_H_ID    
        WHEN MATCHED THEN    
            UPDATE SET I_Frm_Range = Source.I_Frm_Range    
                     , I_To_Range = Source.I_To_Range    
                     , N_Fine_Amount = Source.N_Fine_Amount    
                     , Is_Active = Source.Is_Active    
                     
        WHEN NOT MATCHED THEN    
            INSERT    
            (    
  
               I_Fee_Fine_H_ID  
              ,I_Frm_Range  
              ,I_To_Range  
              ,N_Fine_Amount  
              ,Is_Active  
            )    
            Values    
            (@I_Fee_Fine_H_ID    
           , Source.I_Frm_Range    
           , Source.I_To_Range    
           , Source.N_Fine_Amount    
           , Source.Is_Active    
          
            )    
        WHEN NOT MATCHED BY SOURCE     
  and target.I_Fee_Fine_H_ID=@I_Fee_Fine_H_ID    
  THEN    
            Update SET Is_Active = 0;    
                      
    SET @messageUpdate=1
	  If (@messageInsert=1 and @messageUpdate=1)  
  Begin   
  select 1 StatusFlag,  
             'Fine Configuration Added' Message  
  End  
  Else If (@messageUpdate=1 and @messageInsert is null)  
  Begin  
  select 1 StatusFlag,  
             'Fine Configuration Updated' Message  
  End   
  Else  
  Begin  
  Print 'Action Not Taken '  
  End 
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

