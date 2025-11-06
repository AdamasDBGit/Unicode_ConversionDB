CREATE PROCEDURE [dbo].[tempInsertCredNote](@StdID Nnvarchar(max), @Amt DECIMAL(14,2))
AS
BEGIN
--DECLARE @StdID VARCHAR(MAX)='1920/RICE/3269'
DECLARE @StdDetId INT
DECLARE @InvDetID INT
DECLARE @CrID INT
DECLARE @InvChDetID INT
--DECLARE @Amt DECIMAL(14,2)=180.00





SELECT @StdDetId=TSD.I_Student_Detail_ID FROM dbo.T_Student_Detail AS TSD WHERE TSD.S_Student_ID=@StdID

IF ((SELECT COUNT(*) FROM dbo.T_Invoice_Parent AS TIP WHERE TIP.I_Student_Detail_ID=@StdDetId AND TIP.I_Status=0)=1)

BEGIN


	SELECT @InvDetID=TIP.I_Invoice_Header_ID FROM dbo.T_Invoice_Parent AS TIP WHERE TIP.I_Student_Detail_ID=@StdDetId AND TIP.I_Status=0

	IF ((SELECT COUNT(*) FROM dbo.T_Credit_Note_Invoice_Child_Detail AS TCNICD WHERE TCNICD.I_Invoice_Header_ID=@InvDetID
	AND TCNICD.S_Invoice_Number LIKE 'RC19C0820%')=1)

		BEGIN

			SELECT @CrID=TCNICD.I_Credit_Note_Invoice_Child_Detail_ID,@InvChDetID=TCNICD.I_Invoice_Detail_ID 
			FROM dbo.T_Credit_Note_Invoice_Child_Detail AS TCNICD WHERE TCNICD.I_Invoice_Header_ID=@InvDetID
			AND TCNICD.S_Invoice_Number LIKE 'RC19C0820%'

			IF NOT EXISTS(SELECT * FROM dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS TCNICDT WHERE TCNICDT.I_Credit_Note_Invoice_Child_Detail_ID=@CrID)

			BEGIN

				INSERT INTO dbo.T_Credit_Note_Invoice_Child_Detail_Tax
				(
					I_Credit_Note_Invoice_Child_Detail_ID,
					I_Tax_ID,
					I_Invoice_Detail_ID,
					N_Tax_Value
				)
				VALUES
				(   @CrID,   -- I_Credit_Note_Invoice_Child_Detail_ID - int
					7,   -- I_Tax_ID - int
					@InvChDetID,   -- I_Invoice_Detail_ID - int
					@Amt -- N_Tax_Value - numeric(18, 2)
					)

				INSERT INTO dbo.T_Credit_Note_Invoice_Child_Detail_Tax
				(
					I_Credit_Note_Invoice_Child_Detail_ID,
					I_Tax_ID,
					I_Invoice_Detail_ID,
					N_Tax_Value
				)
				VALUES
				(   @CrID,   -- I_Credit_Note_Invoice_Child_Detail_ID - int
					8,   -- I_Tax_ID - int
					@InvChDetID,   -- I_Invoice_Detail_ID - int
					@Amt -- N_Tax_Value - numeric(18, 2)
					)

					SELECT @StdID AS StudentID,TCNICDT.I_Credit_Note_Invoice_Child_Detail_ID,SUM(TCNICDT.N_Tax_Value) AS TaxAmount FROM dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS TCNICDT 
					WHERE TCNICDT.I_Credit_Note_Invoice_Child_Detail_ID=@CrID
					GROUP BY TCNICDT.I_Credit_Note_Invoice_Child_Detail_ID

			END

		END



END
END

