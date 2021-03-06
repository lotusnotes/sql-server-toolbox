USE [WideWorldImporters]
GO
CREATE TABLE #ImplicitConversionTesting (
	[ID] [int] IDENTITY (1,1) NOT NULL,
	[SomeName] [varchar](50) NOT NULL,
	[SomeID] [int] NOT NULL,
	[SomeDate][datetime2](7)
	CONSTRAINT PK_Implicit PRIMARY KEY (ID)
)
GO 
INSERT INTO #ImplicitConversionTesting (SomeName, SomeID, SomeDate) VALUES ('Whatever',123,'1/1/2018')
GO
SELECT *
  FROM #ImplicitConversionTesting
  WHERE SomeID like '3%' --implicit conversion 
  --WHERE left(SomeID,1) = 3 --same!
  --WHERE SomeDate like N'%1%' --implicit conversion
  --WHERE SomeName like N'What%' --implicit conversion
GO
DROP TABLE IF EXISTS #ImplicitConversionTesting
