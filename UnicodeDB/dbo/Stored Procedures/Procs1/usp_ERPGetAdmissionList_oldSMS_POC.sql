CREATE PROCEDURE [dbo].[usp_ERPGetAdmissionList_oldSMS_POC]          
 -- Add the parameters for the stored procedure here          
 (          
  @Enquiry_No NVARCHAR(max) = null,          
  @Full_Name NVARCHAR(max) = null,          
  @S_FatherName NVARCHAR(max) = NULL,        
  @S_MotherName NVARCHAR(max) = NULL,          
  @Mobile NVARCHAR(max) = null,          
  @AdmissionStageID int = null,      
  @Limit INT,      
  @Offset INT,      
  @SortCol INT,      
  @SortDir NVARCHAR(max),      
  @Search NVARCHAR(max) = NULL,
  @sessionID int =null,
  @PaymentDate datetime=null
 )          
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;          
          
    -- Insert statements for procedure here       
 declare @TotalRecords int, @FilteredRecords int      
      
 -- Start      
 SELECT @TotalRecords = COUNT(*)      
 FROM [T_Enquiry_Regn_Detail] AS TEERD          
 inner join T_ERP_Admission_Stage_Master TEASM on TEASM.I_Admission_Stage_ID = TEERD.R_I_AdmStgTypeID        
 inner join T_Enquiry_Type AS TEET ON TEERD.I_Enquiry_Type_ID = TEET.I_Enquiry_Type_ID          
 left join T_Class AS TC ON TEERD.I_Class_ID = TC.I_Class_ID          
 left join T_ERP_Enquiry_Regn_Guardian_Master AS TEERGM ON TEERD.I_Enquiry_Regn_ID = TEERGM.I_Enquiry_Regn_ID AND TEERGM.I_Relation_ID = 1          
 left join T_Relation_Master AS TRM ON TEERGM.I_Relation_ID = TRM.I_Relation_Master_ID          
 --left join T_ERP_Document_Student_Map TEDSM ON TEDSM.R_I_Enquiry_Regn_ID = TEERD.I_Enquiry_Regn_ID          
 left join (          
    SELECT TOP 1 R_I_Enquiry_Regn_ID, I_Followup_Status, S_Followup_Remarks          
    FROM T_ERP_Enquiry_Regn_Followup a
	----Add Join for adding SessionID Filter ---13.05.2024
	Inner Join T_Enquiry_Regn_Detail b on a.R_I_Enquiry_Regn_ID=b.I_Enquiry_Regn_ID
	where b.R_I_School_Session_ID=@sessionID
	---------------------------------
    ORDER BY Dt_Followup_Date DESC          
    --LIMIT 1 -- or TOP 1 for SQL Server          
 ) AS TEERF ON TEERD.I_Enquiry_Regn_ID = TEERF.R_I_Enquiry_Regn_ID         
 ------Joining for  ------Define Document verification status------        
 Left Join         
 (        
 select distinct R_I_Enquiry_Regn_ID,        
 (select count(R_I_Document_Type_ID) as cnt from (        
     Select dcm.R_I_Enquiry_Regn_ID,dcm.R_I_Document_Type_ID        
     from T_ERP_Document_Student_Map dcm where dcm.R_I_Enquiry_Regn_ID=@Enquiry_No        
     Union         
     select dmp.R_I_Enquiry_Regn_ID as Regid ,I_Document_Type_ID from  [T_ERP_Document_Type_Master] dm         
     Left Join T_ERP_Document_Student_Map dmp on dmp.R_I_Document_Type_ID=dm.I_Document_Type_ID        
     where dm.Is_Mandatory=1         
      ) as cnt) as TotalCount ,        
 (select count(I_Document_StudRegn_ID) from T_ERP_Document_Student_Map where Is_verified=1        
 and Is_Active=1  and R_I_Enquiry_Regn_ID=@Enquiry_No      
 group by R_I_Enquiry_Regn_ID) as Verified,        
    (select count(I_Document_StudRegn_ID) from T_ERP_Document_Student_Map where Is_verified=0         
 and Is_Active=1   and R_I_Enquiry_Regn_ID=@Enquiry_No     
 group by R_I_Enquiry_Regn_ID) as Pending        
 --Into #DocVerification_Status        
        
 from T_ERP_Document_Student_Map dsm        
         
 Group by R_I_Enquiry_Regn_ID) as DocStatusCount on DocStatusCount.R_I_Enquiry_Regn_ID=TEERD.I_Enquiry_Regn_ID        
 WHERE          
 -- TEERD.S_Enquiry_No=ISNULL(@Enquiry_No, TEERD.S_Enquiry_No)         
 -- AND (          
 --  CONCAT(COALESCE(TEERD.S_First_Name+' ', ''), COALESCE(TEERD.S_Middle_Name+' ', ''), COALESCE(TEERD.S_Last_Name, '')) LIKE '%' + @Full_Name + '%'         
 --  OR @Full_Name IS NULL          
 -- )          
 --AND (@S_FatherName IS NULL OR TEERD.S_Father_Name LIKE '%' + @S_FatherName + '%')         
 -- AND (@S_MotherName IS NULL OR TEERD.S_Mother_Name LIKE '%' + @S_MotherName + '%')          
 -- AND (          
 --  TEERD.S_Mobile_No=ISNULL(@Mobile,TEERD.S_Mobile_No)          
 -- )          
   TEERD.App_Payment_Status=1 and TEERD.I_Enquiry_Status_Code=1 
   and I_ERP_Entry = 1 --and (TEERD.R_I_AdmStgTypeID = @AdmissionStageID OR @AdmissionStageID IS NULL)        
    --end 
