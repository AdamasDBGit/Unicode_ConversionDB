
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- exec usp_ERP_GetAcademicSessionByDateRangeAndBrand 107, 21, '2023-01-01 00:00:00.000', '2024-01-01 00:00:00.000'  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetAcademicSessionByFeeStructure]  
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
 SASM.I_School_Session_ID AS SchoolAcademicSessionID,  
 SASM.S_Label AS Label,
 SASM.Dt_Session_Start_Date as AcademicSessionStartDate,
 SASM.Dt_Session_End_Date as AcademicSessionEndDate,
 SASM.I_Current_Session as I_Current_Session,
 CASE WHEN FSAS.I_Fee_Structure_ID IS NOT NULL  THEN 1 ELSE 0 end as IsMapped,
 CASE WHEN 
 CONVERT(DATE,GETDATE()) between CONVERT(DATE,SASM.Dt_Session_Start_Date) and CONVERT(DATE,SASM.Dt_Session_End_Date) THEN 1
 WHEN  CONVERT(DATE,GETDATE()) < CONVERT(DATE,SASM.Dt_Session_Start_Date) THEN 1
 ELSE 0 END as IsEligibletoMap
 FROM [dbo].[T_School_Academic_Session_Master] as SASM
 left join
 (select DISTINCT I_School_Session_ID,I_Fee_Structure_ID from
 T_ERP_Fee_Structure_AcademicSession_Map  where Is_Active=1) as FSAS on SASM.I_School_Session_ID=FSAS.I_School_Session_ID
 and FSAS.I_Fee_Structure_ID=@FeeStructureID
 WHERE SASM.I_Brand_ID = @BrandID 
END  
