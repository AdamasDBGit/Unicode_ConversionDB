CREATE PROCEDURE [dbo].[uspSearchEnquiryListForStudent]   
(        
      @iSelectedHierarchyId INT,    
      @iSelectedBrandId INT = NULL,      
      @iEnquiryId INT = NULL,        
      @sStudentFirstName VARCHAR (50)=NULL,        
      @sStudentSecondName VARCHAR (50)=NULL,        
      @sStudentLastName VARCHAR (50)=NULL ,
      @dtDOB DATETIME = NULL       
)        
        
AS        
        
BEGIN        
      SET NOCOUNT ON;           
      DECLARE @sSearchCenterList VARCHAR(MAX)    
      SELECT  @sSearchCenterList = dbo.fnCenterList(@iSelectedHierarchyId,@iSelectedBrandId)    
        
        
      SELECT terd.I_Enquiry_Regn_ID,ISNULL(terd.S_First_Name,'') AS S_First_Name, ISNULL(terd.S_Middle_Name,'') AS S_Middle_Name, ISNULL(terd.S_Last_Name,'') AS S_Last_Name,        
      terd.I_Corporate_ID, terd.I_Centre_Id,tcm.S_Center_Name,terd.Dt_Birth_Date,terd.Dt_Crtd_On,terd.S_Crtd_By,terd.S_Upd_By,terd.Dt_Upd_On FROM dbo.T_Enquiry_Regn_Detail AS terd  
      INNER JOIN dbo.T_Centre_Master AS tcm    
      ON tcm.I_Centre_Id=terd.I_Centre_Id        
      WHERE  
      terd.S_First_Name LIKE ISNULL(@sStudentFirstName,terd.S_First_Name) + '%'         
      AND terd.S_Middle_Name LIKE ISNULL(@sStudentSecondName,terd.S_Middle_Name) + '%'         
      AND terd.S_Last_Name LIKE ISNULL(@sStudentLastName,terd.S_Last_Name) + '%'    
      AND terd.Dt_Birth_Date = ISNULL(@dtDOB,terd.Dt_Birth_Date)    
      AND terd.I_Enquiry_Regn_ID = ISNULL(@iEnquiryId,terd.I_Enquiry_Regn_ID)   
      AND terd.I_Centre_Id IN (SELECT * FROM dbo.fnString2Rows(@sSearchCenterList,','))    
END
