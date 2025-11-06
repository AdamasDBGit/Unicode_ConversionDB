/*******************************************************  



Description : Gets the list of Feedback Details depending on FeedbackTypeID  



Author :     Soumya Sikder  



Date :   03/05/2007  



*********************************************************/  

--exec [ACADEMICS].[uspGetFeedbackGroupList]3,108

  



CREATE PROCEDURE [ACADEMICS].[uspGetFeedbackGroupList]   --  [ACADEMICS].[uspGetFeedbackGroupList] 3



(  



 @iFeedbackTypeID int,

 @iBrandID int  



)  



AS  



BEGIN TRY   



 -- getting records for Table [0]  



  



  SELECT DISTINCT G.I_Feedback_Group_ID, G.S_Description  



     FROM ACADEMICS.T_Feedback_Master M  



  INNER JOIN ACADEMICS.T_Feedback_Group G WITH(NOLOCK)  



  ON M.I_Feedback_Group_ID = G.I_Feedback_Group_ID  



  WHERE M.I_Feedback_Type_ID = @iFeedbackTypeID



  And M.I_Brand_ID= @iBrandID



  AND M.I_Status = 1  



  



 -- getting records for Table[1]  



   



 SELECT I_Feedback_Master_ID,  



     I_Feedback_Group_ID,  



     I_Feedback_Type_ID,  



     S_Feedback_Question,  



     I_Status  



 FROM ACADEMICS.T_Feedback_Master WITH(NOLOCK)  



 WHERE I_Feedback_Type_ID = @iFeedbackTypeID  



  And I_Brand_ID= @iBrandID



 AND I_Status = 1  



       



 -- getting records for Table[2]  



   



 SELECT O.I_Feedback_Option_Master_ID,  



     O.I_Feedback_Master_ID,  



     O.S_Feedback_Option_Name,  



     O.I_Status  



 FROM ACADEMICS.T_Feedback_Master M  



 INNER JOIN ACADEMICS.T_Feedback_Option_Master O WITH(NOLOCK)  



 ON M.I_Feedback_Master_ID = O.I_Feedback_Master_ID  



 WHERE M.I_Feedback_Type_ID =  @iFeedbackTypeID



  And M.I_Brand_ID= @iBrandID



  AND M.I_Status = 1  



  AND O.I_Status = 1  



  



END TRY  



BEGIN CATCH  



   



 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  



  



 SELECT @ErrMsg = ERROR_MESSAGE(),  



   @ErrSeverity = ERROR_SEVERITY()  



  



 RAISERROR(@ErrMsg, @ErrSeverity, 1)  



END CATCH
