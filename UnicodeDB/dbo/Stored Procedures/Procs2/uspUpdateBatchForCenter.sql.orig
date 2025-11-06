CREATE PROCEDURE [dbo].[uspUpdateBatchForCenter]
    (
      @iBatchId INT ,
      @iCenterId INT = NULL ,
      @MaxStrength INT ,
      @MinRegnAmt DECIMAL(10, 2) ,
      @UpdtBy VARCHAR(500) ,
      @UpdtOn DATETIME ,
      @EmpID INT ,
      @Status INT ,              
 --@iTimeSlotId int,              
      @bIsApproved BIT = NULL ,
      @dtStartDt DATETIME = NULL ,
      @dtEndDate DATETIME = NULL ,
      @iAdmissionGraceDays INT ,
      @MinStrength INT ,
      @iLateFeeGraceDays INT ,
      @sBatchName VARCHAR(100) ,
      @DtBatchIntroductionDate DATETIME = NULL ,
      @sIntroductionTime VARCHAR(250) = NULL,
	  @DtMBatchStartDate DATETIME=NULL,
	  @iBatchType INT=1,
	  @S_ClassDays VARCHAR(MAX)='',
	  @S_OfflineClassTime VARCHAR(MAX)='',
	  @S_OnlineClassTime VARCHAR(MAX)='',
	  @S_HandoutClassTime VARCHAR(MAX)='',
	  @S_ClassMode VARCHAR(MAX)='',
	  @S_BatchTime VARCHAR(MAX)=''
    )
