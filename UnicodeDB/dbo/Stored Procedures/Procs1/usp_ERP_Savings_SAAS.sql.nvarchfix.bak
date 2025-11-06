CREATE PROCEDURE [dbo].[usp_ERP_Savings_SAAS]      
   @SAAS_UT [UT_SAAS] READONLY      
  
AS          
BEGIN          
    SET NOCOUNT ON;          
    BEGIN TRY          
        BEGIN TRANSACTION;          

    MERGE INTO [T_ERP_Saas_Pattern_Child_Header] AS target    
    USING @SAAS_UT AS source    
    ON target.I_Saas_Pattern_Child_Header_ID = source.I_Saas_Pattern_Child_Header_ID   
 and target.I_Pattern_HeaderID = source.I_Pattern_HeaderID    
    WHEN MATCHED THEN    
        UPDATE SET target.N_Value = source.N_Value ,  
     target.Is_Active = 1  ,
	 target.Pattern1 = source.Pattern1,
	 target.Pattern2 = source.Pattern2,
	 target.Pattern3 = source.Pattern3
    WHEN NOT MATCHED BY TARGET AND source.N_Value IS NOT NULL or source.N_Value=0 THEN   
        INSERT (I_Pattern_HeaderID, N_Value,Is_Active,Pattern1,Pattern2,Pattern3)    
        VALUES (source.I_Pattern_HeaderID, source.N_Value,1,Pattern1,Pattern2,Pattern3);    
          
  update a set a.Is_Active=0 from T_ERP_Saas_Pattern_Child_Header a where I_Saas_Pattern_Child_Header_ID not in  (select [I_Saas_Pattern_Child_Header_ID] from @SAAS_UT)  
  
select 1 StatusFlag , 'SAAS Configured' Message   
        COMMIT;          
    END TRY          
    BEGIN CATCH          
        IF @@TRANCOUNT > 0          
            ROLLBACK;          
          
        DECLARE @ErrMsg Nnvarchar(max)       
              , @ErrSeverity int          
          
        SELECT ERROR_MESSAGE() as Message          
             , 0               StatusFlag          
          
        RAISERROR(@ErrMsg, @ErrSeverity, 1)          
          
    END CATCH;          
END;
