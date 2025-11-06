/**************************************************************************************************************
Created by  : Swagata De
Date		: 21.06.2007
Description : This SP will retrieve the KRAs for a particular Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [EOS].[uspGetTargetAchievementForEmployee] 
(	
	@iEmployeeID INT,
	@iMonth INT,
	@iYear INT
)	
AS
BEGIN
IF EXISTS ( SELECT * FROM EOS.T_Employee_KRA_Details WHERE I_Employee_ID=@iEmployeeID AND I_Target_Month = @iMonth AND I_Target_Year=@iYear)
	BEGIN
	
		SELECT DISTINCT
				TEKM.I_KRA_ID,
				TKM.S_KRA_Desc,
				TRKM.I_KRA_Index_ID,
				ISNULL(TEKM.N_Weightage,0) AS N_Weightage,
				ISNULL(TEKD.I_Target_Month,0) AS I_Target_Month,
				ISNULL(TEKD.I_Target_Year,0) AS I_Target_Year,
				ISNULL(TEKD.N_Target_Set,0) AS N_Target_Set,
				ISNULL(TEKD.N_Target_Achieved,0) AS N_Target_Achieved
		FROM 
				EOS.T_Employee_KRA_Map TEKM WITH(NOLOCK)
			LEFT OUTER JOIN EOS.T_Employee_KRA_Details TEKD WITH(NOLOCK)
				ON  TEKD.I_Employee_ID = TEKM.I_Employee_ID
				AND TEKD.I_KRA_ID = TEKM.I_KRA_ID
			INNER JOIN	EOS.T_KRA_Master TKM WITH(NOLOCK)
				ON TEKM.I_KRA_ID = TKM.I_KRA_ID
			INNER JOIN EOS.T_Role_KRA_Map TRKM WITH(NOLOCK)
				ON TEKM.I_KRA_ID = TRKM.I_KRA_ID
			AND TRKM.I_Role_ID IN (SELECT I_Role_ID FROM EOS.T_Employee_Role_Map WHERE I_Employee_ID = @iEmployeeID)
		WHERE	TEKM.I_Employee_ID = @iEmployeeID
			AND (TEKD.I_SubKRA_ID IS NULL OR TEKD.I_SubKRA_ID = 0)
			AND ISNULL(TEKD.I_Target_Month,@iMonth) = @iMonth AND ISNULL(TEKD.I_Target_Year,@iYear) = @iYear
		ORDER BY ISNULL(TEKM.N_Weightage,0)
			
			
		SELECT DISTINCT
				TEKM.I_Employee_ID,
				TEKM.I_KRA_ID,
				TKM.S_KRA_Desc,
				TEKM.I_SubKRA_ID,
				TKM1.S_KRA_Desc AS S_SubKRA_Desc,
				TRKM.I_KRA_Index_ID,
				ISNULL(TEKM.N_Weightage,0) AS N_Weightage,
				ISNULL(TEKD.I_Target_Month,0) AS I_Target_Month,
				ISNULL(TEKD.I_Target_Year,0) AS I_Target_Year,
				ISNULL(TEKD.N_Target_Set,0) AS N_Target_Set,
				ISNULL(TEKD.N_Target_Achieved,0) AS N_Target_Achieved
		FROM 
				EOS.T_Employee_KRA_Map TEKM WITH(NOLOCK)
			LEFT OUTER JOIN EOS.T_Employee_KRA_Details TEKD WITH(NOLOCK)
				ON  TEKM.I_Employee_ID = TEKD.I_Employee_ID
				AND TEKM.I_SubKRA_ID = TEKD.I_SubKRA_ID
			INNER JOIN	EOS.T_KRA_Master TKM WITH(NOLOCK)
				ON TEKM.I_KRA_ID = TKM.I_KRA_ID
			INNER JOIN EOS.T_KRA_Master TKM1 WITH(NOLOCK)
				ON TEKM.I_SubKRA_Id = TKM1.I_KRA_ID
			INNER JOIN EOS.T_Role_KRA_Map TRKM WITH(NOLOCK)
				ON TEKM.I_KRA_ID = TRKM.I_KRA_ID
			AND TRKM.I_Role_ID IN (SELECT I_Role_ID FROM EOS.T_Employee_Role_Map WHERE I_Employee_ID = @iEmployeeID)
		WHERE	TEKM.I_Employee_ID = @iEmployeeID
			AND (TEKM.I_SubKRA_ID IS NOT NULL AND TEKM.I_SubKRA_ID != 0)
			AND ISNULL(TEKD.I_Target_Month,@iMonth) = @iMonth AND ISNULL(TEKD.I_Target_Year,@iYear) = @iYear
		ORDER BY ISNULL(TEKM.N_Weightage,0)

	END
ELSE
	BEGIN
		SELECT DISTINCT
				TEKM.I_KRA_ID,
				TKM.S_KRA_Desc,
				TRKM.I_KRA_Index_ID,
				ISNULL(TEKM.N_Weightage,0) AS N_Weightage,
				@iMonth AS I_Target_Month,
				@iYear AS I_Target_Year,
				0 AS N_Target_Set,
				0 AS N_Target_Achieved
		FROM 
				EOS.T_Employee_KRA_Map TEKM WITH(NOLOCK)
			LEFT OUTER JOIN EOS.T_Employee_KRA_Details TEKD WITH(NOLOCK)
				ON  TEKD.I_Employee_ID = TEKM.I_Employee_ID
				AND TEKD.I_KRA_ID = TEKM.I_KRA_ID
			INNER JOIN	EOS.T_KRA_Master TKM WITH(NOLOCK)
				ON TEKM.I_KRA_ID = TKM.I_KRA_ID
			INNER JOIN EOS.T_Role_KRA_Map TRKM WITH(NOLOCK)
				ON TEKM.I_KRA_ID = TRKM.I_KRA_ID
			AND TRKM.I_Role_ID IN (SELECT I_Role_ID FROM EOS.T_Employee_Role_Map WHERE I_Employee_ID = @iEmployeeID)
		WHERE	TEKM.I_Employee_ID = @iEmployeeID
			AND (TEKD.I_SubKRA_ID IS NULL OR TEKD.I_SubKRA_ID = 0)	
		ORDER BY ISNULL(TEKM.N_Weightage,0)		
			
			
		SELECT DISTINCT
				TEKM.I_Employee_ID,
				TEKM.I_KRA_ID,
				TKM.S_KRA_Desc,
				TRKM.I_KRA_Index_ID,
				TEKM.I_SubKRA_ID,
				TKM1.S_KRA_Desc AS S_SubKRA_Desc,
				ISNULL(TEKM.N_Weightage,0) AS N_Weightage,
				@iMonth AS I_Target_Month,
				@iYear AS I_Target_Year,
				0 AS N_Target_Set,
				0 AS N_Target_Achieved
		FROM 
				EOS.T_Employee_KRA_Map TEKM WITH(NOLOCK)
			LEFT OUTER JOIN EOS.T_Employee_KRA_Details TEKD WITH(NOLOCK)
				ON  TEKM.I_Employee_ID = TEKD.I_Employee_ID
				AND TEKM.I_SubKRA_ID = TEKD.I_SubKRA_ID
			INNER JOIN	EOS.T_KRA_Master TKM WITH(NOLOCK)
				ON TEKM.I_KRA_ID = TKM.I_KRA_ID
			INNER JOIN EOS.T_KRA_Master TKM1 WITH(NOLOCK)
				ON TEKM.I_SubKRA_Id = TKM1.I_KRA_ID
			INNER JOIN EOS.T_Role_KRA_Map TRKM WITH(NOLOCK)
				ON TEKM.I_KRA_ID = TRKM.I_KRA_ID
			AND TRKM.I_Role_ID IN (SELECT I_Role_ID FROM EOS.T_Employee_Role_Map WHERE I_Employee_ID = @iEmployeeID)
		WHERE	TEKM.I_Employee_ID = @iEmployeeID
			AND (TEKM.I_SubKRA_ID IS NOT NULL AND TEKM.I_SubKRA_ID != 0)	
		ORDER BY ISNULL(TEKM.N_Weightage,0)		
	END

END
