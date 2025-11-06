CREATE PROCEDURE [ACADEMICS].[uspGetDropoutStudentListForReactivation]      
(        
 @iCenterID int = null,        
 @sStudentCode varchar(500) = null,        
 @sFirstName varchar(50) = null,        
 @sMiddleName varchar(50)= null,        
 @sLastName varchar(50) = null,        
 @iDropoutTypeID int = null,        
 @iFlag int = null        
)        
AS        
BEGIN TRY         
        
 SET NOCOUNT ON;        
            
 BEGIN        
  IF @iFlag IS NULL        
  BEGIN        
   SELECT DISTINCT D.I_Student_Detail_ID,        
       D.I_Dropout_Type_ID,        
       S.S_First_Name,        
       S.S_Middle_Name,        
       S.S_Last_Name,         
       S.S_Student_ID        
   FROM ACADEMICS.T_Dropout_Details D         
   INNER JOIN dbo.T_Student_Detail S  WITH (NOLOCK)         
   ON D.I_Student_Detail_ID = S.I_Student_Detail_ID        
   AND D.I_Dropout_Type_ID = @iDropoutTypeID        
   AND D.I_Dropout_Status <> 0        
   WHERE S.S_First_Name LIKE ISNULL(@sFirstName,'') + '%'         
   AND ISNULL(S.S_Middle_Name,'') LIKE ISNULL(@sMiddleName,'') + '%'         
   AND S.S_Last_Name LIKE ISNULL(@sLastName,'') + '%'         
   AND S.S_Student_ID LIKE ISNULL(@sStudentCode,'') + '%'        
  END        
  ELSE        
  --whether student is dropout        
  BEGIN        
   SELECT DISTINCT       
       IP.S_Invoice_No,        
       IP.I_Invoice_Header_ID,      
       DD.I_Student_Detail_ID,        
       DD.I_Dropout_Type_ID,        
       SD.S_First_Name,        
       SD.S_Middle_Name,        
       SD.S_Last_Name,         
       SD.S_Student_ID        
   FROM ACADEMICS.T_Dropout_Details DD         
   INNER JOIN dbo.T_Invoice_Parent IP  WITH (NOLOCK) ON DD.I_Invoice_Header_ID = IP.I_Invoice_Header_ID       
   INNER JOIN dbo.T_Student_Detail SD  WITH (NOLOCK) ON SD.I_Student_Detail_ID = IP.I_Student_Detail_ID       
   AND DD.I_Dropout_Type_ID = ISNULL(@iDropoutTypeID,DD.I_Dropout_Type_ID)        
   AND DD.I_Dropout_Status <> 0        
   AND DD.I_Center_Id = @iCenterID        
   WHERE SD.S_First_Name LIKE ISNULL(@sFirstName,'') + '%'         
   AND ISNULL(SD.S_Middle_Name,'') LIKE ISNULL(@sMiddleName,'') + '%'         
   AND SD.S_Last_Name LIKE ISNULL(@sLastName,'') + '%'         
   AND SD.S_Student_ID LIKE ISNULL(@sStudentCode,'') + '%'        
  END        
 END        
         
END TRY        
        
BEGIN CATCH        
 --Error occurred:          
        
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int        
 SELECT @ErrMsg = ERROR_MESSAGE(),        
   @ErrSeverity = ERROR_SEVERITY()        
        
 RAISERROR(@ErrMsg, @ErrSeverity, 1)        
END CATCH
