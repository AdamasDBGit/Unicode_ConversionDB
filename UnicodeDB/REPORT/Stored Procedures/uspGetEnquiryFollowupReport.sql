CREATE PROCEDURE [REPORT].[uspGetEnquiryFollowupReport]
    (
      @sHierarchyID VARCHAR(MAX) ,
      @StartDate DATE ,
      @EndDate DATE ,
      @iBrandID INT ,
      @iFlag INT
    )
AS
    BEGIN

        IF ( @iFlag = 0 )
            BEGIN
                SELECT  T1.* ,
                        CONVERT(DATE, T2.Dt_Receipt_Date) AS FormSaleDate,
                        ISNULL(T3.AmtCollected,0) AS AmountCollected
                FROM    ( SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TUM.S_First_Name + ' '
                                    + ISNULL(TUM.S_Middle_Name, '') + ' '
                                    + TUM.S_Last_Name AS CouncellorName ,
                                    TERD.S_First_Name + ' '
                                    + ISNULL(TERD.S_Middle_Name, '') + ' '
                                    + TERD.S_Last_Name AS StudentName ,
                                    COALESCE(TERD.S_Mobile_No, TERD.S_Phone_No,
                                             TERD.S_Guardian_Mobile_No, '') AS ContactNo ,
                                    TERD.S_Father_Name,
                                    TERD.S_Mother_Name,         
                                    '`'+TERD.S_Curr_Address1 AS CurrAddress ,
                                    TERD.S_Curr_Pincode AS Pincode ,
                                    TERD.I_Enquiry_Regn_ID AS PreEnquiry ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code IS NOT NULL
                                         THEN TERD.I_Enquiry_Regn_ID
                                         ELSE NULL
                                    END AS Enquiry ,
                                    CASE WHEN TERD.S_Form_No IS NOT NULL
                                         THEN TERD.S_Form_No
                                         ELSE NULL
                                    END AS FormSale ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code = 3
                                         THEN TSD.S_Student_ID
                                         ELSE NULL
                                    END AS Admission ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code=1 OR TERD.I_Enquiry_Status_Code=3 THEN  CONVERT(DATE, ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) END AS EnquiryDate ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code=1 OR TERD.I_Enquiry_Status_Code=3 THEN DATENAME(MONTH,ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On))+' '+CAST(DATEPART(YYYY,ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) AS VARCHAR) END AS  EnqMonthYear,
                                    CONVERT(DATE, TSD.Dt_Crtd_On) AS DateofAdmission ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code IS NULL THEN CONVERT(DATE,TERD.Dt_Crtd_On) ELSE CONVERT(DATE, ISNULL(TERD.PreEnquiryDate,TERD.Dt_Crtd_On)) END AS PreEnquiryDate,
                                    CASE WHEN TERD.I_Enquiry_Status_Code IS NULL THEN DATENAME(MONTH,CONVERT(DATE,ISNULL(TERD.PreEnquiryDate,TERD.Dt_Crtd_On)))+' '+CAST(DATEPART(YYYY,CONVERT(DATE,ISNULL(TERD.PreEnquiryDate,TERD.Dt_Crtd_On))) AS VARCHAR)
                                    --ELSE DATENAME(MONTH,ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On))+' '+CAST(DATEPART(YYYY,ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) AS VARCHAR) 
                                    END AS PreEnqMonthYear,
                                    CASE WHEN TERD.I_Relevence_ID = 0
                                         THEN 'Not Relevent'
                                         WHEN TERD.I_Relevence_ID = 1
                                         THEN 'Relevent'
                                    END AS Relevence ,
                                    TISM.S_Info_Source_Name ,
                                    TCM.S_Course_Name AS EnquiryCourse ,
                                    CASE WHEN ISNULL(TBR.Dt_Booking_Date,
                                                     '1990-01-01') = ISNULL(TBR.Dt_Reg_Conversion_Date,
                                                              '1990-01-01')
                                         THEN 'NO'
                                         WHEN ISNULL(TBR.Dt_Booking_Date,
                                                     '1990-01-01') <> ISNULL(TBR.Dt_Reg_Conversion_Date,
                                                              '1990-01-01')
                                         THEN 'YES'
                                         ELSE 'NO'
                                    END AS IsPartPaymentAdmission ,
                                    CAST(DATEPART(dd,
                                                  TBR.Dt_Reg_Conversion_Date) AS VARCHAR)
                                    + '/'
                                    + CAST(TBR.Dt_Reg_Conversion_Date AS CHAR(3))
                                    + '/'
                                    + CAST(DATEPART(YYYY,
                                                    TBR.Dt_Reg_Conversion_Date) AS VARCHAR) FullPaymentMadeOn,
                                    ED.S_Education_CurrentStatus_Description,
									TEEAD.MobileNo as ExtMobileNo,
									TEEAD.EmailID as ExtEmailID,
									TEEAD.InfoCampaign,
									TEEAD.InfoMedium,
									TEEAD.InfoSource,
									TEEAD.LeadCreatedBy,
									TEEAD.Counsellor,
									TEEAD.UserRegistrationDate,
									TEEAD.Origin,
									TEEAD.PrimaryTrafficChannel,
									TEEAD.PrimaryTrafficChannel+'/'+TEEAD.InfoSource+'/'+TEEAD.InfoMedium+'/'+TEEAD.InfoCampaign as InfoSourceMediumCampaign,
									TEEAD.SalesDisposition,
									TEEAD.DateofMaturitySales,
									TUS.S_Sex_Name
                          FROM      dbo.T_Enquiry_Regn_Detail TERD WITH (NOLOCK)
                                    INNER JOIN dbo.T_User_Master TUM WITH (NOLOCK) ON ISNULL(TERD.Enquiry_Crtd_By,TERD.S_Crtd_By) = TUM.S_Login_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND WITH (NOLOCK) ON TERD.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Enquiry_Course TEC WITH (NOLOCK) ON TERD.I_Enquiry_Regn_ID = TEC.I_Enquiry_Regn_ID
                                    INNER JOIN dbo.T_Course_Master TCM WITH (NOLOCK) ON TEC.I_Course_ID = TCM.I_Course_ID
                                    LEFT JOIN dbo.T_Information_Source_Master TISM WITH (NOLOCK) ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
                                    LEFT JOIN dbo.T_Student_Detail TSD WITH (NOLOCK) ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
                                    LEFT JOIN dbo.T_Booking_Record TBR WITH (NOLOCK) ON TSD.I_Student_Detail_ID = TBR.I_Student_Detail_ID
									Left join T_Enquiry_External_Additional_Details TEEAD WITH (NOLOCK) on TERD.I_Enquiry_Regn_ID=TEEAD.PreEnquiryID
									LEFT JOIN T_User_Sex TUS WITH (NOLOCK) on TERD.I_Sex_ID=TUS.I_Sex_ID
                                    LEFT JOIN 
                                    (
                                    SELECT TEECS.I_Enquiry_Regn_ID,TECS.S_Education_CurrentStatus_Description 
									FROM dbo.T_Enquiry_Education_CurrentStatus AS TEECS WITH (NOLOCK)
                                    INNER JOIN dbo.T_Education_CurrentStatus AS TECS WITH (NOLOCK) ON TECS.I_Education_CurrentStatus_ID = TEECS.I_Education_CurrentStatus_ID
                                    ) ED ON ED.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                          WHERE     ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On) >= @StartDate
                                    AND ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On) < DATEADD(d, 1,
                                                              @EndDate)
                                    AND TCHND.I_Center_ID IN (
                                    SELECT  centerID
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyID,
                                                              @iBrandID) FGCFR )
                        ) T1
                        LEFT JOIN ( SELECT  TRH.I_Enquiry_Regn_ID ,
                                            TRH.Dt_Receipt_Date
                                    FROM    dbo.T_Receipt_Header TRH WITH (NOLOCK)
                                    WHERE   I_Receipt_Type IN ( 31, 32, 50, 51,
                                                              57, 85 )
                                            AND I_Status = 1
                                  ) T2 ON T1.PreEnquiry = T2.I_Enquiry_Regn_ID
                        LEFT JOIN ( SELECT  TSD2.I_Enquiry_Regn_ID ,
                                            SUM(ISNULL(TRH2.N_Receipt_Amount,
                                                       0)
                                                + ISNULL(TRH2.N_Tax_Amount, 0)) AS AmtCollected
                                    FROM    dbo.T_Receipt_Header AS TRH2 WITH (NOLOCK)
                                            INNER JOIN dbo.T_Student_Detail AS TSD2 WITH (NOLOCK) ON TSD2.I_Student_Detail_ID = TRH2.I_Student_Detail_ID
                                    WHERE   TRH2.I_Invoice_Header_ID IS NOT NULL
                                            AND TRH2.I_Status = 1
                                            AND TRH2.Dt_Crtd_On < DATEADD(d, 1,
                                                              @EndDate)
                                    GROUP BY TSD2.I_Enquiry_Regn_ID                          
                                  ) T3 ON T1.PreEnquiry = T3.I_Enquiry_Regn_ID
                ORDER BY T1.I_Brand_ID ,
                        T1.I_Center_ID ,
                        T1.PreEnquiry

				OPTION (RECOMPILE)
            END
        ELSE
            BEGIN
                SELECT  T1.* ,
                        CONVERT(DATE, T2.Dt_Receipt_Date) AS FormSaleDate,
                        ISNULL(T3.AmtCollected,0) AS AmountCollected
                FROM    ( SELECT    TCHND.I_Brand_ID ,
                                    TCHND.S_Brand_Name ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TUM.S_First_Name + ' '
                                    + ISNULL(TUM.S_Middle_Name, '') + ' '
                                    + TUM.S_Last_Name AS CouncellorName ,
                                    TERD.S_First_Name + ' '
                                    + ISNULL(TERD.S_Middle_Name, '') + ' '
                                    + TERD.S_Last_Name AS StudentName ,
                                    COALESCE(TERD.S_Mobile_No, TERD.S_Phone_No,
                                             TERD.S_Guardian_Mobile_No, '') AS ContactNo ,
                                    TERD.S_Father_Name,
                                    TERD.S_Mother_Name,         
                                    TERD.S_Curr_Address1 AS CurrAddress ,
                                    TERD.S_Curr_Pincode AS Pincode ,
                                    TERD.I_Enquiry_Regn_ID AS PreEnquiry ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code IS NOT NULL
                                         THEN TERD.I_Enquiry_Regn_ID
                                         ELSE NULL
                                    END AS Enquiry ,
                                    CASE WHEN TERD.S_Form_No IS NOT NULL
                                         THEN TERD.S_Form_No
                                         ELSE NULL
                                    END AS FormSale ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code = 3
                                         THEN TSD.S_Student_ID
                                         ELSE NULL
                                    END AS Admission ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code=1 OR TERD.I_Enquiry_Status_Code=3 THEN  CONVERT(DATE, ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) END AS EnquiryDate ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code=1 OR TERD.I_Enquiry_Status_Code=3 THEN DATENAME(MONTH,ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On))+' '+CAST(DATEPART(YYYY,ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) AS VARCHAR) END AS  EnqMonthYear,
                                    CONVERT(DATE, TSD.Dt_Crtd_On) AS DateofAdmission ,
                                    CASE WHEN TERD.I_Enquiry_Status_Code IS NULL THEN CONVERT(DATE,ISNULL(TERD.PreEnquiryDate,TERD.Dt_Crtd_On)) --ELSE CONVERT(DATE, ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) 
                                    END AS PreEnquiryDate,
                                    CASE WHEN TERD.I_Enquiry_Status_Code IS NULL THEN DATENAME(MONTH,CONVERT(DATE,ISNULL(TERD.PreEnquiryDate,TERD.Dt_Crtd_On)))+' '+CAST(DATEPART(YYYY,CONVERT(DATE,ISNULL(TERD.PreEnquiryDate,TERD.Dt_Crtd_On))) AS VARCHAR)
                                    --ELSE DATENAME(MONTH,ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On))+' '+CAST(DATEPART(YYYY,ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On)) AS VARCHAR) 
                                    END AS PreEnqMonthYear,
                                    CASE WHEN TERD.I_Relevence_ID = 0
                                         THEN 'Not Relevent'
                                         WHEN TERD.I_Relevence_ID = 1
                                         THEN 'Relevent'
                                    END AS Relevence ,
                                    TISM.S_Info_Source_Name ,
                                    TCM.S_Course_Name AS EnquiryCourse ,
                                    CASE WHEN ISNULL(TBR.Dt_Booking_Date,
                                                     '1990-01-01') = ISNULL(TBR.Dt_Reg_Conversion_Date,
                                                              '1990-01-01')
                                         THEN 'NO'
                                         WHEN ISNULL(TBR.Dt_Booking_Date,
                                                     '1990-01-01') <> ISNULL(TBR.Dt_Reg_Conversion_Date,
                                                              '1990-01-01')
                                         THEN 'YES'
                                         ELSE 'NO'
                                    END AS IsPartPaymentAdmission ,
                                    CAST(DATEPART(dd,
                                                  TBR.Dt_Reg_Conversion_Date) AS VARCHAR)
                                    + '/'
                                    + CAST(TBR.Dt_Reg_Conversion_Date AS CHAR(3))
                                    + '/'
                                    + CAST(DATEPART(YYYY,
                                                    TBR.Dt_Reg_Conversion_Date) AS VARCHAR) FullPaymentMadeOn,
                                    ED.S_Education_CurrentStatus_Description,
									TEEAD.MobileNo as ExtMobileNo,
									TEEAD.EmailID as ExtEmailID,
									TEEAD.InfoCampaign,
									TEEAD.InfoMedium,
									TEEAD.InfoSource,
									TEEAD.LeadCreatedBy,
									TEEAD.Counsellor,
									TEEAD.UserRegistrationDate,
									TEEAD.Origin,
									TEEAD.PrimaryTrafficChannel,
									TEEAD.PrimaryTrafficChannel+'/'+TEEAD.InfoSource+'/'+TEEAD.InfoMedium+'/'+TEEAD.InfoCampaign as InfoSourceMediumCampaign,
									TEEAD.SalesDisposition,
									TEEAD.DateofMaturitySales,
									TUS.S_Sex_Name
                          FROM      dbo.T_Enquiry_Regn_Detail TERD
                                    INNER JOIN dbo.T_User_Master TUM ON ISNULL(TERD.Enquiry_Crtd_By,TERD.S_Crtd_By) = TUM.S_Login_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TERD.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Enquiry_Course TEC ON TERD.I_Enquiry_Regn_ID = TEC.I_Enquiry_Regn_ID
                                    INNER JOIN dbo.T_Course_Master TCM ON TEC.I_Course_ID = TCM.I_Course_ID
                                    LEFT JOIN dbo.T_Information_Source_Master TISM ON TERD.I_Info_Source_ID = TISM.I_Info_Source_ID
                                    LEFT JOIN dbo.T_Student_Detail TSD ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
                                    LEFT JOIN dbo.T_Booking_Record TBR ON TSD.I_Student_Detail_ID = TBR.I_Student_Detail_ID
									Left join T_Enquiry_External_Additional_Details TEEAD on TERD.I_Enquiry_Regn_ID=TEEAD.PreEnquiryID
									LEFT JOIN T_User_Sex TUS on TERD.I_Sex_ID=TUS.I_Sex_ID
                                    LEFT JOIN 
                                    (
                                    SELECT TEECS.I_Enquiry_Regn_ID,TECS.S_Education_CurrentStatus_Description FROM dbo.T_Enquiry_Education_CurrentStatus AS TEECS
                                    INNER JOIN dbo.T_Education_CurrentStatus AS TECS ON TECS.I_Education_CurrentStatus_ID = TEECS.I_Education_CurrentStatus_ID
                                    ) ED ON ED.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                          WHERE     ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On) >= @StartDate
                                    AND ISNULL(TERD.Enquiry_Date,TERD.Dt_Crtd_On) < DATEADD(d, 1,
                                                              @EndDate)
                                    AND TCHND.I_Center_ID IN (
                                    SELECT  centerID
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyID,
                                                              @iBrandID) FGCFR )
                                    AND TERD.I_Relevence_ID = 1
                                    AND ( TERD.I_Enquiry_Status_Code IS NULL
                                          OR TERD.I_Enquiry_Status_Code = 1
                                        )
                        ) T1
                        LEFT JOIN ( SELECT  TRH.I_Enquiry_Regn_ID ,
                                            TRH.Dt_Receipt_Date
                                    FROM    dbo.T_Receipt_Header TRH
                                    WHERE   I_Receipt_Type IN ( 31, 32, 50, 51,
                                                              57, 85 )
                                            AND I_Status = 1
                                  ) T2 ON T1.PreEnquiry = T2.I_Enquiry_Regn_ID
                        LEFT JOIN ( SELECT  TSD2.I_Enquiry_Regn_ID ,
                                            SUM(ISNULL(TRH2.N_Receipt_Amount,
                                                       0)
                                                + ISNULL(TRH2.N_Tax_Amount, 0)) AS AmtCollected
                                    FROM    dbo.T_Receipt_Header AS TRH2
                                            INNER JOIN dbo.T_Student_Detail AS TSD2 ON TSD2.I_Student_Detail_ID = TRH2.I_Student_Detail_ID
                                    WHERE   TRH2.I_Invoice_Header_ID IS NOT NULL
                                            AND TRH2.I_Status = 1
                                            AND TRH2.Dt_Crtd_On < DATEADD(d, 1,
                                                              @EndDate)
                                    GROUP BY TSD2.I_Enquiry_Regn_ID                          
                                  ) T3 ON T1.PreEnquiry = T3.I_Enquiry_Regn_ID
                ORDER BY T1.I_Brand_ID ,
                        T1.I_Center_ID ,
                        T1.PreEnquiry

				OPTION (RECOMPILE)

            END

			
        
    END
