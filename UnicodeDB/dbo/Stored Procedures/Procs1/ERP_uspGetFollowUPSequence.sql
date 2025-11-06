-- exec [dbo].[ERP_uspGetPreEnquiryDetails] 234871, null, null, null, 1          
--exec [dbo].[ERP_uspGetPreEnquiryDetails_POC] 234939,null, null,null, null,null, null, 100, 0, 0, 'asc', null               
CREATE PROCEDURE [dbo].[ERP_uspGetFollowUPSequence]                          
    
AS                
    BEGIN        
 Declare @Nextdt date    
select * from T_FollowUPStageSequence    
                                      
    end
