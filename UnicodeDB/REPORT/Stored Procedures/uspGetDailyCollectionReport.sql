/*******************************************************
Author	:     Subrata Pradhan
Date	:	  17/07/2013
Description : This SP retrieves the PMS Summary Report Details
				
*********************************************************/
--exec [REPORT].[uspGetDailyCollectionReport]  '88',109,8,2013

CREATE PROCEDURE [REPORT].[uspGetDailyCollectionReport]
    (
      -- Add the parameters for the stored procedure here
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @iMonth INT ,
      @iYear INT
	
    )
AS 
    BEGIN TRY

        DECLARE @DailyCollection TABLE
            (
              id INT IDENTITY ,
              centreId INT ,
              centrename VARCHAR(MAX) ,
              MonthDate DATE ,
              info_no INT ,
              counseling_no INT ,
              prospectus_no INT ,
              counseling_fees NUMERIC(18, 2) ,
              prospectus_fees NUMERIC(18, 2) ,
              other_onaccount_fees NUMERIC(18, 2) ,
              onaccount_tax NUMERIC(18,2),
              GCOM_L_no INT ,
              GCOM_M_no INT ,
              WBCS_L_no INT ,
              WBCS_M_no INT ,
              ssc_no INT ,
              ADM INT ,
              LumpsumFeesWithoutTax NUMERIC(18, 2) ,
              LumpsumFeesTax NUMERIC(18, 2) ,
              AdmissionFeesWithoutTax NUMERIC(18, 2) ,
              AdmissionFeesTax NUMERIC(18, 2) ,
              MonthlyFeesWithouttax NUMERIC(18, 2) ,
              MonthlyFeestax NUMERIC(18, 2) ,
              TotalCollectionWithoutTax NUMERIC(18, 2) ,
              TotalCollectionTax NUMERIC(18, 2) ,
              TotalCollection NUMERIC(18, 2)
            )



        DECLARE @CenterId INT ,
            @centreName VARCHAR(MAX) ,
            @startDate DATETIME ,
            @enddate DATETIME
        SELECT TOP 1
                @CenterId = centerID ,
                @centreName = centerName
        FROM    dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID) AS fgcfr
  

        SET @startDate = CONVERT(VARCHAR(4), @iYear) + '-'
            + CONVERT(VARCHAR(2), @iMonth) + '-01'
        SET @enddate = DATEADD(dd, -1, DATEADD(MM, 1, @startDate))

        WHILE ( @startDate <= @enddate ) 
            BEGIN
                INSERT  INTO @DailyCollection
                        ( MonthDate )
                        SELECT  @startDate
                SET @startDate = DATEADD(dd, 1, @startDate)
            END

        UPDATE  @DailyCollection
        SET     centreId = @CenterId ,
                centrename = @centreName


