CREATE PROCEDURE [SMManagement].[uspCancelStudentEligibilitySchedule]
    (
      @StudentDetailID INT ,
      @InvoiceID INT ,
      @UpdatedBy VARCHAR(MAX)
    )
AS
    BEGIN


        DECLARE @BatchID INT

        SELECT  @BatchID = TIBM.I_Batch_ID
        FROM    dbo.T_Invoice_Batch_Map AS TIBM
                INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
        WHERE   TICH.I_Invoice_Header_ID = @InvoiceID
                        
                        
        UPDATE  SMManagement.T_Student_Eligibity_Parent
        SET     StatusID = 0 ,
                UpdatedBy = @UpdatedBy ,
                UpdatedOn = GETDATE()
        WHERE   BatchID = @BatchID
                AND CenterDispatchSchemeID = ( SELECT   CenterDispatchSchemeID
                                               FROM     dbo.T_Center_Batch_Details
                                               WHERE    I_Batch_ID = @BatchID
                                             )
                AND StatusID=1 AND IsScheduled=1 
                AND StudentDetailID=@StudentDetailID                                                  



    END
