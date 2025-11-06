CREATE PROCEDURE [dbo].[uspSaveDCCourseInformation]        
(              
 @iTransferRequestId INT      
,@iCourseId INT    
,@iCourseFeePlanId INT    
,@iDeliveryPatternId INT    
,@cPaymentMode CHAR(1)
,@iBatchID INT      
)          
AS          
BEGIN       
    
INSERT INTO dbo.T_Student_Transfer_Request_Details    
(I_Transfer_Request_ID,I_Course_ID,I_Course_Fee_Plan_ID,I_Delivery_Pattern_ID,S_Payment_Mode, I_Batch_ID)    
VALUES    
(@iTransferRequestId,@iCourseId,@iCourseFeePlanId,@iDeliveryPatternId,@cPaymentMode,@iBatchID)    
      
END
