                 
  ----New------------    
CREATE   PROCEDURE [dbo].[usp_ERP_Discount_Savings]      
@SchemeID INT = NULL,  
  
@SchemeCode NVARCHAR(MAX),  
  
@SchemeName NVARCHAR(MAX),  
  
@ValidFrom DATE,  
  
@ValidTo DATE,  
  
@Status INT,  
  
@Description NVARCHAR(MAX),  
  
@CreatedBy NVARCHAR(MAX) = 'rice-group-admin',  
  
@BrandID INT,  
  
@UT_Discount  UT_Discount_Scheme_Comp READONLY    
AS      
Begin     
--    DECLARE @IsEdit int  
--    Select Distinct   
--@IsEdit=Case When FSS.R_I_FineRangeTagID IS NULL Then 1 Else 0 end  
--from T_ERP_Fee_Fine_Header as FFH     
--join T_ERP_Fee_PaymentInstallment_Type as FPT on FFH.FreqType=FPT.I_Fee_Pay_Installment_ID    
--Left Join T_ERP_Fee_Structure FSS on fss.R_I_FineRangeTagID=FFh.I_Fee_Fine_H_ID  
--where FFH.I_Fee_Fine_H_ID=ISNULL(@I_Fee_Fine_H_ID,FFH.I_Fee_Fine_H_ID)  and FFH.I_Brand_ID=@brandID  
--if(@IsEdit=0)  
--BEGIN  
--    select 0 StatusFlag,      
--                 'Component already mapped' Message    
--END  
--else  
--BEGIN  
    SET NOCOUNT ON;      
    BEGIN TRY      
        BEGIN TRANSACTION;      
      
    Declare @messageInsert int,@messageUpdate int    
        IF @SchemeID IS NULL      
        BEGIN      
            INSERT INTO T_Discount_Scheme_Master (  
  
                S_Discount_Scheme_Name,  
  
                Dt_Valid_From,  
  
                Dt_Valid_To,  
  
                I_Status,  
  
                S_Crtd_By,  
  
                S_Upd_By,  
  
                Dt_Crtd_On,  
  
                Dt_Upd_On,  
  
                I_Brand_ID,  
  
                S_Discount_Scheme_Code  
  
            )  
  
            VALUES (  
  
                @SchemeName,  
  
                @ValidFrom,  
  
                @ValidTo,  
  
                @Status,  
  
                @CreatedBy,  
  
                NULL,  
  
                GETDATE(),  
  
                NULL,  
  
                @BrandID,  
  
                @SchemeCode  
            );  
   SET @SchemeID = SCOPE_IDENTITY();  
   IF NOT Exists(  
   Select 1 from T_Discount_Brand_Map where I_Discount_Scheme_ID=@SchemeID  
   and I_Brand_ID=@BrandID and I_Status_ID=@Status  
   )  
   Begin  
   INSERT INTO T_Discount_Brand_Map (  
  
             I_Discount_Scheme_ID,  
  
             I_Brand_ID,   
  
             I_Status_ID  
  
             )  
  
            SELECT @SchemeID, @BrandID, @Status  
   End  
    SET @messageInsert=1   
        END      
        ELSE      
        BEGIN      
      
     UPDATE T_Discount_Scheme_Master  
  
    SET   
    S_Discount_Scheme_Name = @SchemeName,  
      
    Dt_Valid_From = @ValidFrom,  
  
     Dt_Valid_To = @ValidTo,  
  
     I_Brand_ID = @BrandID,  
  
     S_Upd_By = NULL,  
  
     Dt_Upd_On = NULL,  
  
     I_Status = @Status,  
  
     S_Discount_Scheme_Code = @SchemeCode  
WHERE I_Discount_Scheme_ID = @SchemeID;  
  
  Update T_Discount_Brand_Map set I_Status_ID=@Status where I_Discount_Scheme_ID=@SchemeID;  
        End      
    ---------------Discount Details------------------------  
        MERGE INTO T_ERP_Discount_Scheme_Details AS target      
        Using @UT_Discount AS Source      
        ON target.I_Discount_Scheme_Detail_ID = source.I_Discount_Scheme_Detail_ID      
           And target.I_Discount_Scheme_ID = Source.DiscountschemeID      
        WHEN MATCHED THEN      
            UPDATE SET N_Discount_Rate = Source.N_Discount_Rate      
                     , I_FromInstalment = Source.I_Applicable_From     
      , I_NoofInstallments=source.I_Applicable_To  
                     , I_FeeComponentID = Source.I_Component_ID     
      --, I_Brand_ID=@BrandID  
                     , I_Status_ID = 1    
                       
        WHEN NOT MATCHED THEN      
            INSERT      
            (      
    
               I_Discount_Scheme_ID    
              ,I_FromInstalment    
              ,I_NoofInstallments    
              ,I_FeeComponentID   
     ,N_Discount_Rate  
              ,I_Status_ID    
     ,I_Brand_ID  
            )      
            Values      
            (@SchemeID      
           , Source.I_Applicable_From      
          , Source.I_Applicable_To      
           , Source.I_Component_ID   
     ,source.N_Discount_Rate  
           , 1     
     ,@BrandID  
            
            )      
        WHEN NOT MATCHED BY SOURCE       
  and target.I_Discount_Scheme_ID=@SchemeID      
  THEN      
            Update SET I_Status_ID = 0;      
                        
    SET @messageUpdate=1  
   If (@messageInsert=1 and @messageUpdate=1)    
  Begin     
  select 1 StatusFlag,    
             'Discount Scheme Configuration Added' Message    
  End    
  Else If (@messageUpdate=1 and @messageInsert is null)    
  Begin    
  select 1 StatusFlag,    
             'Discount Scheme Configuration Updated' Message    
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
  
--END  
