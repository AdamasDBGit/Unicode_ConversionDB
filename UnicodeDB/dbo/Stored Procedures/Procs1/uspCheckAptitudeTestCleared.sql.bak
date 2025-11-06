CREATE PROCEDURE [dbo].[uspCheckAptitudeTestCleared]  --[dbo].[uspCheckAptitudeTestCleared] 2133  ,0.0   
    @iEnquiryID INT ,
    @iMarks INT
AS 
    BEGIN TRY    
    
        SET NOCOUNT OFF    
        DECLARE @bypassAdmissionTest BIT  
        DECLARE @cSkipAptiTest CHAR(1)  
 --DECLARE @cSkipAptiTest Char(1)    
 --SELECT @cSkipAptiTest = C_Skip_Test    
 -- FROM dbo.T_Enquiry_Regn_Detail    
 -- WHERE I_Enquiry_Regn_ID = @iEnquiryID    
     
    
 --IF (@cSkipAptiTest = 'N')    
 --BEGIN    
 -- IF EXISTS (SELECT I_Enquiry_Test_ID FROM dbo.T_Enquiry_Test    
 --    WHERE I_Enquiry_Regn_ID = @iEnquiryID    
 --    AND N_Marks > 9    
 --    AND N_Marks < 101)    
 -- BEGIN    
 --  SELECT 1    
 -- END    
 -- ELSE    
 -- BEGIN    
 --  SELECT 0    
 -- END    
 --END    
 --ELSE    
 --BEGIN    
 -- SELECT 1    
 --END    
        IF EXISTS ( SELECT  I_Enquiry_Test_ID
                    FROM    dbo.T_Enquiry_Test AS TET
                    WHERE   I_Enquiry_Regn_ID = @iEnquiryID ) 
            BEGIN    
    
                SELECT  @bypassAdmissionTest = bypass_Admission_Test
                FROM    dbo.T_Enquiry_Test
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID  
                IF @bypassAdmissionTest = 1 
                    BEGIN  
                        SELECT  1  -- pass  
                    END   
                ELSE 
                    BEGIN  
                        IF EXISTS ( SELECT  I_Enquiry_Test_ID
                                    FROM    dbo.T_Enquiry_Test AS TET
                                            INNER JOIN dbo.T_Exam_Component_Master TECM ON TECM.I_Exam_Component_ID = TET.I_Exam_Component_ID
                                    WHERE   I_Enquiry_Regn_ID = @iEnquiryID
                                            AND TET.N_Marks >= TECM.N_CutOffPercentage ) 
                            BEGIN    
                                SELECT  1  -- pass  
                            END  
                        ELSE 
                            BEGIN    
                                SELECT  0  -- Fail  
                            END     
                    END       
            END  
        ELSE 
            SELECT  @cSkipAptiTest = C_Skip_Test
            FROM    dbo.T_Enquiry_Regn_Detail
            WHERE   I_Enquiry_Regn_ID = @iEnquiryID  
        IF @cSkipAptiTest = 'F' 
            BEGIN  
                SELECT  0  -- Not register in Aptitude test  
            END   
        ELSE 
            BEGIN    
                SELECT  1  -- Not register in Admission test  
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
