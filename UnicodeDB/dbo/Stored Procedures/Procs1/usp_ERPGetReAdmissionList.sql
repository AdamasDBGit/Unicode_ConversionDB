  
CREATE   PROCEDURE [dbo].[usp_ERPGetReAdmissionList]            
 -- Add the parameters for the stored procedure here            
 (            
  @sStudentID NVARCHAR(max) = null,            
  @Full_Name NVARCHAR(max) = null,          
  @Mobile NVARCHAR(max) = null,            
  @ReAdmissionStageID int = null,        
  @Limit INT,        
  @Offset INT,        
  @SortCol INT,        
  @SortDir NVARCHAR(max),        
  @Search NVARCHAR(max) = NULL,  
  @iSourceSessionID int =null,  
  @iSourceSchoolGroupID int=null,  
  @iSourceClassID int=null,  
  @iSourceStreamID int=null  
 )            
AS            
BEGIN            
 -- SET NOCOUNT ON added to prevent extra result sets from            
 -- interfering with SELECT statements.            
 SET NOCOUNT ON;          
   
  
     -- Insert statements for procedure here         
 declare @TotalRecords int, @FilteredRecords int   
   
  
  
 create table #ReAdmissionStatus  
 (  
 ReAdmissionStatusID int,  
 ReAdmissionStatusDesc nvarchar(max)  
 )  
  
  
 insert into #ReAdmissionStatus  
 (  
 ReAdmissionStatusID,  
 ReAdmissionStatusDesc  
 )  
 values(1,'Approved'),(2,'Fee Mapped'),(3,'Promoted'),(4,'Demoted')  
  
        
 -- Start        
 SELECT DISTINCT @TotalRecords = COUNT(*)  from      
 T_ERP_Student_Promotion_History_Header as SPHH   
 inner join  
 T_Student_Detail as SD on SPHH.I_Student_DetailID=SD.I_Student_Detail_ID  
 inner join  
 T_Class as C on SPHH.I_Source_Class_ID=C.I_Class_ID  
 inner join  
 T_Section as S on SPHH.I_Source_SectionID=S.I_Section_ID  
 inner join  
 T_School_Academic_Session_Master as SASM on SPHH.I_Source_Academic_Session=SASM.I_School_Session_ID  
 inner join  
 T_School_Group as SG on SPHH.I_Source_School_Group_ID=SG.I_School_Group_ID  
 left join  
 T_Stream as S1 on SPHH.I_Source_Stream_ID=S1.I_Stream_ID          
                 
 WHERE            
 SPHH.I_Source_Academic_Session=@iSourceSessionID  
 and C.I_Class_ID= ISNULL(@iSourceClassID,C.I_Class_ID)   
 and SG.I_School_Group_ID=ISNULL(@iSourceSchoolGroupID,SG.I_School_Group_ID)  
 and(@iSourceStreamID IS NULL OR S1.I_Stream_ID=ISNULL(@iSourceStreamID,S1.I_Stream_ID))  
 and SD.S_Student_ID = ISNULL(@sStudentID,SD.S_Student_ID)  
 and SPHH.IsFinancialApproved='true' and SPHH.IsAcademicApproved='true'
 and SPHH.I_Source_Batch_ID IS NOT NULL
     
  
  
    -- Start        
  
  
 ;WITH CountedRecords AS   
