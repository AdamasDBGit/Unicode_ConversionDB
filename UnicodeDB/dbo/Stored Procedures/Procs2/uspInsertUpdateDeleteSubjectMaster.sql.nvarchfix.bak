CREATE PROCEDURE [dbo].[uspInsertUpdateDeleteSubjectMaster]     
(    
 @iMode int =0,    
 @iSubjectID int = null,    
 @iSchoolGroupID int = null,    
 @iClassID int =null,    
 @iStreamID int = null,    
 @sSubjectName nnvarchar(max)=null,    
 @sSubjectCode  nnvarchar(max)=null,    
 @iTotalNumberOfClassesRequired int = null,    
 @iStatus int = 1,    
 @iBrandID int=null,    
 @iCreatedBy int=null,    
 @iSubjectType int =null,    
 @UTSubjectComponents UT_SubjectComponents readonly    
)    
AS    
BEGIN TRANSACTION    
BEGIN TRY     
 IF(@iMode > 0)   -- Delete Mode   
 BEGIN    
  IF EXISTS (SELECT 1 FROM T_ERP_Student_Class_Routine WHERE I_Subject_ID = @iSubjectID)    
  BEGIN    
   SELECT 0 StatusFlag,'Unable to delete, this subject is already assigned to a teacher' Message    
  END    
  ELSE    
  BEGIN    
   DELETE FROM T_Subject_Master WHERE I_Subject_ID = @iSubjectID    
   SELECT 1 StatusFlag,'Subject deleted successfully' Message    
  END    
 END    
 ELSE   -- Insert / Update Mode  
 BEGIN    
   IF(@iSubjectID > 0)   -- Update  
   BEGIN    
    -- Duplicate Checks for Update (Scoped by Class + SchoolGroup + Stream)  
    IF EXISTS(
        SELECT 1 
        FROM T_Subject_Master 
        WHERE S_Subject_Name = @sSubjectName 
          AND I_Class_ID = @iClassID 
          AND I_School_Group_ID = @iSchoolGroupID
          AND ISNULL(I_Stream_ID, -1) = ISNULL(@iStreamID, -1)
          AND I_Subject_ID != @iSubjectID
    )    
    BEGIN    
     SELECT 0 StatusFlag,'Duplicate Subject name' Message    
    END    
    ELSE IF EXISTS(
        SELECT 1 
        FROM T_Subject_Master 
        WHERE S_Subject_Code = @sSubjectCode 
          AND I_Class_ID = @iClassID 
          AND I_School_Group_ID = @iSchoolGroupID
          AND ISNULL(I_Stream_ID, -1) = ISNULL(@iStreamID, -1)
          AND I_Subject_ID != @iSubjectID
    )    
    BEGIN    
     SELECT 0 StatusFlag,'Duplicate Subject Code' Message    
    END    
    ELSE    
    BEGIN    
     UPDATE T_Subject_Master    
     SET    
        S_Subject_Name  = @sSubjectName    
       ,I_School_Group_ID = @iSchoolGroupID    
       ,S_Subject_Code  = @sSubjectCode    
       ,I_Status   = @iStatus    
       ,I_UpdatedBy  = @iCreatedBy    
       ,Dt_UpdatedAt  = GETDATE()    
       ,I_Subject_Type = @iSubjectType    
       ,I_Class_ID = @iClassID    
       ,I_Stream_ID = @iStreamID  
       ,I_TotalNoOfClasses = @iTotalNumberOfClassesRequired  
     WHERE I_Subject_ID = @iSubjectID    
    
     MERGE T_ERP_Subject_Component_Mapping AS target        
     USING @UTSubjectComponents AS source           
     ON target.I_Subject_Component_Mapping = source.I_Subject_Component_Mapping        
        AND target.I_Subject_ID = @iSubjectID             
     WHEN MATCHED THEN        
        UPDATE SET target.I_Subject_Component_ID = source.I_Subject_Component_ID,                
                   target.Is_Active = source.Is_Active         
     WHEN NOT MATCHED THEN        
        INSERT (I_Subject_ID, I_Subject_Component_ID, Is_Active)         
        VALUES (@iSubjectID, source.I_Subject_Component_ID, 1);        
    
     SELECT 1 StatusFlag,'Subject updated successfully' Message    
    END    
   END    
   ELSE   -- Insert  
   BEGIN    
    -- Duplicate Checks for Insert (Scoped by Class + SchoolGroup + Stream)  
    IF EXISTS(
        SELECT 1 
        FROM T_Subject_Master 
        WHERE S_Subject_Name = @sSubjectName 
          AND I_Class_ID = @iClassID 
          AND I_School_Group_ID = @iSchoolGroupID
          AND ISNULL(I_Stream_ID, -1) = ISNULL(@iStreamID, -1)
    )    
    BEGIN    
     SELECT 0 StatusFlag,'Duplicate Subject name' Message    
    END    
    ELSE IF EXISTS(
        SELECT 1 
        FROM T_Subject_Master 
        WHERE S_Subject_Code = @sSubjectCode 
          AND I_Class_ID = @iClassID 
          AND I_School_Group_ID = @iSchoolGroupID
          AND ISNULL(I_Stream_ID, -1) = ISNULL(@iStreamID, -1)
    )    
    BEGIN    
     SELECT 0 StatusFlag,'Duplicate Subject Code' Message    
    END    
    ELSE    
    BEGIN    
     INSERT INTO T_Subject_Master    
     (    
        I_School_Group_ID, I_Class_ID, S_Subject_Name, S_Subject_Code,    
        I_Subject_Type, I_TotalNoOfClasses, I_Status, I_CreatedBy,    
        Dt_CreatedAt, I_Brand_ID, I_Stream_ID    
     )    
     VALUES    
     (    
        @iSchoolGroupID, @iClassID, @sSubjectName, @sSubjectCode,    
        @iSubjectType, @iTotalNumberOfClassesRequired, @iStatus, @iCreatedBy,    
        GETDATE(), @iBrandID, @iStreamID    
     )    
    
     DECLARE @I_Subject_ID int    
     SET @I_Subject_ID = SCOPE_IDENTITY();    
    
     INSERT INTO T_ERP_Subject_Component_Mapping    
     (I_Subject_ID, Is_Active, I_Subject_Component_ID)    
     SELECT @I_Subject_ID, 1, I_Subject_Component_ID 
     FROM @UTSubjectComponents    
    
     SELECT 1 StatusFlag,'Subject added successfully' Message    
    END    
   END    
 END    
END TRY    
BEGIN CATCH    
 ROLLBACK TRANSACTION    
 DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()    
 SELECT 0 StatusFlag,@ErrMsg Message    
END CATCH    
COMMIT TRANSACTION    
