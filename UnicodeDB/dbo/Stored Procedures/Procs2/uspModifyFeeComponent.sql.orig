-- =============================================    
-- Author:  Rabin Mukherjee    
-- Create date: 11/01/2007    
-- Description: Modifies the Brand Master Table    
-- =============================================    
CREATE PROCEDURE [dbo].[uspModifyFeeComponent]
    (
      @iFeeComponentID INT ,
      @vFeeComponentCode VARCHAR(20) ,
      @vFeeComponentName VARCHAR(100) ,
      @vFeeComponentBy VARCHAR(20) ,
      @dFeeComponentOn DATETIME ,
      @iFlag INT ,
      @iFeeComponentTypeID INT,
      @iBrandID INT = NULL   
    )
AS 
    BEGIN TRY    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
        SET NOCOUNT ON ;    
    
        IF @iFlag = 1 
            BEGIN    
                INSERT  INTO dbo.T_Fee_Component_Master
                        ( I_Fee_Component_Type_ID ,
                          S_Component_Code ,
                          S_Component_Name ,
                          I_Status ,
                          S_Crtd_By ,
                          Dt_Crtd_On,
                          I_Brand_ID   
                        )
                VALUES  ( @iFeeComponentTypeID ,
                          @vFeeComponentCode ,
                          @vFeeComponentName ,
                          1 ,
                          @vFeeComponentBy ,
                          @dFeeComponentOn,
                          @iBrandID   
                        )        
            END    
        ELSE 
            IF @iFlag = 2 
                BEGIN    
                    UPDATE  dbo.T_Fee_Component_Master
                    SET     S_Component_Name = @vFeeComponentName ,
                            I_Fee_Component_Type_ID = @iFeeComponentTypeID ,
                            S_Upd_By = @vFeeComponentBy ,
                            Dt_Upd_On = @dFeeComponentOn
                    WHERE   I_Fee_Component_ID = @iFeeComponentID    
                END    
            ELSE 
                IF @iFlag = 3 
                    BEGIN    
                        UPDATE  dbo.T_Fee_Component_Master
                        SET     I_Status = 0 ,
                                S_Upd_By = @vFeeComponentBy ,
                                Dt_Upd_On = @dFeeComponentOn
                        WHERE   I_Fee_Component_ID = @iFeeComponentID    
                    END    
    
    END TRY    
    BEGIN CATCH    
 --Error occurred:      
    
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH
