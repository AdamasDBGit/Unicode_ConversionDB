CREATE PROCEDURE [dbo].[uspSearchStudentListForPostRefund]   
(      
      @iSelectedHierarchyId INT,  
      @iSelectedBrandId INT = NULL,    
      @sStudentId VARCHAR(500)=NULL,      
      @sStudentFirstName VARCHAR (50)=NULL,      
      @sStudentSecondName VARCHAR (50)=NULL,      
      @sStudentLastName VARCHAR (50)=NULL      
)      
      
AS      
      
BEGIN      
      SET NOCOUNT ON;         
      DECLARE @sSearchCenterList VARCHAR(MAX)  
      SELECT  @sSearchCenterList = dbo.fnCenterList(@iSelectedHierarchyId,@iSelectedBrandId)  
      
            
      SELECT   tsd.I_Enquiry_Regn_ID,    
      ISNULL(tsd.S_First_Name,'') AS S_First_Name, ISNULL(tsd.S_Middle_Name,'') AS S_Middle_Name, ISNULL(tsd.S_Last_Name,'') AS S_Last_Name,      
      tsd.S_Student_ID AS STUDENT_CODE,tsd.I_Student_Detail_ID as STUDENT_ID,tsd.I_Corporate_ID, terd.I_Centre_Id,tcm.S_Center_Name,ISNULL(tsd.[S_Is_Corporate],'N') AS S_Is_Corporate,terd.Dt_Crtd_On      
      FROM dbo.T_Student_Detail AS tsd    
      INNER JOIN T_Enquiry_Regn_Detail AS terd       
      ON terd.I_Enquiry_Regn_ID = tsd.I_Enquiry_Regn_ID    
      INNER JOIN dbo.T_Centre_Master AS tcm  
      ON tcm.I_Centre_Id=terd.I_Centre_Id  
      WHERE      
      ISNULL(tsd.S_First_Name,'') LIKE ISNULL(@sStudentFirstName,tsd.S_First_Name) + '%'       
      AND   ISNULL(tsd.S_Middle_Name,'') LIKE ISNULL(@sStudentSecondName,tsd.S_Middle_Name) + '%'       
      AND   ISNULL(tsd.S_Last_Name,'') LIKE ISNULL(@sStudentLastName,tsd.S_Last_Name) + '%'       
      AND tsd.S_Student_ID LIKE ISNULL(@sStudentId,tsd.S_Student_ID) + '%'       
      AND   tsd.I_Student_Detail_ID IN       
      (SELECT I_Student_Detail_ID FROM T_Student_Center_Detail WHERE I_Centre_Id IN (SELECT * FROM dbo.fnString2Rows(@sSearchCenterList,',')))  
  --AND I_Status <> 0     {Commented on 31-Oct-2008 to allow all students irrespective of student status}      
  --AND I_Status <> 0{Commented on 31-Oct-2008 to allow all students irrespective of student status}      
      ORDER BY tsd.S_Student_ID      
            
END
