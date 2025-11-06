CREATE   PROCEDURE [dbo].[usp_ERP_GetStudentBasicDetails] -- [dbo].[uspGetStudentDetails] NULL,'12-0087'                   
    (
      -- Add the parameters for the stored procedure here                        
      @iStudentDetailId INT =NULL,
      @iEnquiryID INT  = NULL                    
    )
AS 
    BEGIN                        

                         

                         

        DECLARE @iCenterId INT ,                
            @iEnquiryRegnId INT                        

  --@iStudentDetailId int                        

                         

        IF ( @iStudentDetailId IS NULL ) 
            SELECT  @iStudentDetailId = I_Student_Detail_ID
            FROM    dbo.T_Student_Detail TSD WITH ( NOLOCK )
                    INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
            WHERE    TERD.I_Enquiry_Regn_ID= @iEnquiryID and I_Status <> 0                

                        
		IF @iEnquiryID IS NULL
                    SELECT  @iEnquiryID = TERD.I_Enquiry_Regn_ID
            FROM    dbo.T_Student_Detail TSD WITH ( NOLOCK )
			INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON TSD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
                    where   TSD.I_Student_Detail_ID= @iStudentDetailId and I_Status <> 0  

   --Table[0] Student Details                        

                           

        SELECT  TSD.I_Student_Detail_ID StudentDetailsID,
                TSD.I_Enquiry_Regn_ID EnquiryID ,
                TSD.S_Student_ID StudentID,
                TSD.I_RollNo RollNo
        FROM    dbo.T_Student_Detail TSD WITH ( NOLOCK )
        WHERE   TSD.I_Student_Detail_ID = ISNULL(@iStudentDetailId,0) --AND TSD.I_Status<>0                        

                           

   --SET @iStudentDetailId=(SELECT I_Student_Detail_ID FROM dbo.T_Student_Detail  WHERE I_Student_ID=@iStudentID AND I_Status<>0)                        

      IF  @iStudentDetailId IS NOT NULL               
	   Begin
        SET @iEnquiryID = ( SELECT  TSD.I_Enquiry_Regn_ID
                                FROM    dbo.T_Student_Detail TSD WITH ( NOLOCK )
                                WHERE   TSD.I_Student_Detail_ID = @iStudentDetailId
                              ) -- AND TSD.I_Status<>0)                        

        End                   

   --Table[1] Enquiry Details                

              

        SELECT  ERD.I_Enquiry_Regn_ID EnquiryID ,
                
                ERD.S_Enquiry_No EnquiryNo,
                ERD.S_First_Name FirstName,
                ERD.S_Middle_Name MiddleName,
                ERD.S_Last_Name LastName,
				ERD.S_Father_Name as FatherName,
				ERD.S_Mother_Name as MotherName,
                ERD.S_Phone_No MobileNo,
                ERD.S_Mobile_No PhoneNo,
				--current
                ISNULL(ERD.I_Curr_City_ID,ERD.I_Perm_City_ID) PresentCity,
                ISNULL(ERD.I_Curr_State_ID,ERD.I_Perm_State_ID) PresentState,
                ISNULL(ERD.I_Curr_Country_ID,ERD.I_Perm_Country_ID) PresentCountry,
                ISNULL(ERD.S_Curr_Address1,ERD.S_Perm_Address1) PresentAddress1,
                ISNULL(ERD.S_Curr_Address2,ERD.S_Perm_Address2) PresentAddress2,
                ISNULL(ERD.S_Curr_Pincode,ERD.S_Perm_Pincode) PresentPinCode,
                ISNULL(ERD.S_Curr_Area,ERD.S_Perm_Area) PresentArea,
				--permanent
                ISNULL(ERD.S_Perm_Address1,ERD.S_Curr_Address1) PermAddress1,
                ISNULL(ERD.S_Perm_Address2,ERD.S_Curr_Address2) PermAddress2,
                ISNULL(ERD.S_Perm_Pincode,ERD.S_Curr_Pincode) PermPincode ,
                ISNULL(ERD.I_Perm_City_ID,ERD.I_Curr_City_ID) PermCity,
                ISNULL(ERD.I_Perm_State_ID,ERD.I_Curr_State_ID) PermState,
                ISNULL(ERD.I_Perm_Country_ID,ERD.I_Curr_Country_ID) PermCountry,
                ISNULL(ERD.S_Perm_Area,ERD.S_Curr_Area) PermArea,
                ERD.S_Form_No as FormNo,
				ERD.S_Student_Photo as StudentPhoto
        FROM    dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) 
                where ERD.I_Enquiry_Regn_ID = @iEnquiryID                         

                           

   --Table[2] Center Details                        

        IF @iCenterId IS NULL 
            BEGIN                   

                SET @iCenterId = ( SELECT   SCD.I_Centre_Id
                                   FROM     dbo.T_Student_Center_Detail SCD
                                   WHERE    SCD.I_Student_Detail_ID = @iStudentDetailId
                                            AND GETDATE() >= ISNULL(GETDATE(),
                                                              SCD.Dt_Valid_From)
                                            AND GETDATE() <= ISNULL(GETDATE(),
                                                              SCD.Dt_Valid_To)
                                            AND SCD.I_Status <> 0
                                 )                        

            END      

                           
                  
		
		--SELECT @iCenterId
		
		--SELECT  TCM.I_Centre_ID CenterID,
  --              TCM.S_Center_Code CenterCode,
  --              TCM.S_Center_Name CenterName,
  --              TBM.S_Brand_Name BrandID,
		--		GCM.S_State_Code GSTCODE,
		--		SM.S_State_Name StudentState
  --      FROM    dbo.T_Centre_Master TCM
  --              INNER JOIN dbo.T_Brand_Center_Details TBCD ON TBCD.I_Centre_Id = TCM.I_Centre_Id
  --              INNER JOIN dbo.T_Brand_Master TBM ON TBM.I_Brand_ID = TBCD.I_Brand_ID
		--		INNER JOIN NETWORK.T_Center_Address AS CA ON TBCD.I_Centre_Id = CA.I_Centre_Id
		--		INNER JOIN dbo.T_State_Master AS SM ON CA.I_State_ID = SM.I_State_ID
		--		LEFT JOIN dbo.T_GST_Code_Master AS GCM ON GCM.I_State_ID = SM.I_State_ID AND GCM.I_Brand_ID = TBM.I_Brand_ID
  --      WHERE   TCM.I_Centre_ID = @iCenterId
  --              AND TCM.I_Status <> 0                          
		--CHANGE END FOR GST IMPLEMENTATION
                           

   --Table[3] StudentCourse Details                        

  --      SELECT DISTINCT
  --              CM.I_Course_ID as CourseID ,
  --              CM.S_Course_Code as CourseCode,
  --              CM.S_Course_Name as CourseName,
  --              CM.S_Course_Desc CourseDesc,
		--		ISNULL(TC.I_Class_ID,0) ClassID,
		--		TC.S_Class_Name as ClassName,
		--		ISNULL(SM.I_Stream_ID ,0) StreamID,
		--		SM.S_Stream_Name StreamName
               
  --      FROM    dbo.T_Course_Master CM ,
  --              dbo.T_CourseFamily_Master CFM ,
  --              dbo.T_Course_Delivery_Map TCDM ,
  --              ( SELECT    I_Course_ID ,
  --                          tsbm.Dt_BatchStartDate ,
  --                          TSBD.I_Batch_ID ,
  --                          Dt_Course_Actual_End_Date ,
  --                          Dt_Course_Expected_End_Date ,
  --                          CAST(CASE ISNULL(TCBD.I_Status, tsbm.I_Status)
  --                                 WHEN 5 THEN 1
  --                                 ELSE 0
  --                               END AS BIT) AS I_Is_Completed ,
  --                          TCBD.I_Course_Fee_Plan_ID ,
  --                          TSBM.I_Delivery_Pattern_ID
  --                FROM      dbo.T_Student_Batch_Details AS TSBD
  --                          INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
  --                          INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON tsbm.I_Batch_ID = TCBD.I_Batch_ID
  --                WHERE     TSBD.I_Student_ID = @iStudentDetailId
  --                          AND TSBD.I_Status <> 0
  --                          AND TSBD.I_Status IN ( 1, 2 )
  --                          AND TCBD.I_Centre_Id = @iCenterId
  --                          AND                  

  -- --I_Status<>0 AND                          
  --                          --GETDATE() >= ISNULL(GETDATE(), Dt_Valid_From)
  --                          --AND GETDATE() <= ISNULL(GETDATE(), Dt_Valid_To)
                            
  --                            TSBD.I_Student_Batch_ID=(SELECT MAX(tsbd1.I_Student_Batch_ID) FROM T_Student_Batch_Details TSBD1 WHERE 
  --                          tsbd1.I_Student_ID=TSBD.I_Student_ID
  --                          and GETDATE() >= ISNULL( TSBD1.Dt_Valid_From,GETDATE())
  --                          AND GETDATE() <= ISNULL(TSBD1.Dt_Valid_To,GETDATE())
  --                          AND tsbd1.I_Status IN (1,2)---Akash
  --                          AND tsbd1.Dt_Valid_From=(SELECT MAX(TSBD2.Dt_Valid_From) FROM dbo.T_Student_Batch_Details TSBD2 WHERE TSBD2.I_Student_ID=@iStudentDetailId AND TSBD2.I_Status IN (1,2))--akash
  --                          )
  --              ) TSCD

		--		Left join
				
		--T_Course_Group_Class_Mapping as CGCM on TSCD.I_Course_ID=CGCM.I_Course_ID
		--inner join
		--T_Class as TC on CGCM.I_Class_ID=TC.I_Class_ID
		--left join
		--T_Stream_Master as SM on SM.I_Stream_ID=CGCM.I_Stream_ID
  --      WHERE   TSCD.I_Course_ID = CM.I_Course_ID
  --              AND CFM.I_CourseFamily_ID = CM.I_CourseFamily_ID
  --              AND TCDM.I_Course_ID = CM.I_Course_ID
  --              AND TCDM.I_Delivery_Pattern_ID = TSCD.I_Delivery_Pattern_ID                      

                       

   --Table[4] Enquiry Qualification Details                  

        --SELECT  TEQD.I_Enquiry_Regn_ID ,
        --        TEQD.S_Name_Of_Exam ,
        --        TEQD.S_University_Name ,
        --        TEQD.S_Year_From ,
        --        TEQD.S_Year_To ,
        --        TEQD.S_Subject_Name ,
        --        TEQD.N_Marks_Obtained ,
        --        TEQD.N_Percentage ,
        --        TEQD.S_Division
        --FROM    dbo.T_Enquiry_Qualification_Details AS TEQD --INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON TEQD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID                
        --        INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD ON TEQD.I_Enquiry_Regn_ID = TERD.I_Enquiry_Regn_ID
        --WHERE   TEQD.I_Status = 1
        --        AND TERD.I_Enquiry_Regn_ID = @iEnquiryRegnId              

                    
                     

    END 