----Add Parameter Session--------13.05.2024
	and TEERD.R_I_School_Session_ID=@sessionID
      
      
      
 --start       
 SELECT @FilteredRecords = COUNT(*)       
 FROM(      
  SELECT TEERD.I_Enquiry_Regn_ID      
   FROM [T_Enquiry_Regn_Detail] AS TEERD          
   inner join T_ERP_Admission_Stage_Master TEASM on TEASM.I_Admission_Stage_ID = TEERD.R_I_AdmStgTypeID        
   inner join T_Enquiry_Type AS TEET ON TEERD.I_Enquiry_Type_ID = TEET.I_Enquiry_Type_ID          
   left join T_Class AS TC ON TEERD.I_Class_ID = TC.I_Class_ID          
   left join T_ERP_Enquiry_Regn_Guardian_Master AS TEERGM ON TEERD.I_Enquiry_Regn_ID = TEERGM.I_Enquiry_Regn_ID AND TEERGM.I_Relation_ID = 1          
   left join T_Relation_Master AS TRM ON TEERGM.I_Relation_ID = TRM.I_Relation_Master_ID          
   --left join T_ERP_Document_Student_Map TEDSM ON TEDSM.R_I_Enquiry_Regn_ID = TEERD.I_Enquiry_Regn_ID          
   left join (          
   SELECT TOP 1 R_I_Enquiry_Regn_ID, I_Followup_Status, S_Followup_Remarks          
   FROM T_ERP_Enquiry_Regn_Followup a
   -----Add Join for Adding Filter SessionID
   Inner Join T_Enquiry_Regn_Detail b on a.R_I_Enquiry_Regn_ID=b.I_Enquiry_Regn_ID
	where b.R_I_School_Session_ID=@sessionID
   ORDER BY Dt_Followup_Date DESC          
   --LIMIT 1 -- or TOP 1 for SQL Server          
   ) AS TEERF ON TEERD.I_Enquiry_Regn_ID = TEERF.R_I_Enquiry_Regn_ID         
   ------Joining for  ------Define Document verification status------        
   Left Join         
   (        
   select distinct R_I_Enquiry_Regn_ID,        
   (select count(R_I_Document_Type_ID) as cnt from (        
    Select dcm.R_I_Enquiry_Regn_ID,dcm.R_I_Document_Type_ID        
    from T_ERP_Document_Student_Map dcm where dcm.R_I_Enquiry_Regn_ID=@Enquiry_No        
    Union         
    select dmp.R_I_Enquiry_Regn_ID as Regid ,I_Document_Type_ID from  [T_ERP_Document_Type_Master] dm         
    Left Join T_ERP_Document_Student_Map dmp on dmp.R_I_Document_Type_ID=dm.I_Document_Type_ID        
    where dm.Is_Mandatory=1         
     ) as cnt) as TotalCount ,        
   (select count(I_Document_StudRegn_ID) from T_ERP_Document_Student_Map where Is_verified=1        
   and Is_Active=1 and R_I_Enquiry_Regn_ID=@Enquiry_No        
   group by R_I_Enquiry_Regn_ID) as Verified,        
   (select count(I_Document_StudRegn_ID) from T_ERP_Document_Student_Map where Is_verified=0         
   and Is_Active=1   and R_I_Enquiry_Regn_ID=@Enquiry_No      
   group by R_I_Enquiry_Regn_ID) as Pending        
   --Into #DocVerification_Status        
        
   from T_ERP_Document_Student_Map dsm        
         
   Group by R_I_Enquiry_Regn_ID) as DocStatusCount on DocStatusCount.R_I_Enquiry_Regn_ID=TEERD.I_Enquiry_Regn_ID        
          
   WHERE          
    TEERD.S_Enquiry_No=ISNULL(@Enquiry_No, TEERD.S_Enquiry_No)         
    AND (          
     CONCAT(COALESCE(TEERD.S_First_Name+' ', ''), COALESCE(TEERD.S_Middle_Name+' ', ''), COALESCE(TEERD.S_Last_Name, '')) LIKE '%' + @Full_Name + '%'         
     OR @Full_Name IS NULL          
    )          
   AND (@S_FatherName IS NULL OR TEERD.S_Father_Name LIKE '%' + @S_FatherName + '%')         
    AND (@S_MotherName IS NULL OR TEERD.S_Mother_Name LIKE '%' + @S_MotherName + '%')          
    AND (          
     TEERD.S_Mobile_No=ISNULL(@Mobile,TEERD.S_Mobile_No)          
    )          
    AND TEERD.App_Payment_Status=1 and TEERD.I_Enquiry_Status_Code=1 and I_ERP_Entry = 1 and (TEERD.R_I_AdmStgTypeID = @AdmissionStageID OR @AdmissionStageID IS NULL)        
    AND (      
    @Search IS NULL       
    OR TEERD.S_Enquiry_No LIKE '%' + @Search + '%'       
    OR CONCAT(COALESCE(TEERD.S_First_Name+' ', ''), COALESCE(TEERD.S_Middle_Name+' ', ''), COALESCE(TEERD.S_Last_Name, '')) LIKE '%' + @Search + '%'       
    OR TEERD.S_Mobile_No LIKE '%' + @Search + '%'       
    OR TC.S_Class_Name LIKE '%' + @Search + '%'       
    OR TEASM.S_Admission_Current_Stage LIKE '%' + @Search + '%'       
    OR TEASM.S_Admission_Current_Stage_Desc LIKE '%' + @Search + '%'       
    OR TEASM.S_Admission_Next_Stage LIKE '%' + @Search + '%'       
    OR TEASM.S_Admission_Next_Stage_Desc LIKE '%' + @Search + '%'           
   )      
   --  order by TEERD.I_Enquiry_Regn_ID       
   --  OFFSET @Offset ROWS      
   --  FETCH NEXT @Limit ROWS ONLY   
   and TEERD.R_I_School_Session_ID=@sessionID
 ) AS CountedRecords;      
       
      
      
 --end      
      
 SELECT TEERD.I_Enquiry_Regn_ID EnquiryRegnID          
 ,TEERD.S_Enquiry_No EnquiryNo          
 ,TEERD.I_Enquiry_Type_ID EnquiryTypeID          
 ,TEERD.Dt_Crtd_On LeadDate        
 ,TEET.S_Enquiry_Type_Desc EnquiryTypeDesc          
 --,TEERD.PreEnquiryDate LeadDate          
 ,CONCAT(COALESCE(TEERD.S_First_Name+' ', ''), COALESCE(TEERD.S_Middle_Name+' ', ''), COALESCE(TEERD.S_Last_Name, '')) FullName          
 ,TEERD.S_Mobile_No MobileNumber          
 ,TEERD.I_Class_ID CourseAppliedForID          
 ,TC.S_Class_Name CourseAppliedFor         
 ,TEERD.R_I_AdmStgTypeID AdmissionStage        
 ,TEASM.S_Admission_Current_Stage AdmissionCurrentStage        
 ,TEASM.S_Admission_Current_Stage_Desc AdmissionCurrentStageDesc        
 ,TEASM.S_Admission_Next_Stage AdmissionNextStage        
 ,TEASM.S_Admission_Next_Stage_Desc AdmissionNextStageDesc        
 ,TEERD.App_Payment_Status ApplicationPayment          
 ,TEERF.I_Followup_Status FollowUpStatus          
 ,TEERF.S_Followup_Remarks FollowUpRemark          
 ,TEERD.S_Father_Name AS FatherName        
 ,TEERD.S_Mother_Name AS MotherName        
 --,TEERGM.I_Relation_ID AS RelationID          
 --,TRM.S_Relation_Type AS RelationName          
 ,TEERD.I_Is_Active AS IsActive          
 ,TEERD.I_ERP_Entry AS ERP_Entry 
 ,TEERD.Dt_PaymentDate PaymentDate
 ,(select count(t1.I_Document_StudRegn_ID) from T_ERP_Document_Student_Map t1 where t1.R_I_Enquiry_Regn_ID=TEERD.I_Enquiry_Regn_ID and t1.Is_Active = 1) DocumentCount          
 ------Define Document verification status------        
 ,Case When DocStatusCount.TotalCount=DocStatusCount.Verified Then 'Verified'        
      When DocStatusCount.Verified<DocStatusCount.TotalCount Then 'Partially Verified'        
   Else 'Pending All' End as Verification_Status        
 ,@TotalRecords AS TotalRecords      
 ,@FilteredRecords AS FilteredRecords  
 ,TEERD.R_I_School_Session_ID AS AcademicSessionID  
 FROM [T_Enquiry_Regn_Detail] AS TEERD          
 inner join T_ERP_Admission_Stage_Master TEASM on TEASM.I_Admission_Stage_ID = TEERD.R_I_AdmStgTypeID        
 inner join T_Enquiry_Type AS TEET ON TEERD.I_Enquiry_Type_ID = TEET.I_Enquiry_Type_ID          
 left join T_Class AS TC ON TEERD.I_Class_ID = TC.I_Class_ID          
 left join T_ERP_Enquiry_Regn_Guardian_Master AS TEERGM ON TEERD.I_Enquiry_Regn_ID = TEERGM.I_Enquiry_Regn_ID AND TEERGM.I_Relation_ID = 1          
 left join T_Relation_Master AS TRM ON TEERGM.I_Relation_ID = TRM.I_Relation_Master_ID          
 --left join T_ERP_Document_Student_Map TEDSM ON TEDSM.R_I_Enquiry_Regn_ID = TEERD.I_Enquiry_Regn_ID          
 left join (          
    SELECT TOP 1 R_I_Enquiry_Regn_ID, I_Followup_Status, S_Followup_Remarks          
    FROM T_ERP_Enquiry_Regn_Followup          
    ORDER BY Dt_Followup_Date DESC          
    --LIMIT 1 -- or TOP 1 for SQL Server          
 ) AS TEERF ON TEERD.I_Enquiry_Regn_ID = TEERF.R_I_Enquiry_Regn_ID         
 ------Joining for  ------Define Document verification status------        
 Left Join         
 (        
 select distinct R_I_Enquiry_Regn_ID,        
 (select count(R_I_Document_Type_ID) as cnt from (        
     Select dcm.R_I_Enquiry_Regn_ID,dcm.R_I_Document_Type_ID        
     from T_ERP_Document_Student_Map dcm where dcm.R_I_Enquiry_Regn_ID=@Enquiry_No        
     Union         
     select dmp.R_I_Enquiry_Regn_ID as Regid ,I_Document_Type_ID from  [T_ERP_Document_Type_Master] dm         
     Left Join T_ERP_Document_Student_Map dmp on dmp.R_I_Document_Type_ID=dm.I_Document_Type_ID        
     where dm.Is_Mandatory=1         
      ) as cnt) as TotalCount ,        
 (select count(I_Document_StudRegn_ID) from T_ERP_Document_Student_Map where Is_verified=1        
 and Is_Active=1    and R_I_Enquiry_Regn_ID=@Enquiry_No    
 group by R_I_Enquiry_Regn_ID) as Verified,        
    (select count(I_Document_StudRegn_ID) from T_ERP_Document_Student_Map where Is_verified=0         
 and Is_Active=1    and R_I_Enquiry_Regn_ID=@Enquiry_No    
 group by R_I_Enquiry_Regn_ID) as Pending        
 --Into #DocVerification_Status        
        
 from T_ERP_Document_Student_Map dsm        
         
 Group by R_I_Enquiry_Regn_ID) as DocStatusCount on DocStatusCount.R_I_Enquiry_Regn_ID=TEERD.I_Enquiry_Regn_ID        
          
 WHERE  TEERD.R_I_School_Session_ID=@sessionID     and      
  TEERD.S_Enquiry_No=ISNULL(@Enquiry_No, TEERD.S_Enquiry_No)         
  AND (          
   CONCAT(COALESCE(TEERD.S_First_Name+' ', ''), COALESCE(TEERD.S_Middle_Name+' ', ''), COALESCE(TEERD.S_Last_Name, '')) LIKE '%' + @Full_Name + '%'         
   OR @Full_Name IS NULL          
  )          
 AND (@S_FatherName IS NULL OR TEERD.S_Father_Name LIKE '%' + @S_FatherName + '%')         
  AND (@S_MotherName IS NULL OR TEERD.S_Mother_Name LIKE '%' + @S_MotherName + '%')          
  AND (          
   TEERD.S_Mobile_No=ISNULL(@Mobile,TEERD.S_Mobile_No)          
  )          
  AND TEERD.App_Payment_Status=1 and TEERD.I_Enquiry_Status_Code=1 and I_ERP_Entry = 1 and (TEERD.R_I_AdmStgTypeID = @AdmissionStageID OR @AdmissionStageID IS NULL)        
  AND (      
  @Search IS NULL       
  OR TEERD.S_Enquiry_No LIKE '%' + @Search + '%'       
  OR CONCAT(COALESCE(TEERD.S_First_Name+' ', ''), COALESCE(TEERD.S_Middle_Name+' ', ''), COALESCE(TEERD.S_Last_Name, '')) LIKE '%' + @Search + '%'       
  OR TEERD.S_Mobile_No LIKE '%' + @Search + '%'       
  OR TC.S_Class_Name LIKE '%' + @Search + '%'       
  OR TEASM.S_Admission_Current_Stage LIKE '%' + @Search + '%'       
  OR TEASM.S_Admission_Current_Stage_Desc LIKE '%' + @Search + '%'       
  OR TEASM.S_Admission_Next_Stage LIKE '%' + @Search + '%'       
  OR TEASM.S_Admission_Next_Stage_Desc LIKE '%' + @Search + '%'         
        
 )      
   order by       
 (       
  case when (@SortCol = 0 and @SortDir = 'asc') then TEERD.I_Enquiry_Regn_ID end      
 )asc,      
 (      
  case when (@SortCol = 0 and @SortDir = 'desc') then TEERD.I_Enquiry_Regn_ID end      
 ) desc,      
 (      
  case when (@SortCol = 1 and @SortDir = 'asc') then TEERD.Dt_Crtd_On end       
 ) asc,      
 (      
  case when (@SortCol = 1 and @SortDir = 'desc') then TEERD.Dt_Crtd_On end      
 ) desc, 
  (      
  case when (@SortCol = 2 and @SortDir = 'asc') then TEERD.Dt_PaymentDate end       
 ) asc, 
 (      
  case when (@SortCol = 2 and @SortDir = 'desc') then TEERD.Dt_PaymentDate end      
 ) desc,
 (      
  case when (@SortCol = 3 and @SortDir = 'asc') then CONCAT(COALESCE(TEERD.S_First_Name+' ', ''), COALESCE(TEERD.S_Middle_Name+' ', ''), COALESCE(TEERD.S_Last_Name, '')) end      
 )asc,      
 (      
  case when (@SortCol = 3 and @SortDir = 'desc') then CONCAT(COALESCE(TEERD.S_First_Name+' ', ''), COALESCE(TEERD.S_Middle_Name+' ', ''), COALESCE(TEERD.S_Last_Name, '')) end      
 ) desc,      
 (      
  case when (@SortCol = 4 and @SortDir = 'asc') then TEERD.S_Mobile_No end      
 ) asc,      
 (      
  case when (@SortCol = 4 and @SortDir = 'desc') then TEERD.S_Mobile_No end      
 ) desc,      
 (      
  case when (@SortCol = 5 and @SortDir = 'asc') then TC.S_Class_Name end      
 ) asc,      
 (      
  case when (@SortCol = 5 and @SortDir = 'desc') then TC.S_Class_Name end       
 ) desc,      
 (      
  case when (@SortCol = 6 and @SortDir = 'asc') then TEASM.S_Admission_Current_Stage end      
 ) asc,      
 (      
  case when (@SortCol = 6 and @SortDir = 'desc') then TEASM.S_Admission_Current_Stage end      
 ) desc,      
 (      
  case when (@SortCol = 7 and @SortDir = 'asc') then TEASM.S_Admission_Next_Stage end      
 ) asc,      
 (      
  case when (@SortCol = 7 and @SortDir = 'desc') then TEASM.S_Admission_Next_Stage end      
 ) desc,      
 (      
  case when (@SortCol = 8 and @SortDir = 'asc') then TEERD.I_Is_Active end       
 ) asc,      
 (      
  case when (@SortCol = 8 and @SortDir = 'desc') then TEERD.I_Is_Active end      
 ) desc  
 
             
   OFFSET @Offset ROWS      
   FETCH NEXT @Limit ROWS ONLY;      
        
END 


