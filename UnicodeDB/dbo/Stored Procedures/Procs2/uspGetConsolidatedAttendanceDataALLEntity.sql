CREATE PROCEDURE [dbo].[uspGetConsolidatedAttendanceDataALLEntity]
AS
BEGIN
	
	TRUNCATE TABLE dbo.T_AttendanceDataALLEntities;
	
	--EXEC dbo.uspGetNewAttendanceDataAC;
	--EXEC dbo.uspGetNewAttendanceDataAIS;
	--EXEC dbo.uspGetNewAttendanceDataAIT;
	--EXEC dbo.uspGetNewAttendanceDataAWS;
	EXEC dbo.uspGetNewAttendanceDataRICE;

	
	
END
