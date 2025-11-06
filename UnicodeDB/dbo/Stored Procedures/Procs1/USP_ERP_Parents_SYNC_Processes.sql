CREATE Proc [dbo].[USP_ERP_Parents_SYNC_Processes](    
@pBrandID int    
)    
as     
begin    
--Declare @pBrandID int =107    
 Select IDENTITY(INT,1,1) AS ID,     
 St.I_Student_Detail_ID,    
 ST.I_Enquiry_Regn_ID,    
       CM.S_Course_Name,    
       SBM.S_Batch_Name,    
       ST.S_Student_ID,    
       Concat(ST.S_First_Name, ' ', ST.S_Middle_Name, ' ', ST.S_Last_Name) as StudentName,    
       ST.S_Mobile_No,    
       --Case When PM.I_Relation_ID=1 Then 'Father' When PM.I_Relation_ID=2 Then 'Mother' end as Relation,    
       ERD.S_Father_Name as FatherName,    
       ERD.S_Father_Office_Phone as FatherContact,    
       ERD.S_Mother_Name as MotherName,    
       ERD.S_Mother_Office_Phone as MotherContact,    
       TM.S_PickupPoint_Name,    
       TM.N_Fees,    
       TBM.S_Route_No,    
       TC.S_Class_Name,    
       TS.S_Section_Name    
    ,CM.I_Brand_ID    
    into #AllNewStudent    
from T_Student_Batch_Details SBD    
    Inner Join T_Student_Batch_Master SBM    
        on SBM.I_Batch_ID = SBD.I_Batch_ID    
    Inner Join T_Course_Master CM    
        on CM.I_Course_ID = SBM.I_Course_ID    
    Inner Join T_Student_Detail ST    
        on ST.I_Student_Detail_ID = SBD.I_Student_ID    
    --Inner Join    
    --(    
    --    Select Count(I_Batch_ID) as BatchCount,    
    --           I_Student_ID    
    --    from T_Student_Batch_Details    
    --    group by I_Student_ID    
    --    Having Count(I_Batch_ID) = 1    
    --) t2    
    --    on t2.I_Student_ID = ST.I_Student_Detail_ID    
    Left Join T_Enquiry_Regn_Detail ERD    
        on ERD.I_Enquiry_Regn_ID = ST.I_Enquiry_Regn_ID    
    --Left Join T_Student_Parent_Maps SPM on SPM.I_Student_Detail_ID=ST.I_Student_Detail_ID    
    --Left Join T_Parent_Master PM on PM.I_Parent_Master_ID=SPM.I_Parent_Master_ID    
    Left Join    
    (    
        SELECT *,    
               ROW_NUMBER() OVER (PARTITION BY I_Student_Detail_ID ORDER BY Dt_Crtd_On DESC) AS rn    
        FROM T_Student_Transport_History    
    ) t1    
        on t1.I_Student_Detail_ID = ST.I_Student_Detail_ID    
           and t1.rn = 1    
    Left Join T_BusRoute_Master TBM    
        on TBM.I_Route_ID = t1.I_Route_ID    
    Left Join T_Transport_Master TM    
        on TM.I_PickupPoint_ID = t1.I_PickupPoint_ID    
           and TM.I_Brand_ID = CM.I_Brand_ID    
    Left Join T_Student_Class_Section SCS    
        on SCS.I_Student_Detail_ID = ST.I_Student_Detail_ID    
    Left Join T_School_Group_Class SGC    
        on SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID    
    Left Join T_Class TC on TC.S_Class_Name=    
 Case When CM.S_Course_Name like '%IGCSE%'    
Then     
left(CM.S_Course_Name, charindex('IGCSE', CM.S_Course_Name) - 1)    
    
          When CM.S_Course_Name like '%-%'    
Then     
SUBSTRING(S_Course_Name, 1, LEN(S_Course_Name) - CHARINDEX('-', REVERSE(S_Course_Name)))    
Else     
SUBSTRING(CM.S_Course_Name, 1, CHARINDEX('(', CM.S_Course_Name) - 1) End    
    
    
    Left Join T_School_Group SG    
        on SG.I_School_Group_ID = SGC.I_School_Group_ID    
    
  Left Join T_Section TS on TS.S_Section_Name=    
Case when SBM.S_Batch_Name Like '% A %' Then 'A'    
     When SBM.S_Batch_Name Like '% B %' Then 'B'    
  When SBM.S_Batch_Name Like '% C %' Then 'C'    
  When SBM.S_Batch_Name Like '% D %' Then 'D'    
  When SBM.S_Batch_Name Like '% E %' Then 'E'    
  When SBM.S_Batch_Name Like '% F %' Then 'F'    
  When SBM.S_Batch_Name Like '% G %' Then 'G'    
  When SBM.S_Batch_Name Like '% H %' Then 'H'    
  ELSe ''    
  End    
    
