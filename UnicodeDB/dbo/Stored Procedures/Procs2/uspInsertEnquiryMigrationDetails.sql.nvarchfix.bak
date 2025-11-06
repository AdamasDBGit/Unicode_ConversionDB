CREATE PROCEDURE [dbo].[uspInsertEnquiryMigrationDetails] 
    (
      @sEnquiryMigrationXML XML = NULL     
    )
AS 
    BEGIN TRY                  
        SET NOCOUNT OFF ; 
        
        DECLARE @iEmployeeId INT
        
        BEGIN TRANSACTION                  
         
         -- Create Temporary Table To TimeTable Parent Information            
        CREATE TABLE #tempTimeTable
            (
				 I_CenterId int ,
				 S_FirstName nvarchar(max),
				 S_LastName nvarchar(max),
				 DT_BirthDate datetime,
				 S_Caste nvarchar(max) ,
				 S_MobileNo nvarchar(max) ,
				 S_Address nvarchar(max) ,
				 S_Country nvarchar(max) ,
				 S_State nvarchar(max) ,
				 S_City nvarchar(max) ,
				 S_Pincode nvarchar(max) ,
				 S_Remarks nvarchar(max) ,
				 S_Source nvarchar(max) ,
				 S_EnrolType nvarchar(max) ,
				 S_SeatType nvarchar(max) ,
				 S_EnrolNo nvarchar(max) ,
				 S_Rank nvarchar(max) ,
				 S_Age nvarchar(max) ,
				 DT_FirstFollowUpDate datetime ,
				 S_CrtdBy nvarchar(max) ,
				 Dt_CrtdOn datetime
            )  
   
   -- Insert Values into Temporary Table            
        INSERT  INTO #tempTimeTable
                SELECT  T.c.value('@I_CenterId', 'int') ,
                        T.c.value('@S_FirstName', 'nvarchar(max)') ,
                        T.c.value('@S_LastName', 'nvarchar(max)') ,
                        T.c.value('@DT_BirthDate', 'datetime') ,
                        CASE WHEN T.c.value('@S_Caste','nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Caste','nvarchar(max)') END,
                        T.c.value('@S_MobileNo', 'nvarchar(max)') ,
                        CASE WHEN T.c.value('@S_Address', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Address', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_Country', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Country', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_State', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_State', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_City', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_City', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_Pincode', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Pincode', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_Remarks', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Remarks', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_Source', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Source', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_EnrolType', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_EnrolType', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_SeatType', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_SeatType', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_EnrolNo','nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_EnrolNo','nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_Rank', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Rank', 'nvarchar(max)') END,
                        CASE WHEN T.c.value('@S_Age', 'nvarchar(max)') = '' THEN NULL ELSE T.c.value('@S_Age', 'nvarchar(max)') END,
						T.c.value('@DT_FirstFollowUpDate', 'datetime') ,
                        T.c.value('@S_CrtdBy', 'nvarchar(max)') ,
                        T.c.value('@Dt_CrtdOn', 'datetime')
                FROM    @sEnquiryMigrationXML.nodes('/Root/EnquiryMigration') T ( c )
                
					 IF ( SELECT count(*)
						FROM   dbo.T_Enquiry_Regn_Detail AS TERD
						inner join #tempTimeTable AS TTT
						on TERD.S_Mobile_No = TTT.S_MobileNo) = 0 
					 BEGIN
						INSERT  INTO dbo.T_Enquiry_Regn_Detail
						(	 I_Centre_Id ,
							 S_First_Name ,
							 S_Last_Name ,
							 Dt_Birth_Date ,
							 S_Age ,
							 I_Caste_ID ,
							 S_Mobile_No ,
							 S_Curr_Address1 ,
							 I_Curr_Country_ID ,
							 I_Curr_State_ID ,
							 I_Curr_City_ID ,
							 S_Curr_Pincode ,
							 S_Enquiry_Desc ,
							 B_IsPreEnquiry ,
							 I_Info_Source_ID ,
							 I_Enrolment_Type_ID ,
							 I_Seat_Type_ID ,
							 S_Enrolment_No ,
							 I_Rank_Obtained ,
							 S_Crtd_By ,
							 Dt_Crtd_On     
						)
						 ( SELECT 
							TTT.I_CenterId,TTT.S_FirstName,TTT.S_LastName,TTT.DT_BirthDate,TTT.S_Age,TCM.I_Caste_ID,
							TTT.S_MobileNo,TTT.S_Address,TCOM.I_Country_ID,TSM.I_State_ID,TCIM.I_City_ID,TTT.S_Pincode,
							TTT.S_Remarks,1,TISM.I_Info_Source_ID,TETM.I_Enrolment_Type_ID,TSTM.I_Seat_Type_ID,
							TTT.S_EnrolNo,TTT.S_Rank,TTT.S_CrtdBy,TTT.Dt_CrtdOn
							
							FROM #tempTimeTable AS TTT
							left outer join dbo.T_Caste_Master AS TCM on TCM.S_Caste_Name = TTT.S_Caste 
							left outer join dbo.T_Country_Master AS TCOM on TCOM.S_Country_Name = TTT.S_Country
							left outer join dbo.T_State_Master AS TSM on TSM.S_State_Name = TTT.S_State 
							left outer join dbo.T_City_Master AS TCIM on TCIM.S_City_Name = TTT.S_City 
							left outer join dbo.T_Information_Source_Master AS TISM on TISM.S_Info_Source_Name = TTT.S_Source 
							left outer join dbo.T_Enrolment_Type_Master AS TETM on TETM.S_Enrolment_Type = TTT.S_EnrolType 
							left outer join dbo.T_Seat_Type_Master AS TSTM on TSTM.S_Seat_Type = TTT.S_SeatType 
						 )
						 
						UPDATE  dbo.T_Enquiry_Regn_Detail
						set S_Enquiry_No=I_Enquiry_Regn_ID
						WHERE I_Enquiry_Regn_ID in (SELECT I_Enquiry_Regn_ID FROM dbo.T_Enquiry_Regn_Detail AS TERD
						inner join #tempTimeTable AS TTT on TERD.S_Mobile_No = TTT.S_MobileNo) 
						
						SELECT  @iEmployeeId = I_Employee_ID    
						FROM    dbo.T_Employee_Dtls    
						WHERE   I_Employee_ID in ( SELECT    TUM.I_Reference_ID    
													FROM #tempTimeTable AS TTT
													inner join dbo.T_User_Master AS TUM ON TUM.S_Login_ID = TTT.S_CrtdBy 
												 ) 
						
						INSERT  INTO dbo.T_Enquiry_Regn_FollowUp    
                        ( I_Enquiry_Regn_ID ,    
                          I_Employee_ID ,    
                          Dt_Followup_Date ,    
                          Dt_Next_Followup_Date ,    
                          S_Followup_Remarks    
                        )    
                        (	SELECT  TERD.I_Enquiry_Regn_ID, 
							@iEmployeeId,
							TTT.Dt_CrtdOn,
							TTT.DT_FirstFollowUpDate,
							'First FollowUp after Enquiry'
							FROM #tempTimeTable AS TTT
							inner join dbo.T_Enquiry_Regn_Detail AS TERD ON TERD.S_Mobile_No = TTT.S_MobileNo
							inner join dbo.T_User_Master AS TUM ON TUM.S_Login_ID = TTT.S_CrtdBy
                        )
                        
                        SELECT TERD.S_Enquiry_No,TERD.S_First_Name,TERD.S_Last_Name,TERD.S_Mobile_No FROM dbo.T_Enquiry_Regn_Detail AS TERD
						inner join #tempTimeTable AS TTT on TERD.S_Mobile_No = TTT.S_MobileNo
						
					 END
					 ELSE
					 BEGIN  
						RAISERROR('Entry with the same mobile no. already exists',11,1)  
					 END 
        COMMIT TRANSACTION  
              
    END TRY                  
    BEGIN CATCH                  
 --Error occurred:                    
        ROLLBACK TRANSACTION                   
        DECLARE @ErrMsg Nnvarchar(max) ,
            @ErrSeverity INT                  
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()                  
                  
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                  
    END CATCH
