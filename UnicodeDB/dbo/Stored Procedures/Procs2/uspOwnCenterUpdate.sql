CREATE PROCEDURE [dbo].[uspOwnCenterUpdate]
AS
Begin	

	Update dbo.T_Receipt_Header
		SET N_Amount_Rff = N_Receipt_Amount,
			N_Receipt_Tax_Rff = N_Tax_Amount
	FROM T_Receipt_Header RH
		where RH.I_Centre_Id in
			(SELECT I_Centre_ID FROM T_CENTRE_MASTER WHERE I_Is_OwnCenter = 1)

	UPDATE dbo.T_Receipt_Component_Detail
		SET N_Comp_Amount_Rff = N_Amount_Paid
	FROM dbo.T_Receipt_Component_Detail
		WHERE I_Receipt_Detail_ID IN
		(
		Select I_Receipt_Header_ID FROM T_Receipt_Header RH
		where RH.I_Centre_Id in
			(SELECT I_Centre_ID FROM T_CENTRE_MASTER WHERE I_Is_OwnCenter = 1)
		)

	UPDATE dbo.T_Receipt_Tax_Detail
		SET N_Tax_Rff = N_Tax_Paid
	FROM dbo.T_Receipt_Tax_Detail
		WHERE I_Receipt_Comp_Detail_ID IN
		(
			SELECT I_Receipt_Comp_Detail_ID from dbo.T_Receipt_Component_Detail
			WHERE I_Receipt_Detail_ID IN
			(
				Select I_Receipt_Header_ID FROM T_Receipt_Header RH
				where RH.I_Centre_Id in
					(SELECT I_Centre_ID FROM T_CENTRE_MASTER WHERE I_Is_OwnCenter = 1)
			)
		)

	UPDATE dbo.T_OnAccount_Receipt_Tax
		SET N_Tax_Rff = N_Tax_Paid
		FROM dbo.T_OnAccount_Receipt_Tax
		WHERE I_Receipt_Header_ID IN 
			(
				Select I_Receipt_Header_ID FROM T_Receipt_Header RH
				where RH.I_Centre_Id in
					(SELECT I_Centre_ID FROM T_CENTRE_MASTER WHERE I_Is_OwnCenter = 1)
			)
			
			


End
