
CREATE PROCEDURE [REPORT].[uspGetACAdmissionList_BKP_NOV]
    (
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS 
    BEGIN

        IF ( @iBrandID = 111 ) 
            BEGIN
                SELECT  TCHND.S_Brand_Name,TCHND.I_Center_ID,TCHND.S_Center_Name ,
						CASE WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM2.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM2.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM2.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre,
                        TCM.S_Course_Name ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StdName ,
                        CONVERT(DATE, TIP.Dt_Crtd_On) AS InvoiceDate ,
                        DATENAME(MONTH, TIP.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YYYY, TIP.Dt_Crtd_On) AS VARCHAR) AS InvoiceMonthYear ,
                        TIP.S_Invoice_No ,
                        CONVERT(DATE,TSD.Dt_Crtd_On) AS AdmissionDate,
                        CASE WHEN ( SELECT  TBR.I_Student_Detail_ID
                                    FROM    dbo.T_Booking_Record TBR
                                    WHERE   TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                            AND TBR.Dt_Booking_Date <> ISNULL(TBR.Dt_Reg_Conversion_Date,
                                                              '1990-01-01')
                                  ) IS NOT NULL THEN 'YES'
                             WHEN ( SELECT  TBR.I_Student_Detail_ID
                                    FROM    dbo.T_Booking_Record TBR
                                    WHERE   TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                            AND TBR.Dt_Booking_Date = TBR.Dt_Reg_Conversion_Date
                                  ) IS NOT NULL THEN 'NO'
                             WHEN ( SELECT  TBR.I_Student_Detail_ID
                                    FROM    dbo.T_Booking_Record TBR
                                    WHERE   TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                  ) IS NULL THEN 'NO'
                        END AS IsBooking ,
                        CASE WHEN TSD.Dt_Crtd_On BETWEEN @dtStartDate
                                                 AND     DATEADD(d, 1,
                                                              @dtEndDate)
                             THEN 'New Admission/Booking'
                             WHEN TSD.Dt_Crtd_On NOT BETWEEN @dtStartDate
                                                 AND         DATEADD(d, 1,
                                                              @dtEndDate)
                             THEN 'Repeater Student'
                        END AS AdmStatus ,
                        CASE WHEN TCM2.S_Center_Code LIKE 'FR-%' THEN 'NO'
                             WHEN TCM2.S_Center_Code NOT LIKE 'FR-%'
                             THEN 'YES'
                        END IsOwnCentre,
                        TSD.S_Mobile_No,
                        TSBM.S_Batch_Name,
                        TSBM.Dt_BatchStartDate,
                        TISM.S_Info_Source_Name,
                        TSD.Dt_Birth_Date,
                        TICH.C_Is_LumpSum,
						ISNULL(TSD.B_HasTakenLoan,0) as HasTakenLoan,
						ISNULL(A.S_Discount_Desc,'No Discount') as DiscountType,
						B.InfoSource,
						B.InfoMedium,
						B.InfoCampaign,
						TSD.S_Email_ID,
						TUS.S_Sex_Name,
						TERD.S_Form_No,
						TIP.I_Invoice_Header_ID,
						TIP.N_Invoice_Amount+ISNULL(TIP.N_Tax_Amount,0) as PayableAmount,
						1 AS IsAdmission
        --FROM    dbo.T_Invoice_Parent TIP
        --        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
        --        INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
        --        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TIBM.I_Batch_ID = TSBD.I_Batch_ID
        --                                                      AND TSBD.I_Student_ID = TIP.I_Student_Detail_ID
        --        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
        --        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
        --        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
        --        INNER JOIN dbo.T_Course_Master TCM ON TCHND.I_Brand_ID = TCM.I_Brand_ID
        --                                              AND TSBM.I_Course_ID = TCM.I_Course_ID
        --        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                FROM    dbo.T_Invoice_Parent TIP
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN dbo.T_Centre_Master TCM2 ON TCHND.I_Center_ID = TCM2.I_Centre_Id
                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                        LEFT JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
						left join T_Discount_Type A on A.I_Discount_Type_ID=TSD.I_DiscountType_ID
						left join T_Enquiry_External_Additional_Details B on TERD.I_Enquiry_Regn_ID=B.PreEnquiryID
						left join T_User_Sex TUS on TERD.I_Sex_ID=TUS.I_Sex_ID
                WHERE   TIP.I_Status IN ( 0, 1 )
                        AND TIP.I_Parent_Invoice_ID IS NULL
                --AND TSBD.I_Status IN (0,1,2)
                        AND ( TIP.Dt_Crtd_On >= @dtStartDate
                              AND TIP.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                            )
                        AND TIP.I_Centre_Id IN (
                        SELECT  fnCenter.centerID
                        FROM    fnGetCentersForReports(@sHierarchyList,
                                                       @iBrandID) fnCenter )
                --AND TSD.S_Student_ID='1415/AC/1526'
            END
                
        ELSE 
            IF ( @iBrandID = 110
                 OR @iBrandID = 107
                 OR @iBrandID = 112
                 OR @iBrandID = 108
               ) 
                BEGIN
                    SELECT  TCHND.S_Brand_Name,TCHND.I_Center_ID,TCHND.S_Center_Name ,
							CASE WHEN TCM3.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM3.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM3.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM3.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre,
                            TCM.S_Course_Name ,
                            TSD.S_Student_ID ,
                            TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name,
                                                            '') + ' '
                            + TSD.S_Last_Name AS StdName ,
                            CONVERT(DATE, TIP.Dt_Crtd_On) AS InvoiceDate ,
                            DATENAME(MONTH, TIP.Dt_Crtd_On) + ' '
                            + CAST(DATEPART(YYYY, TIP.Dt_Crtd_On) AS VARCHAR) AS InvoiceMonthYear ,
                            TIP.S_Invoice_No ,
                            CONVERT(DATE,TSD.Dt_Crtd_On) AS AdmissionDate,
                            CASE WHEN ( SELECT  TOP 1 TBR.I_Student_Detail_ID
                                        FROM    dbo.T_Booking_Record TBR
                                        WHERE   TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                AND TBR.Dt_Booking_Date <> ISNULL(TBR.Dt_Reg_Conversion_Date,
                                                              '1990-01-01')
                                      ) IS NOT NULL THEN 'YES'
                                 WHEN ( SELECT TOP 1 TBR.I_Student_Detail_ID
                                        FROM    dbo.T_Booking_Record TBR
                                        WHERE   TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                AND TBR.Dt_Booking_Date = TBR.Dt_Reg_Conversion_Date
                                      ) IS NOT NULL THEN 'NO'
                                 WHEN ( SELECT TOP 1 TBR.I_Student_Detail_ID
                                        FROM    dbo.T_Booking_Record TBR
                                        WHERE   TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                      ) IS NULL THEN 'NO'
                            END AS IsBooking ,
                            'New Admission/Booking' AS AdmStatus ,
                            CASE WHEN TCM3.S_Center_Code LIKE 'FR-%' THEN 'NO'
                                 WHEN TCM3.S_Center_Code NOT LIKE 'FR-%'
                                 THEN 'YES'
                            END IsOwnCentre,
                            TSD.S_Mobile_No,
                            TSBM.S_Batch_Name,
                            TSBM.Dt_BatchStartDate,
                            TISM.S_Info_Source_Name,
                            TSD.Dt_Birth_Date,
                            TICH.C_Is_LumpSum,
							ISNULL(TSD.B_HasTakenLoan,0) as HasTakenLoan,
							ISNULL(A.S_Discount_Desc,'No Discount') as DiscountType,
							B.InfoSource,
							B.InfoMedium,
							B.InfoCampaign,
							TSD.S_Email_ID,
							TUS.S_Sex_Name,
							TERD.S_Form_No,
							TIP.I_Invoice_Header_ID,
							TIP.N_Invoice_Amount+ISNULL(TIP.N_Tax_Amount,0) as PayableAmount,
							1 AS IsAdmission
        --FROM    dbo.T_Invoice_Parent TIP
        --        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
        --        INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
        --        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TIBM.I_Batch_ID = TSBD.I_Batch_ID
        --                                                      AND TSBD.I_Student_ID = TIP.I_Student_Detail_ID
        --        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
        --        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
        --        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
        --        INNER JOIN dbo.T_Course_Master TCM ON TCHND.I_Brand_ID = TCM.I_Brand_ID
        --                                              AND TSBM.I_Course_ID = TCM.I_Course_ID
        --        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                    FROM    dbo.T_Invoice_Parent TIP
                            INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                            INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
                            INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                            INNER JOIN dbo.T_Centre_Master TCM3 ON TCHND.I_Center_ID = TCM3.I_Centre_Id
                            INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                            INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
							LEFT JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
							left join T_Discount_Type A on A.I_Discount_Type_ID=TSD.I_DiscountType_ID
							left join T_Enquiry_External_Additional_Details B on TERD.I_Enquiry_Regn_ID=B.PreEnquiryID
							left join T_User_Sex TUS on TERD.I_Sex_ID=TUS.I_Sex_ID
                    WHERE   TIP.I_Status IN ( 0, 2, 1 )
                            AND TIP.I_Parent_Invoice_ID IS NULL
                --AND TSBD.I_Status IN (0,1,2)
                            AND ( TIP.Dt_Crtd_On >= @dtStartDate
                                  AND TIP.Dt_Crtd_On < DATEADD(d, 1,
                                                              @dtEndDate)
                                )
                            AND TIP.I_Centre_Id IN (
                            SELECT  fnCenter.centerID
                            FROM    fnGetCentersForReports(@sHierarchyList,
                                                           @iBrandID) fnCenter )
                            AND CONVERT(DATE, TIP.Dt_Invoice_Date) = CONVERT(DATE, TSD.Dt_Crtd_On)
                            AND CONVERT(DATE,TIBM.Dt_Crtd_On)=CONVERT(DATE,TSD.Dt_Crtd_On)
                            AND TICH.I_Course_ID IS NOT NULL
                            --AND DATEADD(MI, DATEDIFF(MI, 0, TIP.Dt_Invoice_Date), 0)=DATEADD(MI, DATEDIFF(MI, 0, TSD.Dt_Crtd_On), 0)
                END
				ELSE IF (@iBrandID = 109)
				BEGIN

					select  * from
