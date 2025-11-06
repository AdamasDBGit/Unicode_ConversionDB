CREATE PROCEDURE [dbo].[ERP_uspInsertStudentDetailsFromEnquiry_bak_27092024]                  
    (                  
      @iEnquiryRegnID INT ,                  
      @CrtdBy Nnvarchar(max) ,                  
      @DtCrtdOn DATETIME ,                  
      @sConductCode Nnvarchar(max) =Null,                  
      @sStudentCode Nnvarchar(max) = NULL,                  
      @iRollNo INT = NULL,                
      @sStudyMaterialNo Nnvarchar(max) = NULL      
      ,@s_brandid Int=null    
      --@iStudentDetailId_OUTPUT INT OUTPUT            
    )                  
AS                   
    SET NOCOUNT ON                    
    BEGIN TRY                     
                    
        DECLARE @sLoginID nvarchar(max)                     
        DECLARE @iStudentDetailId INT                    
        DECLARE @iCenterID INT                    
                    
        BEGIN TRANSACTION                    
        SELECT TOP 1                  
                @iCenterID = I_Destination_Center_ID                  
        FROM    dbo.T_Student_Registration_Details                  
        WHERE   I_Enquiry_Regn_ID = @iEnquiryRegnID                    
        IF ( @iCenterID IS NULL )                   
            BEGIN                    
                SELECT  @iCenterID = I_Centre_Id                  
                FROM    dbo.T_Enquiry_Regn_Detail                  
                WHERE   I_Enquiry_Regn_ID = @iEnquiryRegnID                    
            END                    
         Print @iCenterID            
        IF EXISTS ( SELECT  1                  
                    FROM    T_Student_Detail                  
                    WHERE   I_Enquiry_Regn_Id = @iEnquiryRegnID                  
                            AND I_Status <> 0 )                   
            BEGIN                    
                RAISERROR('Student Already Exists With This Enquiry', 16, 1)                    
            END             
   --Print 'NOT Exists'            
                    
  IF(@sStudentCode IS NULL)                  
  BEGIN                  
   SELECT  @sLoginID = [dbo].fnGetStudentNo(@iCenterID)               
   Print @sLoginID            
  END                  
  ELSE                  
   BEGIN                  
    SET @sLoginID = @sStudentCode                  
   END                   
    Print @sLoginID                
        INSERT  INTO T_Student_Detail                  
                ( I_Enquiry_Regn_Id ,                  
                  S_Student_Id ,                  
                  I_Status ,                  
                  S_Title ,                  
                  S_First_Name ,                  
                  S_Middle_Name ,                  
                  S_Last_Name ,                  
                  Dt_Birth_Date ,                  
                  S_Age ,                  
                  C_Skip_Test ,                  
                  I_Occupation_ID ,                  
                  I_Pref_Career_ID ,                  
                  I_Qualification_Name_ID ,                  
                  I_Stream_ID ,                  
                  S_Guardian_Name ,                  
                  I_Guardian_Occupation_ID ,                  
                  S_Guardian_Email_ID ,                  
                  S_Mobile_No ,                  
                  S_Guardian_Phone_No ,                  
                  I_Curr_City_ID ,                  
                  I_Curr_State_ID ,                  
                  S_Email_ID ,                  
                  I_Curr_Country_ID ,                  
                  S_Phone_No ,                  
                  S_Curr_Address1 ,                  
                  S_Curr_Address2 ,                  
                  S_Curr_Pincode ,                  
                  S_Perm_Address1 ,                  
                  S_Guardian_Mobile_No ,                  
                  S_Perm_Address2 ,                  
                  I_Income_Group_ID ,              
                  S_Perm_Pincode ,                  
                  S_Curr_Area ,                  
                  I_Perm_City_ID ,                  
         I_Perm_State_ID ,                  
                  I_Perm_Country_ID ,                  
                  S_Perm_Area ,                  
                  S_Is_Corporate ,                  
           I_Corporate_ID ,                  
                  S_Conduct_Code ,                  
                  S_Crtd_By ,                  
                  Dt_Crtd_On,                  
       I_RollNo                    
                )                  
                SELECT  @iEnquiryRegnID ,                  
                        @sLoginID ,                  
                        1 ,        
      S_Title ,                  
                        S_First_Name ,                  
                        S_Middle_Name ,                  
                        S_Last_Name ,                  
                        Dt_Birth_Date ,                  
                        S_Age ,                  
                        C_Skip_Test ,                  
                        I_Occupation_ID ,                  
                        I_Pref_Career_ID ,                  
                        I_Qualification_Name_ID ,                  
                        I_Stream_ID ,                  
                        S_Guardian_Name ,                  
                        I_Guardian_Occupation_ID ,                  
                        S_Guardian_Email_ID ,                  
                        S_Mobile_No ,                  
                        S_Guardian_Phone_No ,                  
                        I_Curr_City_ID ,                  
                        I_Curr_State_ID ,                  
                        S_Email_ID ,                  
                        I_Curr_Country_ID ,                  
                        S_Phone_No ,                  
                        S_Curr_Address1 ,                  
                        S_Curr_Address2 ,                  
                        S_Curr_Pincode ,                  
                        S_Perm_Address1 ,                  
                        S_Guardian_Mobile_No ,                  
                        S_Perm_Address2 ,                  
                        I_Income_Group_ID ,                  
                        S_Perm_Pincode ,                  
                        S_Curr_Area ,                  
                        I_Perm_City_ID ,                  
                        I_Perm_State_ID ,                  
                        I_Perm_Country_ID ,                  
                        S_Perm_Area ,                  
                        S_Is_Corporate ,                  
                        I_Corporate_ID ,                  
                        @sConductCode ,                  
                        @CrtdBy ,                  
                        @DtCrtdOn,                  
                        @iRollNo                  
                FROM    T_Enquiry_Regn_Detail                  
                WHERE   I_Enquiry_Regn_ID = @iEnquiryRegnID                    
                     
        SET @iStudentDetailId = SCOPE_IDENTITY()               
       -- SET @iStudentDetailId_OUTPUT=@iStudentDetailId            
                
                    
 --close the enquiry/registration                    
        UPDATE  T_Enquiry_Regn_Detail                  
        SET     I_Enquiry_Status_Code = 3 ,                  
                I_Centre_Id = @iCenterID                  
        WHERE   I_Enquiry_Regn_ID = @iEnquiryRegnID                    
                     
        INSERT  INTO T_Student_Center_Detail                  
                ( I_Student_Detail_ID ,                  
                  I_Centre_ID ,                  
                  I_Status ,                  
                  Dt_Valid_From                    
                )            
                SELECT  @iStudentDetailId ,                  
                        @iCenterID ,                  
                        1 ,                  
                        GETDATE()                    
                  
  if(@sStudyMaterialNo is not null)                
  BEGIN                 
   insert into T_Student_StudyMaterial_Map                
   select @iStudentDetailId,@sStudyMaterialNo                
  END                
                
  ----- Susmita Paul : Parent Details populate for Buzz app for School : 2023June09 ---------------                
