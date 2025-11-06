





CREATE VIEW [dbo].[LMSInterfaceLogsView]
as

SELECT [ID]
      ,[StudentDetailID]
      ,[StudentID]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Email]
      ,[ContactNo]
      ,[CurrAddress]
      ,[Country]
      ,[BrandID]
      ,[BrandName]
      ,[CentreID]
      ,[CentreCode]
      ,[CentreName]
      ,[BatchID]
      ,[BatchCode]
      ,[BatchName]
      ,[CourseID]
      ,[CourseName]
      ,[ActionType]
      ,[ActionStatus]
      ,[NoofAttempts]
      ,[StatusID]
      ,[CreatedOn]
      ,[CompletedOn]
      ,[Remarks]
      ,[OrgEmailID]
      ,[SecondaryLanguage]
FROM 
LMS.T_Student_Details_Interface_API WHERE ActionStatus=0 AND StudentDetailID IS NOT NULL and NoofAttempts>1
--and ActionType!='UPDATE STUDENT BATCH'
and CreatedOn>='2021-07-01'
--ORDER BY ID DESC



--GRANT SELECT ON [dbo].[LMSInterfaceLogsView] TO [azraalikhan]