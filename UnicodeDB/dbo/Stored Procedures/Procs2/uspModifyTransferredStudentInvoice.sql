CREATE PROCEDURE [dbo].[uspModifyTransferredStudentInvoice] --21341,0,0.0,8819,11,12,'381516'    
    (
      @iInvoiceHeaderId INT ,
      @iInstallment INT ,
      @nNewInvoiceAmount NUMERIC(18, 10) ,
      @iStudentDetailId INT ,
      @iSourceCenterId INT ,
      @iDestinationCenterId INT ,
      @sUser NVARCHAR(max)
    )
AS
    BEGIN                            
----------------------------------------------------------                            
-------     INVOICE PARENT    ------                            
--        DECLARE @InvoiceParentTable TABLE      
--            (      
--              I_Invoice_Header_ID INT ,      
--              N_Invoice_Amount NUMERIC(18, 10) ,      
--              N_Tax_Amount NUMERIC(18, 10) ,      
--              N_Ratio NUMERIC(18, 10)      
--            )                            
--        INSERT  INTO @InvoiceParentTable      
--                SELECT  I_Invoice_Header_ID ,      
--                        N_Invoice_Amount ,      
--                        N_Tax_Amount ,      
--                        ( N_Tax_Amount / dbo.fnISZERO(N_Invoice_Amount) )      
--                FROM    T_Invoice_Parent      
--                WHERE   I_Invoice_Header_Id = @iInvoiceHeaderId                            
                            
-----------------------------------------------------------------                            
-----------         INVOICE CHILD HEADER    -----------                            
--        DECLARE @oldInvoiceAmount NUMERIC(18, 10)                            
--        SELECT  @oldInvoiceAmount = N_Invoice_Amount      
--        FROM    @InvoiceParentTable      
--        WHERE   I_Invoice_Header_Id = @iInvoiceHeaderId                            
--        DECLARE @InvoiceChildHeaderTable TABLE      
--            (      
--              ROWID INT IDENTITY(1, 1) ,      
--              I_Invoice_Child_Header_ID INT ,      
--              I_Invoice_Header_ID INT ,      
--              I_Course_ID INT ,      
--              N_Amount NUMERIC(18, 10) ,      
--              N_Tax_Amount NUMERIC(18, 10) ,      
--              N_Ratio NUMERIC(18, 10) ,      
--              N_CourseAmount_Ratio NUMERIC(18, 10)      
--            )                            
--        INSERT  INTO @InvoiceChildHeaderTable      
--                SELECT  I_Invoice_Child_Header_ID ,      
--                        I_Invoice_Header_ID ,      
--                        I_Course_ID ,      
--                        N_Amount ,      
--                        N_Tax_Amount ,      
--                        ( N_Tax_Amount / dbo.fnISZERO(N_Amount) ) ,      
--                        ( N_Amount / dbo.fnISZERO(@oldInvoiceAmount) )      
--                FROM    T_Invoice_Child_Header      
--                WHERE   I_Invoice_Header_Id = @iInvoiceHeaderId                            
                            
--        UPDATE  @InvoiceChildHeaderTable      
--        SET     N_Amount = ( @nNewInvoiceAmount * N_CourseAmount_Ratio ) ,      
--                N_Tax_Amount = ( ( @nNewInvoiceAmount * N_CourseAmount_Ratio )      
--                                 * N_Ratio )                            
                            
                            
--        UPDATE  @InvoiceParentTable      
--        SET     N_Invoice_Amount = @nNewInvoiceAmount ,      
--                N_Tax_Amount = ( @nNewInvoiceAmount * N_Ratio )      
--        WHERE   I_Invoice_Header_Id = @iInvoiceHeaderId                            
                            
