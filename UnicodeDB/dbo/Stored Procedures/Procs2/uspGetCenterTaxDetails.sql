-- =============================================  
-- Author:  Debarshi Basu  
-- Create date: 26/03/2006  
-- Description: Gets all the tax components attached to a center  
-- =============================================  
  
CREATE PROCEDURE [dbo].[uspGetCenterTaxDetails] 
    @iCountryID INT ,
    @iCenterID INT
AS 
    BEGIN   
        IF @iCenterID = 0 
            BEGIN  
  
                SELECT  A.I_Fee_Component_ID ,
                        A.I_Tax_ID ,
                        A.N_Tax_Rate ,
                        C.I_Centre_Id ,
                        C.S_Center_Name
                FROM    dbo.T_Tax_Country_Fee_Component A
                        INNER JOIN dbo.T_Centre_Master C ON A.I_Country_ID = C.I_Country_ID
                WHERE   A.I_Country_ID = @iCountryID
                        AND A.I_Status = 1
                        AND ISNULL(A.Dt_Valid_From, GETDATE()) <= GETDATE()
                        AND ISNULL(A.Dt_Valid_To, GETDATE()) >= GETDATE()
                        AND A.N_Tax_Rate <> 0  
  
            END  
        ELSE 
            BEGIN   
  
                DECLARE @nTaxRate NUMERIC(10, 6),@iBrandID INT   
				
                SELECT  @iBrandID = I_Brand_ID
                FROM    dbo.T_Center_Hierarchy_Details AS TCHD
                        INNER JOIN dbo.T_Hierarchy_Brand_Details AS THBD ON TCHD.I_Hierarchy_Master_ID = THBD.I_Hierarchy_Master_ID
                WHERE   I_Center_Id = @iCenterID
                        AND TCHD.I_Status = 1
                        AND THBD.I_Status = 1    
				
                CREATE TABLE #TempTable
                    (
                      I_Fee_Component_ID INT ,
                      I_Tax_ID INT ,
                      N_Tax_Rate NUMERIC(10, 6) ,
                      S_Tax_Desc VARCHAR(50)
                    )  
  
                INSERT  INTO #TempTable
                        SELECT  A.I_Fee_Component_ID ,
                                A.I_Tax_ID ,
                                A.N_Tax_Rate ,
                                B.S_Tax_Desc
                        FROM    dbo.T_Tax_Country_Fee_Component A
                                INNER JOIN dbo.T_Tax_Master B ON A.I_Tax_ID = B.I_Tax_ID
                                INNER JOIN dbo.T_Fee_Component_Master C ON A.I_Fee_Component_ID = C.I_Fee_Component_ID  
                        WHERE   A.I_Country_ID IN (
                                SELECT  I_Country_ID
                                FROM    dbo.T_Centre_Master
                                WHERE   I_Centre_Id = @iCenterID )
                                AND A.I_Status = 1
                                AND ISNULL(A.Dt_Valid_From, GETDATE()) <= GETDATE()
                                AND ISNULL(A.Dt_Valid_To, GETDATE()) >= GETDATE()  
								AND C.I_Brand_ID = @iBrandID
								
                CREATE TABLE #tempCenterTax
                    (
                      ID INT IDENTITY(1, 1) ,
                      I_Fee_Component_ID INT ,
                      I_Tax_ID INT ,
                      N_Tax_Rate NUMERIC(10, 6) ,
                      S_Tax_Desc VARCHAR(50)
                    )  
  
                INSERT  INTO #tempCenterTax
                        SELECT  A.I_Fee_Component_ID ,
                                A.I_Tax_ID ,
                                A.N_Tax_Rate ,
                                B.S_Tax_Desc
                        FROM    dbo.T_Fee_Component_Tax A
                                INNER JOIN dbo.T_Tax_Master B ON A.I_Tax_ID = B.I_Tax_ID
                        WHERE   A.I_Centre_Id = @iCenterID
                                AND A.N_Tax_Rate <> 0  
  
                DECLARE @iCount INT  
                DECLARE @iRowCount INT  
                SELECT  @iRowCount = COUNT(ID)
                FROM    #tempCenterTax  
                SET @iCount = 1  
  
                WHILE ( @iCount <= @iRowCount ) 
                    BEGIN    
                        IF EXISTS ( SELECT  *
                                    FROM    #TempTable
                                    WHERE   I_Fee_Component_ID IN (
                                            SELECT  I_Fee_Component_ID
                                            FROM    #tempCenterTax
                                            WHERE   ID = @iCount )
                                            AND I_Tax_ID IN ( SELECT
                                                              I_Tax_ID
                                                              FROM
                                                              #tempCenterTax
                                                              WHERE
                                                              ID = @iCount ) ) 
                            BEGIN  
                                SELECT  @nTaxRate = N_Tax_Rate
                                FROM    #tempCenterTax
                                WHERE   ID = @iCount      
  
                                UPDATE  #TempTable
                                SET     N_Tax_Rate = @nTaxRate
                                WHERE   I_Fee_Component_ID IN (
                                        SELECT  I_Fee_Component_ID
                                        FROM    #tempCenterTax
                                        WHERE   ID = @iCount )
                                        AND I_Tax_ID IN ( SELECT
                                                              I_Tax_ID
                                                          FROM
                                                              #tempCenterTax
                                                          WHERE
                                                              ID = @iCount )  
                            END  
                        ELSE 
                            BEGIN  
                                INSERT  INTO #TempTable
                                        SELECT  I_Fee_Component_ID ,
                                                I_Tax_ID ,
                                                N_Tax_Rate ,
                                                S_Tax_Desc
                                        FROM    #tempCenterTax
                                        WHERE   ID = @iCount  
                            END  
  
                        SET @iCount = @iCount + 1  
                    END  
    
                SELECT  * ,
                        C.I_Centre_Id ,
                        C.S_Center_Name
                FROM    #TempTable ,
                        dbo.T_Centre_Master C
                WHERE   N_Tax_Rate <> 0
                        AND C.I_Centre_Id = @iCenterID  
  
                DROP TABLE #TempTable  
                DROP TABLE #tempCenterTax  
            END  
    END
