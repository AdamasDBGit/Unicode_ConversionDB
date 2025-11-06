-- =============================================    
-- Author:  <Rajesh>    
-- Create date: <31-01-2007>    
-- Description: <Modify T_Session_Master>    
-- =============================================    
CREATE PROCEDURE [dbo].[uspModifySession]    
 -- Add the parameters for the stored procedure here    
    @iSessionID INT ,  
    @iSessionType INT = NULL ,  
    @iBrandID INT = NULL ,  
    @sSessionCode NVARCHAR(MAX) = NULL ,  
    @sSessionName NVARCHAR(MAX) = NULL ,  
    @nSessionDuration NUMERIC ,  
    @sSessionTopic NVARCHAR(MAX) = NULL ,  
    @sSessionBy NVARCHAR(MAX) ,  
    @dSessionOn DATETIME ,  
    @iFlag INT,  
    @iSkillID INT = NULL  
AS   
    BEGIN TRY    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
        SET NOCOUNT OFF    
    
    -- Insert statements for procedure here    
        IF ( @iFlag = 1 )   
            BEGIN    
      
                BEGIN TRAN T1    
                INSERT  INTO dbo.T_Session_Master  
                        ( I_Session_Type_ID ,  
                          I_Brand_ID ,  
                          S_Session_Code ,  
                          S_Session_Name ,  
                          N_Session_Duration ,  
                          S_Session_Topic ,  
                          I_Skill_ID,  
                          S_Crtd_By ,  
                          Dt_Crtd_On ,  
                          I_Status    
                        )  
                VALUES  ( @iSessionType ,  
                          @iBrandID ,  
                          @sSessionCode ,  
                          @sSessionName ,  
                          @nSessionDuration ,  
                          @sSessionTopic ,  
                          @iSkillID,  
                          @sSessionBy ,  
                          @dSessionOn ,  
                          1    
                        )    
           
                SET @iSessionID = @@IDENTITY    
           
                COMMIT TRAN T1    
            END     
        IF ( @iFlag = 2 )   
            BEGIN    
                UPDATE  dbo.T_Session_Master  
                SET     I_Session_Type_ID = @iSessionType ,  
                        S_Session_Name = @sSessionName ,  
                        N_Session_Duration = @nSessionDuration ,  
                        S_Session_Topic = @sSessionTopic ,  
                        I_Skill_ID = @iSkillID,  
                        S_Upd_By = @sSessionBy ,  
                        Dt_Upd_On = @dSessionOn,
                        S_Session_Code = @sSessionCode  
                WHERE   I_Session_ID = @iSessionID    
            END      
     
    
        IF ( @iFlag = 3 )   
            BEGIN    
                UPDATE  dbo.T_Session_Master  
                SET     I_Status = 0 ,  
                        S_Upd_By = @sSessionBy ,  
                        Dt_Upd_On = @dSessionOn  
                WHERE   I_Session_ID = @iSessionID    
            END      
     
        SELECT  @iSessionID AS SessionID    
     
    END TRY    
    BEGIN CATCH    
 --Error occurred:      
    
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH

