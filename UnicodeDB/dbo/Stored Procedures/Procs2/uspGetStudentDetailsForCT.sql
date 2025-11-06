--select * From t_student_detail where s_first_name like 'ankit'      
      
CREATE PROCEDURE [dbo].[uspGetStudentDetailsForCT]    
(              
 -- Add the parameters for the stored procedure here              
  @iStudentDetailId int,              
  @sStudentNo NVARCHAR(MAX) = NULL              
)              
AS              
BEGIN              
               
               
 DECLARE              
  @iCenterId int,              
  @iEnquiryRegnId int              
  --@iStudentDetailId int              
               
  IF (@iStudentDetailId IS NULL)              
   SELECT @iStudentDetailId = I_Student_Detail_ID FROM dbo.T_Student_Detail  WHERE S_Student_ID = @sStudentNo --AND I_Status<>0              
              
                
   --Table[0] Student Details              
                 
   SELECT TSD.* FROM dbo.T_Student_Detail TSD WHERE TSD.I_Student_Detail_ID=@iStudentDetailId --AND TSD.I_Status<>0              
                 
   --SET @iStudentDetailId=(SELECT I_Student_Detail_ID FROM dbo.T_Student_Detail  WHERE I_Student_ID=@iStudentID AND I_Status<>0)              
                 
   SET @iEnquiryRegnId=(SELECT TSD.I_Enquiry_Regn_ID FROM dbo.T_Student_Detail TSD WHERE TSD.I_Student_Detail_ID=@iStudentDetailId) -- AND TSD.I_Status<>0)              
                 
   --Table[1] Enquiry Details              
                 
   SELECT ERD.* FROM dbo.T_Enquiry_Regn_Detail ERD,dbo.T_Student_Detail TSD WHERE ERD.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID AND ERD.I_Enquiry_Regn_ID=@iEnquiryRegnId               
                 
   --Table[2] Center Details              
                 
   SET @iCenterId=(SELECT  SCD.I_Centre_Id  FROM dbo.T_Student_Center_Detail SCD               
   WHERE SCD.I_Student_Detail_ID=@iStudentDetailId               
   AND GETDATE() >= ISNULL(GETDATE(),SCD.Dt_Valid_From)              
   AND GETDATE() <= ISNULL(GETDATE(),SCD.Dt_Valid_To)              
   AND SCD.I_Status <> 0)              
                 
   SELECT TCM.I_Centre_ID, TCM.S_Center_Code, TCM.S_Center_Name, TBM.S_Brand_Name              
   FROM dbo.T_Centre_Master TCM              
   INNER JOIN dbo.T_Brand_Center_Details TBCD ON TBCD.I_Centre_Id = TCM.I_Centre_Id              
   INNER JOIN dbo.T_Brand_Master TBM ON TBM.I_Brand_ID = TBCD.I_Brand_ID              
   WHERE TCM.I_Centre_ID=@iCenterId AND TCM.I_Status<>0              
                 
   --Table[3] StudentCourse Details              
