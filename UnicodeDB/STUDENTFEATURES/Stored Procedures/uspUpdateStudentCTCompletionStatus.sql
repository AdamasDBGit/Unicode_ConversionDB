CREATE PROCEDURE [STUDENTFEATURES].[uspUpdateStudentCTCompletionStatus]
    (
      @iStudentDetailID int,
      @iCourseID int,
      @iTermID int = null,
      @sUser varchar(20),
      @dDate DATETIME,
      @sCertificateType CHAR(1) = 'C'
    )
AS 
    BEGIN TRY 
	
        DECLARE @iCounter INT
	
        IF @iTermID IS NULL 
            BEGIN
	
		-- SET DEFAULT VALUE
                SET @iCounter = 0

		-- UPADTE COURSE COMPLETION STATUS IN dbo.T_Student_Course_Detail  
		--UPDATE dbo.T_Student_Batch_Details
		--SET 
		----Dt_Course_Actual_End_Date = @dDate, //Comment By Shankha
		--B_Is_Completed = 'TRUE',
		--S_Upd_By = @sUser,
		--dt_Upd_On = @dDate
		--WHERE I_Student_Detail_ID = @iStudentDetailID
		--AND I_Course_ID = @iCourseID
		--AND @dDate >= ISNULL(Dt_Valid_From, @dDate)
		--AND @dDate <= ISNULL(Dt_Valid_To, @dDate)
		--AND I_Status = 1

		--SET @iCounter = @@ROWCOUNT

		--IF @iCounter > 0	
		--BEGIN
	
			-- IF CERTIFICATE IS THERE FOR THE COURSE, 
			-- ENTER RECORD IN PSCERTIFICATE.T_Student_PS_Certificate FOR COURSE CERTIFICATE
                IF EXISTS ( SELECT  'TRUE'
                            FROM    dbo.T_Course_Master
                            WHERE   I_Course_ID = @iCourseID
                                    AND I_Certificate_ID > 0
                                    AND I_Status = 1 ) 
                    BEGIN
                        INSERT  INTO PSCERTIFICATE.T_Student_PS_Certificate
                                (
                                  I_Student_Detail_ID,
                                  I_Course_ID,
                                  B_PS_Flag,
                                  I_Status,
                                  S_Crtd_By,
                                  Dt_Crtd_On,
                                  C_Certificate_Type
				        )
                                SELECT  @iStudentDetailID,
                                        @iCourseID,
                                        0,
                                        1,
                                        @sUser,
                                        @dDate,
                                        @sCertificateType
                    END
		--END

            END
        ELSE 
            BEGIN
	
		-- SET DEFAULT VALUE
                SET @iCounter = 0

                IF EXISTS ( SELECT  1
                            FROM    dbo.T_Student_Term_Detail
                            WHERE   I_Student_Detail_ID = @iStudentDetailID
                                    AND I_Course_ID = @iCourseID
                                    AND I_Term_ID = @iTermID  AND  I_Is_Completed ='FALSE') 
                    BEGIN
		-- UPADTE COURSE COMPLETION STATUS IN dbo.T_Student_Term_Detail
                        UPDATE  dbo.T_Student_Term_Detail
                        SET     I_Is_Completed = 'TRUE',
                                S_Upd_By = @sUser,
                                Dt_Upd_On = @dDate
                        WHERE   I_Student_Detail_ID = @iStudentDetailID
                                AND I_Course_ID = @iCourseID
                                AND I_Term_ID = @iTermID
		
                        UPDATE  dbo.T_Student_Module_Detail
                        SET     I_Is_Completed = 'TRUE',
                                S_Upd_By = @sUser,
                                Dt_Upd_On = @dDate
                        WHERE   I_Student_Detail_ID = @iStudentDetailID
                                AND I_Course_ID = @iCourseID
                                AND I_Term_ID = @iTermID
		
                        SET @iCounter = 1
                    END
	
		-- CHECK THE NON EXAMINABLE COURSE AND SET PASS FOR THE TERM 
                IF EXISTS ( SELECT  *
                            FROM    dbo.T_Term_Course_Map
                            WHERE   I_Course_ID = @iCourseID
                                    AND I_Term_ID = @iTermID
                                    AND C_Examinable = 'N'   AND I_Status = 1) 
                    BEGIN
                        UPDATE  dbo.T_Student_Term_Detail
                        SET     S_Term_Status = 'PASS'
                        WHERE   I_Student_Detail_ID = @iStudentDetailID
                                AND I_Course_ID = @iCourseID
                                AND I_Term_ID = @iTermID
				
				-- For not enterting data in PSCERTIFICATE.T_Student_PS_Certificate  table this counter need to 
                        SET @iCounter = 0			
                    END

		-- CHECK FOR SHORT TERM COURSE
                IF EXISTS ( SELECT  *
                            FROM    dbo.T_Course_Master
                            WHERE   I_Course_ID = @iCourseID
                                    AND C_IsShortTermCourse = 'Y' ) 
                    BEGIN
					-- This the check for the term marks if its reffer or pass no certificate will generate
                        DECLARE @ExamStatus VARCHAR(50)
                        SET @ExamStatus = ( SELECT  [dbo].[fnGetExamStatus](@iStudentDetailID, @iCourseID, @iTermID)
                                          )
				
                        IF ( @ExamStatus <> 'Referred' ) 
                            BEGIN
                                UPDATE  dbo.T_Student_Term_Detail
                                SET     S_Term_Status = 'PASS'
                                WHERE   I_Student_Detail_ID = @iStudentDetailID
                                        AND I_Course_ID = @iCourseID
                                        AND I_Term_ID = @iTermID
                            END
				-- For not enterting data in PSCERTIFICATE.T_Student_PS_Certificate  table this counter need to 
                        SET @iCounter = 0			
                    END

                IF @iCounter > 0 
                    BEGIN

			-- ENTER RECORD IN PSCERTIFICATE.T_Student_PS_Certificate FOR TERM PS
                        INSERT  INTO PSCERTIFICATE.T_Student_PS_Certificate
                                (
                                  I_Student_Detail_ID,
                                  I_Course_ID,
                                  I_Term_ID,
                                  B_PS_Flag,
                                  I_Status,
                                  S_Crtd_By,
                                  Dt_Crtd_On,
                                  C_Certificate_Type
			              )
                                SELECT  @iStudentDetailID,
                                        @iCourseID,
                                        @iTermID,
                                        1,
                                        1,
                                        @sUser,
                                        @dDate,
                                        @sCertificateType

			-- IF CERTIFICATE IS THERE FOR THE TERM, 
			-- ENTER RECORD IN PSCERTIFICATE.T_Student_PS_Certificate FOR TERM CERTIFICATE
                        IF EXISTS ( SELECT  'TRUE'
                                    FROM    dbo.T_Term_Course_Map
                                    WHERE   I_Course_ID = @iCourseID
                                            AND I_Term_ID = @iTermID
                                            AND I_Certificate_ID > 0
                                            AND I_Status = 1
                                            AND @dDate >= ISNULL(Dt_Valid_From, @dDate)
                                            AND @dDate <= ISNULL(Dt_Valid_To, @dDate) ) 
                            BEGIN
				
					-- This the check for the term marks if its reffer or pass no certificate will generate
                                DECLARE @ExamStatus2 VARCHAR(50)
                                SET @ExamStatus2 = ( SELECT [dbo].[fnGetExamStatus](@iStudentDetailID, @iCourseID, @iTermID)
                                                   )
				
                                IF ( @ExamStatus2 <> 'Referred' ) 
                                    BEGIN
                                        INSERT  INTO PSCERTIFICATE.T_Student_PS_Certificate
                                                (
                                                  I_Student_Detail_ID,
                                                  I_Course_ID,
                                                  I_Term_ID,
                                                  B_PS_Flag,
                                                  I_Status,
                                                  S_Crtd_By,
                                                  Dt_Crtd_On,
                                                  C_Certificate_Type
					                  )
                                                SELECT  @iStudentDetailID,
                                                        @iCourseID,
                                                        @iTermID,
                                                        0,
                                                        1,
                                                        @sUser,
                                                        @dDate,
                                                        @sCertificateType
                                    END
                            END

                    END

            END	

	-- Update the S_Certificate_Serial_No column in T_Student_PS_Certificate table
	-- for all PS entries done today
        UPDATE  PSCERTIFICATE.T_Student_PS_Certificate
        SET     S_Certificate_Serial_No = 'PS_'
                + CAST(SPSC.I_Student_Certificate_ID AS VARCHAR(150))
        FROM    PSCERTIFICATE.T_Student_PS_Certificate SPSC
        WHERE   SPSC.S_Crtd_By = @sUser
                AND SPSC.Dt_Crtd_On = @dDate
                AND ISNULL(SPSC.B_PS_Flag, 0) = 1

	-- Update the S_Certificate_Serial_No column in T_Student_PS_Certificate table
	-- for all Certificate entries done today
        UPDATE  PSCERTIFICATE.T_Student_PS_Certificate
        SET     S_Certificate_Serial_No = 'CERT_'
                + CAST(SPSC.I_Student_Certificate_ID AS VARCHAR(150))
        FROM    PSCERTIFICATE.T_Student_PS_Certificate SPSC
        WHERE   SPSC.S_Crtd_By = @sUser
                AND SPSC.Dt_Crtd_On = @dDate
                AND ISNULL(SPSC.B_PS_Flag, 0) = 0

    END TRY
    BEGIN CATCH
	
        DECLARE @ErrMsg NVARCHAR(4000),
            @ErrSeverity int

        SELECT  @ErrMsg = ERROR_MESSAGE(),
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR ( @ErrMsg, @ErrSeverity, 1 )
    END CATCH
