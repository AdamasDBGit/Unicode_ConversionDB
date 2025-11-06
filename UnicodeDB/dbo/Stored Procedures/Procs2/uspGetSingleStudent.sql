
CREATE PROCEDURE [dbo].[uspGetSingleStudent]

@StudentBarCodeNo nvarchar(255),
@IssueingUser INT

AS
BEGIN TRY

declare @branchid INT 
declare @StudentBranchid INT 
 SELECT @branchid= ISNULL(I_Center_Id,0) FROM T_Center_Hierarchy_Details  WHERE I_Hierarchy_Detail_ID=@IssueingUser
 
 --IF (@branchid>0)
 IF(1=1)
 BEGIN

	IF (ISNULL(@StudentBarCodeNo,'')<>'')
		BEGIN 
		select @StudentBranchid= ISNULL(I_Centre_Id,0) from T_Student_Center_Detail A inner join T_Student_Detail B ON A.I_Student_Detail_ID=B.I_Student_Detail_ID AND B.S_Student_ID=@StudentBarCodeNo
		--IF(@StudentBranchid = @branchid)
		IF(1=1)
		BEGIN
		
			SELECT   
				 SD.I_Student_Detail_ID AS I_Student_Detail_ID  
				,S_Student_ID AS S_Student_ID  
				,S_Title AS S_Title  
				,S_First_Name AS S_First_Name  
				,S_Middle_Name AS S_Middle_Name  
				,S_Last_Name AS S_Last_Name  
				,S_Email_ID as Email   
				,S_Phone_No as PhoneNumber   
				,S_Mobile_No as MobileNumber   
				,SCD.I_Centre_Id as CentreI
				,CM.S_Center_Name as CentreName
				 ,SBD.S_Batch_Name as BatchName
				 ,ISNULL(S_Curr_Address1, '') +' '+ ISNULL(S_Curr_Address2, '') +' '+ char (53) + ISNULL(S_Curr_Area, '') + ' '+ISNULL(S_Curr_Pincode, '') as Address 
				--,(S_Curr_Address1 +' '+ S_Curr_Address2 +' '+ char (53) + S_Curr_Area + ' '+S_Curr_Pincode) as Address   
				  
				FROM dbo.T_Student_Detail SD   
				INNER JOIN dbo.T_Student_Center_Detail SCD  
				ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID  
				INNER JOIN dbo.T_Brand_Center_Details BCD  
				ON BCD.I_Centre_Id  = SCD.I_Centre_ID 
				INNER JOIN T_Centre_Master CM ON CM.I_Centre_Id=SCD.I_Centre_ID
				inner join T_Student_Batch_Details STBD on STBD.I_Student_ID=SD.I_Student_Detail_ID
				inner join dbo.T_Student_Batch_Master SBD
				on SBD.I_Batch_ID=STBD.I_Batch_ID
				AND SD.S_Student_ID=@StudentBarCodeNo
				AND  STBD.I_Status = 1
		END		
	END

END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
