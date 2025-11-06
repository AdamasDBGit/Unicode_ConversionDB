CREATE PROCEDURE [ACADEMICS].[uspInsertUpdateStudentStatusCompleted]
    (
      @dtExecutionDate DATE = NULL
    )
AS 
    BEGIN
        IF @dtExecutionDate = NULL 
            SET @dtExecutionDate = GETDATE()
	
        DECLARE @StdID INT
        --DECLARE @Due DECIMAL(14, 2)
        
	
        
                    
        DECLARE RICECompleted CURSOR
        FOR
        SELECT TSD.I_Student_Detail_ID FROM dbo.T_Student_Detail TSD
        --INNER JOIN 
        --(
        --SELECT TIP.I_Student_Detail_ID,MIN(TIP.I_Invoice_Header_ID) AS InvID FROM dbo.T_Invoice_Parent TIP
        --INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id=TCHND.I_Center_ID
        --WHERE TCHND.I_Brand_ID=109
        --GROUP BY TIP.I_Student_Detail_ID
        --) T1 ON TSD.I_Student_Detail_ID = T1.I_Student_Detail_ID
        --INNER JOIN dbo.T_Invoice_Child_Header TICH ON T1.InvID=TICH.I_Invoice_Header_ID
        --INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
        --INNER JOIN dbo.T_Student_Batch_Master TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID
        WHERE
        DATEDIFF(d,TSD.Dt_Crtd_On,@dtExecutionDate)>730
        AND TSD.S_Student_ID LIKE '%/RICE/%' AND TSD.I_Status<>0
                    
        OPEN RICECompleted
        FETCH NEXT FROM RICECompleted
                    INTO
                    @StdID
                    
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                    
						
						
                IF NOT EXISTS ( SELECT  TSSD.I_Student_Status_Detail_ID
                            FROM    dbo.T_Student_Status_Details TSSD
                            WHERE   TSSD.I_Student_Detail_ID = @StdID
                                    AND TSSD.I_Student_Status_ID = 2
                                    AND TSSD.I_Status = 1 ) 
                    BEGIN
                        
                        INSERT INTO dbo.T_Student_Status_Details
                    	        ( I_Student_Detail_ID ,
                    	          I_Student_Status_ID ,
                    	          I_Status ,
                    	          S_Crtd_By ,
                    	          Dt_Crtd_On 
                    	        )
                    	VALUES  ( @StdID , -- I_Student_Detail_ID - int
                    	          2 , -- I_Student_Status_ID - int
                    	          1 , -- I_Status - int
                    	          'dba' , -- S_Crtd_By - varchar(max)
                    	          @dtExecutionDate  -- Dt_Crtd_On - datetime
                    	        )
                    		
                       
                    		   		
                    END
                    
                    
                    
                    FETCH NEXT FROM RICECompleted
                    INTO @StdID
            END
            
            CLOSE RICECompleted
            DEALLOCATE RICECompleted
            
            --PRINT @idlist;
            
                    
                    
                    
    END