IF (@iStudentDetailId > 0)                
BEGIN                
                
DECLARE @BrandID INT=null           
                
--set @BrandID=[dbo].[fnValidateBrandofStudentForBuzzAppParentLogin](@iStudentDetailId,@iEnquiryRegnID)                
    SET    @BrandID=@s_brandid         
                
IF (@BrandID > 0)                
 BEGIN                
  DECLARE @GaudianDetails table (                
  I_Brand_ID INT,                
  S_Mobile_No nnvarchar(max),                
  S_FullName nvarchar(max),                
 I_RelationID INT,                
  I_IsPrimary INT,                
  S_Address nnvarchar(max),                
  S_Pin_Code nnvarchar(max)                
  )                
                
  DECLARE @S_ADDRESS nnvarchar(max),@S_Pin_Code nnvarchar(max)                
                
  select @S_ADDRESS=S_Curr_Address1,@S_Pin_Code=S_Curr_Pincode from T_Student_Detail             
  where I_Enquiry_Regn_ID=@iEnquiryRegnID                
                 
  insert into @GaudianDetails(                
  I_Brand_ID,                
  S_FullName,                
  S_Mobile_No,                
  I_RelationID,                
  I_IsPrimary,                
  S_Address,                
  S_Pin_Code                
  )                
  select @BrandID,S_Father_Name,S_Father_Mobile_No,(select I_Relation_Master_ID from T_Relation_Master where S_Relation_Type like 'father'),1                
  ,@S_ADDRESS,@S_Pin_Code                
  from T_Enquiry_Regn_Detail where I_Enquiry_Regn_ID=@iEnquiryRegnID                
  union                
  select @BrandID,S_Mother_Name,S_Mother_Mobile_No,(select I_Relation_Master_ID from T_Relation_Master where S_Relation_Type like 'mother'),1                
  ,@S_ADDRESS,@S_Pin_Code                
  from T_Enquiry_Regn_Detail where I_Enquiry_Regn_ID=@iEnquiryRegnID                
                
                
  DECLARE @ipI_Brand_ID INT                
  DECLARE @ipS_Mobile_No nnvarchar(max)                
  DECLARE @ipFullName nvarchar(max)                
  DECLARE @ipRelationID INT                
  DECLARE @ipIsPrimary INT                
  DECLARE @ipAddress nnvarchar(max)                
  DECLARE @ipPin_Code nnvarchar(max)                
                
  -- declare cursor for Parent details                          
        DECLARE UPLOADPARENTDETAILS_CURSOR CURSOR FOR                           
        SELECT  I_Brand_ID,                
  S_Mobile_No,                
  S_FullName,                
  I_RelationID,                
  I_IsPrimary,                
  S_Address,                
  S_Pin_Code                
        FROM @GaudianDetails                
                
                
                
  OPEN UPLOADPARENTDETAILS_CURSOR                           
        FETCH NEXT FROM UPLOADPARENTDETAILS_CURSOR                           
  INTO @ipI_Brand_ID,                
  @ipS_Mobile_No,                
  @ipFullName,                
  @ipRelationID,                
  @ipIsPrimary,                
  @ipAddress,                
  @ipPin_Code                
                
   WHILE @@FETCH_STATUS = 0                 
            BEGIN                 
                
    DECLARE @FirstName nnvarchar(max),@MiddleName nnvarchar(max),@LastName nnvarchar(max),@iparentID INT                
    SELECT                 
    @FirstName=Ltrim(SubString(@ipFullName, 1, Isnull(Nullif(CHARINDEX(' ', @ipFullName), 0), 1000)))                 
    ,@MiddleName=Ltrim(SUBSTRING(@ipFullName, CharIndex(' ', @ipFullName),                 
    CASE                 
    WHEN (CHARINDEX(' ', @ipFullName, CHARINDEX(' ', @ipFullName) + 1) - CHARINDEX(' ', @ipFullName)) <= 0                
                    THEN 0                
                ELSE                
     CHARINDEX(' ', @ipFullName, CHARINDEX(' ', @ipFullName) + 1) - CHARINDEX(' ', @ipFullName)                
                END))                 
    ,@LastName=Ltrim(SUBSTRING(@ipFullName, Isnull(Nullif(CHARINDEX(' ', @ipFullName, Charindex(' ', @ipFullName) + 1), 0), CHARINDEX(' ', @ipFullName)), CASE                 
                WHEN Charindex(' ', @ipFullName) = 0                
                    THEN 0                
                ELSE                
    LEN(@ipFullName)                
                END))                
                
                
    IF NOT EXISTS(                 
    select * from                 
    T_Parent_Master                 
    where UPPER(RTRIM(LTRIM(S_First_Name))) = UPPER(RTRIM(LTRIM(@FirstName)))                
    and UPPER(RTRIM(LTRIM(S_Middile_Name))) = UPPER(RTRIM(LTRIM(@MiddleName)))                
    and UPPER(RTRIM(LTRIM(S_Last_Name))) = UPPER(RTRIM(LTRIM(@LastName)))                
    and S_Mobile_No=@ipS_Mobile_No                
    and ISNULL(I_IsPrimary,0)=ISNULL(@ipIsPrimary,0)                
    )                
     BEGIN                
                
      insert into T_Parent_Master                 
      (                
      S_First_Name,                
      S_Middile_Name,                
      S_Last_Name,                
      S_Mobile_No,                
      I_IsPrimary,                
      --S_Address,              
      S_Pin_Code,                
      S_CreatedBy,                
      Dt_CreatedAt,                
      I_Relation_ID,                
      I_Status,                
      I_Brand_ID                
      )                
      select                 
      @FirstName,                
      @MiddleName,                
      @LastName,                
      @ipS_Mobile_No,                
      @ipIsPrimary,                
      --@ipAddress,                
      @ipPin_Code,                
      @CrtdBy,                
      GETDATE(),                
      @ipRelationID,                
      1,                
      @ipI_Brand_ID                
                
      SET @iparentID = SCOPE_IDENTITY()                 
                
                
     END                
                
     ELSE                
     BEGIN                
                     
      select @iparentID=I_Parent_Master_ID from                 
      T_Parent_Master                 
      where UPPER(RTRIM(LTRIM(S_First_Name))) = UPPER(RTRIM(LTRIM(@FirstName)))                
      and UPPER(RTRIM(LTRIM(S_Middile_Name))) = UPPER(RTRIM(LTRIM(@MiddleName)))                
      and UPPER(RTRIM(LTRIM(S_Last_Name))) = UPPER(RTRIM(LTRIM(@LastName)))                
      and S_Mobile_No=@ipS_Mobile_No                
      and ISNULL(I_IsPrimary,0)=ISNULL(@ipIsPrimary,0)                
                
     END                
                
     IF (@iparentID > 0)                
      BEGIN                
                
       insert into T_Student_Parent_Maps                
       (                
       I_Brand_ID,                
       I_Parent_Master_ID,              
    I_Student_Detail_ID,            
       S_Student_ID,                
       Dt_CreatedAt,                
       I_Status                
       )                
       select                
       @BrandID,                
       @iparentID,             
       @iStudentDetailId,            
       @sStudentCode,                
       GETDATE(),                
       1                
                
      END                
                
                
      -- FETCH NEXT FOR PARENT CURSOR                 
     FETCH NEXT FROM UPLOADPARENTDETAILS_CURSOR                           
    INTO  @ipI_Brand_ID,              
    @ipS_Mobile_No,                
    @ipFullName,                
    @ipRelationID,                
    @ipIsPrimary,                
    @ipAddress,                
    @ipPin_Code                
                
   END                
                
                 
   CLOSE UPLOADPARENTDETAILS_CURSOR                           
   DEALLOCATE UPLOADPARENTDETAILS_CURSOR                 
                
                
                
                 
 END                
                