-- INFO_count
 
        UPDATE  T
        SET     T.Info_no = ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Enquiry_Regn_Detail a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Crtd_On AS DATE) = b.MonthDate
                  GROUP BY  b.centreId ,
                            CAST(Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate
		
		
-- COUNSELING_count
 
        UPDATE  T
        SET     T.counseling_no = C.Cnt
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Crtd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND I_Receipt_Type = 76
                  GROUP BY  b.centreId ,
                            CAST(Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate 
                
        UPDATE  T
        SET     T.counseling_no = T.counseling_no - C.Cnt
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Upd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND a.I_Status = 0
                            AND I_Receipt_Type = 76
                  GROUP BY  b.centreId ,
                            CAST(Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate 
		
-- PROS_count
 
        UPDATE  T
        SET     T.prospectus_no = C.Cnt
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Crtd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND I_Receipt_Type = 32
                            AND a.N_Receipt_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate
		
		UPDATE  T
        SET     T.prospectus_no = T.prospectus_no - C.Cnt
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Upd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND a.I_Status = 0
                            AND I_Receipt_Type = 32
                            AND a.N_Receipt_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate
		
-- COUNSELING_fees
 
        UPDATE  T
        SET     T.counseling_fees = C.counseling_fees
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(a.N_Receipt_Amount, 0)
                                + ISNULL(a.N_Tax_Amount, 0)) AS counseling_fees ,
                            b.centreId ,
                            CAST(Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Crtd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND I_Receipt_Type = 76 --AND a.I_Status = 1
                  GROUP BY  b.centreId ,
                            CAST(Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate 
		
        UPDATE  T
        SET     T.counseling_fees = T.counseling_fees - C.counseling_fees
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(a.N_Receipt_Amount, 0)
                                + ISNULL(a.N_Tax_Amount, 0)) AS counseling_fees ,
                            b.centreId ,
                            CAST(Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Upd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND I_Receipt_Type = 76
                            AND a.I_Status = 0
                  GROUP BY  b.centreId ,
                            CAST(Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate 
                
-- PROS_fees
 
        UPDATE  T
        SET     T.prospectus_fees = C.prospectus_fees
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(a.N_Receipt_Amount, 0)
                                + ISNULL(a.N_Tax_Amount, 0)) AS prospectus_fees ,
                            b.centreId ,
                            CAST(Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Crtd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND I_Receipt_Type = 32 -- AND a.I_Status = 1
                  GROUP BY  b.centreId ,
                            CAST(Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate
		
        UPDATE  T
        SET     T.prospectus_fees = T.prospectus_fees - C.prospectus_fees
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(a.N_Receipt_Amount, 0)
                                + ISNULL(a.N_Tax_Amount, 0)) AS prospectus_fees ,
                            b.centreId ,
                            CAST(Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Upd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND I_Receipt_Type = 32
                            AND a.I_Status = 0
                  GROUP BY  b.centreId ,
                            CAST(Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate

-- Other On-Account Fees

        UPDATE  T
        SET     T.other_onaccount_fees = C.other_onaccount_fees
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(a.N_Receipt_Amount, 0)
                                + ISNULL(a.N_Tax_Amount, 0)) AS other_onaccount_fees ,
                            b.centreId ,
                            CAST(Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Crtd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND I_Receipt_Type NOT IN ( 32, 76 ) -- AND a.I_Status = 1
                  GROUP BY  b.centreId ,
                            CAST(Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate
		
        UPDATE  T
        SET     T.other_onaccount_fees = T.other_onaccount_fees
                - C.other_onaccount_fees
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(a.N_Receipt_Amount, 0)
                                + ISNULL(a.N_Tax_Amount, 0)) AS other_onaccount_fees ,
                            b.centreId ,
                            CAST(Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Upd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND I_Receipt_Type NOT IN ( 32, 76 )
                            AND a.I_Status = 0
                  GROUP BY  b.centreId ,
                            CAST(Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate
                
-- On Account Tax

UPDATE  T
        SET     T.onaccount_tax = C.onaccount_tax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(a.N_Tax_Amount, 0)) AS onaccount_tax ,
                            b.centreId ,
                            CAST(Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Crtd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL                            
                  GROUP BY  b.centreId ,
                            CAST(Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate

UPDATE  T
        SET     T.onaccount_tax = T.onaccount_tax - C.onaccount_tax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(a.N_Tax_Amount, 0)) AS onaccount_tax ,
                            b.centreId ,
                            CAST(Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Receipt_Header a ,
                            @DailyCollection b
                  WHERE     I_Centre_Id = b.centreId
                            AND CAST(Dt_Crtd_On AS DATE) = b.MonthDate
                            AND a.I_Invoice_Header_ID IS NULL
                            AND a.I_Status = 0                           
                  GROUP BY  b.centreId ,
                            CAST(Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate
                
                
-- GCOM_L_no
		
        UPDATE  T
        SET     T.GCOM_L_no = ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                     AND CAST(tip.Dt_Crtd_On AS DATE) = b.MonthDate
                                     INNER JOIN T_Invoice_Batch_Map TIBM on TIBM.I_Invoice_Child_Header_ID=tich.I_Invoice_Child_Header_ID --AND TIBM.I_Status=1
                             INNER JOIN T_Student_Batch_Details tsbd on tsbd.I_Student_ID=tip.I_Student_Detail_ID AND tsbd.I_Status=1
                  WHERE    I_Course_ID IN ( 12 )
                            AND tich.C_Is_LumpSum = 'Y'
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(tip.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate
                
        UPDATE  T
        SET     T.GCOM_L_no = T.GCOM_L_no - ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                     AND CAST(tip.Dt_Upd_On AS DATE) = b.MonthDate
                                     INNER JOIN T_Invoice_Batch_Map TIBM on TIBM.I_Invoice_Child_Header_ID=tich.I_Invoice_Child_Header_ID
                             INNER JOIN T_Student_Batch_Details tsbd on tsbd.I_Student_ID=tip.I_Student_Detail_ID AND tsbd.I_Status=1
                  WHERE    I_Course_ID IN ( 12 )
                            AND tich.C_Is_LumpSum = 'Y'
                            AND tip.I_Status = 0
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(tip.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate

-- GCOM_M_no
 
        UPDATE  T
        SET     T.GCOM_M_no = ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(tip.Dt_Crtd_On AS DATE) = b.MonthDate
                             INNER JOIN T_Invoice_Batch_Map TIBM on TIBM.I_Invoice_Child_Header_ID=tich.I_Invoice_Child_Header_ID --AND TIBM.I_Status=1
                             INNER JOIN T_Student_Batch_Details tsbd on tsbd.I_Student_ID=tip.I_Student_Detail_ID AND tsbd.I_Status=1
                  WHERE     I_Course_ID IN ( 12 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(tip.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate
                
        UPDATE  T
        SET     T.GCOM_M_no = T.GCOM_M_no - ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(tip.Dt_Upd_On AS DATE) = b.MonthDate
                             INNER JOIN T_Invoice_Batch_Map TIBM on TIBM.I_Invoice_Child_Header_ID=tich.I_Invoice_Child_Header_ID
                             INNER JOIN T_Student_Batch_Details tsbd on tsbd.I_Student_ID=tip.I_Student_Detail_ID AND tsbd.I_Status=1
                  WHERE     I_Course_ID IN ( 12 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND tip.I_Status = 0
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(tip.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate        
		
-- WBCS_L_no
 
        UPDATE  T
        SET     T.WBCS_L_no = ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(tip.Dt_Crtd_On AS DATE) = b.MonthDate
                             INNER JOIN T_Invoice_Batch_Map TIBM on TIBM.I_Invoice_Child_Header_ID=tich.I_Invoice_Child_Header_ID --AND TIBM.I_Status=1
                             INNER JOIN T_Student_Batch_Details tsbd on tsbd.I_Student_ID=tip.I_Student_Detail_ID AND tsbd.I_Status=1
                  WHERE     I_Course_ID IN ( 11 )
                            AND tich.C_Is_LumpSum = 'Y'
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(tip.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate

		UPDATE  T
        SET     T.WBCS_L_no = T.WBCS_L_no - ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(tip.Dt_Upd_On AS DATE) = b.MonthDate
                             INNER JOIN T_Invoice_Batch_Map TIBM on TIBM.I_Invoice_Child_Header_ID=tich.I_Invoice_Child_Header_ID
                             INNER JOIN T_Student_Batch_Details tsbd on tsbd.I_Student_ID=tip.I_Student_Detail_ID AND tsbd.I_Status=1
                  WHERE     I_Course_ID IN ( 11 )
							AND tip.I_Status = 0
                            AND tich.C_Is_LumpSum = 'Y'
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(tip.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate
                
-- WBCS_M_no
 
        UPDATE  T
        SET     T.WBCS_M_no = ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(tip.Dt_Crtd_On AS DATE) = b.MonthDate
                            INNER JOIN T_Invoice_Batch_Map TIBM on TIBM.I_Invoice_Child_Header_ID=tich.I_Invoice_Child_Header_ID --AND TIBM.I_Status=1
                             INNER JOIN T_Student_Batch_Details tsbd on tsbd.I_Student_ID=tip.I_Student_Detail_ID AND tsbd.I_Status=1
                  WHERE     I_Course_ID IN ( 11 )
                            AND ISNULL(tich.C_Is_LumpSum, '') <> 'Y'
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(tip.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate
                
        UPDATE  T
        SET     T.WBCS_M_no = T.WBCS_M_no - ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(tip.Dt_Upd_On AS DATE) = b.MonthDate
                            INNER JOIN T_Invoice_Batch_Map TIBM on TIBM.I_Invoice_Child_Header_ID=tich.I_Invoice_Child_Header_ID
                             INNER JOIN T_Student_Batch_Details tsbd on tsbd.I_Student_ID=tip.I_Student_Detail_ID AND tsbd.I_Status=1
                  WHERE     I_Course_ID IN ( 11 )
                            AND tip.I_Status = 0
                            AND ISNULL(tich.C_Is_LumpSum, '') <> 'Y'
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(tip.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate
		
		
-- SSC_no
 
        UPDATE  T
        SET     T.SSC_no = ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(tip.Dt_Crtd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 13 )
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate
		
		UPDATE  T
        SET     T.SSC_no = T.SSC_no - ISNULL(C.Cnt, 0)
        FROM    @DailyCollection AS T ,
                ( SELECT    COUNT(*) AS Cnt ,
                            b.centreId ,
                            CAST(tip.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(tip.Dt_Upd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 13 )
                            AND tip.I_Status = 0
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate
		
        UPDATE  @DailyCollection
        SET     ADM = ISNULL(GCOM_L_no, 0) + ISNULL(GCOM_M_no, 0)
                + ISNULL(WBCS_L_no, 0) + ISNULL(WBCS_M_no, 0) + ISNULL(ssc_no,
                                                              0)
		
		
	-- LumpsumFees

        UPDATE  T
        SET     T.LumpsumFeesWithoutTax = C.LumpsumFeesWithoutTax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRCD.N_Amount_Paid, 0)) LumpsumFeesWithoutTax ,
                            b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Crtd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum = 'Y'
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate
		
        UPDATE  T
        SET     T.LumpsumFeesWithoutTax = T.LumpsumFeesWithoutTax
                - C.LumpsumFeesWithoutTax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRCD.N_Amount_Paid, 0)) LumpsumFeesWithoutTax ,
                            b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Upd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum = 'Y'
                            --AND tip.I_Status = 0
                            AND trh.I_Status=0
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate 
		
        UPDATE  T
        SET     T.LumpsumFeesTax = C.LumpsumFeesTax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRTD.N_Tax_Paid, 0)) LumpsumFeesTax ,
                            b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                             
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD WITH ( NOLOCK ) ON trcd.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
                            AND trcd.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Crtd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum = 'Y'
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate 
		
        UPDATE  T
        SET     T.LumpsumFeesTax = T.LumpsumFeesTax - C.LumpsumFeesTax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRTD.N_Tax_Paid, 0)) LumpsumFeesTax ,
                            b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD WITH ( NOLOCK ) ON trcd.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
                            AND trcd.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Upd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum = 'Y'
                            --AND tip.I_Status = 0
                            AND trh.I_Status=0
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate 

-- Admission Fees
 		
        UPDATE  T
        SET     T.AdmissionFeesWithoutTax = C.AdmissionFeesWithoutTax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRCD.N_Amount_Paid, 0)) AdmissionFeesWithoutTax ,
                            b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              AND TICD.I_Installment_No = 1
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Crtd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND ticd.I_Installment_No = 1
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate 
		
        UPDATE  T
        SET     T.AdmissionFeesWithoutTax = T.AdmissionFeesWithoutTax
                - C.AdmissionFeesWithoutTax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRCD.N_Amount_Paid, 0)) AdmissionFeesWithoutTax ,
                            b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              AND TICD.I_Installment_No = 1
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Upd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND trh.I_Status = 0
                            AND ticd.I_Installment_No = 1
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate 
		
        UPDATE  T
        SET     T.AdmissionFeesTax = C.AdmissionFeesTax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRTD.N_Tax_Paid, 0)) AdmissionFeesTax ,
                            b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              AND TICD.I_Installment_No = 1
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD WITH ( NOLOCK ) ON trcd.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
                            AND trcd.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Crtd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND ticd.I_Installment_No = 1
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate 
		
        UPDATE  T
        SET     T.AdmissionFeesTax = T.AdmissionFeesTax - C.AdmissionFeesTax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRTD.N_Tax_Paid, 0)) AdmissionFeesTax ,
                            b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              AND TICD.I_Installment_No = 1
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD WITH ( NOLOCK ) ON trcd.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
                            AND trcd.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Upd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND ticd.I_Installment_No = 1
                            AND trh.I_Status = 0
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate 
		
-- MonthlyFees
  
		
        UPDATE  T
        SET     T.MonthlyFeeswithouttax = C.MonthlyFeeswithouttax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRCD.N_Amount_Paid, 0)) MonthlyFeeswithouttax ,
                            b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              AND TICD.I_Installment_No <> 1
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Crtd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND ticd.I_Installment_No <> 1
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate 
		
        UPDATE  T
        SET     T.MonthlyFeeswithouttax = T.MonthlyFeeswithouttax
                - C.MonthlyFeeswithouttax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRCD.N_Amount_Paid, 0)) MonthlyFeeswithouttax ,
                            b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              AND TICD.I_Installment_No <> 1
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Upd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND ticd.I_Installment_No <> 1
                            AND trh.I_Status = 0
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate
		
        UPDATE  T
        SET     T.MonthlyFeestax = C.MonthlyFeestax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRTD.N_Tax_Paid, 0)) MonthlyFeestax ,
                            b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE) Dt_Crtd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              AND TICD.I_Installment_No <> 1
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD WITH ( NOLOCK ) ON trcd.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
                            AND trcd.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Crtd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND ticd.I_Installment_No <> 1
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Crtd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Crtd_On = t.MonthDate 
		
        UPDATE  T
        SET     T.MonthlyFeestax = T.MonthlyFeestax - C.MonthlyFeestax
        FROM    @DailyCollection AS T ,
                ( SELECT    SUM(ISNULL(TRTD.N_Tax_Paid, 0)) MonthlyFeestax ,
                            b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE) Dt_Upd_On
                  FROM      dbo.T_Invoice_Parent AS tip
                            INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Receipt_Header AS trh ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                            INNER JOIN T_Invoice_Child_Detail TICD WITH ( NOLOCK ) ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              AND TICD.I_Installment_No <> 1
                            INNER JOIN t_receipt_component_detail TRCD WITH ( NOLOCK ) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND trh.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
                            INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD WITH ( NOLOCK ) ON trcd.I_Receipt_Comp_Detail_ID = TRTD.I_Receipt_Comp_Detail_ID
                            AND trcd.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                            INNER JOIN @DailyCollection b ON tip.I_Centre_Id = b.centreId
                                                             AND CAST(trh.Dt_Upd_On AS DATE) = b.MonthDate
                  WHERE     I_Course_ID IN ( 11, 12, 13 )
                            AND tich.C_Is_LumpSum <> 'Y'
                            AND ticd.I_Installment_No <> 1
                            AND trh.I_Status = 0
                            AND tip.N_Invoice_Amount > 0
                  GROUP BY  b.centreId ,
                            CAST(trh.Dt_Upd_On AS DATE)
                ) AS C
        WHERE   c.centreId = T.centreId
                AND C.Dt_Upd_On = t.MonthDate 
		
	
        UPDATE  @DailyCollection
        SET     TotalCollectionWithoutTax = ISNULL(LumpsumFeesWithoutTax, 0)
                + ISNULL(AdmissionFeesWithoutTax, 0)
                + ISNULL(MonthlyFeeswithouttax, 0)
                + ISNULL(counseling_fees,0)
                + ISNULL(prospectus_fees,0)
                + ISNULL(other_onaccount_fees,0)
                - ISNULL(onaccount_tax,0)
											
        UPDATE  @DailyCollection
        SET     TotalCollectionTax = ISNULL(LumpsumFeesTax, 0)
                + ISNULL(AdmissionFeesTax, 0) + ISNULL(MonthlyFeestax, 0) + ISNULL(onaccount_tax, 0)
											
        UPDATE  @DailyCollection
        SET     TotalCollection = ISNULL(LumpsumFeesWithoutTax, 0)
                + ISNULL(LumpsumFeesTax, 0) + ISNULL(AdmissionFeesWithoutTax,0)
                + ISNULL(AdmissionFeesTax, 0) + ISNULL(MonthlyFeeswithouttax,0)
                + ISNULL(MonthlyFeestax, 0) + ISNULL(counseling_fees,0)
                + ISNULL(prospectus_fees,0) + ISNULL(other_onaccount_fees,0)

        SELECT  *
        FROM    @DailyCollection A 
        ORDER BY id

    END TRY

    BEGIN CATCH
	
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT

        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
    END CATCH
