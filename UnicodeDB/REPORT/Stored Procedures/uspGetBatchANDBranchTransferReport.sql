--select * from dbo.fnGetCentersForReports('127',109) 
--exec [REPORT].[uspGetBatchANDBranchTransferReport] '127',109,NULL,Null,NULL,2
CREATE PROCEDURE [REPORT].[uspGetBatchANDBranchTransferReport]
    (
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @iStudentID INT = NULL ,
      @startDate DATETIME ,
      @enddate DATETIME ,
      @iTransferTypeID INT -- 1 for Branch Tranfer, 2 for Batch Branfer
   
    )
AS 
    BEGIN
    
        DECLARE @tempResult TABLE
            (
              id INT IDENTITY ,
              HierachyID INT ,
              BrandID INT ,
              centreId INT ,
              centrecode VARCHAR(100) ,
              centrename VARCHAR(MAX) ,
              I_Status_Value INT
            )
	
	
        DECLARE @tempStudentList TABLE
            (
              id INT IDENTITY ,
              I_Student_Detail_ID INT ,
              centreId INT ,
              centrecode VARCHAR(100) ,
              centrename VARCHAR(MAX)
            )
    
        DECLARE @Result TABLE
            (
              id INT IDENTITY ,
              BranchTransfer INT ,
              I_Student_Detail_ID INT ,
              studentName VARCHAR(250) ,
              I_RollNo INT ,
              I_Source_Centre_Id INT ,
              S_Source_Centre VARCHAR(250) ,
              SourceBatch VARCHAR(250) ,
              I_Destination_Centre_Id INT ,
              S_Destination_Centre VARCHAR(250) ,
              DestinationBatch VARCHAR(250) ,
              [TRANSFERRING AUTHORITY] VARCHAR(500) ,
              Transterdate VARCHAR(25) ,
              HierachyID INT ,
              BrandID INT ,
              centreId INT ,
              centrecode VARCHAR(150) ,
              centrename VARCHAR(350) ,
              I_Status_Value INT ,
              BILLNO VARCHAR(500) ,
              TransferFees DECIMAL(18, 2)
            )

  
        IF ( @iTransferTypeID = 1 ) 
            BEGIN
  
  
  
                INSERT  INTO @tempResult
                        ( BrandID ,
                          HierachyID ,
                          centreId ,
                          centrecode ,
                          centrename ,
                          I_Status_Value
	                  )
                        SELECT  fgcfr.* ,
                                tsm.I_Status_Value
                        FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                           @iBrandID) AS fgcfr
                                LEFT JOIN dbo.T_Status_Master AS tsm ON fgcfr.BrandID = tsm.I_Brand_ID
                                                              AND tsm.S_Status_Desc IN (
                                                              'Branch Transfer' )
                                                              AND tsm.S_Status_Type = 'ReceiptType'
    
                SELECT DISTINCT
                        1 AS BranchTransfer ,
                        tstr.I_Student_Detail_ID ,
                        tsd.S_First_Name + ' ' + ISNULL(tsd.s_middle_name, '')
                        + ' ' + ISNULL(tsd.s_last_name, '') studentName ,
                        tsd.I_RollNo ,
                        FN2.InstanceChain ,
                        tstr.I_Source_Centre_Id ,
                        TCM1.S_Center_Name S_Source_Centre ,
                        ( SELECT TOP 1
                                    tsbm.S_Batch_Name
                          FROM      dbo.T_Student_Batch_Details AS tsbd
                                    INNER JOIN dbo.T_Center_Batch_Details AS tcbd ON tcbd.I_Batch_ID = tsbd.I_Batch_ID
                                    INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbm.I_Batch_ID = tcbd.I_Batch_ID
                          WHERE     tsbd.I_Student_ID = tstr.I_Student_Detail_ID
                                    AND tstr.I_Source_Centre_Id = tcbd.I_Centre_Id
                        ) AS SourceBatch ,
                        tstr.I_Destination_Centre_Id ,
                        TCM2.S_Center_Name S_Destination_Centre ,
                        ( SELECT TOP 1
                                    tsbm.S_Batch_Name
                          FROM      dbo.T_Student_Batch_Details AS tsbd
                                    INNER JOIN dbo.T_Center_Batch_Details AS tcbd ON tcbd.I_Batch_ID = tsbd.I_Batch_ID
                                    INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbm.I_Batch_ID = tcbd.I_Batch_ID
                          WHERE     tsbd.I_Student_ID = tstr.I_Student_Detail_ID
                                    AND tstr.I_Destination_Centre_Id = tcbd.I_Centre_Id
                        ) AS DestinationBatch ,
                        TSM.S_First_Name + ' ' + ISNULL(TSM.s_middle_name, '')
                        + ' ' + ISNULL(TSM.S_last_name, '') [TRANSFERRING AUTHORITY] ,
                        CONVERT(VARCHAR(10), ISNULL(tstr.Dt_Upd_On,
                                                    tstr.Dt_Crtd_On), 105) AS Transterdate ,
                        A.HierachyID ,
                        A.BrandID ,
                        A.centreId ,
                        A.centrecode ,
                        A.centrename ,
                        A.I_Status_Value ,
                        trh.s_Receipt_No BillNo ,
                        trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount, 0) AS TransferFees ,
                        ( SELECT TOP 1
                                    MAX(ttcm.I_Sequence)
                          FROM      dbo.T_Student_Attendance AS tsa
                                    INNER JOIN dbo.T_TimeTable_Master AS tttm ON tsa.I_TimeTable_ID = tttm.I_TimeTable_ID
                                    INNER JOIN T_Term_Course_Map AS ttcm ON ttcm.I_Term_ID = tttm.I_Term_ID
                          WHERE     tstr.I_Student_Detail_ID = tsa.I_Student_Detail_ID
                                    AND tttm.I_Center_ID = tstr.I_Source_Centre_Id
                          GROUP BY  tttm.I_Center_ID ,
                                    tttm.I_Batch_ID ,
                                    tsa.I_Student_Detail_ID
                        ) AS SmTaught
                FROM    dbo.T_Student_Transfer_Request AS tstr WITH ( NOLOCK )
                        INNER JOIN t_user_master TSM WITH ( NOLOCK ) ON TSM.S_Login_ID = ISNULL(tstr.S_Upd_By,
                                                              tstr.S_Crtd_By)
                        INNER JOIN T_Centre_Master TCM1 WITH ( NOLOCK ) ON TCM1.I_Centre_Id = tstr.I_Source_Centre_Id
                        INNER JOIN T_Centre_Master TCM2 WITH ( NOLOCK ) ON TCM2.I_Centre_Id = tstr.I_Destination_Centre_Id
                        INNER JOIN dbo.T_Student_Detail AS tsd WITH ( NOLOCK ) ON tstr.I_Student_Detail_ID = tsd.I_Student_Detail_ID                        
                        LEFT OUTER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON TCM1.I_Centre_Id = FN1.CenterID
                        LEFT OUTER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                        LEFT JOIN @tempResult A ON tstr.I_Source_Centre_Id = A.centreId
                        LEFT JOIN dbo.T_Receipt_Header AS trh ON trh.I_Centre_Id = tstr.I_Source_Centre_Id
                                                              AND A.I_Status_Value = trh.I_Receipt_Type
                                                              AND trh.I_Student_Detail_ID = tstr.I_Student_Detail_ID
                                                              AND DATEDIFF(dd,tstr.Dt_Upd_On,Dt_Receipt_Date) = 0
                WHERE   tstr.I_Student_Detail_ID = ISNULL(@iStudentID,
                                                          tstr.I_Student_Detail_ID)
                        AND CONVERT(DATE, ISNULL(tstr.Dt_Upd_On,
                                                 tstr.Dt_Crtd_On)) BETWEEN ISNULL(@startDate,
                                                              CONVERT(DATE, ISNULL(tstr.Dt_Upd_On,
                                                              tstr.Dt_Crtd_On)))
                                                              AND
                                                              ISNULL(@enddate,
                                                              CONVERT(DATE, ISNULL(tstr.Dt_Upd_On,
                                                              tstr.Dt_Crtd_On)))
                        AND tstr.I_Status = 0
                        AND ( tstr.I_Source_Centre_Id IN (
                              SELECT    fgcfr1.centerID
                              FROM      fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) fgcfr1 )
                              OR tstr.I_Destination_Centre_Id IN (
                              SELECT    fgcfr2.centerID
                              FROM      fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) fgcfr2 )
                            )
            END
        ELSE 
            BEGIN    	



                DECLARE @StudentBatch TABLE
                    (
                      id INT IDENTITY ,
                      I_Student_Batch_ID INT ,
                      I_Student_ID INT ,
                      I_Batch_ID INT ,
                      BatchName VARCHAR(500) ,
                      DT_valid_from DATETIME ,
                      I_Status INT
                    )
		
		
                INSERT  INTO @tempResult
                        ( BrandID ,
                          HierachyID ,
                          centreId ,
                          centrecode ,
                          centrename ,
                          I_Status_Value
		
		            )
                        SELECT  fgcfr.* ,
                                tsm.I_Status_Value
                        FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                           @iBrandID) AS fgcfr
                                LEFT JOIN dbo.T_Status_Master AS tsm ON fgcfr.BrandID = tsm.I_Brand_ID
                                                              AND tsm.S_Status_Desc IN (
                                                              'Batch Transfer' )
                                                              AND tsm.S_Status_Type = 'ReceiptType'
    
                DECLARE @i INT ,
                    @iMax INT ,
                    @k INT ,
                    @kMax INT ,
                    @iI_Student_Batch_ID INT ,
                    @iCurrentBatchId INT ,
                    @iPrevBatchID INT ,
                    @ivStudentID INT ,
                    @iI_Status INT ,
                    @BatchName VARCHAR(500)
		
		
                INSERT  INTO @tempStudentList
                        ( I_Student_Detail_ID ,
                          centreId ,
                          centrecode ,
                          centrename 
		            )
                        SELECT DISTINCT
                                TSBD.I_Student_ID ,
                                A.centreId ,
                                A.centrecode ,
                                A.centrename
                        FROM    dbo.T_Center_Batch_Details AS tcbd WITH ( NOLOCK )
                                INNER JOIN T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON tcbd.I_Batch_ID = TSBD.I_Batch_ID
                                LEFT JOIN @tempResult A ON tcbd.I_Centre_Id = A.centreId
                                INNER JOIN dbo.T_Student_Detail AS tsd WITH ( NOLOCK ) ON tsd.I_Student_Detail_ID = TSBD.I_Student_ID
                                LEFT JOIN dbo.T_Receipt_Header AS trh ON trh.I_Centre_Id = A.centreId
                                                              AND A.I_Status_Value = trh.I_Receipt_Type
                                                              AND trh.I_Student_Detail_ID = TSBD.I_Student_ID
                        WHERE   TSBD.I_Student_ID = ISNULL(@iStudentID,
                                                           TSBD.I_Student_ID)
                                AND CONVERT(DATE, ISNULL(trh.Dt_Upd_On,
                                                         trh.Dt_Crtd_On)) BETWEEN ISNULL(@startDate,
                                                              CONVERT(DATE, ISNULL(trh.Dt_Upd_On,
                                                              trh.Dt_Crtd_On)))
                                                              AND
                                                              ISNULL(@enddate,
                                                              CONVERT(DATE, ISNULL(trh.Dt_Upd_On,
                                                              trh.Dt_Crtd_On)))
		
		
                SELECT  @kMax = COUNT(*)
                FROM    @tempStudentList
                SET @k = 1
		
		
                DECLARE @vcentreId INT ,
                    @vcentrecode VARCHAR(100) ,
                    @vcentrename VARCHAR(MAX) ,
                    @tmpID INT ,
                    @iPrevStudentID INT
		
                SET @iPrevStudentID = 0
		
                WHILE ( @k <= @kMax ) 
                    BEGIN
			
			
                        SELECT  @ivStudentID = I_Student_Detail_ID ,
                                @vcentreId = centreId ,
                                @vcentrecode = centrecode ,
                                @vcentrename = centrename
                        FROM    @tempStudentList
                        WHERE   id = @k
			
			
		
                        IF ( @iPrevStudentID = 0 ) 
                            BEGIN
                                SET @iPrevStudentID = @ivStudentID
                            END
			
			
			
                        INSERT  INTO @StudentBatch
                                ( I_Student_Batch_ID ,
                                  I_Student_ID ,
                                  I_Batch_ID ,
                                  BatchName ,
                                  DT_valid_from ,
                                  I_Status 
			              )
                                SELECT  tsbd.I_Student_Batch_ID ,
                                        tsbd.I_Student_ID ,
                                        tsbd.I_Batch_ID ,
                                        TSBM.S_Batch_Name ,
                                        tsbd.Dt_Valid_From ,
                                        tsbd.I_Status
                                FROM    dbo.T_Student_Batch_Details AS tsbd
                                        WITH ( NOLOCK )
                                        LEFT JOIN T_Student_Batch_Master TSBM
                                        WITH ( NOLOCK ) ON tsbd.I_Batch_ID = TSBM.I_Batch_ID
                                WHERE   I_Student_ID = @ivStudentID
                                ORDER BY tsbd.Dt_Valid_From ASC
		 
			
                        SELECT  @i = MIN(id)
                        FROM    @StudentBatch 
                        SELECT  @iMax = MAX(id)
                        FROM    @StudentBatch
		 
		 
                        WHILE ( @i <= @iMax ) 
                            BEGIN
                                SELECT  @BatchName = BatchName
                                FROM    @StudentBatch
                                WHERE   ID = @i
		     	
		     	     
                                INSERT  INTO @Result
                                        ( BranchTransfer ,
                                          I_Student_Detail_ID ,
                                          studentName ,
                                          I_RollNo ,
                                          I_Source_Centre_Id ,
                                          S_Source_Centre ,
                                          SourceBatch ,
                                          I_Destination_Centre_Id ,
                                          S_Destination_Centre ,
                                          DestinationBatch ,
                                          [TRANSFERRING AUTHORITY] ,
                                          Transterdate ,
                                          HierachyID ,
                                          BrandID ,
                                          centreId ,
                                          centrecode ,
                                          centrename ,
                                          I_Status_Value ,
                                          BILLNO ,
                                          TransferFees 
		                            )
                                        SELECT  2 ,
                                                tsd.I_Student_Detail_ID ,
                                                tsd.S_First_Name + ' '
                                                + ISNULL(tsd.s_middle_name, '')
                                                + ' ' + ISNULL(tsd.s_last_name,
                                                              '') ,
                                                tsd.I_RollNo ,
                                                @vcentreId ,
                                                @vcentrename ,
                                                BatchName ,
                                                @vcentreId ,
                                                @vcentrename ,
                                                NULL ,
                                                NULL ,
                                                A.DT_valid_from ,
                                                NULL ,
                                                NULL ,
                                                NULL ,
                                                NULL ,
                                                NULL ,
                                                NULL ,
                                                NULL ,
                                                NULL
                                        FROM    @StudentBatch A
                                                INNER JOIN dbo.T_Student_Detail
                                                AS tsd WITH ( NOLOCK ) ON A.I_Student_ID = TSD.I_Student_Detail_ID
                                        WHERE   A.ID = @i
		    		       
                                SET @tmpID = SCOPE_IDENTITY()
		 
                                IF ( @iPrevStudentID = @ivStudentID ) 
                                    BEGIN
                                        UPDATE  @Result
                                        SET     DestinationBatch = @BatchName
                                        WHERE   ID = @tmpID - 1
                                    END	
		   
		  
                                SET @i = @i + 1
		   
                                SET @iPrevStudentID = @ivStudentID
		   	
                            END
		 
		 
		
                        SET @k = @k + 1
                        SET @iPrevStudentID = @ivStudentID
                        DELETE  FROM @StudentBatch
		
                    END
		
                SELECT  id ,
                        BranchTransfer ,
                        I_Student_Detail_ID ,
                        studentName ,
                        I_RollNo ,
                        I_Source_Centre_Id ,
                        S_Source_Centre ,
                        SourceBatch ,
                        I_Destination_Centre_Id ,
                        S_Destination_Centre ,
                        DestinationBatch ,
                        [TRANSFERRING AUTHORITY] ,
                        CONVERT(VARCHAR(10), Transterdate, 105) Transterdate ,
                        HierachyID ,
                        R.BrandID ,
                        centreId ,
                        centrecode ,
                        centrename ,
                        I_Status_Value ,
                        BILLNO ,
                        TransferFees ,
                        FN2.InstanceChain
                FROM    @Result R
                        INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON R.I_Source_Centre_Id = FN1.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
                WHERE   DestinationBatch IS NOT NULL
                ORDER BY I_Student_Detail_ID ,
                        Transterdate

            END
                        
    END