END                
-----------------Mapping With Student and Class -Stream-Group----------------          
Declare @ClassID int,@GroupID int,@SessionID int,@StreamID INT          
Select @ClassID=I_Class_ID,@GroupID=I_School_Group_ID,@SessionID=R_I_School_Session_ID,@StreamID=I_Stream_ID          
from T_Enquiry_Regn_Detail where I_Enquiry_Regn_ID=@iEnquiryRegnID           
          
Declare @I_School_Group_Class_ID int           
          
SET @I_School_Group_Class_ID=(Select TOP 1 I_School_Group_Class_ID           
from T_School_Group_Class where I_School_Group_ID=@GroupID           
And I_Class_ID=@ClassID and I_Status=1)          
          
-----Inserting Section with Students-------          
--DECLARE @StudentID INT = 123; -- Replace with your actual student ID          
DECLARE @DesiredSectionID INT = null;          
          
-- Check for available seats in sections          
SELECT TOP 1          
    @DesiredSectionID = I_Section_ID          
FROM          
    T_Section          
WHERE          
    SeatCapacity > ISnull(Occupied_Seat,0)          
ORDER BY          
    S_Section_Name ASC;          
 --Print @DesiredSectionID          
          
-- If a section with available seats is found, insert the student mapping          
IF @DesiredSectionID IS NOT NULL          
BEGIN          
   Insert Into T_Student_Class_Section(          
               I_Student_Detail_ID          
              ,S_Student_ID          
              ,I_Brand_ID          
              ,I_School_Session_ID          
              ,I_School_Group_Class_ID          
              ,I_Section_ID          
              ,I_Stream_ID          
              ,I_Student_Type_ID          
              ,S_Class_Roll_No          
              ,I_Status          
)          
          
    VALUES (@iStudentDetailId, @sLoginID,@BrandID,@SessionID,@I_School_Group_Class_ID,@DesiredSectionID,@StreamID,NUll,Null,1);          
          
    -- Update the OccupiedSeats count for the selected section          
    UPDATE T_Section          
    SET Occupied_Seat = ISnull(Occupied_Seat,0) + 1   ,Dt_LastSectionModified=GETDATE()       
    WHERE I_Section_ID = @DesiredSectionID;          
          
    PRINT 'Student successfully mapped to Section ' + CAST(@DesiredSectionID AS NVARCHAR(10));          
END          
ELSE          
BEGIN          
    PRINT 'No available seats in any section.';          
END          
          
-- ---------------------------------------------------- --------------------------                
                
                  
        SELECT  @iStudentDetailId AS StudentID ,                  
                @sLoginID AS StudentCode                     
        COMMIT TRANSACTION                    
    END TRY                    
                    
    BEGIN CATCH                    
 --Error occurred:                      
        ROLLBACK TRANSACTION                    
        DECLARE @ErrMsg Nnvarchar(max) ,                  
                @ErrSeverity INT                    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,                  
                @ErrSeverity = ERROR_SEVERITY()                    
                    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                    
    END CATCH

