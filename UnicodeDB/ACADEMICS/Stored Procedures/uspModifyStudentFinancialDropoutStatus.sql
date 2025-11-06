--MODIFIED STORED PROCEDURE FOR FINANCIAL DROPOUT (BRANDWISE)    
CREATE PROCEDURE [ACADEMICS].[uspModifyStudentFinancialDropoutStatus]         
(            
 @iBrandID int = NULL    
)            
AS            
            
BEGIN TRY            
BEGIN TRAN T1            
            
 SET NOCOUNT ON;            
            
 Declare @I_Process_ID_Max Int            
 Declare @Comments Varchar(2000)            
 Declare @Center_Name Varchar(500)            
 Declare @Student_Name Varchar(500)            
            
 DECLARE @iSelectedCenterID INT            
 DECLARE @iStudentID INT            
 DECLARE @iAllowableNonPaymentDays INT            
 DECLARE @iNoOfRelaxedInstallments INT                 
 DECLARE @cFinancialDropout CHAR(1)            
 DECLARE @dDate DATETIME            
 DECLARE @iInvoiceCount INT              
 DECLARE @iDropoutInvoiceCount INT         
----------------------        
DECLARE @min INT            
DECLARE @max INT            
DECLARE @iInvoiceHeaderId INT            
DECLARE @sIsDropoutInvoice CHAR(1)        
DECLARE @sIsReactivationFeesPaid VARCHAR(10)            
DECLARE @TEMPTABLE TABLE        
(ROWID INT IDENTITY(1,1)        
,I_Invoice_Header_Id INT        
,S_Is_Dropout_Invoice CHAR(1)        
,S_Is_Reactivation_Fees_Paid VARCHAR(10)        
)            
         
