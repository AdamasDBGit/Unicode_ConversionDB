-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- exec usp_ERP_GetAcademicSessionByDateRangeAndBrand 107, 21, '2023-01-01 00:00:00.000', '2024-01-01 00:00:00.000'  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetAcademicSessionByDateRangeAndBrand]  
(  
 @BrandID int = NULL,  
 @FeeStructureID int = NULL
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 SELECT   
 I_School_Session_ID AS SchoolAcademicSessionID,  
 S_Label AS Label,
 Dt_Session_Start_Date as AcademicSessionStartDate,
 Dt_Session_End_Date as AcademicSessionEndDate
 FROM [dbo].[T_School_Academic_Session_Master]  
 WHERE I_Brand_ID = @BrandID 
 and I_School_Session_ID not in(Select I_School_Session_ID from T_ERP_Fee_Structure_AcademicSession_Map
 where I_Fee_Structure_ID=@FeeStructureID and Is_Active=1)
END  