(
SELECT  TCHND.S_Brand_Name,TCHND.I_Center_ID,TCHND.S_Center_Name ,
							CASE WHEN TCM3.S_Center_Code LIKE 'Judiciary T%'
                                     THEN 'Judiciary'
                                     WHEN TCM3.S_Center_Code LIKE 'IAS T%'
                                     THEN 'IAS'
                                     WHEN TCM3.S_Center_Code = 'BRST'
                                     THEN 'AIPT'
                                     WHEN TCM3.S_Center_Code LIKE 'FR-%'
                                     THEN 'Franchise'
                                     ELSE 'Own'
                                END AS TypeofCentre,
                            TCM.S_Course_Name ,
                            TSD.S_Student_ID ,
                            TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name,
                                                            '') + ' '
                            + TSD.S_Last_Name AS StdName ,
                            CONVERT(DATE, TIP.Dt_Crtd_On) AS InvoiceDate ,
                            DATENAME(MONTH, TIP.Dt_Crtd_On) + ' '
                            + CAST(DATEPART(YYYY, TIP.Dt_Crtd_On) AS VARCHAR) AS InvoiceMonthYear ,
                            TIP.S_Invoice_No ,
                            CONVERT(DATE,TSD.Dt_Crtd_On) AS AdmissionDate,
                            CASE WHEN ( SELECT  TOP 1 TBR.I_Student_Detail_ID
                                        FROM    dbo.T_Booking_Record TBR
                                        WHERE   TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                AND TBR.Dt_Booking_Date <> ISNULL(TBR.Dt_Reg_Conversion_Date,
                                                              '1990-01-01')
                                      ) IS NOT NULL THEN 'YES'
                                 WHEN ( SELECT TOP 1 TBR.I_Student_Detail_ID
                                        FROM    dbo.T_Booking_Record TBR
                                        WHERE   TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                AND TBR.Dt_Booking_Date = TBR.Dt_Reg_Conversion_Date
                                      ) IS NOT NULL THEN 'NO'
                                 WHEN ( SELECT TOP 1 TBR.I_Student_Detail_ID
                                        FROM    dbo.T_Booking_Record TBR
                                        WHERE   TBR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                      ) IS NULL THEN 'NO'
                            END AS IsBooking ,
                            'New Admission/Booking' AS AdmStatus ,
                            CASE WHEN TCM3.S_Center_Code LIKE 'FR-%' THEN 'NO'
                                 WHEN TCM3.S_Center_Code NOT LIKE 'FR-%'
                                 THEN 'YES'
                            END IsOwnCentre,
                            TSD.S_Mobile_No,
                            TSBM.S_Batch_Name,
                            TSBM.Dt_BatchStartDate,
                            TISM.S_Info_Source_Name,
                            TSD.Dt_Birth_Date,
                            TICH.C_Is_LumpSum,
							ISNULL(TSD.B_HasTakenLoan,0) as HasTakenLoan,
							ISNULL(A.S_Discount_Desc,'No Discount') as DiscountType,
							B.InfoSource,
							B.InfoMedium,
							B.InfoCampaign,
							TSD.S_Email_ID,
							TUS.S_Sex_Name,
							TERD.S_Form_No,
							TIP.I_Invoice_Header_ID,
							TIP.N_Invoice_Amount+ISNULL(TIP.N_Tax_Amount,0) as PayableAmount,
							CASE WHEN TCM.I_Course_ID in (520,519,730,728) and T1.InvHeaderID IS NOT NULL THEN 1
								 WHEN TCM.I_Course_ID in (520,519,730,728) and T1.InvHeaderID IS NULL THEN 0
								 ELSE 1 END AS IsAdmission
                    FROM    dbo.T_Invoice_Parent TIP
                            INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                            INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
                            INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
                            INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                            INNER JOIN dbo.T_Centre_Master TCM3 ON TCHND.I_Center_ID = TCM3.I_Centre_Id
                            INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                            INNER JOIN dbo.T_Enquiry_Regn_Detail TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
							LEFT JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
							left join T_Discount_Type A on A.I_Discount_Type_ID=TSD.I_DiscountType_ID
							left join T_Enquiry_External_Additional_Details B on TERD.I_Enquiry_Regn_ID=B.PreEnquiryID
							left join T_User_Sex TUS on TERD.I_Sex_ID=TUS.I_Sex_ID
							left join
							(
								select A.I_Student_Detail_ID,MIN(A.I_Invoice_Header_ID) as InvHeaderID 
								from T_Invoice_Parent A
								inner join T_Invoice_Child_Header B on A.I_Invoice_Header_ID=B.I_Invoice_Header_ID
								where A.I_Parent_Invoice_ID IS NULL
								group by A.I_Student_Detail_ID
								--where B.I_Course_ID=730
							) T1 ON T1.InvHeaderID=TIP.I_Invoice_Header_ID and T1.I_Student_Detail_ID=TSD.I_Student_Detail_ID --and T1.I_Course_ID=TICH.I_Course_ID
                    WHERE   TIP.I_Status IN ( 0, 2, 1 )
                            AND TIP.I_Parent_Invoice_ID IS NULL
                --AND TSBD.I_Status IN (0,1,2)
                            AND ( TIP.Dt_Crtd_On >= @dtStartDate
                                  AND TIP.Dt_Crtd_On < DATEADD(d, 1,
                                                              @dtEndDate)
                                )
                            AND TIP.I_Centre_Id IN (
                            SELECT  fnCenter.centerID
                            FROM    fnGetCentersForReports(@sHierarchyList,
                                                           @iBrandID) fnCenter )
                            --AND CONVERT(DATE, TIP.Dt_Invoice_Date) = CONVERT(DATE, TSD.Dt_Crtd_On)
                            --AND CONVERT(DATE,TIBM.Dt_Crtd_On)=CONVERT(DATE,TSD.Dt_Crtd_On)
                            --AND TICH.I_Course_ID IS NOT NULL
							AND ISNULL(TCM.B_IsAdmissionCourse,1)=1
							--and TSD.S_Student_ID='2122/RICE/1130'
							--AND TCHND.I_Center_ID=132
							) ADM 
							where IsAdmission=1

				END

    END
