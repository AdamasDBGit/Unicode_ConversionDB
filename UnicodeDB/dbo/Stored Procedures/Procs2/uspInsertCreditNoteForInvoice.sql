CREATE PROCEDURE [dbo].[uspInsertCreditNoteForInvoice] --exec uspInsertCreditNoteForInvoice 153624
(
    @iInvoiceId INT
)
AS
BEGIN   
    SET NOCOUNT ON;
   
    CREATE TABLE #ICHNX(
        ID INT IDENTITY(1,1),
        I_Invoice_Detail_ID INT,
        I_Invoice_Header_ID INT,
        N_Amount NUMERIC(18,2)
    )

    CREATE TABLE #ICTNX(
        ID INT IDENTITY(1,1),
        I_Tax_ID INT,
        I_Invoice_Detail_ID INT,
        N_Tax_Value NUMERIC(18,2)
    )

    CREATE TABLE #ITAX(
        ID INT IDENTITY(1,1),
        I_Tax_ID INT,
        I_Invoice_Detail_ID INT,
        N_Tax_Value NUMERIC(18,2)
    )

    CREATE TABLE #RTAX(
        ID INT IDENTITY(1,1),
        I_Tax_ID INT,
        I_Invoice_Detail_ID INT,
        N_Tax_Value NUMERIC(18,2)
    )

    CREATE TABLE #TAXDiff(
        ID INT IDENTITY(1,1),
        IInv INT,
        ITax INT,
        ITaxDue NUMERIC(18,2),
        RInv INT,
        RTax INT,
        RTaxPaid NUMERIC(18,2),
        TaxDiff NUMERIC(18,2)
    )

    CREATE TABLE #ICHNW(
        ID INT IDENTITY(1,1),
        I_Invoice_Detail_ID INT,
        I_Fee_Component_ID INT,
        I_Invoice_Child_Header_ID INT,
        I_Invoice_Header_ID INT,
        I_Installment_No INT,
        Dt_Installment_Date DATETIME,
        N_Amount_Due NUMERIC(18,2),
        N_Amount_Adv NUMERIC(18,2),
        S_Invoice_Number VARCHAR(100),
        Flag_IsAdvanceTax VARCHAR(10)
    )

    INSERT INTO #ICHNW(I_Invoice_Detail_ID,I_Fee_Component_ID,I_Invoice_Child_Header_ID,I_Invoice_Header_ID,I_Installment_No,
                Dt_Installment_Date,N_Amount_Due,N_Amount_Adv,S_Invoice_Number,Flag_IsAdvanceTax)
    SELECT B.I_Invoice_Detail_ID,B.I_Fee_Component_ID,B.I_Invoice_Child_Header_ID,B.I_Invoice_Header_ID,B.I_Installment_No,B.Dt_Installment_Date,
           ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)-ISNULL(B.N_Discount_Amount,0.00),B.N_Amount_Adv_Coln, B.S_Invoice_Number, ISNULL(B.Flag_IsAdvanceTax,'N')
    FROM 
	(SELECT ICD.I_Invoice_Detail_ID,ICD.I_Fee_Component_ID,ICD.I_Invoice_Child_Header_ID,ICH.I_Invoice_Header_ID,ICD.I_Installment_No,ICD.Dt_Installment_Date,
           ICD.N_Amount_Due,ICD.N_Discount_Amount,ICD.N_Due,ICD.I_Display_Fee_Component_ID,ICD.I_Sequence,ICD.N_Amount_Adv_Coln,ICD.Flag_IsAdvanceTax,ICD.S_Invoice_Number,ICD.Tmp_AutoIdTag
           --,SUM(ITax.N_Tax_Value) AS N_Tax_Value
    FROM T_Invoice_Child_Detail ICD
    INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
    INNER JOIN T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
    --INNER JOIN T_Invoice_Detail_Tax AS ITax ON ICD.I_Invoice_Detail_ID=ITax.I_Invoice_Detail_ID
    WHERE IP.I_Invoice_Header_ID = @iInvoiceId
    AND ISNULL(ICD.Flag_IsAdvanceTax,'N') <> 'Y'
    ) B
    LEFT JOIN
    (SELECT RCD.I_Invoice_Detail_ID, SUM(ISNULL(RCD.N_Amount_Paid,0)) N_Amount_Paid
    FROM T_Receipt_Header RH
    INNER JOIN T_Receipt_Component_Detail RCD ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
    --INNER JOIN T_Receipt_Tax_Detail AS RTax ON RCD.I_Invoice_Detail_ID=RTax.I_Invoice_Detail_ID
    WHERE RH.I_Invoice_Header_ID = @iInvoiceId
    AND ISNULL(RH.I_Status,0)<>0
    GROUP BY RCD.I_Invoice_Detail_ID) A   
    ON B.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
    WHERE (ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)-ISNULL(B.N_Discount_Amount,0.00)) >= 0
    ORDER BY B.I_Installment_No ASC

    INSERT INTO #ICHNX(I_Invoice_Detail_ID,I_Invoice_Header_ID,N_Amount)
    SELECT IC.I_Invoice_Detail_ID, IC.I_Invoice_Header_ID,SUM(ISNULL(N_Amount,0))
    FROM #ICHNW IC
    INNER JOIN T_Credit_Note_Invoice_Child_Detail CN ON (IC.I_Invoice_Header_ID = CN.I_Invoice_Header_ID AND IC.I_Invoice_Detail_ID = CN.I_Invoice_Detail_ID)
    GROUP BY IC.I_Invoice_Detail_ID, IC.I_Invoice_Header_ID

    INSERT INTO #ICTNX(I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value)
    SELECT CNT.I_Tax_ID, CNT.I_Invoice_Detail_ID,SUM(ISNULL(CNT.N_Tax_Value,0))
    FROM T_Credit_Note_Invoice_Child_Detail_Tax CNT
    INNER JOIN T_Credit_Note_Invoice_Child_Detail CN ON CNT.I_Credit_Note_Invoice_Child_Detail_ID = CN.I_Credit_Note_Invoice_Child_Detail_ID
    INNER JOIN #ICHNW IC ON (IC.I_Invoice_Header_ID = CN.I_Invoice_Header_ID AND IC.I_Invoice_Detail_ID = CN.I_Invoice_Detail_ID)
    GROUP BY CNT.I_Tax_ID, CNT.I_Invoice_Detail_ID

    INSERT INTO #ITAX(I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value)
    SELECT ITax.I_Tax_ID, ICD.I_Invoice_Detail_ID,SUM(ISNULL(ITax.N_Tax_Value,0))
    FROM
    T_Invoice_Child_Detail ICD
    INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
    INNER JOIN T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
    INNER JOIN T_Invoice_Detail_Tax AS ITax ON ICD.I_Invoice_Detail_ID=ITax.I_Invoice_Detail_ID
    --INNER JOIN #ICHNW IC ON (IC.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID AND IC.I_Invoice_Detail_ID = ITax.I_Invoice_Detail_ID)
    WHERE ICH.I_Invoice_Header_ID = @iInvoiceId
    AND ISNULL(ICD.Flag_IsAdvanceTax,'N') <> 'Y'
    GROUP BY ITax.I_Tax_ID, ICD.I_Invoice_Detail_ID
    order by ICD.I_Invoice_Detail_ID

    --select * from #ITAX

    INSERT INTO #RTAX(I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value)
    SELECT RTax.I_Tax_ID, RCD.I_Invoice_Detail_ID,SUM(ISNULL(RTax.N_Tax_Paid,0))
    FROM T_Receipt_Header RH
    INNER JOIN T_Receipt_Component_Detail RCD ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
    INNER JOIN T_Receipt_Tax_Detail AS RTax ON RCD.I_Invoice_Detail_ID=RTax.I_Invoice_Detail_ID
    AND RCD.I_Receipt_Comp_Detail_ID=RTax.I_Receipt_Comp_Detail_ID
    --INNER JOIN #ICHNW IC ON (IC.I_Invoice_Header_ID = RH.I_Invoice_Header_ID AND IC.I_Invoice_Detail_ID = RTax.I_Invoice_Detail_ID)
    WHERE RH.I_Invoice_Header_ID = @iInvoiceId
    AND ISNULL(RH.I_Status,0)<>0
    GROUP BY RTax.I_Tax_ID, RCD.I_Invoice_Detail_ID
    order by RCD.I_Invoice_Detail_ID

    --select * from #RTAX

    INSERT INTO #TAXDiff(IInv,ITax,ITaxDue,RInv,RTax,RTaxPaid,TaxDiff)
    SELECT IT.I_Invoice_Detail_ID AS IInv,IsNull(IT.I_Tax_ID,0) AS ITax,ISNULL(IT.N_Tax_Value,0) AS ITaxDue
    ,RT.I_Invoice_Detail_ID AS RInv,IsNull(RT.I_Tax_ID,0) AS RTax,ISNULL(RT.N_Tax_Value,0) AS RTaxPaid
    --,(CASE WHEN IT.N_Tax_Value=0 THEN (IsNull(RT.N_Tax_Value,0)-IsNull(IT.N_Tax_Value,0)) ELSE (IsNull(IT.N_Tax_Value,0)-IsNull(RT.N_Tax_Value,0)) END)  AS TaxDiff
    ,IsNull((IsNull(IT.N_Tax_Value,0)-IsNull(RT.N_Tax_Value,0)),0)  AS TaxDiff
    FROM #ITAX AS IT
    LEFT OUTER JOIN #RTAX AS RT ON IT.I_Invoice_Detail_ID=RT.I_Invoice_Detail_ID and IT.I_Tax_ID=RT.I_Tax_ID
    --Where (CASE WHEN IT.N_Tax_Value=0 THEN (IsNull(RT.N_Tax_Value,0)-IsNull(IT.N_Tax_Value,0)) ELSE (IsNull(IT.N_Tax_Value,0)-IsNull(RT.N_Tax_Value,0)) END)>0
    --Where IsNull((IsNull(IT.N_Tax_Value,0)-IsNull(RT.N_Tax_Value,0)),0)>0
    Where IsNull((IsNull(IT.N_Tax_Value,0)-IsNull(RT.N_Tax_Value,0)),0)<>0
    --where IT.I_Invoice_Detail_ID=595301
    order by IT.I_Invoice_Detail_ID

    --select * from #TAXDiff

    DECLARE @row INT = 1
    DECLARE @count INT

    DECLARE @I_Invoice_Detail_ID INT
    DECLARE @I_Fee_Component_ID INT
    DECLARE @I_Invoice_Child_Header_ID INT
    DECLARE @I_Invoice_Header_ID INT
    DECLARE @I_Installment_No INT
    DECLARE @Dt_Installment_Date DATETIME
    DECLARE @N_Amount_Due NUMERIC(18,2)
    DECLARE @N_Amount_Adv NUMERIC(18,2)
    DECLARE @S_Invoice_Number VARCHAR(100)
    DECLARE @Flag_IsAdvanceTax VARCHAR(10)

    ----- TAX DIFF -----
    --Declare @TotalInvTax NUMERIC(18,2)
    --Declare @TotalRcvTax NUMERIC(18,2)
    Declare @TaxDiff NUMERIC(18,2)
    Declare @ZeroTaxID INT
    Declare @TotalTaxID INT
    SET @TotalTaxID=0
    SET @ZeroTaxID=0
    ----- TAX DIFF -----

    DECLARE @N_CN_Amount NUMERIC(18,2)
    DECLARE @I_Credit_Note_Invoice_Child_Detail_ID INT


    SELECT @count = COUNT(ID) FROM #ICHNW

    WHILE (@row <= @count)
    BEGIN
        SELECT @I_Invoice_Detail_ID = I_Invoice_Detail_ID,
               @I_Fee_Component_ID = I_Fee_Component_ID,
               @I_Invoice_Child_Header_ID = I_Invoice_Child_Header_ID,
               @I_Invoice_Header_ID = I_Invoice_Header_ID,
               @I_Installment_No = I_Installment_No,
               @Dt_Installment_Date = Dt_Installment_Date,
               @N_Amount_Due = N_Amount_Due,
               @N_Amount_Adv = N_Amount_Adv,
               @S_Invoice_Number = S_Invoice_Number,
               @Flag_IsAdvanceTax = Flag_IsAdvanceTax
        FROM #ICHNW WHERE ID = @row
        AND ((N_Amount_Due>0 AND N_Amount_Adv>0) OR (N_Amount_Due>=0 AND N_Amount_Adv=0))
       
        Select @TaxDiff= SUM(TaxDiff) From #TAXDiff Where IInv=@I_Invoice_Detail_ID

        SET @ZeroTaxID=(Select COUNT(*) From #TAXDiff Where IInv=@I_Invoice_Detail_ID AND RTax=0)
        SET @TotalTaxID=(Select COUNT(*) From #TAXDiff Where IInv=@I_Invoice_Detail_ID)

       

        SET @N_CN_Amount = 0
        SELECT @N_CN_Amount = SUM(ISNULL(N_Amount,0.00)) FROM #ICHNX
        WHERE I_Invoice_Header_ID = @I_Invoice_Header_ID AND I_Invoice_Detail_ID = @I_Invoice_Detail_ID
       
        IF(((ISNULL(@N_Amount_Due,0) - ISNULL(@N_CN_Amount,0))>0) or @TaxDiff>0)
        BEGIN
           
            EXEC dbo.uspGenerateInvoiceNumberForCreditNote @I_Invoice_Header_ID, @I_Installment_No, @Dt_Installment_Date, @S_Invoice_Number OUTPUT       
           

           
            INSERT INTO T_Credit_Note_Invoice_Child_Detail(I_Invoice_Header_ID,I_Invoice_Detail_ID,S_Invoice_Number, Dt_Crtd_On, N_Amount, N_Amount_Due, N_Amount_Adv)
            VALUES(@I_Invoice_Header_ID,@I_Invoice_Detail_ID, @S_Invoice_Number, GETDATE(), (ISNULL(@N_Amount_Due,0) - ISNULL(@N_CN_Amount,0)), (ISNULL(@N_Amount_Due,0) - ISNULL(@N_CN_Amount,0)), @N_Amount_Adv)
           
           
            SET @I_Credit_Note_Invoice_Child_Detail_ID = SCOPE_IDENTITY()           
           
            IF(@Flag_IsAdvanceTax = 'Y')
                BEGIN
                    INSERT INTO T_Credit_Note_Invoice_Child_Detail_Tax(I_Credit_Note_Invoice_Child_Detail_ID,I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value)
                    SELECT @I_Credit_Note_Invoice_Child_Detail_ID, IDT.I_Tax_ID, IDT.I_Invoice_Detail_ID, SUM(IDT.N_Tax_Value_Scheduled) - SUM(ISNULL(ICT.N_Tax_Value,0))
                    FROM T_Invoice_Detail_Tax IDT
                    LEFT JOIN #ICTNX ICT  ON (IDT.I_Tax_ID = ICT.I_Tax_ID AND IDT.I_Invoice_Detail_ID = ICT.I_Invoice_Detail_ID)
                    WHERE IDT.I_Invoice_Detail_ID = @I_Invoice_Detail_ID
                    GROUP BY IDT.I_Tax_ID, IDT.I_Invoice_Detail_ID
                    HAVING (SUM(IDT.N_Tax_Value_Scheduled) - SUM(ISNULL(ICT.N_Tax_Value,0))) > 0
                END
            ELSE
                BEGIN
                    --INSERT INTO T_Credit_Note_Invoice_Child_Detail_Tax(I_Credit_Note_Invoice_Child_Detail_ID,I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value)
                    --SELECT @I_Credit_Note_Invoice_Child_Detail_ID, B.I_Tax_ID, B.I_Invoice_Detail_ID, ISNULL(SUM(B.N_Tax_Value),0)
                    --FROM(
                    --    SELECT TAX.I_Tax_ID, @I_Invoice_Detail_ID AS I_Invoice_Detail_ID,
                    --    CAST((ISNULL(@N_Amount_Due,0) - ISNULL(@N_CN_Amount,0)) * TAX.N_Tax_Rate / 100.00 AS NUMERIC(18,2)) AS N_Tax_Value
                    --    FROM
                    --    (SELECT TCFC.N_Tax_Rate, TM.I_Tax_ID
                    --    FROM (select * from dbo.T_Tax_Master) AS TM
                    --    INNER JOIN (select * from dbo.T_Tax_Country_Fee_Component where I_Fee_Component_ID=@I_Fee_Component_ID) AS TCFC
                    --        ON (TM.I_Tax_ID = TCFC.I_Tax_ID
                    --            AND TM.I_Country_ID = TCFC.I_Country_ID AND TCFC.N_Tax_Rate > 0
                    --            AND @Dt_Installment_Date BETWEEN TCFC.Dt_Valid_From AND TCFC.Dt_Valid_To
                    --            )
                    --    ) TAX
                    --) B
                    --GROUP BY B.I_Tax_ID, B.I_Invoice_Detail_ID

                    IF(@N_Amount_Due>0 and @TaxDiff>0)
                      BEGIN
                   
                       

                        --IF(@ZeroTaxID>0)
                        IF(@ZeroTaxID=@TotalTaxID)
                        BEGIN
                             INSERT INTO T_Credit_Note_Invoice_Child_Detail_Tax(I_Credit_Note_Invoice_Child_Detail_ID,I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value)
                             select @I_Credit_Note_Invoice_Child_Detail_ID,(CASE WHEN ITax=0 THEN RTax ELSE ITax END),IInv
                            ,CAST((((ISNULL(@N_Amount_Due,0) - ISNULL(@N_CN_Amount,0))*(tcfc.N_Tax_Rate))/100) AS NUMERIC(18,2)) AS TaxDiff--,TaxDiff 
                            from #TAXDiff as tf Inner Join dbo.T_Tax_Master as tm on (CASE WHEN ITax=0 THEN RTax ELSE ITax END)=tm.I_Tax_ID
                            Inner Join T_Tax_Country_Fee_Component AS tcfc on TM.I_Tax_ID = tcfc.I_Tax_ID
                            AND TM.I_Country_ID = tcfc.I_Country_ID AND tcfc.N_Tax_Rate > 0
                            AND I_Fee_Component_ID=@I_Fee_Component_ID
                            AND @Dt_Installment_Date BETWEEN tcfc.Dt_Valid_From AND tcfc.Dt_Valid_To
                            WHERE IInv=@I_Invoice_Detail_ID


                        END
                       ELSE
                        BEGIN
                            INSERT INTO T_Credit_Note_Invoice_Child_Detail_Tax(I_Credit_Note_Invoice_Child_Detail_ID,I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value)
                            select @I_Credit_Note_Invoice_Child_Detail_ID,(CASE WHEN ITax=0 THEN RTax ELSE ITax END),IInv,TAXDiff  from #TAXDiff
                            WHERE IInv=@I_Invoice_Detail_ID

                        END

                       

                      END
                    IF(@N_Amount_Due=0 and @TaxDiff>0)
                      BEGIN

                        INSERT INTO T_Credit_Note_Invoice_Child_Detail_Tax(I_Credit_Note_Invoice_Child_Detail_ID,I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value)
                        select @I_Credit_Note_Invoice_Child_Detail_ID,(CASE WHEN ITax=0 THEN RTax ELSE ITax END),IInv,TAXDiff   from #TAXDiff
                        WHERE IInv=@I_Invoice_Detail_ID

                      END

                END
        END

        SET @row = @row + 1
    END
    DROP TABLE #ICHNW   
    DROP TABLE #ICHNX
    DROP TABLE #ICTNX
   
    DROP TABLE #ITAX
    DROP TABLE #RTAX
    DROP TABLE #TAXDiff
END
