USE [BlockStone_Capital]
GO

DROP TABLE  IF EXISTS [tbl_Funds]
GO

DROP TABLE IF EXISTS [tbl_Monthly_AUM]
GO

DROP TABLE IF EXISTS [tbl_Monthly_NAV]
GO

DROP TABLE IF EXISTS [tbl_Monthly_Return]
GO

DROP TABLE IF EXISTS [tbl_FileDetails]
GO

DROP TABLE IF EXISTS [tbl_Additional_Column]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_Funds](
	[ManagementCompany] [nvarchar](500) NULL,
	[FundName] [nvarchar](500) NULL,
	[FundId] [bigint] NOT NULL,
	[ISIN_OR_RefCode] [nvarchar](500) NULL,
	[Approaches] [nvarchar](1500) NULL,
	[Strategies] [nvarchar](MAX) NULL,
	[StrategyDescription] [nvarchar](MAX) NULL,
	[PortfolioManager] [nvarchar](1500) NULL,
	[CEO_OR_COO] [nvarchar](1500) NULL,
	[MarketingManager] [nvarchar](1500) NULL,
	[Address1] [nvarchar](1500) NULL,
	[Address2] [nvarchar](1500) NULL,
	[Zip_Post_Code] [nvarchar](1500) NULL,
	[FundDuration] [nvarchar](1500) NULL,
	[HeadTrader] [nvarchar](1500) NULL,
	[Currency] [nvarchar](1500) NULL,
	[MarketCaps] [nvarchar](1500) NULL,
	[Regions] [nvarchar](1500) NULL,
	[Countries] [nvarchar](1500) NULL,
	[AUM_US_M] [nvarchar](1500) NULL,
	[PrimaryContact] [nvarchar](1500) NULL,
	[ContactEmailAddress] [nvarchar](2000) NULL,
	[City] [nvarchar](1500) NULL,
	[GeneralEmailAddress] [nvarchar](1500) NULL,
	[Website] [nvarchar](1500) NULL,
	[Auditor] [nvarchar](1500) NULL,
	[Administrator] [nvarchar](1500) NULL,
	[LegalAdvisors] [nvarchar](1500) NULL,
	[FundCapacity_US_M] [nvarchar](1500) NULL,
	[TotalGroupAssets_US_M] [nvarchar](1500) NULL,
	[FundType] [nvarchar](1500) NULL,
	[PerformanceFee] [nvarchar](1500) NULL,
	[ManagementFee] [nvarchar](1500) NULL,
	[MinimumInvestment] [nvarchar](1500) NULL,
	[SubscriptionTerms] [nvarchar](1500) NULL,
	[RedemptionTerms] [nvarchar](1500) NULL,
	[HighWaterMark] [nvarchar](1500) NULL,
	[HurdleRate] [nvarchar](1500) NULL,
	[Telephone] [nvarchar](1500) NULL,
	[Country] [nvarchar](1500) NULL,
	[PrimeBroker] [nvarchar](1500) NULL,
	[Sectors] [nvarchar](1000) NULL,
	[Domicile] [nvarchar](1500) NULL,
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_tblFundId]
ON tbl_Funds (FundId ASC)

CREATE NONCLUSTERED INDEX [IX_tblFundName]
ON tbl_Funds (FundName ASC)

CREATE NONCLUSTERED INDEX [IX_tblISIN_OR_RefCode]
ON tbl_Funds (ISIN_OR_RefCode ASC)

CREATE NONCLUSTERED INDEX [IX_tblManagementCompany]
ON tbl_Funds (ManagementCompany ASC)


CREATE TABLE [dbo].[tbl_Monthly_AUM](
	[rid] INT PRIMARY KEY IDENTITY(1,1),
	[FundId] [bigint] NOT NULL,
	[key_Value] VARCHAR(50) NULL,
	[Data_Value] VARCHAR(50) NULL,
)ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_tbl_Monthly_AUM_FundID]
ON [tbl_Monthly_AUM] (FundId ASC)

CREATE TABLE [dbo].[tbl_Monthly_NAV](
	[rid] INT PRIMARY KEY IDENTITY(1,1),
	[FundId] [bigint] NOT NULL,
	[key_Value] VARCHAR(50) NULL,
	[Data_Value] VARCHAR(50) NULL,
)ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_tbl_Monthly_NAV_FundID]
ON [tbl_Monthly_NAV] (FundId ASC)

CREATE TABLE [dbo].[tbl_Monthly_Return](
	[rid] INT PRIMARY KEY IDENTITY(1,1),
	[FundId] [bigint] NOT NULL,
	[key_Value] VARCHAR(50) NULL,
	[Data_Value] VARCHAR(50) NULL,
)ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_tbl_Monthly_Return_FundID]
ON [tbl_Monthly_Return] (FundId ASC)

CREATE TABLE [dbo].[tbl_Additional_Column](
	[rid] INT PRIMARY KEY IDENTITY(1,1),
	[FundId] [bigint] NOT NULL,
	[key_Value] VARCHAR(MAX) NULL,
	[Data_Value] VARCHAR(MAX) NULL,
)ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_tbl_Additional_Column_FundID]
ON [tbl_Additional_Column] (FundId ASC)

CREATE TABLE [dbo].[tbl_FileDetails](
	[rid] INT IDENTITY(1,1) PRIMARY KEY,
	[FileName] VARCHAR(200) NOT NULL,
	[ImportedDate] VARCHAR(50) NULL
)ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_tbl_FileDetails_rID]
ON [tbl_FileDetails] (rid ASC)