(  
    SELECT DISTINCT SPHH.I_Student_DetailID,  
        CASE   
             WHEN SPHH.ispromoted IS NULL AND SPHH.isfeemapped='true' THEN 2  
            WHEN SPHH.ispromoted IS NULL AND SPHH.isfeemapped IS NULL THEN 1  
            WHEN SPHH.isfeemapped='true' AND SPHH.IsPromoted= 'true' THEN 3  
   WHEN SPHH.isfeemapped='true' AND SPHH.IsDemoted= 'true' THEN 4  
        END AS ReAdmissionStatus  
    FROM T_ERP_Student_Promotion_History_Header AS SPHH  
    INNER JOIN T_Student_Detail AS SD ON SPHH.I_Student_DetailID = SD.I_Student_Detail_ID  
    INNER JOIN T_Class AS C ON SPHH.I_Source_Class_ID = C.I_Class_ID  
    INNER JOIN T_Section AS S ON SPHH.I_Source_SectionID = S.I_Section_ID  
    INNER JOIN T_School_Academic_Session_Master AS SASM ON SPHH.I_Source_Academic_Session = SASM.I_School_Session_ID  
    INNER JOIN T_School_Group AS SG ON SPHH.I_Source_School_Group_ID = SG.I_School_Group_ID  
    LEFT JOIN T_Stream AS S1 ON SPHH.I_Source_Stream_ID = S1.I_Stream_ID  
    LEFT JOIN #ReAdmissionStatus AS RS ON RS.ReAdmissionStatusID =   
        CASE   
            WHEN SPHH.ispromoted IS NULL AND  SPHH.IsDemoted IS NULL AND SPHH.isfeemapped='true' THEN 2  
            WHEN SPHH.ispromoted IS NULL AND SPHH.isfeemapped IS NULL THEN 1  
            WHEN SPHH.isfeemapped='true' AND SPHH.IsPromoted= 'true' THEN 3  
   WHEN SPHH.isfeemapped='true' AND SPHH.IsDemoted= 'true' THEN 4  
        END  
    WHERE SPHH.I_Source_Academic_Session = @iSourceSessionID  
	 and SPHH.I_Source_Batch_ID IS NOT NULL
 and C.I_Class_ID= ISNULL(@iSourceClassID,C.I_Class_ID)   
 and SG.I_School_Group_ID=ISNULL(@iSourceSchoolGroupID,SG.I_School_Group_ID)  
 and(@iSourceStreamID IS NULL OR S1.I_Stream_ID=ISNULL(@iSourceStreamID,S1.I_Stream_ID))  
 and SD.S_Student_ID = ISNULL(@sStudentID,SD.S_Student_ID)  
 and SPHH.IsFinancialApproved='true' and SPHH.IsAcademicApproved='true'  
        AND (  
            CONCAT(COALESCE(SD.S_First_Name + ' ', ''), COALESCE(SD.S_Middle_Name + ' ', ''), COALESCE(SD.S_Last_Name, '')) LIKE '%' + @Full_Name + '%'   
            OR @Full_Name IS NULL  
        )  
        AND (SD.S_Mobile_No = ISNULL(@Mobile, SD.S_Mobile_No))  
  AND (RS.ReAdmissionStatusID=ISNULL(@ReAdmissionStageID,RS.ReAdmissionStatusID))  
  AND (SD.S_Student_ID = ISNULL(@sStudentID,SD.S_Student_ID))  
        AND (  
            @Search IS NULL   
            OR SD.S_Student_ID LIKE '%' + @Search + '%'  
            OR CONCAT(COALESCE(SD.S_First_Name + ' ', ''), COALESCE(SD.S_Middle_Name + ' ', ''), COALESCE(SD.S_Last_Name, '')) LIKE '%' + @Search + '%'  
            OR SD.S_Mobile_No LIKE '%' + @Search + '%'  
            OR C.S_Class_Name LIKE '%' + @Search + '%'  
            OR S.S_Section_Name LIKE '%' + @Search + '%'  
            OR SG.S_School_Group_Name LIKE '%' + @Search + '%'  
            OR S1.S_Stream LIKE '%' + @Search + '%'  
            OR RS.ReAdmissionStatusDesc LIKE '%' + @Search + '%'  
        )  
)  
SELECT @FilteredRecords = COUNT(*) FROM CountedRecords;  
  
  
   -- end  
  
  
  
 SELECT DISTINCT  
 SPHH.I_Student_Promotion_History_Header_ID as StudentPromotionHistoryHeaderID,  
 SD.S_Student_ID StudentID,  
 SPHH.I_Student_DetailID as StudentDetailID,  
 SD.I_Enquiry_Regn_ID EnquiryRegnID,  
 CONCAT(COALESCE(SD.S_First_Name+' ', ''), COALESCE(SD.S_Middle_Name+' ', ''), COALESCE(SD.S_Last_Name, '')) FullName,  
 SD.S_Mobile_No as MobileNo,  
 SASM.I_School_Session_ID as SourceSessionID,  
 SASM.S_Label as SourceSession,  
 SG.I_School_Group_ID as SourceSchoolGroupID,  
 SG.S_School_Group_Name as SourceSchoolGroup,  
 C.I_Class_ID as SourceClassID,  
 C.S_Class_Name as SourceClass,  
 S.I_Section_ID as SourceSectionID,  
 S.S_Section_Name as SourceSectionName,  
 S1.I_Stream_ID as SourceStreamID,  
 S1.S_Stream as SourceStream,  
  
 SASMD.I_School_Session_ID as DestinationSessionID,  
 SASMD.S_Label as DestinationSession,  
 SGD.I_School_Group_ID as DestinationSchoolGroupID,  
 SGD.S_School_Group_Name as DestinationSchoolGroup,  
 CD.I_Class_ID as DestinationClassID,  
 CD.S_Class_Name as DestinationClass,  
 SDes.I_Section_ID as DestinationSectionID,  
 SDes.S_Section_Name as DestinationSectionName,  
 SDest.I_Stream_ID as DestinationStreamID,  
 SDest.S_Stream as DestinationStream,  
 CASE WHEN (RS.ReAdmissionStatusDesc like '%Approved%' OR  RS.ReAdmissionStatusDesc like '%Fee%') AND SPHH.WillDemoted ='true' THEN RS.ReAdmissionStatusDesc +' to Demote'  
  WHEN RS.ReAdmissionStatusDesc like '%Promoted%' OR RS.ReAdmissionStatusDesc like '%Demoted%' AND (SPHH.IsPromoted = 'true' OR SPHH.IsDemoted = 'true') THEN RS.ReAdmissionStatusDesc + ' to '+CD.S_Class_Name  
 ELSE RS.ReAdmissionStatusDesc +' to Promote'  
 END ReAdmissionStatusDesc,  
 ISNULL(SPHH.IsFinancialApproved,'false') IsFinancialApproved,  
 ISNULL(SPHH.IsAcademicApproved,'false')IsAcademicApproved,  
 ISNULL(SPHH.IsFeeMapped,'false') IsFeeMapped,  
 ISNULL(SPHH.IsPromoted,'false') IsPromoted,  
 ISNULL(SPHH.IsDemoted,'false') IsDemoted,  
 ISNULL(SPHH.WillDemoted,'false') WillDemoted,  
 ISNULL(SPHH.FeeStructureID,0) FeeStructureID,  
 @TotalRecords as TotalRecords,  
 @FilteredRecords as FilteredRecords  
  
  
    FROM T_ERP_Student_Promotion_History_Header AS SPHH  
    INNER JOIN T_Student_Detail AS SD ON SPHH.I_Student_DetailID = SD.I_Student_Detail_ID  
    INNER JOIN T_Class AS C ON SPHH.I_Source_Class_ID = C.I_Class_ID  
    INNER JOIN T_Section AS S ON SPHH.I_Source_SectionID = S.I_Section_ID  
    INNER JOIN T_School_Academic_Session_Master AS SASM ON SPHH.I_Source_Academic_Session = SASM.I_School_Session_ID  
    INNER JOIN T_School_Group AS SG ON SPHH.I_Source_School_Group_ID = SG.I_School_Group_ID  
    LEFT JOIN T_Stream AS S1 ON SPHH.I_Source_Stream_ID = S1.I_Stream_ID  
  
 INNER JOIN T_Class AS CD ON SPHH.I_Destination_Class_ID = CD.I_Class_ID  
    INNER JOIN T_Section AS SDes ON SPHH.I_Destination_SectionID = SDes.I_Section_ID  
    INNER JOIN T_School_Academic_Session_Master AS SASMD ON SPHH.I_Destination_Academic_Session = SASMD.I_School_Session_ID  
    INNER JOIN T_School_Group AS SGD ON SPHH.I_Destination_School_Group_ID = SGD.I_School_Group_ID  
    LEFT JOIN T_Stream AS SDest ON SPHH.I_Destination_Stream_ID = SDest.I_Stream_ID  
    LEFT JOIN #ReAdmissionStatus AS RS ON RS.ReAdmissionStatusID =   
        CASE   
            WHEN SPHH.ispromoted IS NULL AND SPHH.IsDemoted IS NULL  AND SPHH.isfeemapped='true' THEN 2  
            WHEN SPHH.ispromoted IS NULL AND SPHH.isfeemapped IS NULL THEN 1  
            WHEN SPHH.isfeemapped='true' AND SPHH.IsPromoted= 'true' THEN 3  
   WHEN SPHH.isfeemapped='true' AND SPHH.IsDemoted= 'true' THEN 4  
        END  
    WHERE SPHH.I_Source_Academic_Session = @iSourceSessionID
	and  SPHH.I_Source_Batch_ID IS NOT NULL
 and C.I_Class_ID= ISNULL(@iSourceClassID,C.I_Class_ID)   
 and SG.I_School_Group_ID=ISNULL(@iSourceSchoolGroupID,SG.I_School_Group_ID)  
 and(@iSourceStreamID IS NULL OR S1.I_Stream_ID=ISNULL(@iSourceStreamID,S1.I_Stream_ID))  
 and SD.S_Student_ID = ISNULL(@sStudentID,SD.S_Student_ID)  
  and SPHH.IsFinancialApproved='true' and SPHH.IsAcademicApproved='true'  
        AND (  
            CONCAT(COALESCE(SD.S_First_Name + ' ', ''), COALESCE(SD.S_Middle_Name + ' ', ''), COALESCE(SD.S_Last_Name, '')) LIKE '%' + @Full_Name + '%'   
            OR @Full_Name IS NULL  
        )  
        AND (SD.S_Mobile_No = ISNULL(@Mobile, SD.S_Mobile_No))  
  AND (RS.ReAdmissionStatusID=ISNULL(@ReAdmissionStageID,RS.ReAdmissionStatusID))  
  AND (SD.S_Student_ID = ISNULL(@sStudentID,SD.S_Student_ID))  
        AND (  
            @Search IS NULL   
            OR SD.S_Student_ID LIKE '%' + @Search + '%'  
            OR CONCAT(COALESCE(SD.S_First_Name + ' ', ''), COALESCE(SD.S_Middle_Name + ' ', ''), COALESCE(SD.S_Last_Name, '')) LIKE '%' + @Search + '%'  
            OR SD.S_Mobile_No LIKE '%' + @Search + '%'  
            OR C.S_Class_Name LIKE '%' + @Search + '%'  
            OR S.S_Section_Name LIKE '%' + @Search + '%'  
            OR SG.S_School_Group_Name LIKE '%' + @Search + '%'  
            OR S1.S_Stream LIKE '%' + @Search + '%'  
            OR RS.ReAdmissionStatusDesc LIKE '%' + @Search + '%'  
        )  
        
          
END   

