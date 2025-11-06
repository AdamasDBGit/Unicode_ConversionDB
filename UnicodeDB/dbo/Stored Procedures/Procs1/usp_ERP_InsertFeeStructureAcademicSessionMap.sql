-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- exec [usp_ERP_InsertFeeStructureAcademicSessionMap] 107,21,2,1  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_InsertFeeStructureAcademicSessionMap]  
(  
 @BrandID int,  
 @FeeStructureID int,  
 @SchoolSessionID int,  
 @CreatedBy int   
)  
AS  
begin transaction  
BEGIN TRY   
 SET NOCOUNT ON;    
  
  If exists (select 1 from T_ERP_Fee_Structure_AcademicSession_Map 
  where I_Fee_Structure_ID=@FeeStructureID and I_School_Session_ID=@SchoolSessionID)  
  Begin  
   Update [dbo].[T_ERP_Fee_Structure_AcademicSession_Map]  
   Set  
    Is_Active = 1,  
    Dt_Updated_At = GETDATE(),  
    I_Updated_By = @CreatedBy  
   Where I_Fee_Structure_ID=@FeeStructureID and I_School_Session_ID=@SchoolSessionID  
   Update T_ERP_Fee_Structure_AcademicSession_Map set Is_Active=0 
   where I_Fee_Structure_ID=@FeeStructureID and I_School_Session_ID<>@SchoolSessionID
  end  
  else  
  begin  
   INSERT INTO [dbo].[T_ERP_Fee_Structure_AcademicSession_Map]  
   (  
    I_Brand_ID,  
    I_School_Session_ID,  
    I_Fee_Structure_ID,  
    Is_Active,  
    I_Created_By,  
    Dt_Created_At  
   )  
   VALUES  
   (  
    @BrandID,  
    @SchoolSessionID,  
    @FeeStructureID,  
    1,  
    @CreatedBy,  
    GETDATE()  
   )  

   Update T_ERP_Fee_Structure_AcademicSession_Map set Is_Active=0 
   where I_Fee_Structure_ID=@FeeStructureID and I_School_Session_ID<>@SchoolSessionID
  end  
  SELECT 1 StatusFlag,'Academic Session and Fee Structure Mapped successfully' Message       
  commit transaction;  
END TRY  
BEGIN CATCH  
 IF @@TRANCOUNT > 0  
  rollback transaction;  
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 --SELECT @ErrMsg = ERROR_MESSAGE(),  
 --  @ErrSeverity = ERROR_SEVERITY()  
 select 0 StatusFlag,ERROR_MESSAGE() Message  
 --RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH  
