CREATE PROCEDURE [dbo].[uspUpdateInstallmentDates] --8755,526             
(              
 @iStudentDetailID INT,       
 @iPreviousInvoiceHeaderID INT,             
 @iNextInvoiceHeaderID INT,            
 @iPreviousCourseID INT ,          
 @iNextCourseID INT,          
 @iBridgeID INT,           
 @sUser VARCHAR(500)            
)    
AS    
BEGIN TRY    
    
            
DECLARE @dtFirstInstallmentDate DATETIME            
DECLARE @dtSecondInstallmentDate DATETIME      
     
---FETCHES THE LINKED INVOICE HEADER ID USING COURSE ID      
SET @dtFirstInstallmentDate = (            
SELECT DISTINCT ICD.[Dt_Installment_Date] FROM [T_Invoice_Child_Detail] ICD WITH(nolock)            
INNER JOIN [T_Invoice_Child_Header] ICH WITH(nolock)            
ON ICD.[I_Invoice_Child_Header_ID] = ICH.[I_Invoice_Child_Header_ID]            
WHERE ICH.[I_Invoice_Header_ID]=@iNextInvoiceHeaderID           
AND ICD.[I_Installment_No]=1            
)              
    
---LOGIC FOR SECOND INSTALLMENT DATE---------------------            
SET @dtSecondInstallmentDate = DATEADD(MONTH,1,@dtFirstInstallmentDate)            
---SETS THE DATE AS LAST DAY OF NEXT MONTH            
SET @dtSecondInstallmentDate= DateAdd(day, -1, DateAdd(month, DateDiff(month, 0, @dtSecondInstallmentDate)+1, 0))            
---SETS THE DATE AS FIRST DAY OF THE FOLLOWING MONTH ----           
SET @dtSecondInstallmentDate=DATEADD(DAY,1,@dtSecondInstallmentDate)            
            
---UPDATES DT_INSTALLMENT_DATE OF TABLE T_INVOICE_CHILD_DETAILS                      
UPDATE [T_Invoice_Child_Detail]            
SET [Dt_Installment_Date]=@dtSecondInstallmentDate            
FROM [T_Invoice_Child_Detail] ICD WITH(nolock)            
INNER JOIN [T_Invoice_Child_Header] ICH WITH(nolock)            
ON ICD.[I_Invoice_Child_Header_ID] = ICH.[I_Invoice_Child_Header_ID]            
WHERE ICH.[I_Invoice_Header_ID]=@iNextInvoiceHeaderID           
AND ICD.[I_Installment_No]=2            
              
---UPDATES THE REMAINING INSTALLMENT DATES(OTHER THAN FIRST AND SECOND)             
              
UPDATE [T_Invoice_Child_Detail]            
SET [Dt_Installment_Date] = DATEADD(MONTH,[I_Installment_No]-2,@dtSecondInstallmentDate)            
FROM [T_Invoice_Child_Detail] ICD WITH(nolock)            
INNER JOIN [T_Invoice_Child_Header] ICH WITH(nolock)            
ON ICD.[I_Invoice_Child_Header_ID] = ICH.[I_Invoice_Child_Header_ID]            
WHERE ICH.[I_Invoice_Header_ID]=@iNextInvoiceHeaderID           
AND ICD.[I_Installment_No] > 2            
     
---INSERT INTO STUDENT UPGRADE DETAIL TABLE            
IF NOT EXISTS    
(    
SELECT 'TRUE' FROM dbo.T_Student_Upgrade_Detail    
WHERE I_Student_Detail_Id = @iStudentDetailID    
AND I_Previous_Invoice_Header_ID = @iPreviousInvoiceHeaderID     
AND I_Upgrade_Invoice_Header_ID = @iNextInvoiceHeaderID    
AND I_Bridge_ID = @iBridgeID    
AND I_Course_ID = @iPreviousCourseID    
)    
BEGIN    
 INSERT INTO dbo.T_Student_Upgrade_Detail(I_Student_Detail_Id    
 ,I_Previous_Invoice_Header_ID    
 ,I_Upgrade_Invoice_Header_ID    
 ,I_Bridge_ID    
 ,I_Course_ID    
 ,I_Status    
 ,S_Crtd_By    
 ,Dt_Crtd_On    
 )    
 VALUES    
 (    
 @iStudentDetailID    
 ,@iPreviousInvoiceHeaderID     
 ,@iNextInvoiceHeaderID    
 ,@iBridgeID    
 ,@iPreviousCourseID    
 ,1    
 ,@sUser    
 ,GETDATE()    
 )    
END    
ELSE    
BEGIN    
 UPDATE dbo.T_Student_Upgrade_Detail    
 SET  I_Upgrade_Invoice_Header_ID = @iNextInvoiceHeaderID    
  ,S_Crtd_By = @sUser    
  ,Dt_Upd_On = GETDATE()    
 WHERE I_Student_Detail_Id = @iStudentDetailID    
 AND I_Previous_Invoice_Header_ID = @iPreviousInvoiceHeaderID     
 AND I_Bridge_ID = @iBridgeID    
 AND I_Course_ID = @iPreviousCourseID    
