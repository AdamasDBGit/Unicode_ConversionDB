CREATE PROCEDURE [dbo].[uspInsertStudentDataInInterfaceForDiscontinuation]
    (
      @sDiscontinueXML XML ,
      @iFlag INT ,
      @sLoginID VARCHAR(50)
    )
AS
    BEGIN
        SET NOCOUNT OFF  
        BEGIN TRY   
            BEGIN TRANSACTION 
        			

				
            INSERT  INTO dbo.T_Discontinue_Student_Interface
                    ( S_Student_ID ,
                      S_Student_Name ,
                      I_Invoice_Detail_ID ,
                      DueAmount ,
                      TaxAmount ,
                      TotalAmount ,
                      AmountPaid ,
                      TaxPaid ,
                      TotalPaid ,
                      TotalDue
                    )
                    SELECT  T.c.value('@S_Student_ID', 'VARCHAR(MAX)') ,
                            T.c.value('@S_Student_Name', 'VARCHAR(MAX)') ,
                            T.c.value('@I_Invoice_Detail_ID', 'INT') ,
                            T.c.value('@Due_Value', 'DECIMAL(14,2)') ,
                            T.c.value('@Tax_Value', 'DECIMAL(14,2)') ,
                            T.c.value('@Total_Value', 'DECIMAL(14,2)') ,
                            T.c.value('@Amount_Paid', 'DECIMAL(14,2)') ,
                            T.c.value('@Tax_Paid', 'DECIMAL(14,2)') ,
                            T.c.value('@Total_Paid', 'DECIMAL(14,2)') ,
                            T.c.value('@Total_Due', 'DECIMAL(14,2)')
                    FROM    @sDiscontinueXML.nodes('/Root/StudentDiscontinue') T ( c )
                
                
            IF ( @iFlag = 1 )
                EXEC dbo.uspDiscontinueStudents @sLoginID = @sLoginID -- varchar(50)
                
                
                
            COMMIT TRANSACTION
      
        END TRY      
        BEGIN CATCH      
            ROLLBACK TRANSACTION  
            DECLARE @ErrMsg NVARCHAR(4000) ,
                @ErrSeverity INT      
            SELECT  @ErrMsg = ERROR_MESSAGE() ,
                    @ErrSeverity = ERROR_SEVERITY()      
      
            RAISERROR(@ErrMsg, @ErrSeverity, 1)      
        END CATCH




    END
