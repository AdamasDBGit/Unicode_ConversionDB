

CREATE VIEW [dbo].[OracleTransportData]
AS
SELECT I_Center_ID,S_Route_Name,Dt_StartDate,Dt_EndDate,SUM(ISNULL(N_Collectable,0)) as Collectable FROM dbo.T_TransportDataForOracle
group by I_Center_ID,S_Route_Name,Dt_StartDate,Dt_EndDate
--order by I_Center_ID,S_Route_Name