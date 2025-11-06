-- =============================================  
-- Author:  <susmita Paul>  
-- Create date: <2023-Oct-05>  
-- Description: <Get Log Book Details>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetLogBookDetailsAPI]  
 -- Add the parameters for the stored procedure here  
 (  
 @sToken nvarchar(200) =null,  
 @LogDate datetime,  
 @iSubjectID INT=NULL,  
 @iClass INT=NULL,  
 @iLogbookID INT=NULL  
 ,@iBrand INT = NULL  
 )  
AS  
BEGIN TRY  
  
SET NOCOUNT ON;  
  
begin transaction  
  
 DECLARE @ErrMessage NVARCHAR(4000),@UserID INT  
  
 --set @sToken='Ahx6cuOkPkykBfpthTpYhXc'  
  
 IF EXISTS  
 (  
 select * from   
 T_Faculty_Master as FM   
 inner join  
 T_ERP_User as UM on UM.I_User_ID=FM.I_User_ID where   
 UM.S_Token=@sToken  
 )  
   
  
  
 begin  
  
   Create Table #LogBookID  
   (  
   I_Subject_Structure_Plan_ID int,  
   I_Subject_Structure_Plan_Detail_ID int,  
   PlanDate datetime,  
   ClassID int,  
   ClassName varchar(max),  
   SubjectID int,  
   SubjectName varchar(max),  
   PeriodNo int,  
   FromSlot varchar(5),  
   ToSlot varchar(5),  
   LeafSubjectStructureID int,  
   CompletionPercentage decimal(4, 1),  
   Remarks nvarchar(max)  
   ,SchoolGroupType varchar(max)  
   ,IsLogBookRemarksRegistered BIT  
   )  
  
    insert into #LogBookID  
    select   
    SSP.I_Subject_Structure_Plan_ID,  
    SSPD.I_Subject_Structure_Plan_Detail_ID --as LogBookID  
    ,TTP.Dt_Plan_Date as PlanDate  
    ,TC.I_Class_ID as ClassID  
    ,TC.S_Class_Name as ClassName  
    ,SM.I_Subject_ID as SubjectID  
    ,SM.S_Subject_Name as SubjectName  
    ,RSD.I_Period_No as PeriodNo  
    ,CONVERT(VARCHAR(5), CAST((select RSD.T_FromSlot from T_ERP_Routine_Structure_Detail where I_Routine_Structure_Detail_ID=1) AS TIME), 108) as FromSlot  
    ,CONVERT(VARCHAR(5), CAST((select RSD.T_ToSlot from T_ERP_Routine_Structure_Detail where I_Routine_Structure_Detail_ID=1) AS TIME), 108) as ToSlot  
    ,SS.I_Subject_Structure_ID as LeafSubjectStructureID  
    --,ISNULL(SPER.I_Completion_Percentage,0.0) as CompletionPercentage  
    --,SPER.S_Remarks as Remarks  
    ,SG.S_School_Group_Name as SchoolGroupType  
    --,CASE   
    -- WHEN SPER.I_Completion_Percentage IS NULL THEN 0  
    -- ELSE 1  
    -- END  
    -- as IsLogBookRemarksRegistered  
    from   
    T_ERP_Subject_Structure_Plan  as SSP WITH (NOLOCK)   
    inner join  
    T_ERP_Subject_Structure_Plan_Detail as SSPD WITH (NOLOCK)  
    on SSP.I_Subject_Structure_Plan_ID=SSPD.I_Subject_Structure_Plan_ID  
    inner join  
    T_ERP_Teacher_Time_Plan as TTP WITH (NOLOCK)   
     on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID   
    inner join  
    T_ERP_Student_Class_Routine as SCR WITH (NOLOCK)   
     on SCR.I_Student_Class_Routine_ID=TTP.I_Student_Class_Routine_ID  
    inner join  
    T_ERP_Routine_Structure_Detail as RSD WITH (NOLOCK)   
     on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID   
    inner join  
    T_ERP_Routine_Structure_Header as RSH WITH (NOLOCK)   
     on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID  
    inner join  
    T_Subject_Master as SM on SM.I_Subject_ID=SCR.I_Subject_ID and SM.I_Status=1  
    inner join  
    T_Class as TC on TC.I_Class_ID=RSH.I_Class_ID and TC.I_Status=1  
    inner join  
    T_School_Group as SG on SG.I_School_Group_ID=RSH.I_School_Group_ID and SG.I_Status=1  
    inner join  
    T_ERP_Subject_Structure SS on SS.I_Subject_Structure_ID=SSPD.I_Subject_Structure_ID  
 --   left join T_ERP_Subject_Structure_Plan_Execution_Remarks as SPER 
	--on SPER.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID  
    inner join  
    T_Faculty_Master as FM on FM.I_Faculty_Master_ID=SCR.I_Faculty_Master_ID  
    inner join  
    T_ERP_User as UM on UM.I_User_ID=FM.I_User_ID  
    where CONVERT(DATE,TTP.Dt_Plan_Date)=CONVERT(DATE,@LogDate) and TC.I_Class_ID=ISNULL(@iClass,TC.I_Class_ID)  
    and SM.I_Subject_ID=ISNULL(@iSubjectID,SM.I_Subject_ID)  
    and UM.S_Token=@sToken  
    and SSP.I_Subject_Structure_Plan_ID=ISNULL(@iLogbookID,SSP.I_Subject_Structure_Plan_ID)  
      
  
  
    Declare  @CourseStructure Table  
    (  
    ID int identity,  
    I_Subject_Structure_Plan_ID int,  
    I_Subject_Structure_Plan_Detail_ID int,  
    LeafSubjectStructureID INT,  
    SubjectStructureID INT,  
    SubjectStructureLabel varchar(max),  
    SubjectStructureName varchar(max),  
    SubjectStructureSequenceNo INT  
    )  
  
    --Declare @SubjectStructure Table  
    --(  
    --ID int identity,  
    --SequenceNo int,  
    --SubjectStructureID int,  
    --SubjectStructureLabel varchar(max),  
    --SubjectStructureName varchar(max),  
    --SubjectParentID INT  
    --)  
  
    --insert into @SubjectStructure  
    --(  
    --SequenceNo,  
    --SubjectStructureID,  
    --SubjectStructureLabel,  
    --SubjectStructureName,  
    --SubjectParentID  
    --)  
    --select EST.I_Sequence_Number,ESS.I_Subject_Structure_ID,  
    --EST.S_Structure_Name,ESS.S_Name,ESS.I_Parent_Subject_Structure_ID  
    --from T_ERP_Subject_Structure as ESS  
    --inner join  
    --T_ERP_Subject_Template as EST on EST.I_Subject_Template_ID=ESS.I_Subject_Template_ID  
  
  
    DECLARE   
    @LeafSubjectStructureID int,  
    @CurrentSubjectStructureID int,  
    @SequenceNo int=0,  
    @SubjectStructureID INT,  
    @SubjectStructureLabel varchar(max),  
    @SubjectStructureName varchar(max),  
    @ParentSubjectStructureID INT,  
    @I_Subject_Structure_Plan_ID int,  
    @I_Subject_Structure_Plan_Detail_ID int  
  
   DECLARE cursor_log CURSOR  
   FOR SELECT   
     LeafSubjectStructureID,I_Subject_Structure_Plan_ID,I_Subject_Structure_Plan_Detail_ID  
    FROM   
     #LogBookID;  
  
   OPEN cursor_log;  
  
   FETCH NEXT FROM cursor_log INTO   
      @LeafSubjectStructureID,  
      @I_Subject_Structure_Plan_ID,  
      @I_Subject_Structure_Plan_Detail_ID  
  
   WHILE @@FETCH_STATUS = 0  
    BEGIN  
     --PRINT @LeafSubjectStructureID;  
  
     set @CurrentSubjectStructureID=@LeafSubjectStructureID  
  
    
     while (ISNULL(@CurrentSubjectStructureID,0) > 0)  
  
      BEGIN  
  
      PRINT @CurrentSubjectStructureID  
  
      select @SequenceNo=EST.I_Sequence_Number,@SubjectStructureID=ESS.I_Subject_Structure_ID,  
      @SubjectStructureLabel=EST.S_Structure_Name,@SubjectStructureName=ESS.S_Name,  
      @ParentSubjectStructureID=ESS.I_Parent_Subject_Structure_ID  
      from T_ERP_Subject_Structure as ESS  
      inner join  
      T_ERP_Subject_Template as EST on EST.I_Subject_Template_ID=ESS.I_Subject_Template_ID  
      where ESS.I_Subject_Structure_ID=@CurrentSubjectStructureID  
  
      --PRINT '77'   
      PRINT @ParentSubjectStructureID  
  
      insert into @CourseStructure   
      (  
      LeafSubjectStructureID,  
      I_Subject_Structure_Plan_ID,  
      I_Subject_Structure_Plan_Detail_ID,  
      SubjectStructureID,  
      SubjectStructureLabel,  
      SubjectStructureName,  
      SubjectStructureSequenceNo  
      )  
      values  
      (  
      @LeafSubjectStructureID,  
      @I_Subject_Structure_Plan_ID,  
      @I_Subject_Structure_Plan_Detail_ID,  
      @SubjectStructureID,  
      @SubjectStructureLabel,  
      @SubjectStructureName,  
      @SequenceNo  
      )  
    
      SET @CurrentSubjectStructureID= @ParentSubjectStructureID  
  
      END  
  
     FETCH NEXT FROM cursor_log INTO   
      @LeafSubjectStructureID,  
      @I_Subject_Structure_Plan_ID,  
      @I_Subject_Structure_Plan_Detail_ID  
      ;   
              
    END;  
  
   CLOSE cursor_log;  
  
   DEALLOCATE cursor_log;  
  
  
   select DISTINCT  
   --I_Subject_Structure_Plan_ID as SubjectStructurePlanID,  
   --I_Subject_Structure_Plan_Detail_ID as SubjectStructurePlanDetailID,  
   I_Subject_Structure_Plan_ID as LogBookID,  
   PlanDate,  
   ClassID,  
   ClassName,  
   SubjectID,  
   SubjectName,  
   PeriodNo,  
   FromSlot,  
   ToSlot  
   --,LeafSubjectStructureID  
   ,CompletionPercentage  
   ,Remarks  
   ,SchoolGroupType  
   ,IsLogBookRemarksRegistered  
   from #LogBookID  
  
   select   
   DISTINCT  
   I_Subject_Structure_Plan_ID as SubjectStructurePlanID,  
   --0 as SubjectStructurePlanDetailID,  
   I_Subject_Structure_Plan_Detail_ID as SubjectStructurePlanDetailID,  
   I_Subject_Structure_Plan_ID as LogBookID,  
   LeafSubjectStructureID,  
   SubjectStructureID,  
   SubjectStructureLabel,  
   SubjectStructureName,  
   SubjectStructureSequenceNo  
  
   from @CourseStructure  
  
  
   select DISTINCT  
   CS.I_Subject_Structure_Plan_ID as SubjectStructurePlanID,  
   --CS.I_Subject_Structure_Plan_Detail_ID as SubjectStructurePlanDetailID,  
   CS.I_Subject_Structure_Plan_ID as LogBookID,  
   ESSM.I_Subject_Structure_Media_ID as SubjectStructureMediaID,  
   ESSM.S_Media_Name as MediaNames,  
   ESSM.S_Media_Type as MediaType,  
   ESSM.S_Document_Link as DocumentLink  
   from   
   @CourseStructure as CS  
   inner join  
   T_ERP_Subject_Structure as ESS on CS.SubjectStructureID=ESS.I_Subject_Structure_ID  
   inner join  
   T_ERP_Subject_Structure_Media as ESSM on ESSM.I_Subject_Structure_Header_ID=ESS.I_Subject_Structure_Header_ID  
  
  
 end  
  
 else  
   begin  
  
    SELECT @ErrMessage='Invalid Token'  
  
    RAISERROR(@ErrMessage,11,1)  
  
   end  
  
 commit transaction  
  
END TRY  
BEGIN CATCH  
 rollback transaction  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH  