----------------------             
            
 DECLARE @iPreviousCenterID INT            
 SET @iPreviousCenterID=0            
             
 SET @dDate=CAST(SUBSTRING(CAST(GETDATE() AS VARCHAR),1,11) as datetime)            
            
 DECLARE  @InvoiceWiseDropoutTable TABLE            
      (              
       I_Student_Detail_ID INT              
      ,I_Center_Id INT              
      ,I_Invoice_Header_Id INT              
      ,S_Is_Dropout_Invoice CHAR(1)         
   ,S_Is_Reactivation_Fees_Paid VARCHAR(10)               
      )              
            
 DECLARE @tmpDropout TABLE            
 (            
  centerID INT,            
  centerHierarchyDetailID INT,            
  studentID INT,            
  studentCode VARCHAR(500),            
  studentFirstName VARCHAR(50),            
  studentMiddleName VARCHAR(50),            
  studentLastName VARCHAR(50)            
 )            
            
 Declare @S_Batch_Process_Name VARCHAR(500)            
             
 SET @S_Batch_Process_Name='STUDENT_FINANCIAL_DROPOUT'    
            
 Declare @I_Batch_Process_ID Int            
 Select @I_Batch_Process_ID=I_Batch_Process_ID From dbo.T_Batch_Master WITH (NOLOCK) Where S_Batch_Process_Name=@S_Batch_Process_Name And I_Status=1            
            
 Select @I_Process_ID_Max=ISNULL(Max(I_Process_ID),0)+1 From dbo.T_Batch_Log WITH (NOLOCK) Where S_Batch_Process_Name=@S_Batch_Process_Name            
            
 SET @cFinancialDropout = ''            
 SET @iAllowableNonPaymentDays = 0            
            
 DECLARE DROPOUT_CURSOR CURSOR FOR            
 SELECT SCD.I_Student_Detail_ID, SCD.I_Centre_Id            
 FROM dbo.T_Student_Center_Detail SCD WITH (NOLOCK)            
 INNER JOIN dbo.T_Centre_Master CM WITH (NOLOCK) ON SCD.I_Centre_Id = CM.I_Centre_Id            
 INNER JOIN [T_Brand_Center_Details] BCD WITH (NOLOCK) ON BCD.I_Centre_Id =CM.I_Centre_Id            
 WHERE BCD.I_Brand_Id= ISNULL(@iBrandID,BCD.I_Brand_Id)    
 --AND SCD.I_Status = 1            
 AND @dDate>= ISNULL(SCD.Dt_Valid_From, @dDate)            
 AND @dDate <= ISNULL(SCD.Dt_Valid_To, @dDate)            
 ORDER BY SCD.I_Centre_Id            
            
 OPEN DROPOUT_CURSOR            
 FETCH NEXT FROM DROPOUT_CURSOR INTO @iStudentID, @iSelectedCenterID            
            
 WHILE @@FETCH_STATUS = 0                
 BEGIN              
              
  IF(@iPreviousCenterID<>@iSelectedCenterID)            
  BEGIN            
   SELECT @cFinancialDropout=ISNULL(S_CONFIG_VALUE,'') FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iSelectedCenterID,'ACADS_CHECK_FINANCIAL_DROPOUT_YN')            
   SELECT @iAllowableNonPaymentDays=ISNULL(S_CONFIG_VALUE,0) FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iSelectedCenterID,'LIMIT_NON_PAYMENT_FEE_DAYS')            
   SELECT @iNoOfRelaxedInstallments = ISNULL(S_CONFIG_VALUE,3) FROM [dbo].[ufnPopulateCenterConfigDetailsBatch](@iSelectedCenterID,'CENTER_NO_OF_INSTALLMENT_RELAXED')              
  END            
              
  IF @cFinancialDropout = 'Y'              
  BEGIN                   
      ------------------------------------------------------------              
                     
      INSERT INTO @InvoiceWiseDropoutTable              
      SELECT * FROM [ACADEMICS].[ufnGetStudentFinancialDropoutStatusBatch](@iStudentID, @iSelectedCenterID, @iAllowableNonPaymentDays, @dDate, @iNoOfRelaxedInstallments)                   
                     
       SELECT @CENTER_NAME=S_CENTER_NAME FROM dbo.T_CENTRE_MASTER WITH (NOLOCK) WHERE I_CENTRE_ID=@iSelectedCenterID            
       SELECT @Student_Name=ISNULL(S_FIRST_NAME,'')+' '+ISNULL(S_MIDDLE_NAME,'')+' '+ISNULL(S_LAST_NAME,'') FROM dbo.T_STUDENT_DETAIL WITH (NOLOCK) WHERE I_STUDENT_DETAIL_ID = @iStudentID            
      --------------------------         
    INSERT INTO @TEMPTABLE             
    SELECT I_Invoice_Header_Id,S_Is_Dropout_Invoice,S_Is_Reactivation_Fees_Paid             
    FROM @InvoiceWiseDropoutTable      
    
    SELECT @min = MIN(ROWID), @max = MAX(ROWID) FROM @TEMPTABLE            
                
    WHILE @min <= @max             
    BEGIN        
        
    SELECT   @iInvoiceHeaderId = I_Invoice_Header_Id        
      ,@sIsDropoutInvoice = S_Is_Dropout_Invoice        
      ,@sIsReactivationFeesPaid = S_Is_Reactivation_Fees_Paid        
    FROM @TEMPTABLE WHERE ROWID = @min         
      
    SELECT I_Batch_ID INTO #temp FROM dbo.T_Invoice_Batch_Map AS TIBM
			 INNER JOIN dbo.T_Invoice_Child_Header AS TICH
			 ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
			 INNER JOIN dbo.T_Invoice_Parent AS TIP
			 ON TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
			 WHERE TICH.I_Invoice_Header_ID = @iInvoiceHeaderId       
         
          IF (@sIsDropoutInvoice = 'Y')            
          BEGIN            
                    
        IF NOT EXISTS (SELECT I_Dropout_ID FROM ACADEMICS.T_Dropout_Details WITH (NOLOCK)            
         WHERE I_Student_Detail_ID = @iStudentID            
         AND I_Center_Id = @iSelectedCenterID            
         AND I_Dropout_Type_ID = 2      
   AND I_Invoice_Header_Id = @iInvoiceHeaderId      
   )            
          BEGIN            
           
            
            
           UPDATE dbo.T_Student_Batch_Details
           SET I_Status = 0
           WHERE I_Student_ID = @iStudentID 
           AND I_Batch_ID IN 
           (
			 SELECT I_Batch_ID FROM #temp
           )          
           --UPDATE dbo.T_Student_Detail            
           --SET I_Status = 0,             
           --S_Upd_By = 'SYSTEM_BATCH',            
           --Dt_Upd_On = @dDate            
           --WHERE I_Student_Detail_ID = @iStudentID            
                     
           INSERT INTO ACADEMICS.T_Dropout_Details            
           (            
            I_Student_Detail_ID,            
            I_Center_Id,            
            I_Dropout_Type_ID,            
            I_Dropout_Status,            
            Dt_Dropout_Date,            
            Dt_Crtd_On,            
            S_Crtd_By,        
            I_Invoice_Header_Id            
           )            
           VALUES            
           (            
            @iStudentID ,            
            @iSelectedCenterID ,            
            2,            
            1,            
            @dDate ,            
            @dDate,            
            'SYSTEM_BATCH'        
            ,@iInvoiceHeaderId           
           )            
          END           
         ELSE          
          BEGIN          
          IF EXISTS ( SELECT  'TRUE'        
            FROM    ACADEMICS.T_Dropout_Details        
              WITH ( NOLOCK )        
            WHERE   I_Student_Detail_ID = @iStudentID        
              AND I_Center_Id = @iSelectedCenterID        
              AND I_Dropout_Type_ID = 2 AND [I_Dropout_Status]=0         
              AND I_Invoice_Header_Id = @iInvoiceHeaderId        
             )         
            BEGIN             
               UPDATE ACADEMICS.T_Dropout_Details          
               SET I_Dropout_Status = 1,      
    Dt_Dropout_Date = @dDate,          
                S_Upd_By = 'SYSTEM_BATCH',          
                Dt_Upd_On = @dDate          
               WHERE I_Student_Detail_ID = @iStudentID          
               AND I_Center_Id = @iSelectedCenterID          
               AND I_Dropout_Type_ID = 2        
               AND  I_Invoice_Header_Id = @iInvoiceHeaderId        
            END        
          END           
                
         Set @Comments=@Center_Name+'('+cast(@iSelectedCenterID as varchar)+')> '+@Student_Name+'('+cast(@iStudentID as varchar)+') - Dropped out'       
      + ' [InvoiceHeaderId:'+CAST(@iInvoiceHeaderId AS VARCHAR)+']' +'[ReactFeeStatus:'+ @sIsReactivationFeesPaid+']'        
         EXEC uspWriteBatchProcessLog_New @I_Process_ID_Max,@S_Batch_Process_Name,@Comments,'Success',@I_Batch_Process_ID            
                
        END              
       ELSE IF (@sIsDropoutInvoice = 'N') -- ACTIVATE THE STUDENT WHO IS NOT FINANCIAL DROPOUT            
        BEGIN            
                    
         IF EXISTS (SELECT I_Dropout_ID FROM ACADEMICS.T_Dropout_Details WITH (NOLOCK)            
              WHERE I_Student_Detail_ID = @iStudentID            
              AND I_Center_Id = @iSelectedCenterID            
              AND I_Dropout_Status = 1            
              AND I_Dropout_Type_ID = 2        
              AND I_Invoice_Header_Id = @iInvoiceHeaderId        
            )            
             BEGIN            
               UPDATE ACADEMICS.T_Dropout_Details            
               SET I_Dropout_Status = 0,            
                S_Upd_By = 'SYSTEM_BATCH',            
                Dt_Upd_On = @dDate            
               WHERE I_Student_Detail_ID = @iStudentID            
               AND I_Center_Id = @iSelectedCenterID            
               AND I_Dropout_Type_ID = 2            
               AND I_Dropout_Status = 1         
               AND I_Invoice_Header_Id = @iInvoiceHeaderId           
                     
             END            
                    
             Set @Comments=@Center_Name+'('+cast(@iSelectedCenterID as varchar)+')> '+@Student_Name+'('+cast(@iStudentID as varchar)+') - Activated'            
       + ' [InvoiceHeaderId:'+CAST(@iInvoiceHeaderId AS VARCHAR)+']' +'[ReactFeeStatus:'+ @sIsReactivationFeesPaid+']'        
             EXEC uspWriteBatchProcessLog_New @I_Process_ID_Max,@S_Batch_Process_Name,@Comments,'Success',@I_Batch_Process_ID            
        
        
         END         
     SET @min = @min + 1        
    END        
    -------------------------------------------------        
    --- updating the student status in dbo.T_Student_Detail         
        
    IF EXISTS(SELECT 'TRUE' FROM @InvoiceWiseDropoutTable WHERE S_Is_Dropout_Invoice = 'Y')        
             BEGIN  
				UPDATE dbo.T_Student_Batch_Details
					   SET I_Status = 0
					   WHERE I_Student_ID = @iStudentID 
					   AND I_Batch_ID IN 
					   (
						 SELECT I_Batch_ID FROM #temp
					   )        
                --  UPDATE dbo.T_Student_Detail            
                --SET I_Status = 0,             
                --S_Upd_By = 'SYSTEM_BATCH',            
                --Dt_Upd_On = @dDate            
                --WHERE I_Student_Detail_ID = @iStudentID         
             END        
    ELSE        
       BEGIN        
            IF NOT EXISTS (SELECT 'TRUE' FROM ACADEMICS.T_Dropout_Details WITH (NOLOCK)              
               WHERE I_Student_Detail_ID = @iStudentID              
               AND I_Center_Id = @iSelectedCenterID            
               AND I_Dropout_Status = 1)              
            BEGIN  
				UPDATE dbo.T_Student_Batch_Details
					   SET I_Status = 1
					   WHERE I_Student_ID = @iStudentID 
					   AND I_Batch_ID IN 
					   (
						 SELECT I_Batch_ID FROM #temp
					   )              
              --UPDATE dbo.T_Student_Detail              
              --SET I_Status = 1,               
              --S_Upd_By = 'SYSTEM_BATCH',              
              --Dt_Upd_On = @dDate              
              --WHERE I_Student_Detail_ID = @iStudentID              
            END              
       END        
               
     ---end of updating the student status in dbo.T_Student_Detail         
    -------------------------------------------------        
    DELETE @InvoiceWiseDropoutTable        
        
    DELETE @TEMPTABLE            
    ---------------------------------------------------            
   END -- end of  @cFinancialDropout = 'Y'             
              
  SET @iPreviousCenterID=@iSelectedCenterID            
         
  FETCH NEXT FROM DROPOUT_CURSOR INTO @iStudentID, @iSelectedCenterID            
 END             
            
 CLOSE DROPOUT_CURSOR            
 DEALLOCATE DROPOUT_CURSOR            
             
 --SELECT * FROM @tmpDropout            
 EXEC uspUpdateBatchProcessesDataBrandWise @S_Batch_Process_Name,'Success'            
            
COMMIT TRAN T1            
END TRY            
            
BEGIN CATCH            
--Error occurred:            
 ROLLBACK  TRAN T1            
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT,@Description VARCHAR(4000)            
 Declare @S_Batch_Process_Name_ERROR VARCHAR(500)            
            
 SELECT @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()                  
     
 SET @S_Batch_Process_Name_ERROR='STUDENT_FINANCIAL_DROPOUT'    
            
 SET @Description='Error : '+CAST(@ErrMsg AS VARCHAR)            
 EXEC uspWriteBatchProcessLog_New 2000,@S_Batch_Process_Name_ERROR,@Description,'Faliure',2            
 EXEC uspUpdateBatchProcessesDataBrandWise @S_Batch_Process_Name_ERROR,'Faliure'            
-- RAISERROR(@ErrMsg, @ErrSeverity, 1)            
END CATCH