AS
    BEGIN TRY                
            
        DECLARE @dtprevStartDate DATETIME = NULL            
        DECLARE @Message VARCHAR(MAX)              
             
 --Get Old Start Date            
             
        SELECT  @dtprevStartDate = Dt_BatchStartDate
        FROM    dbo.T_Student_Batch_Master AS tsbm
        WHERE   tsbm.I_Batch_ID = @iBatchId

		if(@S_OfflineClassTime=',')
		begin
			set @S_OfflineClassTime=''
		end

		if(@S_OnlineClassTime=',')
		begin
			set @S_OnlineClassTime=''
		end

		if(@S_HandoutClassTime=',')
		begin
			set @S_HandoutClassTime=''
		end





		if(LEN(@S_ClassDays)>2)
		begin
			set @S_ClassDays=LEFT(@S_ClassDays,LEN(@S_ClassDays)-1)
		end

		if(LEN(@S_OfflineClassTime)>2)
		begin
			set @S_OfflineClassTime=LEFT(@S_OfflineClassTime,LEN(@S_OfflineClassTime)-1)
		end

		if(LEN(@S_OnlineClassTime)>2)
		begin
			set @S_OnlineClassTime=LEFT(@S_OnlineClassTime,LEN(@S_OnlineClassTime)-1)
		end

		if(LEN(@S_HandoutClassTime)>2)
		begin
			set @S_HandoutClassTime=LEFT(@S_HandoutClassTime,LEN(@S_HandoutClassTime)-1)
		end



		
		if(@iBatchType=2)
		begin

			if(@DtMBatchStartDate IS NULL)
			begin

				SET @DtMBatchStartDate=ISNULL(@dtStartDt,@dtprevStartDate)

			end

		end
		else if (@iBatchType=1)
		begin

			SET @DtMBatchStartDate=ISNULL(@dtStartDt,@dtprevStartDate)

		end
             
        IF ( @iCenterId IS NOT NULL )
            BEGIN               
               
                IF ( @dtStartDt IS NULL
                     OR @dtStartDt = @dtprevStartDate
                   )
                    BEGIN            
            --Update            
                        UPDATE  T_Student_Batch_Master
                        SET     I_Admission_GraceDays = @iAdmissionGraceDays ,
                                I_Latefee_Grace_Day = @iLateFeeGraceDays ,
                                Dt_BatchIntroductionDate = @DtBatchIntroductionDate ,
                                s_BatchIntroductionTime = @sIntroductionTime ,
                                b_IsApproved = @bIsApproved ,
                                Dt_BatchStartDate = ISNULL(@dtStartDt,
                                                           Dt_BatchStartDate) ,
                                Dt_Course_Expected_End_Date = ISNULL(@dtEndDate,
                                                              Dt_Course_Expected_End_Date) ,
                                S_Batch_Name = @sBatchName ,
                                Dt_Upd_On = @UpdtOn ,
                                S_Updt_By = @UpdtBy,
								Dt_MBatchStartDate=@DtMBatchStartDate,
								I_BatchType=@iBatchType,
								I_Category_ID=@iBatchType--added by susmita

                        WHERE   I_Batch_ID = @iBatchId                
               
                        UPDATE  dbo.T_Center_Batch_Details
                        SET     Max_Strength = @MaxStrength ,
                                I_Minimum_Regn_Amt = @MinRegnAmt ,
                                --S_Updt_By = @UpdtBy ,
                                --Dt_Upd_On = @UpdtOn ,
                                I_Employee_ID = @EmpID ,
                                I_Status = @Status ,
                                I_Min_Strength = @MinStrength ,
								S_ClassDays=@S_ClassDays,
								S_OfflineClassTime=@S_OfflineClassTime,
								S_OnlineClassTime=@S_OnlineClassTime,
								S_HandoutClassTime=@S_HandoutClassTime,
								S_ClassMode=@S_ClassMode,
								S_BatchTime=@S_BatchTime,
                                Dt_Upd_On = @UpdtOn ,
                                S_Updt_By = @UpdtBy
                        WHERE   I_Batch_ID = @iBatchId
                                AND I_Centre_Id = ISNULL(@iCenterId,
                                                         I_Centre_Id)
                        
                        IF ( @dtStartDt IS NOT NULL
                             AND @dtStartDt != @dtprevStartDate
                           )
                            BEGIN                                 
                                UPDATE  SMManagement.T_Student_Eligibity_Details
                                SET     EligibilityDate = DATEADD(d, -15,
                                                              DATEADD(m,
                                                              ( I_Delivery - 1 )
                                                              * 2, @dtStartDt))
                                WHERE   EligibilityDetailID IN (
                                        SELECT  TSED.EligibilityDetailID
                                        FROM    SMManagement.T_Student_Eligibity_Details
                                                AS TSED
                                        WHERE   TSED.EligibilityHeaderID IN (
                                                SELECT  TSEP.EligibilityHeaderID
                                                FROM    SMManagement.T_Student_Eligibity_Parent
                                                        AS TSEP
                                                WHERE   TSEP.BatchID = @iBatchId
                                                        AND TSEP.StatusID = 1 )
                                                AND TSED.IsApproved <> 1 )  
                            END
                                                              
                    END            
                ELSE
                    BEGIN            
                        IF EXISTS ( SELECT  I_TimeTable_ID
                                    FROM    dbo.T_Student_Attendance AS tsa
                                    WHERE   I_TimeTable_ID IN (
                                            SELECT  I_TimeTable_ID
                                            FROM    dbo.T_TimeTable_Master AS tsbs
                                            WHERE   I_Batch_ID = @iBatchId ) )
                            BEGIN            
                     
                                SET @Message = 'Attendance is already marked against this batch. The start date cannot be changed.'              
                                RAISERROR (@Message, -- Message text.            
          16, -- Severity.            
          1 -- State.            
          );            
                            END            
                        ELSE
                            BEGIN            
          ---Delete and Update
                                DELETE  FROM dbo.T_TimeTable_Faculty_Map
                                WHERE   I_TimeTable_ID IN (
                                        SELECT  I_TimeTable_ID
                                        FROM    dbo.T_TimeTable_Master
                                        WHERE   I_Batch_ID = @iBatchId
                                                AND I_Is_Complete = 0 )
                      
                                DELETE  FROM dbo.T_TimeTable_Master
                                WHERE   I_Batch_ID = @iBatchId
                                        AND I_Is_Complete = 0            
                  
                                UPDATE  T_Student_Batch_Master
                                SET     I_Admission_GraceDays = @iAdmissionGraceDays ,
                                        b_IsApproved = @bIsApproved ,
                                        Dt_BatchStartDate = ISNULL(@dtStartDt,
                                                              Dt_BatchStartDate) ,
                                        Dt_Course_Expected_End_Date = ISNULL(@dtEndDate,
                                                              Dt_Course_Expected_End_Date) ,
                                        I_Latefee_Grace_Day = @iLateFeeGraceDays ,
                                        S_Batch_Name = @sBatchName ,
                                        Dt_BatchIntroductionDate = @DtBatchIntroductionDate ,
                                        s_BatchIntroductionTime = @sIntroductionTime ,
                                        Dt_Upd_On = @UpdtOn ,
                                        S_Updt_By = @UpdtBy,
										Dt_MBatchStartDate=@DtMBatchStartDate,
										I_BatchType=@iBatchType,
										I_Category_ID=@iBatchType--added by susmita
                                WHERE   I_Batch_ID = @iBatchId             
                      
                                UPDATE  dbo.T_Center_Batch_Details
                                SET     Max_Strength = @MaxStrength ,
                                        I_Minimum_Regn_Amt = @MinRegnAmt ,
										S_ClassDays=@S_ClassDays,
										S_OfflineClassTime=@S_OfflineClassTime,
										S_OnlineClassTime=@S_OnlineClassTime,
										S_HandoutClassTime=@S_HandoutClassTime,
										S_ClassMode=@S_ClassMode,
										S_BatchTime=@S_BatchTime,
                                        S_Updt_By = @UpdtBy ,
                                        Dt_Upd_On = @UpdtOn ,
                                        I_Employee_ID = @EmpID ,
                                        I_Status = @Status ,
                                        I_Min_Strength = @MinStrength
                                WHERE   I_Batch_ID = @iBatchId
                                        AND I_Centre_Id = ISNULL(@iCenterId,
                                                              I_Centre_Id)
                                                              
                                IF ( @dtStartDt IS NOT NULL
                                     AND @dtStartDt != @dtprevStartDate
                                   )
                                    BEGIN                                 
                                        UPDATE  SMManagement.T_Student_Eligibity_Details
                                        SET     EligibilityDate = DATEADD(d,
                                                              -15,
                                                              DATEADD(m,
                                                              ( I_Delivery - 1 )
                                                              * 2, @dtStartDt))
                                        WHERE   EligibilityDetailID IN (
                                                SELECT  TSED.EligibilityDetailID
                                                FROM    SMManagement.T_Student_Eligibity_Details
                                                        AS TSED
                                                WHERE   TSED.EligibilityHeaderID IN (
                                                        SELECT
                                                              TSEP.EligibilityHeaderID
                                                        FROM  SMManagement.T_Student_Eligibity_Parent
                                                              AS TSEP
                                                        WHERE TSEP.BatchID = @iBatchId
                                                              AND TSEP.StatusID = 1 )
                                                        AND TSED.IsApproved <> 1 )  
                                    END                                               
                   
                  
                            END                   
                   
                    END            
             
            END            
                 
        ELSE
            BEGIN                
              
                UPDATE  dbo.T_Student_Batch_Master
                SET     I_Admission_GraceDays = @iAdmissionGraceDays ,
                        I_Latefee_Grace_Day = @iLateFeeGraceDays ,
                        Dt_BatchIntroductionDate = @DtBatchIntroductionDate ,
                        s_BatchIntroductionTime = @sIntroductionTime ,
                        I_User_ID = @EmpID ,
                        S_Batch_Name = @sBatchName ,
                        Dt_Upd_On = @UpdtOn ,
                        S_Updt_By = @UpdtBy,
						Dt_MBatchStartDate=@DtMBatchStartDate,
						I_BatchType=@iBatchType,
						I_Category_ID=@iBatchType--added by susmita
                WHERE   I_Batch_ID = @iBatchId  
				

                UPDATE  dbo.T_Center_Batch_Details
                SET     Max_Strength = @MaxStrength ,
                        I_Minimum_Regn_Amt = @MinRegnAmt ,
						S_ClassDays=@S_ClassDays,
						S_OfflineClassTime=@S_OfflineClassTime,
						S_OnlineClassTime=@S_OnlineClassTime,
						S_HandoutClassTime=@S_HandoutClassTime,
						S_ClassMode=@S_ClassMode,
						S_BatchTime=@S_BatchTime,
                        S_Updt_By = @UpdtBy ,
                        Dt_Upd_On = @UpdtOn ,
                        I_Status = @Status ,
                        I_Min_Strength = @MinStrength
                WHERE   I_Batch_ID = @iBatchId
                        AND I_Centre_Id = ISNULL(@iCenterId, I_Centre_Id) 
                        
                IF ( @dtStartDt IS NOT NULL
                     AND @dtStartDt != @dtprevStartDate
                   )
                    BEGIN                                 
                        UPDATE  SMManagement.T_Student_Eligibity_Details
                        SET     EligibilityDate = DATEADD(d, -15,
                                                          DATEADD(m,
                                                              ( I_Delivery - 1 )
                                                              * 2, @dtStartDt))
                        WHERE   EligibilityDetailID IN (
                                SELECT  TSED.EligibilityDetailID
                                FROM    SMManagement.T_Student_Eligibity_Details
                                        AS TSED
                                WHERE   TSED.EligibilityHeaderID IN (
                                        SELECT  TSEP.EligibilityHeaderID
                                        FROM    SMManagement.T_Student_Eligibity_Parent
                                                AS TSEP
                                        WHERE   TSEP.BatchID = @iBatchId
                                                AND TSEP.StatusID = 1 )
                                        AND TSED.IsApproved <> 1 )  
                    END                     
                 
            END                
                 
    END TRY                
    BEGIN CATCH          
        DECLARE @ErrorMessage NVARCHAR(4000);            
        DECLARE @ErrorSeverity INT;            
        DECLARE @ErrorState INT;            
            
        SELECT  @ErrorMessage = ERROR_MESSAGE() ,
                @ErrorSeverity = ERROR_SEVERITY() ,
                @ErrorState = ERROR_STATE();            
            
    -- Use RAISERROR inside the CATCH block to return error            
    -- information about the original error that caused            
    -- execution to jump to the CATCH block.            
        RAISERROR (@ErrorMessage, -- Message text.            
               @ErrorSeverity, -- Severity.            
               @ErrorState -- State.            
               );            
    END CATCH