------------------------------------------------------------------------------                            
------  INVOICE CHILD DETAIL     ------------------------                            
--        DECLARE @InvoiceChildDetailTable TABLE      
--            (      
--              I_Invoice_Detail_ID INT ,      
--              I_Invoice_Child_Header_ID INT ,      
--              I_Fee_Component_ID INT ,      
--              I_Installment_No INT ,      
--              N_Amount_Due NUMERIC(18, 10)      
--            )                            
--        INSERT  INTO @InvoiceChildDetailTable      
--                SELECT  ICD.I_Invoice_Detail_ID ,      
--                        ICD.I_Invoice_Child_Header_ID ,      
-- ICD.I_Fee_Component_ID ,      
--                        ICD.I_Installment_No ,      
--                        ICD.N_Amount_Due      
--                FROM    T_Invoice_Child_Detail ICD      
--                        INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID      
--                WHERE   ICH.I_Invoice_Header_Id = @iInvoiceHeaderId                                              
------------------------------------------------------------------------------                            
---------    INVOICE TAX DETAIL    ------------------------                            
--        DECLARE @InvoiceDetailTaxTable TABLE      
--            (      
--              I_Tax_ID INT ,      
--              I_Invoice_Detail_ID INT ,      
--              N_Tax_Value NUMERIC(18, 10) ,      
--              N_Ratio NUMERIC(18, 10)      
--            )                            
--        INSERT  INTO @InvoiceDetailTaxTable      
--                SELECT  IDT.I_Tax_ID ,      
--                        IDT.I_Invoice_Detail_ID ,      
--                        IDT.N_Tax_Value ,      
--                        ( IDT.N_Tax_Value / dbo.fnISZERO(ICD.N_Amount_Due) )      
--                FROM    dbo.T_Invoice_Detail_Tax IDT      
--                        INNER JOIN T_Invoice_Child_Detail ICD ON ICD.I_Invoice_Detail_ID = IDT.I_Invoice_Detail_ID      
--                        INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID      
--                WHERE   ICH.I_Invoice_Header_Id = @iInvoiceHeaderId                            
                            