END    
    
INSERT INTO dbo.T_Student_Upgrade_Detail(    
  I_Student_Detail_Id    
 ,I_Previous_Invoice_Header_ID    
 ,I_Upgrade_Invoice_Header_ID    
 ,I_Bridge_ID    
 ,I_Course_ID    
 ,I_Status    
 ,S_Crtd_By    
 ,Dt_Crtd_On    
 )    
 VALUES    
 (    
  @iStudentDetailID    
 ,@iNextInvoiceHeaderID    
 ,NULL    
 ,@iBridgeID    
 ,@iNextCourseID    
 ,1    
,@sUser    
 ,GETDATE()    
 )    
              
END TRY                      
BEGIN CATCH              
 --Error occurred:                
              
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int              
 SELECT @ErrMsg = ERROR_MESSAGE(),              
   @ErrSeverity = ERROR_SEVERITY()              
              
 RAISERROR(@ErrMsg, @ErrSeverity, 1)              
END CATCH    
   
  
  
      
  
----------------------------------------------------------------------------------------------------------------------------------------  
--  
--GO  
--/****** Object:  StoredProcedure [dbo].[uspGetCourseDetailsForUpgrade]    Script Date: 03/20/2009 15:18:49 ******/  
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uspGetCourseDetailsForUpgrade]') AND type in (N'P', N'PC'))  
--DROP PROCEDURE [dbo].[uspGetCourseDetailsForUpgrade]  
--  
--GO  
--/****** Object:  StoredProcedure [dbo].[uspGetCourseDetailsForUpgrade]    Script Date: 03/20/2009 15:18:54 ******/  
--SET ANSI_NULLS ON  
--GO  
--SET QUOTED_IDENTIFIER ON  
--GO  
--    
--CREATE PROCEDURE [dbo].[uspGetCourseDetailsForUpgrade] --527     
--(    
-- -- Add the parameters for the stored procedure here    
-- @iCourseID int    
--)    
--AS    
--BEGIN    
-- -- SET NOCOUNT ON added to prevent extra result sets from    
-- -- interfering with SELECT statements.    
-- SET NOCOUNT OFF    
--     
-- DECLARE @iGradingPatternID int    
--    
-- SELECT     
-- @iGradingPatternID = CM.I_Grading_Pattern_ID    
-- FROM dbo.T_COURSE_MASTER CM     
-- WHERE CM.I_Course_ID = @iCourseID    
-- AND CM.I_Status=1    
--     
--    -- Course Basic Details    
--    -- Table[0]    
-- SELECT     
-- CM.I_Course_ID,    
-- CM.I_CourseFamily_ID,    
-- CM.I_Brand_ID,    
-- CM.S_Course_Code,    
-- CM.S_Course_Name,    
-- CM.I_Grading_Pattern_ID,    
-- CM.S_Course_Desc,    
-- CM.I_Certificate_ID,    
-- CM.S_Crtd_By,    
-- BM.S_Brand_Code,    
-- BM.S_Brand_Name,    
-- ( SELECT COUNT(B.I_Session_ID)     
--    FROM dbo.T_Session_Module_Map A    
--    INNER JOIN dbo.T_Session_Master B    
--    ON A.I_Session_ID = B.I_Session_ID    
--    INNER JOIN dbo.T_Module_Term_Map C    
--    ON A.I_Module_ID = C.I_Module_ID    
--    INNER JOIN dbo.T_Term_Course_Map D       
--    ON C.I_Term_ID = D.I_Term_ID    
--    AND D.I_Course_ID = CM.I_Course_ID    
--    AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())    
--    AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())    
--    AND A.I_Status <> 0    
--    AND B.I_Status <> 0    
--    AND C.I_Status <> 0    
--    AND D.I_Status <> 0) AS I_No_Of_Session,    
-- CM.S_Upd_By,    
-- CM.C_AptitudeTestReqd,    
-- CM.C_IsCareerCourse,    
-- CM.C_IsShortTermCourse,    
-- CM.C_IsPlacementApplicable,    
-- CM.Dt_Crtd_On,    
-- CM.Dt_Upd_On,    
-- CM.I_Status,    
-- CM.I_Is_Editable,     
-- CR.S_Certificate_Name,    
-- CF.S_CourseFamily_Name,    
-- ISNULL(CM.I_Is_Upgrade_Course,0) AS I_Is_Upgrade_Course   
-- FROM dbo.T_Course_Master CM    
--    LEFT OUTER JOIN dbo.T_Certificate_Master CR    
-- ON CM.I_Certificate_ID = CR.I_Certificate_ID    
-- LEFT OUTER JOIN dbo.T_CourseFamily_Master CF     
-- ON CM.I_CourseFamily_ID = CF.I_courseFamily_ID    
-- INNER JOIN dbo.T_Brand_Master BM    
-- ON CM.I_Brand_ID = BM.I_Brand_ID    
-- WHERE CM.I_Course_ID = @iCourseID    
-- AND CM.I_Status=1    
-- AND BM.I_Status <> 0    
--  
--  
--    
--END    
--  
-----------------------------------------------------------------------------------------------------------------------------------------------  
--