DECLARE @duration INT            
SELECT @duration = DATEDIFF(MM,Dt_Course_Start_Date,Dt_Course_Expected_End_Date)               
FROM dbo.T_Student_Course_Detail               
WHERE I_Student_Detail_Id = @iStudentDetailId             
                 
   SELECT DISTINCT               
   CM.I_Course_ID,    
   CM.S_Course_Code,              
   CM.S_Course_Name ,              
   CM.S_Course_Desc,              
   CM.C_IsCareerCourse,      
   ISNULL([CM].[I_Min_Week_For_Placement],0) AS [I_Min_Week_For_Placement],    
   ISNULL([CM].[I_Max_Week_For_Placement],1000) AS [I_Max_Week_For_Placement],            
   CFM.S_CourseFamily_Name,              
   CFM.I_CourseFamily_ID, 
   CFM.I_IsMTech,             
   0 AS I_TimeSlot_ID,              
   '' AS S_TimeSlot_Code,               
   '' AS S_TimeSlot_Desc,              
   TSCD.Dt_Course_Start_Date,              
   TSCD.Dt_Course_Actual_End_Date,              
   TSCD.Dt_Course_Expected_End_Date,              
   TSCD.I_Is_Completed,              
   TCCDF.I_Course_Fee_Plan_ID,                 
   --TCDM.N_Course_Duration,             
   DATEDIFF(MM,TSCD.Dt_Course_Start_Date,TSCD.Dt_Course_Expected_End_Date) as N_Course_Duration,            
   ( SELECT COUNT(B.I_Session_ID)               
    FROM dbo.T_Session_Module_Map A              
    INNER JOIN dbo.T_Session_Master B              
    ON A.I_Session_ID = B.I_Session_ID              
    INNER JOIN dbo.T_Module_Term_Map C              
    ON A.I_Module_ID = C.I_Module_ID              
    INNER JOIN dbo.T_Term_Course_Map D                 
    ON C.I_Term_ID = D.I_Term_ID              
    AND D.I_Course_ID = CM.I_Course_ID              
    AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())              
    AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())              
    AND A.I_Status <> 0              
    AND B.I_Status <> 0              
    AND C.I_Status <> 0              
    AND D.I_Status <> 0              
     ) AS I_No_Of_Session,              
   ( SELECT COUNT(*) FROM dbo.T_Student_Attendance_Details TSAD               
    WHERE TSAD.I_Student_Detail_ID = @iStudentDetailId              
    AND TSAD.I_Course_ID = CM.I_Course_ID AND I_Has_Attended = 1 ) AS Session_Attended,              
    ((SELECT DATEDIFF(dd ,               
        (select min(Dt_Attendance_Date) from dbo.T_Student_Attendance_Details TSAD               
        WHERE TSAD.I_Student_Detail_ID = @iStudentDetailId              
        AND TSAD.I_Course_ID = CM.I_Course_ID AND I_Has_Attended = 1 ) ,               
        (select MAX(Dt_Attendance_Date) from dbo.T_Student_Attendance_Details TSAD               
        WHERE TSAD.I_Student_Detail_ID = @iStudentDetailId              
        AND TSAD.I_Course_ID = CM.I_Course_ID AND I_Has_Attended = 1)              
    )/25)              
   ) AS Duration_Completed    
   ,TSCD.I_Batch_ID               
   FROM               
   dbo.T_Course_Master CM,dbo.T_CourseFamily_Master CFM,dbo.T_Course_Delivery_Map TCDM,              
   (SELECT I_Course_ID,I_TimeSlot_ID,Dt_Course_Start_Date,              
   Dt_Course_Actual_End_Date,Dt_Course_Expected_End_Date,I_Is_Completed,I_Course_Center_Delivery_ID , I_Batch_ID             
   FROM dbo.T_Student_Course_Detail    
   WHERE               
   I_Student_Detail_ID=@iStudentDetailId AND               
   I_Status<>0 AND                
   GETDATE() >= ISNULL(GETDATE(),Dt_Valid_From)AND GETDATE() <= ISNULL(GETDATE(),Dt_Valid_To)) TSCD,              
   dbo.T_Course_Center_Delivery_FeePlan TCCDF         
   WHERE               
   TSCD.I_Course_ID=CM.I_Course_ID               
   --AND TSCD.I_TimeSlot_ID=CTS.I_TimeSlot_ID               
   AND CFM.I_CourseFamily_ID = CM.I_CourseFamily_ID              
   AND TSCD.I_Course_Center_Delivery_ID = TCCDF.I_Course_Center_Delivery_ID              
   AND TCDM.I_Course_ID = CM.I_Course_ID               
   AND TCDM.I_Course_Delivery_ID = TCCDF.I_Course_Delivery_ID             
   --AND TCDM.I_Status <> 0 AND TCCDF.I_Status <> 0              
   --AND GETDATE() >= ISNULL(GETDATE(),TCCDF.Dt_Valid_From)AND GETDATE() <= ISNULL(GETDATE(),TCCDF.Dt_Valid_To)              
                 
 SELECT [TIP].[I_Student_Detail_ID],[TIP].[I_Invoice_Header_ID],[TIP].[N_Invoice_Amount],    
  [TICH].[I_Course_ID],[TICH].[N_Amount]    
 FROM [dbo].[T_Invoice_Parent] AS TIP    
 INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH    
 ON [TIP].[I_Invoice_Header_ID] = [TICH].[I_Invoice_Header_ID]    
 WHERE [TIP].[I_Student_Detail_ID] = @iStudentDetailID  AND TIP.I_Status <> 0  
END

