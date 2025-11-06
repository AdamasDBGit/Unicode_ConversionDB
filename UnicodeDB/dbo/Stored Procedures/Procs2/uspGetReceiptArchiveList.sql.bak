CREATE PROCEDURE [dbo].[uspGetReceiptArchiveList]  
as  
begin TRY    
;WITH    C ( I_Invoice_Header_ID, S_Invoice_No, Dt_Crtd_On, Dt_Upd_On, Dt_Invoice_Date, I_Parent_Invoice_ID, Parent_S_Invoice_No, Current_I_Invoice_Header_ID, I_Status, keyid, PKeyID )  
          AS ( SELECT   C1.I_Invoice_Header_ID ,  
                        C1.S_Invoice_No ,  
                        C1.Dt_Crtd_On ,  
                        C1.Dt_Upd_On ,  
                        C1.Dt_Invoice_Date ,  
                        C1.I_Parent_Invoice_ID ,  
                        P1.S_Invoice_No AS Parent_S_Invoice_No ,  
                        C1.I_Invoice_Header_ID AS Current_I_Invoice_Header_ID ,  
                        C1.I_Status ,  
                        1 ,  
                        ROW_NUMBER() OVER ( ORDER BY C1.I_Invoice_Header_ID )  
               FROM     dbo.T_Invoice_Parent C1  
                        INNER JOIN dbo.T_Invoice_Parent P1 ON c1.I_Parent_Invoice_ID = P1.I_Invoice_Header_ID  
               WHERE    C1.I_Status IN (1,2,3,0)  
                        AND C1.I_Parent_Invoice_ID IS NOT NULL  
               UNION ALL  
               SELECT   P.I_Invoice_Header_ID ,  
                        P.S_Invoice_No ,  
                        P.Dt_Crtd_On ,  
                        P.Dt_Upd_On ,  
                        P.Dt_Invoice_Date ,  
                        P.I_Parent_Invoice_ID ,  
                        ( SELECT    P1.S_Invoice_No  
                          FROM      dbo.T_Invoice_Parent P1  
                          WHERE     P.I_Parent_Invoice_ID = P1.I_Invoice_Header_ID  
                        ) AS Parent_S_Invoice_No ,  
                        C.Current_I_Invoice_Header_ID ,  
                        P.I_Status ,  
                        C.keyid + 1 ,  
                        C.PKeyID  
               FROM     dbo.T_Invoice_Parent AS P  
                        INNER JOIN C ON C.I_Parent_Invoice_ID = P.I_Invoice_Header_ID  
             )  
    SELECT  C.keyid ,  
            C.PKeyID ,  
            R.I_Receipt_Header_ID ,  
            R.I_Invoice_Header_ID ,  
            R.S_Receipt_No ,  
            R.Dt_Receipt_Date ,  
            C.I_Parent_Invoice_ID AS I_Parent_Invoice_ID_To_Be_Tagged ,  
            C.Parent_S_Invoice_No AS Parent_S_Invoice_No_To_Be_tagged ,  
            R.N_Receipt_Amount ,  
            ROW_NUMBER() OVER ( PARTITION BY R.I_Receipt_Header_ID ORDER BY C.keyid DESC ) AS RID ,  
            ROW_NUMBER() OVER ( ORDER BY C.PKeyID , C.keyid DESC , R.Dt_Receipt_Date ) AS UniqueID  
    INTO    #temp  
    FROM    C  
            INNER JOIN dbo.T_Receipt_Header R ON C.Current_I_Invoice_Header_ID = R.I_Invoice_Header_ID  
                                                 AND R.Dt_Receipt_Date < C.Dt_Crtd_On  
                                                 --AND CONVERT(DATE, R.Dt_Receipt_Date) >= '2013-01-01'  
                                                 --AND CONVERT(DATE, C.Dt_Invoice_Date) >= '2013-01-01'  
            LEFT JOIN dbo.T_Receipt_Header_Archive TRHA ON C.I_Parent_Invoice_ID = TRHA.I_Invoice_Header_ID AND trha.S_Receipt_No=r.S_Receipt_No  
    WHERE   C.I_Parent_Invoice_ID IS NOT NULL  
            AND TRHA.I_Receipt_Header_ID IS NULL ;  
              
              
SELECT  keyid ,  
        PKeyID ,  
        I_Receipt_Header_ID ,  
        I_Invoice_Header_ID ,  
        S_Receipt_No ,  
        Dt_Receipt_Date ,  
        I_Parent_Invoice_ID_To_Be_Tagged ,  
        Parent_S_Invoice_No_To_Be_tagged ,  
        N_Receipt_Amount ,  
        RID ,  
        UniqueID ,  
        NULL AS I_Revise_Invoice_Id ,  
        NULL AS S_ReRevise_Invoice_No  
FROM    #temp  
WHERE   rid = 1  
UNION ALL  
SELECT  T.keyid ,  
        T.PKeyID ,  
        T.I_Receipt_Header_ID ,  
        T.I_Invoice_Header_ID ,  
        T.S_Receipt_No ,  
        T.Dt_Receipt_Date ,  
        T1.I_Parent_Invoice_ID_To_Be_Tagged ,  
        T1.Parent_S_Invoice_No_To_Be_tagged ,  
        T.N_Receipt_Amount ,  
        T.RID ,  
        T.UniqueID ,  
        T.I_Parent_Invoice_ID_To_Be_Tagged AS I_Revise_Invoice_Id ,  
        T.Parent_S_Invoice_No_To_Be_tagged AS S_ReRevise_Invoice_No  
FROM    #temp T  
        INNER JOIN #temp T1 ON T.I_Receipt_Header_ID = T1.I_Receipt_Header_ID  
                               AND T.RID - 1 = T1.RID  
WHERE   T.rid <> 1  
ORDER BY UniqueID  
              
DROP TABLE #temp  
       
     end TRY  
     BEGIN CATCH    
--Error occurred:    
    
DECLARE @ErrMsg NVARCHAR(4000) ,    
@ErrSeverity INT    
SELECT @ErrMsg = ERROR_MESSAGE() ,    
@ErrSeverity = ERROR_SEVERITY()    
    
RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
