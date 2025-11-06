    
--exec [REPORT].[uspgetEnquiryReport] null,null,'2012-12-31','2013-12-31','sa'    
CREATE PROCEDURE [REPORT].[uspgetEnquiryReport]
    (
      @sHierarchyList VARCHAR(MAX) = NULL ,
      @iBrandID INT = NULL ,
      @StartDate DATE = NULL ,
      @EndDate DATE = NULL ,
      @S_Crtd_By VARCHAR(20) = NULL    
       
    )
AS 
    BEGIN      
        IF ( UPPER(@S_Crtd_By) = '--SELECT--'
             OR UPPER(@S_Crtd_By) = 'ALL'
           ) 
            BEGIN
                SET @S_Crtd_By = NULL
            END
        SELECT  --VReport.DisplayDate ,
                VReport.ID ,
                VReport.name ,
                SUM(isPreEnquiry) PreEnquiry ,
                SUM(isEnquiry) Enquiry ,
                SUM(isForm) Form ,
                SUM(isAdmission) Admission,
                instanceChain
        FROM    ( (SELECT  -- CONVERT(VARCHAR(10), terd.dt_crtd_on, 105) AS DisplayDate ,
                            TUM.S_Login_ID ID ,
                            TUM.S_First_Name + ' ' + ISNULL(TUM.s_middle_name,
                                                            '') + ' '
                            + ISNULL(TUM.s_last_name, '') name ,
                            CASE WHEN ( terd.I_Enquiry_Status_Code IS NULL
                                        OR B_IsPreEnquiry = 1
                                      ) THEN 1
                                 ELSE 0
                            END isPreEnquiry ,
                            CASE WHEN terd.I_Enquiry_Status_Code IS NOT NULL
                                 THEN 1
                                 ELSE 0
                            END isEnquiry ,
                            0 AS isForm ,
                            0 AS isAdmission,
                            FN2.instanceChain
                   FROM     T_Enquiry_Regn_Detail terd
                            INNER JOIN T_User_Master TUM ON TUM.S_Login_ID = terd.S_Crtd_By
                            INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON terd.I_Centre_Id = FN1.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                   WHERE    ISNULL(terd.Enquiry_Date,terd.dt_crtd_on) BETWEEN ISNULL(@StartDate,
                                                              CONVERT(DATE, ISNULL(terd.Enquiry_Date,terd.dt_crtd_on)))
                                                           AND
                                                              ISNULL(@EndDate,
                                                              CONVERT(DATE, ISNULL(terd.Enquiry_Date,terd.dt_crtd_on)))
                            AND terd.S_Crtd_By = ISNULL(@S_Crtd_By,
                                                        terd.S_Crtd_By)
                            AND terd.I_PreEnquiryFor = 1
                            AND terd.I_Centre_Id IN (
                            SELECT  fgcfr.centerID
                            FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) AS fgcfr ))
                  UNION ALL
                  ( SELECT -- CONVERT(VARCHAR(10), trh.Dt_Crtd_On, 105) AS DisplayDate ,
                            TUM.S_Login_ID ID ,
                            TUM.S_First_Name + ' ' + ISNULL(TUM.s_middle_name,
                                                            '') + ' '
                            + ISNULL(TUM.s_last_name, '') name ,
                            0 PreEnquiry ,
                            0 Enquiry ,
                            1 AS isform ,
                            0 AS isAdmission,
                            fn2.instanceChain
                    FROM    dbo.T_Receipt_Header AS trh
                            INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd ON trh.I_Enquiry_Regn_ID = terd.I_Enquiry_Regn_ID
                            INNER JOIN T_User_Master TUM ON TUM.S_Login_ID = trh.S_Crtd_By
                            INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON trh.I_Centre_Id = FN1.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                    WHERE   (trh.I_Status = 1 and terd.S_Form_No is not null)
                            AND I_Receipt_Type IN (32,57)
                            AND trh.dt_crtd_on BETWEEN ISNULL(@StartDate,
                                                              CONVERT(DATE, trh.dt_crtd_on))
                                                              AND
                                                              ISNULL(@EndDate,
                                                              CONVERT(DATE, trh.dt_crtd_on))
                            AND trh.S_Crtd_By = ISNULL(@S_Crtd_By,
                                                       trh.S_Crtd_By)
                            AND trh.I_Centre_Id IN (
                            SELECT  fgcfr.centerID
                            FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) AS fgcfr )
                  )
                  UNION ALL
                  ( SELECT  --CONVERT(VARCHAR(10), TSD.Dt_Crtd_On, 105) AS DisplayDate ,
                            TUM.S_Login_ID ID ,
                            TUM.S_First_Name + ' ' + ISNULL(TUM.s_middle_name,
                                                            '') + ' '
                            + ISNULL(TUM.s_last_name, '') name ,
                            0 PreEnquiry ,
                            0 Enquiry ,
                            0 AS isform ,
                            1 AS isAdmission,
                            FN2.instanceChain
                    FROM    --dbo.T_Invoice_Parent AS tip
                            T_Student_Detail TSD 
                            INNER JOIN T_Enquiry_Regn_Detail TERD ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
                            INNER JOIN T_User_Master TUM ON TUM.S_Login_ID = TERD.S_Crtd_By
                            INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON TERD.I_Centre_Id = FN1.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                    WHERE   ISNULL(terd.Enquiry_Date,terd.dt_crtd_on)>ISNULL(@StartDate,
                                                              CONVERT(DATE, ISNULL(terd.Enquiry_Date,terd.dt_crtd_on)))
                                                          AND ISNULL(terd.Enquiry_Date,terd.dt_crtd_on)<ISNULL(DATEADD(d,1,@EndDate),
                                                              CONVERT(DATE, ISNULL(terd.Enquiry_Date,terd.dt_crtd_on)))
                            AND TERD.S_Crtd_By = ISNULL(@S_Crtd_By,
                                                        TERD.S_Crtd_By)
                            AND TERD.I_Enquiry_Status_Code = 3
                            AND TERD.I_Centre_Id IN (
                            SELECT  fgcfr.centerID
                            FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) AS fgcfr )
                  )
                ) VReport
        
        
        /*
        GROUP BY VReport.DisplayDate ,
                VReport.ID ,
                VReport.name, 
				VReport.instanceChain
       
         */
         
         GROUP BY VReport.instanceChain,
				 VReport.ID ,
                VReport.name
                 --VReport.DisplayDate               
    END
