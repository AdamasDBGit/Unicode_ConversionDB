CREATE PROCEDURE [dbo].[uspGetTask]   
    (  
      @iTaskDetailId INT = NULL ,  
      @sKeyValue XML = NULL ,  
      @iCondition INT = NULL ,  
      @iHierarchyMasterId INT = NULL ,  
      @sHierarchyChain Nnvarchar(max) = NULL ,  
      @iStatus INT    
    )  
AS   
    BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
        SET NOCOUNT ON ;    
     
        IF @iTaskDetailId IS NOT NULL   
            BEGIN    
                SELECT  *  
                FROM    T_Task_Details TD  
                        INNER JOIN T_Task_Master TM ON TD.I_Task_Master_Id = TM.I_Task_Master_Id  
                WHERE   I_Task_Details_Id = @iTaskDetailId  
                        AND TD.I_Status NOT IN ( 4, 5 )  
                        AND DATEDIFF(dd, TD.Dt_Created_Date, GETDATE()) < 10  
                ORDER BY TD.Dt_Created_Date DESC    
      
                SELECT  TM.*  
                FROM    T_Task_Mapping TM  
                        INNER JOIN T_Task_Details TD ON TD.I_Task_Details_Id = TM.I_Task_Details_Id  
                WHERE   TD.I_Task_Details_Id = @iTaskDetailId  
                        AND TD.I_Status NOT IN ( 4, 5 )  
                        AND DATEDIFF(dd, TD.Dt_Created_Date, GETDATE()) < 10    
            END    
        ELSE   
            BEGIN    
     
                IF @sKeyValue IS NOT NULL   
                    BEGIN    
       
                        CREATE TABLE #tempTableKeyValues  
                            (  
                              seq INT IDENTITY(1, 1) ,  
                              S_Key nvarchar(max),  
                              S_Value nvarchar(max),  
                              bStatus INT  
                            )     
       
                        INSERT  INTO #tempTableKeyValues  
                                ( S_Key ,  
                                  S_Value    
                                )  
                                SELECT  T.c.value('@S_Key', 'nvarchar(max)') ,  
                                        T.c.value('@S_Value', 'nvarchar(max)')  
                                FROM    @sKeyValue.nodes('/KeyValueList/KeyValue') T ( c )      
      
      
                        SELECT DISTINCT  
                                TD.I_Task_Details_Id ,  
                                TD.I_Task_Master_Id ,  
                                TD.S_Task_Description ,  
                                TD.S_Querystring ,  
                                TD.I_Hierarchy_Master_ID ,  
                                TD.S_Hierarchy_Chain ,  
                                TD.I_Status ,  
                                TMS.I_Type ,  
                                TMS.S_URL ,  
                                TD.S_Wf_Instanceid ,  
                                TD.Dt_Due_date ,  
                                TD.Dt_Created_Date ,  
                                1  
                        FROM    T_Task_Details TD  
                                INNER JOIN T_Task_Mapping TM ON TD.I_Task_Details_Id = TM.I_Task_Details_Id  
                                                              AND TD.I_Status NOT IN (  
                                                              4, 5 )  
                                INNER JOIN T_Task_Master TMS ON TD.I_Task_Master_Id = TMS.I_Task_Master_Id  
                        WHERE   TD.I_Hierarchy_Master_ID = @iHierarchyMasterId     
     --AND TD.S_Hierarchy_Chain = @sHierarchyChain    
                                AND TD.I_Task_Details_Id IN (  
                                SELECT  TM.I_Task_Details_Id  
                                FROM    T_Task_Mapping TM ,  
                                        #tempTableKeyValues TTKV  
                                WHERE   TM.S_Key = 'TrustDomain' -- match one Role Hierarchy (mandatory)    
                                        AND TM.S_Key = TTKV.S_Key  
                                        AND TTKV.S_Value = TM.S_Value )  
                                AND dbo.fnEligibleTask(TD.I_Task_Details_Id,  
                                                       @iCondition, @sKeyValue) = 1  
                                AND DATEDIFF(dd, TD.Dt_Created_Date, GETDATE()) < 10  
                        ORDER BY TD.Dt_Created_Date DESC    
             
                        DROP TABLE #tempTableKeyValues      
                    END    
       
                ELSE   
                    BEGIN    
                        SELECT DISTINCT  
                                TD.I_Task_Details_Id ,  
                                TD.I_Task_Master_Id ,  
                                TD.S_Task_Description ,  
                                TD.S_Querystring ,  
                                TD.I_Hierarchy_Master_ID ,  
                                TD.S_Hierarchy_Chain ,  
                                TD.I_Status ,  
                                TMS.I_Type ,  
                                TMS.S_URL ,  
                                TD.S_Wf_Instanceid ,  
                                TD.Dt_Due_date ,  
                                TD.Dt_Created_Date ,  
                                1  
                        FROM    T_Task_Details TD  
                                INNER JOIN T_Task_Mapping TM ON TD.I_Task_Details_Id = TM.I_Task_Details_Id  
                                                              AND TD.I_Status NOT IN (  
                                                              4, 5 )  
                                INNER JOIN T_Task_Master TMS ON TD.I_Task_Master_Id = TMS.I_Task_Master_Id  
                        WHERE   TD.I_Hierarchy_Master_ID = @iHierarchyMasterId     
       --AND TD.S_Hierarchy_Chain = @sHierarchyChain    
                                AND DATEDIFF(dd, TD.Dt_Created_Date, GETDATE()) < 10  
                        ORDER BY TD.Dt_Created_Date DESC    
                    END     
            END     
    END

