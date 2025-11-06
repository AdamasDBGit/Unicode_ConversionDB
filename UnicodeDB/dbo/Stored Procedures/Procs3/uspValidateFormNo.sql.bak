CREATE PROCEDURE [dbo].[uspValidateFormNo]   
(  
 @sFormNo NVARCHAR(MAX),  
 @iBrandID INT  
)    
AS     
    BEGIN    
        DECLARE @Valid BIT    
        IF ( SELECT COUNT(*)    
             FROM   dbo.T_Enquiry_Regn_Detail AS TRH    
             WHERE  S_Form_No = @sFormNo    
			 AND I_Centre_Id IN (select I_Centre_Id from T_Brand_Center_Details where I_Brand_ID = @iBrandID and I_Status = 1)  
           ) > 0     
            BEGIN    
                SET @Valid = 0    
            END    
        ELSE     
            BEGIN    
                SET @Valid = 1    
            END    
         SELECT @Valid    
    END

