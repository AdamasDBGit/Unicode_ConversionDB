



-- =============================================
-- Author:		<Pramatha Nath Ghosh>
-- Create date: <05-21-2014,>
-- Description:	<Get SM By Student>
-- =============================================
CREATE PROCEDURE [dbo].[KPMG_uspGetSmStudentwise]

AS
	BEGIN Try
		DECLARE @tempInfo TABLE (STId VARCHAR(50),ItmCode VARCHAR(50),BrCode VARCHAR(50),ColumnNumber VARCHAR(50))
		Insert into @tempInfo
		SELECT Fld_KPMG_StudentId,Fld_KPMG_ItemCode,Fld_KPMG_Barcode,ROW_NUMBER() OVER(PARTITION BY Fld_KPMG_StudentId ORDER BY Fld_KPMG_StudentId) AS ColumnNumber FROM Tbl_KPMG_SM_Issue

		DECLARE @tmpIssue TABLE (StudId VARCHAR(50),
								 ItmCd_1 VARCHAR(50),Brcd_1 VARCHAR(50),ItmCd_2 VARCHAR(50),Brcd_2 VARCHAR(50),
								 ItmCd_3 VARCHAR(50),Brcd_3 VARCHAR(50),ItmCd_4 VARCHAR(50),Brcd_4 VARCHAR(50),
								 ItmCd_5 VARCHAR(50),Brcd_5 VARCHAR(50),ItmCd_6 VARCHAR(50),Brcd_6 VARCHAR(50),
								 ItmCd_7 VARCHAR(50),Brcd_7 VARCHAR(50),ItmCd_8 VARCHAR(50),Brcd_8 VARCHAR(50))

		Insert into @tmpIssue
		SELECT DISTINCT t.Fld_KPMG_StudentId,
						IsNUll(t1.ItmCode, ' ') AS ItmCode1,IsNUll(t1.BrCode, ' ') AS BarCode1,
						IsNUll(t2.ItmCode, ' ') AS ItmCode2,IsNUll(t2.BrCode, ' ') AS BarCode2,
						IsNUll(t3.ItmCode, ' ') AS ItmCode3,IsNUll(t3.BrCode, ' ') AS BarCode3,
						IsNUll(t4.ItmCode, ' ') AS ItmCode4,IsNUll(t4.BrCode, ' ') AS BarCode4,
						IsNUll(t5.ItmCode, ' ') AS ItmCode5,IsNUll(t5.BrCode, ' ') AS BarCode5,
						IsNUll(t6.ItmCode, ' ') AS ItmCode6,IsNUll(t6.BrCode, ' ') AS BarCode6,
						IsNUll(t7.ItmCode, ' ') AS ItmCode7,IsNUll(t7.BrCode, ' ') AS BarCode7,
						IsNUll(t8.ItmCode, ' ') AS ItmCode8,IsNUll(t8.BrCode, ' ') AS BarCode8		
		FROM Tbl_KPMG_SM_Issue t 
		LEFT OUTER JOIN @tempInfo t1 ON t.Fld_KPMG_StudentId=t1.STId AND t1.ColumnNumber=1 
		LEFT OUTER JOIN @tempInfo t2 ON t.Fld_KPMG_StudentId=t2.STId AND t2.ColumnNumber=2 
		LEFT OUTER JOIN @tempInfo t3 ON t.Fld_KPMG_StudentId=t3.STId AND t3.ColumnNumber=3
		LEFT OUTER JOIN @tempInfo t4 ON t.Fld_KPMG_StudentId=t4.STId AND t4.ColumnNumber=4
		LEFT OUTER JOIN @tempInfo t5 ON t.Fld_KPMG_StudentId=t4.STId AND t5.ColumnNumber=5
		LEFT OUTER JOIN @tempInfo t6 ON t.Fld_KPMG_StudentId=t4.STId AND t6.ColumnNumber=6
		LEFT OUTER JOIN @tempInfo t7 ON t.Fld_KPMG_StudentId=t4.STId AND t7.ColumnNumber=7
		LEFT OUTER JOIN @tempInfo t8 ON t.Fld_KPMG_StudentId=t4.STId AND t8.ColumnNumber=8 
		Order by t.Fld_KPMG_StudentId desc


		-- Code for the Installment Purpose


		-- Declare temp table to insert datas by Studentwise INstallment
		DECLARE @tempInstl TABLE (STId VARCHAR(50),InstlNo VARCHAR(50),ColumnNumber VARCHAR(50))

		-- Insert the datas in the temp table
		Insert into @tempInstl
		SELECT InvP.I_Student_Detail_ID,ClDt.I_Installment_No,ROW_NUMBER() OVER(PARTITION BY InvP.I_Student_Detail_ID ORDER BY InvP.I_Student_Detail_ID) AS ColumnNumber 
		  FROM T_Invoice_Parent InvP INNER JOIN T_Invoice_Child_Header ClHd ON InvP.I_Invoice_Header_ID = ClHd.I_Invoice_Header_ID
									 INNER JOIN T_Invoice_child_detail ClDt ON ClDt.I_Invoice_Child_Header_ID = ClHd.I_Invoice_Header_ID
		 Order By InvP.I_Student_Detail_ID,ClDt.I_Installment_No,ColumnNumber

		-- Declare tamp table to store the datas in  the column format from the row values
		DECLARE @tmpInstallment TABLE (StudId VARCHAR(50),
									   Instl_1 VARCHAR(50),Instl_2 VARCHAR(50),Instl_3 VARCHAR(50),Instl_4 VARCHAR(50),
									   Instl_5 VARCHAR(50),Instl_6 VARCHAR(50),Instl_7 VARCHAR(50),Instl_8 VARCHAR(50))							   

		-- Insert the datas in  the column format from the row values
		Insert into @tmpInstallment
		SELECT DISTINCT t.I_Student_Detail_ID,
						IsNUll(t1.InstlNo, ' ') AS Instl_1,
						IsNUll(t2.InstlNo, ' ') AS Instl_2,
						IsNUll(t3.InstlNo, ' ') AS Instl_3,
						IsNUll(t4.InstlNo, ' ') AS Instl_4,
						IsNUll(t5.InstlNo, ' ') AS Instl_5,
						IsNUll(t6.InstlNo, ' ') AS Instl_6,
						IsNUll(t7.InstlNo, ' ') AS Instl_7,
						IsNUll(t8.InstlNo, ' ') AS Instl_8				
		FROM T_Invoice_Parent t 
		LEFT OUTER JOIN @tempInstl t1 ON t.I_Student_Detail_ID = t1.STId AND t1.ColumnNumber=1 
		LEFT OUTER JOIN @tempInstl t2 ON t.I_Student_Detail_ID = t2.STId AND t2.ColumnNumber=2 
		LEFT OUTER JOIN @tempInstl t3 ON t.I_Student_Detail_ID = t3.STId AND t3.ColumnNumber=3
		LEFT OUTER JOIN @tempInstl t4 ON t.I_Student_Detail_ID = t4.STId AND t4.ColumnNumber=4
		LEFT OUTER JOIN @tempInstl t5 ON t.I_Student_Detail_ID = t5.STId AND t5.ColumnNumber=5
		LEFT OUTER JOIN @tempInstl t6 ON t.I_Student_Detail_ID = t6.STId AND t6.ColumnNumber=6
		LEFT OUTER JOIN @tempInstl t7 ON t.I_Student_Detail_ID = t7.STId AND t7.ColumnNumber=7
		LEFT OUTER JOIN @tempInstl t8 ON t.I_Student_Detail_ID = t8.STId AND t8.ColumnNumber=8 
		Order by t.I_Student_Detail_ID desc 

		Select Sd.I_Student_Detail_ID as StudentId, 
			   Sd.S_First_Name + ' ' + Sd.S_Middle_Name + ' ' + Sd.S_Last_Name as StudentName,
			   IsNUll(Bd.I_Batch_ID, 0) as BatchId,
			   IsNUll(Ti.ItmCd_1,' ') as ItmCd_1,
			   IsNUll(Ti.Brcd_1,' ')  as Brcd_1,
			   IsNUll(Ti.ItmCd_2,' ') as ItmCd_2,
			   IsNUll(Ti.Brcd_2,' ')  as Brcd_2,
			   IsNUll(Ti.ItmCd_3,' ') as ItmCd_3,
			   IsNUll(Ti.Brcd_3,' ')  as Brcd_3,
			   IsNUll(Ti.ItmCd_4,' ') as ItmCd_4,
			   IsNUll(Ti.Brcd_4,' ')  as Brcd_4,
			   IsNUll(Ti.ItmCd_5,' ') as ItmCd_5,
			   IsNUll(Ti.Brcd_5,' ')  as Brcd_5,
			   IsNUll(Ti.ItmCd_6,' ') as ItmCd_6,
			   IsNUll(Ti.Brcd_6,' ')  as Brcd_6,
			   IsNUll(Ti.ItmCd_7,' ') as ItmCd_7,
			   IsNUll(Ti.Brcd_7,' ')  as Brcd_7,
			   IsNUll(Ti.ItmCd_8,' ') as ItmCd_8,
			   IsNUll(Ti.Brcd_8,' ')  as Brcd_8,
			   Case when IsNUll(TIns.Instl_1 ,0)=0 then 0 else 1 END as Instl_1,	   
			   Case when IsNUll(TIns.Instl_2 ,0)=0 then 0 else 1 END as Instl_2,
			   Case when IsNUll(TIns.Instl_3 ,0)=0 then 0 else 1 END as Instl_3,
			   Case when IsNUll(TIns.Instl_4 ,0)=0 then 0 else 1 END as Instl_4,
			   Case when IsNUll(TIns.Instl_5 ,0)=0 then 0 else 1 END as Instl_5,
			   Case when IsNUll(TIns.Instl_6 ,0)=0 then 0 else 1 END as Instl_6,
			   Case when IsNUll(TIns.Instl_7 ,0)=0 then 0 else 1 END as Instl_7,
			   Case when IsNUll(TIns.Instl_8 ,0)=0 then 0 else 1 END as Instl_8
		from	T_Student_Detail Sd
			INNER JOIN  T_Student_Batch_Details  Bd  ON Sd.I_Student_Detail_ID = Bd.I_Student_ID
			INNER JOIN @tmpIssue Ti ON Sd.I_Student_Detail_ID = Ti.StudId
			INNER JOIN @tmpInstallment TIns ON Sd.I_Student_Detail_ID = TIns.StudId	

	END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH
