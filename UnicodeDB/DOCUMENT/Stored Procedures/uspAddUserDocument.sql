CREATE PROCEDURE [DOCUMENT].[uspAddUserDocument]  
(
    @iCategoryID INT,
    @iBrandID INT,
    @iHierarchyDetailID INT = NULL,
    @sFileName VARCHAR(250),
    @sFilePath VARCHAR(250),
    @iFileSize INT,
    @dtExpiryDate DateTime ,
    @iCourseID INT = NULL,
    @iTermID INT = NULL,
    @iModuleID INT = NULL,
    @iBatchID INT = NULL,
    @iStatus INT = NULL,
    @sCrtdBy varchar(20) = NULL,
    @dtCrtdOn datetime = NULL
   
   
)
AS
BEGIN

 INSERT INTO DOCUMENT.T_User_Documents
         ( 
           I_Category_ID ,
           I_Brand_ID ,
           I_Hierarchy_Detail_ID ,
           S_File_Name ,
           S_File_Path ,
           I_File_Size ,
           Dt_Expiry_Date ,
           I_Course_ID ,
           I_Term_ID ,
           I_Module_ID ,
           I_Batch_ID ,
           S_CreatedBy ,
           Dt_CreatedOn ,
           S_UpdatedBy ,
           Dt_UpadtedOn ,
           I_Status
         )
 VALUES  ( 
           @iCategoryID , -- I_Category_ID - int
           @iBrandID , -- I_Brand_ID - int
           @iHierarchyDetailID , -- I_Hierarchy_Detail_ID - int
           @sFileName , -- S_File_Name - varchar(250)
           @sFilePath , -- S_File_Path - varchar(250)
           @iFileSize , -- I_File_Size - int
           @dtExpiryDate , -- Dt_Expiry_Date - datetime
           @iCourseID , -- I_Course_ID - int
           @iTermID , -- I_Term_ID - int
           @iModuleID , -- I_Module_ID - int
           @iBatchID , -- I_Batch_ID - int
           @sCrtdBy , -- S_CreatedBy - varchar(50)
           @dtCrtdOn , -- Dt_CreatedOn - datetime
           NULL , -- S_UpdatedBy - varchar(50)
           NULL , -- Dt_UpadtedOn - datetime
           @iStatus  -- I_Status - int
         )
        
        SELECT @@IDENTITY
END
