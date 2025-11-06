


CREATE PROCEDURE [dbo].[uspCanculateTaxDifference]
    (
      @I_Invoice_Header_ID INT ,
      @I_Fee_Component_ID INT ,
      @I_Installment_No INT ,
      @I_Course_FeePlan_ID INT

    )
AS 
    BEGIN
	
--SET @I_Invoice_Header_ID = 40513
--SET @I_Fee_Component_ID = 42
--SET @I_Installment_No = 1
--SET @I_Course_FeePlan_ID = 34769


        DECLARE @oldtaxrate NUMERIC(20, 11)
        DECLARE @Newtaxrate NUMERIC(20, 11)
        DECLARE @Factor NUMERIC(20, 11)

        SET @Factor = 1

        SELECT  @oldtaxrate = ISNULL(SUM(TD.N_Tax_Rate), 0)
        FROM    T_Tax_Country_Fee_Component TD
                INNER JOIN ( SELECT TOP 1
                                    CD.Dt_Installment_Date ,
                                    CD.I_Fee_Component_ID
                             FROM   dbo.T_Invoice_Child_Header CH
                                    INNER JOIN dbo.T_Invoice_Child_Detail CD ON CH.I_Invoice_Child_Header_ID = CD.I_Invoice_Child_Header_ID
                             WHERE  CH.I_Invoice_Header_ID = @I_Invoice_Header_ID
                                    AND CD.I_Fee_Component_ID = @I_Fee_Component_ID
                                    AND CD.I_Installment_No = @I_Installment_No
                                    AND CH.I_Course_FeePlan_ID = @I_Course_FeePlan_ID
                           ) vw ON TD.I_Fee_Component_ID = vw.I_Fee_Component_ID
                                   AND vw.Dt_Installment_Date >= TD.Dt_Valid_From
                                   AND vw.Dt_Installment_Date <= TD.Dt_Valid_To
                                   AND TD.I_Status = 1


        SELECT  @Newtaxrate = ISNULL(SUM(TD.N_Tax_Rate), 0)
        FROM    T_Tax_Country_Fee_Component TD
        WHERE   TD.I_Fee_Component_ID = @I_Fee_Component_ID
                AND CONVERT(DATE, GETDATE()) >= TD.Dt_Valid_From
                AND CONVERT(DATE, GETDATE()) <= TD.Dt_Valid_To
                AND TD.I_Status = 1
		
        IF NOT EXISTS ( SELECT TOP 1
                                CD.Dt_Installment_Date ,
                                CD.I_Fee_Component_ID
                        FROM    dbo.T_Invoice_Child_Header CH
                                INNER JOIN dbo.T_Invoice_Child_Detail CD ON CH.I_Invoice_Child_Header_ID = CD.I_Invoice_Child_Header_ID
                        WHERE   CH.I_Invoice_Header_ID = @I_Invoice_Header_ID
                                AND CD.I_Fee_Component_ID = @I_Fee_Component_ID
                                AND CD.I_Installment_No = @I_Installment_No
                                AND CH.I_Course_FeePlan_ID = @I_Course_FeePlan_ID ) 
            BEGIN
                IF NOT EXISTS ( SELECT TOP 1
                                        CD.Dt_Installment_Date ,
                                        CD.I_Fee_Component_ID
                                FROM    dbo.T_Invoice_Child_Header CH
                                        INNER JOIN dbo.T_Invoice_Child_Detail CD ON CH.I_Invoice_Child_Header_ID = CD.I_Invoice_Child_Header_ID
                                WHERE   CH.I_Invoice_Header_ID = @I_Invoice_Header_ID
                                        AND CD.I_Fee_Component_ID = @I_Fee_Component_ID
                                        AND CD.I_Installment_No >= @I_Installment_No
                                        AND CH.I_Course_FeePlan_ID = @I_Course_FeePlan_ID ) 
                    BEGIN
                        SET @oldtaxrate = NULL
                    END
                ELSE 
                    BEGIN
                        DECLARE @vDt_Installment_Date DATE
                        DECLARE @vI_Installment_No_New INT
                        DECLARE @vDt_Installment_Date_Check DATE
                        SELECT TOP 1
                                @vDt_Installment_Date = CD.Dt_Installment_Date ,
                                @vI_Installment_No_New = CD.I_Installment_No
                        FROM    dbo.T_Invoice_Child_Header CH
                                INNER JOIN dbo.T_Invoice_Child_Detail CD ON CH.I_Invoice_Child_Header_ID = CD.I_Invoice_Child_Header_ID
                        WHERE   CH.I_Invoice_Header_ID = @I_Invoice_Header_ID
                                AND CD.I_Fee_Component_ID = @I_Fee_Component_ID
                                AND CD.I_Installment_No >= @I_Installment_No
                                AND CH.I_Course_FeePlan_ID = @I_Course_FeePlan_ID
                        ORDER BY CD.I_Installment_No
                                        
                        SELECT  @vDt_Installment_Date_Check = DATEADD(dd,
                                                              ( @I_Installment_No
                                                              - @vI_Installment_No_New ),
                                                              @vDt_Installment_Date)
                                        
                        SELECT  @oldtaxrate = ISNULL(SUM(TD.N_Tax_Rate), 0)
                        FROM    T_Tax_Country_Fee_Component TD
                        WHERE   TD.I_Fee_Component_ID = @I_Fee_Component_ID
                                AND CONVERT(DATE, @vDt_Installment_Date_Check) >= TD.Dt_Valid_From
                                AND CONVERT(DATE, @vDt_Installment_Date_Check) <= TD.Dt_Valid_To
                                AND TD.I_Status = 1
                    END	
            END
		
        IF @Newtaxrate <> 0
            AND @oldtaxrate IS NOT NULL 
            BEGIN
                SET @Factor = ( @oldtaxrate + 100 ) / ( @Newtaxrate + 100 )
            END
        SELECT  @Newtaxrate AS Newtaxrate ,
                @oldtaxrate AS oldtaxrate ,
                @Factor AS Factor
        
    END