-----------------------------------------------------------------------------------------------------                            
---------  MANIPULATING TRANSFERRED STUDENT'S INVOICE   ---------------------------------                            
                            
                            
        --DECLARE @min INT                             
        --DECLARE @max INT                            
        --DECLARE @iInvoiceChildHeaderId INT                            
        --DECLARE @iMaxInstallmentNo INT                            
        --DECLARE @iInstallmentsNotZero INT                            
        --DECLARE @nCourseAmount NUMERIC(18, 10)                           
                            
                            
                            
                            
                            
        --SELECT  @min = MIN(ROWID) ,      
        --        @max = MAX(ROWID)      
        --FROM    @InvoiceChildHeaderTable                            
                            
        --WHILE @min <= @max       
        --    BEGIN                            
        --        SELECT  @iInvoiceChildHeaderId = I_Invoice_Child_Header_ID      
        --        FROM    @InvoiceChildHeaderTable      
        --        WHERE   ROWID = @min                            
                             
        --        SELECT  @nCourseAmount = N_Amount      
        --        FROM    @InvoiceChildHeaderTable      
        --        WHERE   ROWID = @min 
                 
        --        SET @iInstallmentsNotZero = 0                            
                            
        --        UPDATE  @InvoiceChildDetailTable      
        --        SET     N_Amount_Due = 0      
        --        WHERE   I_Invoice_Child_Header_ID = @iInvoiceChildHeaderId      
        --                AND I_Installment_No > @iInstallmentsNotZero                            
                            
        --        DECLARE @nInstallmentSum NUMERIC(18, 10)                            
                            
        --        SELECT  @nInstallmentSum = SUM(N_Amount_Due)      
        --        FROM    @InvoiceChildDetailTable      
        --        WHERE   I_Invoice_Child_Header_ID = @iInvoiceChildHeaderId                            
                            
        --        UPDATE  @InvoiceChildDetailTable      
        --        SET     N_Amount_Due = ( ( N_Amount_Due / dbo.fnISZERO(@nInstallmentSum) )      
        --                                 * @nCourseAmount )      
        --        WHERE   I_Invoice_Child_Header_ID = @iInvoiceChildHeaderId      
        --                AND I_Installment_No <= @iInstallmentsNotZero                            
                            
        --        UPDATE  @InvoiceDetailTaxTable      
        --        SET     N_Tax_Value = ( ICD.N_Amount_Due * IDT.N_Ratio )      
        --        FROM    @InvoiceDetailTaxTable IDT      
        --                INNER JOIN @InvoiceChildDetailTable ICD ON IDT.I_Invoice_Detail_Id = ICD.I_Invoice_Detail_Id      
        --        WHERE   ICD.I_Invoice_Child_Header_ID = @iInvoiceChildHeaderId                            
                             
                            
        --        SET @min = @min + 1                            
                            
        --    END                            
                       
        --UPDATE  T_Invoice_Parent      
        --SET     N_Invoice_Amount = IPT.N_Invoice_Amount ,      
        --        N_Tax_Amount = IPT.N_Tax_Amount      
        --FROM    T_Invoice_Parent IP      
        --        INNER JOIN @InvoiceParentTable IPT ON IP.I_Invoice_Header_Id = IPT.I_Invoice_Header_Id                            
                            
        --UPDATE  T_Invoice_Child_Header      
        --SET     N_Amount = ICHT.N_Amount ,      
        --        N_Tax_Amount = ICHT.N_Tax_Amount      
        --FROM    T_Invoice_Child_Header ICH      
        --        INNER JOIN @InvoiceChildHeaderTable ICHT ON ICH.I_Invoice_Child_Header_ID = ICHT.I_Invoice_Child_Header_ID                            
                            
        --UPDATE  T_Invoice_Child_Detail      
        --SET     N_Amount_Due = ICDT.N_Amount_Due      
        --FROM    T_Invoice_Child_Detail ICD      
        --        INNER JOIN @InvoiceChildDetailTable ICDT ON ICD.I_Invoice_Detail_ID = ICDT.I_Invoice_Detail_ID                            
                            
        --UPDATE  T_Invoice_Detail_Tax      
        --SET     N_Tax_Value = IDTT.N_Tax_Value      
        --FROM    T_Invoice_Detail_Tax IDT      
        --        INNER JOIN @InvoiceDetailTaxTable IDTT ON IDT.I_Invoice_Detail_ID = IDTT.I_Invoice_Detail_ID      
        --                                                  AND IDT.I_Tax_ID = IDTT.I_Tax_ID 
		
		CREATE TABLE #SourceBatch
		(
			ID INT IDENTITY(1,1),
			BatchID INT
		)


        IF ( @iInstallment > 0 )
            BEGIN  
                UPDATE  T_Invoice_Parent
                SET     I_Status = 2 ,
                        I_Centre_Id = @iSourceCenterId
                WHERE   I_Invoice_Header_ID = @iInvoiceHeaderId                          
            END                        
        ELSE
            BEGIN             
                UPDATE  T_Invoice_Parent
                SET     I_Status = 3
                WHERE   I_Invoice_Header_ID = @iInvoiceHeaderId                          
            END                          
        DECLARE @iStdDetailId INT                       
                          
        SELECT  @iStdDetailId = I_Student_Detail_ID
        FROM    T_Invoice_Parent
        WHERE   I_Invoice_Header_ID = @iInvoiceHeaderId                          
             
        DECLARE @iCancelledInvoiceId INT        
          
          
        SELECT TOP 1
                @iCancelledInvoiceId = I_Invoice_Header_ID
        FROM    T_Invoice_Parent
        WHERE   I_Student_Detail_ID = @iStdDetailId
                AND I_Invoice_Header_ID <> @iInvoiceHeaderId
                AND I_Centre_Id = @iSourceCenterId
                AND I_Status IN ( 1, 3 )
        ORDER BY I_Invoice_Header_ID DESC
                         
        UPDATE  T_Invoice_Parent
        SET     I_Status = 0 ,
                S_Upd_By = @sUser ,
                Dt_Upd_On = GETDATE() ,
                S_Cancel_Type = '1'
        WHERE   I_Student_Detail_ID = @iStdDetailId
                AND I_Invoice_Header_ID = @iCancelledInvoiceId 
                
        EXEC SMManagement.uspCancelStudentEligibilitySchedule @StudentDetailID = @iStdDetailId, -- int
            @InvoiceID = @iCancelledInvoiceId, -- int
            @UpdatedBy = @sUser -- nvarchar(max)           
        
        EXEC uspInsertCreditNoteForInvoice @iCancelledInvoiceId
        
         -- end code addition       
        DECLARE @iBrandID INT        
        SELECT  @iBrandID = I_Brand_ID
        FROM    dbo.T_Brand_Center_Details AS TBCD
        WHERE   I_Centre_Id = @iDestinationCenterId
                AND I_Status = 1        
             
        IF ( @iInstallment > 0 )
            EXEC [dbo].[uspCreateTransferInInvoice] @iCancelledInvoiceId,
                @iStdDetailId, @iDestinationCenterId, @sUser, @iBrandID,
                @iInvoiceHeaderId    
        ELSE
            EXEC [dbo].[uspCreateTransferOutInvoice] @iCancelledInvoiceId,
                @iStdDetailId, @iSourceCenterId, @sUser, @iBrandID               
                        
        UPDATE  T_Student_Center_Detail
        SET     I_Status = 0
        WHERE   I_Centre_Id = @iSourceCenterId
                AND I_Student_Detail_ID = @iStudentDetailId
                AND I_Status = 1                       
                
        --Deactivate student from source center's batches
		

		--insert into #SourceBatch
		--select DISTINCT A.I_Batch_ID from T_Student_Batch_Details A
		--inner join T_Center_Batch_Details B on A.I_Batch_ID=B.I_Batch_ID
		--where
		--B.I_Centre_Id=@iSourceCenterId and A.I_Student_ID=@iStudentDetailId and A.I_Status=1

		--DECLARE @i INT=1
		--DECLARE @c INT=0

		--select @c=ISNULL(COUNT(*),0) from #SourceBatch

		--while(@i<=@c)
		--BEGIN
			
		--	DECLARE @b INT=0

		--	select @b=BatchID from #SourceBatch where ID=@i

		--	EXEC [LMS].[uspInsertStudentBatchDetailsForInterface] @iStudentDetailID,@b,'DELETE',NULL
			
		--	set @i=@i+1

		--END

		


        UPDATE  dbo.T_Student_Batch_Details
        SET     I_Status = 0
        WHERE   I_Batch_ID IN ( SELECT  I_Batch_ID
                                FROM    dbo.T_Center_Batch_Details AS TCBD
                                WHERE   I_Centre_Id = @iSourceCenterId )
                AND I_Student_ID = @iStudentDetailId        
                 
        IF ( SELECT COUNT(*)
             FROM   dbo.T_Student_Center_Detail
             WHERE  I_Centre_Id = @iDestinationCenterId
                    AND I_Student_Detail_ID = @iStudentDetailId
           ) = 0
            BEGIN             
                INSERT  INTO T_Student_Center_Detail
                        ( I_Student_Detail_ID ,
                          I_Centre_Id ,
                          Dt_Valid_From ,
                          Dt_Valid_To ,
                          I_Status ,
                          S_Crtd_By ,
                          S_Upd_By ,
                          Dt_Crtd_On ,
                          Dt_Upd_On        
                        )
                VALUES  ( @iStudentDetailId ,
                          @iDestinationCenterId ,
                          GETDATE() ,
                          NULL ,
                          1 ,
                          @sUser ,
                          NULL ,
                          GETDATE() ,
                          NULL        
                        )                      
            END      
        ELSE
            BEGIN      
                UPDATE  dbo.T_Student_Center_Detail
                SET     I_Status = 1 ,
                        S_Upd_By = @sUser ,
                        Dt_Upd_On = GETDATE()
                WHERE   I_Centre_Id = @iDestinationCenterId
                        AND I_Student_Detail_ID = @iStudentDetailId        
            END                  
                            
    END


