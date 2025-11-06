CREATE PROCEDURE [SMManagement].[uspInsertStudentEligibilityScheduleMigration]
    (
      @StudentDetailID INT ,
      @BatchID INT ,
      @CourseID INT ,
      @CenterID INT,
      @CreatedBy VARCHAR(MAX),
      @CreatedDate DATETIME,
      @LastDelivery INT
    )
AS
    BEGIN

        DECLARE @GraceDays INT= 15
        DECLARE @CenterDispatchSchemeID INT= NULL
        DECLARE @BatchStartDate DATETIME= ( SELECT  Dt_BatchStartDate
                                            FROM    dbo.T_Student_Batch_Master
                                            WHERE   I_Batch_ID = @BatchID
                                          )
        DECLARE @EligibilityHeaderID INT
        DECLARE @IsRequired INT= 1
        
        --CREATE TABLE
        
        
        SELECT  @CenterDispatchSchemeID = TCBD.I_Center_Dispatch_Scheme_ID
        FROM    dbo.T_Center_Batch_Details AS TCBD
        WHERE   TCBD.I_Batch_ID = @BatchID
                AND TCBD.I_Center_Dispatch_Scheme_ID IS NOT NULL
                
                        
        
        IF ( @CenterDispatchSchemeID IS NOT NULL )
            BEGIN
        
                INSERT  INTO SMManagement.T_Student_Eligibity_Parent
                        ( StudentDetailID ,
                          CenterDispatchSchemeID ,
                          CourseID ,
                          CenterID ,
                          BatchID ,
                          StatusID ,
                          IsScheduled ,
                          CreatedOn ,
                          CreatedBy
                        )
                VALUES  ( @StudentDetailID , -- StudentDetailID - int
                          @CenterDispatchSchemeID , -- CenterDispatchSchemeID - int
                          @CourseID , -- CourseID - int
                          @CenterID , -- CenterID - int
                          @BatchID , -- BatchID - int
                          1 , -- StatusID - int
                          1 , -- IsScheduled - bit
                          @CreatedDate , -- CreatedOn - datetime
                          @CreatedBy  -- CreatedBy - varchar(max)
                        )
                                
                SET @EligibilityHeaderID = SCOPE_IDENTITY()
        
                INSERT  INTO SMManagement.T_Student_Eligibity_Details
                        ( EligibilityHeaderID ,
                          I_Delivery ,
                          EligibilityDate ,
                          BarcodePrefix ,
                          IsApproved ,
                          ItemType
                        )
                        SELECT  @EligibilityHeaderID ,
                                DISDATA.I_Delivery ,
                                DATEADD(d, -@GraceDays,
                                        DATEADD(m,
                                                ( DISDATA.I_Delivery - 1 )
                                                * DISDATA.Frequency,
                                                @BatchStartDate)) AS EligibilityDate ,
                                DISDATA.BarcodePrefix ,
                                0 ,
                                DISDATA.ItemType
                        FROM    ( SELECT    T1.StudentID ,
                                            T1.CenterID ,
                                            T1.CourseID ,
                                            T1.DispatchSchemeID ,
                                            T1.Frequency ,
                                            T1.I_Delivery ,
                                            T1.ItemType ,
                                            T1.BarcodePrefix ,
                                            T2.IsApproved
                                  FROM      ( SELECT    @StudentDetailID AS StudentID ,
                                                        @CenterID AS CenterID ,
                                                        @CourseID AS CourseID ,
                                                        TDSM.DispatchSchemeID ,
                                                        TDSM.Frequency ,
                                                        TDSD.I_Delivery ,
                                                        TDSD.ItemType ,
                                                        TDSD.BarcodePrefix
                                              FROM      dbo.T_Center_Batch_Details
                                                        AS TCBD
                                                        INNER JOIN SMManagement.T_Centre_Dispatch_Scheme_Map
                                                        AS TCDSM ON TCBD.I_Center_Dispatch_Scheme_ID = TCDSM.CentreDispatchSchemeID
                                                        INNER JOIN SMManagement.T_Dispatch_Scheme_Master
                                                        AS TDSM ON TDSM.DispatchSchemeID = TCDSM.SchemeID
                                                        INNER JOIN SMManagement.T_Dispatch_Scheme_Details
                                                        AS TDSD ON TDSD.DispatchSchemeID = TDSM.DispatchSchemeID
                                              WHERE     TCBD.I_Centre_Id = @CenterID
                                                        AND TCBD.I_Batch_ID = @BatchID
                                                        AND TCDSM.CourseID = @CourseID
                                                        AND TDSM.IsScheduled = 1
                                            ) T1
                                            LEFT JOIN ( SELECT DISTINCT
                                                              TSEP.StudentDetailID ,
                                                              TSEP.CenterID ,
                                                              TCDSM.CourseID ,
                                                              TDSM.DispatchSchemeID ,
                                                              TSED.I_Delivery ,
                                                              TSED.ItemType ,
                                                              TSED.BarcodePrefix ,
                                                              TSED.IsApproved
                                                        FROM  SMManagement.T_Student_Eligibity_Parent
                                                              AS TSEP
                                                              INNER JOIN SMManagement.T_Student_Eligibity_Details
                                                              AS TSED ON TSED.EligibilityHeaderID = TSEP.EligibilityHeaderID
                                                              INNER JOIN SMManagement.T_Centre_Dispatch_Scheme_Map
                                                              AS TCDSM ON TCDSM.CentreDispatchSchemeID = TSEP.CenterDispatchSchemeID
                                                              INNER JOIN SMManagement.T_Dispatch_Scheme_Master
                                                              AS TDSM ON TDSM.DispatchSchemeID = TCDSM.SchemeID
                                                        WHERE TSEP.IsScheduled = 1
                                                              AND TSED.IsApproved = 1
                                                              AND TSEP.StudentDetailID = @StudentDetailID --AND TSEP.StatusID=1
                                                      ) T2 ON T1.StudentID = T2.StudentDetailID
                                                              AND T2.DispatchSchemeID = T1.DispatchSchemeID
                                                              AND T2.I_Delivery = T1.I_Delivery
                                                              AND T2.ItemType = T1.ItemType
                                                              AND T2.BarcodePrefix = T1.BarcodePrefix
                                ) DISDATA
                        WHERE   ( DISDATA.IsApproved IS NULL
                                  OR DISDATA.IsApproved = 0
                                )
                                
                                
            UPDATE SMManagement.T_Student_Eligibity_Details SET IsApproved=1,IsDelivered=1,IsDispatched=1,ApprovedDate=GETDATE() 
            WHERE I_Delivery<=@LastDelivery AND EligibilityHeaderID=@EligibilityHeaderID 
            
                               
		
		
		
		
		
            END
		
		
		







      --  IF (@IsRequired>0 AND @CenterDispatchSchemeID IS NOT NULL)
      --      BEGIN
                    
						--DECLARE @DeliveryCount INT
						--DECLARE @Frequency INT
						--DECLARE @NoofItems INT
						--DECLARE @i INT=1
						
						--SELECT @DeliveryCount=TDSM.NoOfDelivery,@Frequency=TDSM.Frequency,@NoofItems=TDSM.BooksPerDelivery 
						--FROM SMManagement.T_Centre_Dispatch_Scheme_Map AS TCDSM
						--INNER JOIN SMManagement.T_Dispatch_Scheme_Master AS TDSM ON TCDSM.SchemeID=TDSM.DispatchSchemeID
						
						

      --                  INSERT  INTO SMManagement.T_Student_Eligibity_Parent
      --                          ( StudentDetailID ,
      --                            CenterDispatchSchemeID ,
      --                            CourseID ,
      --                            CenterID ,
      --                            BatchID ,
      --                            StatusID ,
      --                            IsScheduled ,
      --                            CreatedOn ,
      --                            CreatedBy
      --                          )
      --                  VALUES  ( @StudentDetailID , -- StudentDetailID - int
      --                            @CenterDispatchSchemeID , -- CenterDispatchSchemeID - int
      --                            @CourseID , -- CourseID - int
      --                            @CenterID , -- CenterID - int
      --                            @BatchID , -- BatchID - int
      --                            1 , -- StatusID - int
      --                            1 , -- IsScheduled - bit
      --                            GETDATE() , -- CreatedOn - datetime
      --                            'rice-group-admin'  -- CreatedBy - varchar(max)
      --                          )
                                
      --                    SET @EligibilityHeaderID=SCOPE_IDENTITY()
                          
      --                    WHILE (@i<=@DeliveryCount)
                          
      --                    BEGIN
                          
      --                    INSERT INTO SMManagement.T_Student_Eligibity_Details
      --                            ( EligibilityHeaderID ,
      --                              I_Delivery ,
      --                              EligibilityDate ,
      --                              BarcodePrefix ,
      --                              IsDelivered ,
      --                              ItemType
      --                            )
                          
      --                    SELECT @EligibilityHeaderID,TDSD.I_Delivery,DATEADD(d,-@GraceDays,DATEADD(m,(@i-1)*@Frequency,@BatchStartDate)) AS EligibilityDate,TDSD.BarcodePrefix,0,TDSD.ItemType FROM SMManagement.T_Centre_Dispatch_Scheme_Map AS TCDSM
      --                    INNER JOIN SMManagement.T_Dispatch_Scheme_Master AS TDSM ON TCDSM.SchemeID=TDSM.DispatchSchemeID
      --                    INNER JOIN SMManagement.T_Dispatch_Scheme_Details AS TDSD ON TDSD.DispatchSchemeID = TDSM.DispatchSchemeID
      --                    WHERE TCDSM.CentreDispatchSchemeID=1 AND TDSD.I_Delivery=@i
                          
      --                    SET @i=@i+1
                          
      --                    END
                             
                               
      --              END
		
		

    END
