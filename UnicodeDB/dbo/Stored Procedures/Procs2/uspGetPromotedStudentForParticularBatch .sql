CREATE PROCEDURE [dbo].[uspGetPromotedStudentForParticularBatch ]
    (
      @iBatchID INT = NULL ,
      @sStudentCode Nnvarchar(max) = NULL ,
      @sFname Nnvarchar(max) = NULL ,
      @sMname Nnvarchar(max) = NULL ,
      @sLname Nnvarchar(max) = NULL ,
      @iCenterID INT = NULL          
            
    )
AS 
    BEGIN              
        BEGIN TRY       
            SELECT DISTINCT
                    STD.I_Student_Detail_ID ,
                    ERD.I_Enquiry_Regn_ID ,
                    STD.S_Student_ID ,
                    STD.S_First_Name ,
                    ISNULL(STD.S_Middle_Name, '') AS S_Middle_Name ,
                    STD.S_Last_Name,
                    TSBM.S_Batch_Name,
                    STBD.I_Batch_ID
            FROM    T_Student_Batch_Details STBD
					INNER JOIN dbo.T_Student_Batch_Master TSBM ON STBD.I_Batch_ID = TSBM.I_Batch_ID
                    INNER JOIN T_Student_Detail STD ON STD.I_Student_Detail_ID = STBD.I_Student_ID
                    INNER JOIN T_Enquiry_Regn_Detail ERD ON STD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                    INNER JOIN T_Center_Batch_Details CBD on TSBM.I_Batch_ID=CBD.I_Batch_ID
            WHERE   STBD.I_Batch_ID = ISNULL(@iBatchID, STBD.I_Batch_ID)
                    AND STD.S_First_Name LIKE ISNULL(@sFname, STD.S_First_Name)
                    + '%'
                    AND ( STD.S_Middle_Name IS NULL
                          OR STD.S_Middle_Name LIKE ISNULL(@sMname,
                                                           STD.S_Middle_Name)
                          + '%'
                        )
                    AND STD.S_Last_Name LIKE ISNULL(@sLname, STD.S_Last_Name)
                    + '%'
                    AND STD.S_Student_ID = ISNULL(@sStudentCode, S_Student_ID)
                    
                    /* Akash 20.9.2014
                    
                    AND ERD.I_Centre_Id = ISNULL(@iCenterID, ERD.I_Centre_Id)
                    
                   Akash 20.9.2014 */
                   AND CBD.I_Centre_Id = ISNULL(@iCenterID, CBD.I_Centre_Id)
                    
                    AND STBD.I_Status = 3               
        END TRY    
        BEGIN CATCH    
 --Error occurred:      
    
            DECLARE @ErrMsg Nnvarchar(max) ,
                @ErrSeverity INT    
            SELECT  @ErrMsg = ERROR_MESSAGE() ,
                    @ErrSeverity = ERROR_SEVERITY()    
    
            RAISERROR(@ErrMsg, @ErrSeverity, 1)    
        END CATCH      
              
    END