Where SBM.S_Batch_Name Like '%(2024)'    
      and SBD.I_Status = 1    
      and CM.I_Brand_ID = @pBrandID --and ST.S_Student_ID='24-0016'    
--and ST.S_Student_ID like '24-25%'    
and  Not Exists(Select 1 from T_Student_Parent_Maps SPM      
where SPM.I_Student_Detail_ID=ST.I_Student_Detail_ID)    
Order by ST.I_Student_Detail_ID    
    
    
    
--Drop Table #AllNewStudent    
    
    
    
-------------End-----------------------------    
     
 SET NOCOUNT ON;    
 Declare @ID int,@lst int,@iEnquiryRegnID Int ,@iStudentDetailId Int,            
       @sStudentCode varchar(50),@BrandID int    
 SET @ID=1    
 SET @lst=(select MAX(ID) from #AllNewStudent)    
 While @ID<=@lst    
 Begin    
 SET @iEnquiryRegnID=(select Top 1 I_Enquiry_Regn_ID from #AllNewStudent where ID=@ID)    
 SET @iStudentDetailId =(select Top 1 I_Student_Detail_ID from #AllNewStudent where ID=@ID)    
  SET @sStudentCode =(select Top 1 S_Student_ID from #AllNewStudent where ID=@ID)    
  SET @brandID =(select Top 1 i_brand_ID from #AllNewStudent where ID=@ID)    
  IF NOT Exists (Select 1 from T_Student_Parent_Maps  where I_Student_Detail_ID=@iStudentDetailId)    
  Begin-----Main Processes Start    
      
 DECLARE @GaudianDetails table (     
  ID1 int Identity(1,1),    
  I_Brand_ID INT,                
  S_Mobile_No nvarchar(max),                
  S_FullName varchar(max),                
  I_RelationID INT,                
  I_IsPrimary INT,                
  S_Address nvarchar(max),                
  S_Pin_Code nvarchar(max)                
  )     
   DECLARE @S_ADDRESS nvarchar(max),@S_Pin_Code nvarchar(max)            
                
  select Top 1 @S_ADDRESS=S_Curr_Address1,@S_Pin_Code=S_Curr_Pincode     
  from T_Student_Detail             
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
  select Top 1 @brandID,S_Father_Name,S_Father_Office_Phone,(select I_Relation_Master_ID from T_Relation_Master where S_Relation_Type like 'father'),1                
  ,@S_ADDRESS,@S_Pin_Code                
  from T_Enquiry_Regn_Detail where I_Enquiry_Regn_ID=@iEnquiryRegnID                
  union                
  select top 1 @brandID,S_Mother_Name,S_Mother_Office_Phone,(select I_Relation_Master_ID from T_Relation_Master where S_Relation_Type like 'mother'),1                
  ,@S_ADDRESS,@S_Pin_Code                
  from T_Enquiry_Regn_Detail where I_Enquiry_Regn_ID=@iEnquiryRegnID      
    
  DECLARE @ipI_Brand_ID INT                
  DECLARE @ipS_Mobile_No nvarchar(max)                
  DECLARE @ipFullName varchar(max)                
  DECLARE @ipRelationID INT                
  DECLARE @ipIsPrimary INT                
  DECLARE @ipAddress nvarchar(max)                
  DECLARE @ipPin_Code nvarchar(max)                
                
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
                
    DECLARE @FirstName nvarchar(max),@MiddleName nvarchar(max),@LastName nvarchar(max),@iparentID INT                
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
    select 1 from                 
    T_Parent_Master                 
    where UPPER(RTRIM(LTRIM(S_First_Name))) = UPPER(RTRIM(LTRIM(@FirstName)))                
    and UPPER(RTRIM(LTRIM(S_Middile_Name))) = UPPER(RTRIM(LTRIM(@MiddleName)))                
    and UPPER(RTRIM(LTRIM(S_Last_Name))) = UPPER(RTRIM(LTRIM(@LastName)))                
    and S_Mobile_No=@ipS_Mobile_No                
    and ISNULL(I_IsPrimary,0)=ISNULL(@ipIsPrimary,0)                
    )                
     Begin                
      
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
      1,                
      GETDATE(),                
      @ipRelationID,                
      1,                
      @brandID                
                
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
    where not exists(select 1 from  T_Student_Parent_Maps where   I_Parent_Master_ID=  @iparentID)        
                
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
            
   End                
                
                 
   CLOSE UPLOADPARENTDETAILS_CURSOR                           
   DEALLOCATE UPLOADPARENTDETAILS_CURSOR     
    
   Print 'New Student Mapped--'+ @sStudentCode    
   End-------End Of Existence Check    
   Else     
    
   Begin    
   Print 'Student ID: '+@sStudentCode+' Already Exists'    
   End     
      SET @ID=@ID+1    
   End-------End Of While Loop    
   Drop table #AllNewStudent    
   End
