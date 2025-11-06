-- =============================================  
-- Author:  <Susmita Paul>  
-- Create date: <2023 Nov 14>  
-- Description: <Get The Faculty Details for ERP Based on User LogIN>  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetERP_AllFacultyDetailsBasedOnLogIn]   
 -- Add the parameters for the stored procedure here  
 @iBrandID INT  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 select FM.I_Faculty_Master_ID as FacultyId,  
 FM.S_Faculty_Name as FacultyName,  
 ISNULL(Fm.S_Faculty_Code,'NA') as FacultyCode  
 from   
 T_Faculty_Master as FM   
 inner join  
 T_ERP_User as EU on FM.I_User_ID=EU.I_User_ID  
 inner join  
 T_ERP_User_Brand as UB on FM.I_User_ID=UB.I_User_ID   
 where UB.I_Brand_ID=@iBrandID   
 and UB.Is_Active=1 and UB.Is_Teaching_Staff=1 and EU.I_Status=1 and FM.I_Status=1  
  
  
END
