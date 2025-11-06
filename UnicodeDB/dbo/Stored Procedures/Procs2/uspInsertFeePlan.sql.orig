--*********************  
--Created By: Debman Mukherjee 20/03/07  
--**********************  
  
CREATE PROCEDURE [dbo].[uspInsertFeePlan]   
(  
 -- Add the parameters for the stored procedure here  
 @iCourseID int,  
 @iCourseDeliveryID int,  
 @iCurrencyID int,  
 @sFeePlanName text,  
 @iTotalLumpSum int,  
 @iTotalInstallment int,  
 @sFeePlanDetailXml text,  
 @sCreatedBy varchar(20),  
 @iNNoOfInstallments INT = NULL 
)  
  
AS  
BEGIN TRY  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON  
   
 DECLARE @iDocHandle int  
 DECLARE @iCourseFeePlanID int  
 DECLARE @iCourseDeliveryMapID int  
  
 SELECT @iCourseDeliveryMapID = I_Course_Delivery_ID  
 FROM dbo.T_Course_Delivery_Map  
 WHERE I_Course_ID = @iCourseID  
 AND I_Delivery_Pattern_ID = @iCourseDeliveryID  
 AND I_Status = 1  
   
 BEGIN TRAN T1  
   
 INSERT INTO dbo.T_Course_Fee_Plan  
 (  
  I_Course_ID,  
  I_Course_Delivery_ID,  
  I_Currency_ID,  
  S_Fee_Plan_Name,  
  N_TotalLumpSum,  
  N_TotalInstallment,  
  S_Crtd_By,  
  Dt_Crtd_On,  
  I_Status,
  N_No_Of_Installments  
 )  
 VALUES  
 (  
  @iCourseID,  
  @iCourseDeliveryMapID,  
  @iCurrencyID,  
  @sFeePlanName,  
  @iTotalLumpSum,  
  @iTotalInstallment,  
  @sCreatedBy,  
  getdate(),  
  1,
  @iNNoOfInstallments  
 )  
  
 SET @iCourseFeePlanID=@@IDENTITY  
  
 EXEC sp_xml_preparedocument @iDocHandle output,@sFeePlanDetailXml  
  
 INSERT INTO dbo.T_Course_Fee_Plan_Detail  
 (  
  I_Fee_Component_ID,  
  N_CompanyShare,  
  I_Installment_No,  
  I_Sequence,  
  C_Is_LumpSum,  
  I_Item_Value,  
  I_Display_Fee_Component_ID,   
  I_Status,  
  I_Course_Fee_Plan_ID,  
  S_Crtd_By,  
  Dt_Crtd_On  
 )  
 SELECT *,1,@iCourseFeePlanID,@sCreatedBy,getdate() FROM OPENXML(@iDocHandle, '/FeePlanDetail/Installments',2)  
 WITH   
 ( I_Fee_Component_ID int,  
  N_Company_Share numeric,  
  I_Installment_No int,  
  I_Sequence int,  
  C_Is_LumpSum char(1),  
  I_Item_Value numeric,  
  I_Display_Fee_Component_ID int  
 )  
   
 SELECT @iCourseFeePlanID FeePlanID  
 COMMIT TRAN T1   
END TRY  
BEGIN CATCH  
 --Error occurred:    
 ROLLBACK TRAN T1  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
