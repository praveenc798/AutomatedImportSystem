USE BlockStone_Capital
GO

CREATE OR
	ALTER PROCEDURE [dbo].[Up_Insert_FundData]
( @TableName NVARCHAR(150))
AS

SET NOCOUNT ON

DECLARE @SQL VARCHAR(MAX)
DECLARE @DELETE VARCHAR(MAX)
DECLARE @UpdateSQLBatch_1 VARCHAR(MAX)
DECLARE @UpdateSQLBatch_2 VARCHAR(MAX)
DECLARE @ErrorMessage NVARCHAR(4000);  
DECLARE @ErrorSeverity INT
DECLARE @ErrorState INT

BEGIN TRY

INSERT INTO tbl_FileDetails ([FileName], ImportedDate)
VALUES(@TableName, GETDATE())

SET @DELETE = 'DELETE FROM dbo.[' +  @TableName + ']
WHERE Fund_Id IS NULL AND ISIN_or_Ref_Code IS NULL'

EXEC (@DELETE)

SET @UpdateSQLBatch_1 =
'UPDATE F
SET F.ManagementCompany =
CASE
	WHEN ISNULL(F.ManagementCompany, '''') <> ISNULL(S.Management_Company, '''')
	THEN S.Management_Company
	ELSE F.ManagementCompany
END,
 F.FundName =
CASE
	WHEN ISNULL(F.FundName, '''') <> ISNULL(S.Fund_Name, '''')
	THEN S.Fund_Name
	ELSE F.FundName
END,
 F.Approaches =
CASE
	WHEN ISNULL(F.Approaches, '''') <> ISNULL(S.Approaches, '''')
	THEN S.Approaches
	ELSE F.Approaches
END,
 F.Strategies =
CASE
	WHEN ISNULL(F.Strategies, '''') <> ISNULL(S.Strategies, '''')
	THEN S.Strategies
	ELSE F.Strategies
END,
 F.StrategyDescription =
CASE
	WHEN ISNULL(F.StrategyDescription, '''') <> ISNULL(S.Strategy_Description, '''')
	THEN S.Strategy_Description
	ELSE F.StrategyDescription
END,
 F.CEO_OR_COO =
CASE
	WHEN ISNULL(F.CEO_OR_COO, '''') <> ISNULL(S.CEO_OR_COO, '''')
	THEN S.CEO_OR_COO
	ELSE F.CEO_OR_COO
END,
 F.MarketingManager =
CASE
	WHEN ISNULL(F.MarketingManager, '''') <> ISNULL(S.Marketing_Manager, '''')
	THEN S.Marketing_Manager
	ELSE F.MarketingManager
END,
 F.PortfolioManager =
CASE
	WHEN ISNULL(F.PortfolioManager, '''') <> ISNULL(S.Portfolio_manager,'''')
	THEN S.Portfolio_manager
	ELSE F.PortfolioManager
END,
 F.PrimaryContact =
CASE
	WHEN ISNULL(F.PrimaryContact, '''') <> ISNULL(S.Primary_contact, '''')
	THEN S.Primary_contact
	ELSE F.PrimaryContact
END,
 F.ContactEmailAddress =
CASE
	WHEN ISNULL(F.ContactEmailAddress, '''') <> ISNULL(S.Contact_email_address, '''')
	THEN S.Contact_email_address
	ELSE F.ContactEmailAddress
END,
 F.GeneralEmailAddress =
CASE
	WHEN ISNULL(F.GeneralEmailAddress, '''') <> ISNULL(S.General_Email_Address, '''')
	THEN S.General_Email_Address
	ELSE F.GeneralEmailAddress 
END,
 F.City =
CASE
	WHEN ISNULL(F.City, '''') <> ISNULL(S.City, '''')
	THEN S.City
	ELSE F.City
END,
 F.Website =
CASE
	WHEN ISNULL(F.Website, '''') <> ISNULL(S.Website, '''')
	THEN S.Website
	ELSE F.Website
END,
 F.Administrator =
CASE
	WHEN ISNULL(F.Administrator, '''') <> ISNULL(S.Administrator, '''')
	THEN S.Administrator
	ELSE F.Administrator
END,
 F.Auditor =
CASE
	WHEN ISNULL(F.Auditor, '''') <> ISNULL(S.Auditor, '''')
	THEN S.Auditor
	ELSE F.Auditor
END,
 F.LegalAdvisors =
CASE
	WHEN ISNULL(F.LegalAdvisors, '''') <> ISNULL(S.Legal_Advisors, '''')
	THEN S.Legal_Advisors
	ELSE F.LegalAdvisors
END,
 F.FundCapacity_US_M =
CASE
	WHEN ISNULL(F.FundCapacity_US_M, '''') <> ISNULL(S.Fund_Capacity_US_m, '''')
	THEN S.Fund_Capacity_US_m
	ELSE F.FundCapacity_US_M
END,
 F.TotalGroupAssets_US_M =
CASE
	WHEN ISNULL(F.TotalGroupAssets_US_M, '''') <> ISNULL(S.Total_Group_Assets_US_m, '''')
	THEN S.Total_Group_Assets_US_m
	ELSE F.TotalGroupAssets_US_M
END,
 F.FundType =
CASE
	WHEN ISNULL(F.FundType, '''') <> ISNULL(S.Fund_Type, '''')
	THEN S.Fund_Type
	ELSE F.FundType
END,
 F.Address1 =
CASE
	WHEN ISNULL(F.Address1, '''') <> ISNULL(S.Address_1, '''')
	THEN S.Address_1
	ELSE F.Address1
END
FROM dbo.tbl_Funds F
INNER JOIN dbo.[' +  @TableName + '] S ON
ISNULL(S.Fund_Id,'''') = ISNULL(F.FundId, '''')
	AND ISNULL(S.ISIN_or_Ref_Code, '''') = ISNULL(F.ISIN_OR_RefCode,'''')'

EXEC (@UpdateSQLBatch_1)

SET @UpdateSQLBatch_2 =
'UPDATE F
SET 
 F.AUM_US_M =
CASE
	WHEN ISNULL(F.AUM_US_M, '''') <> ISNULL(S.AUM_US_m, '''')
	THEN S.AUM_US_m
	ELSE F.AUM_US_M
END,
 F.Address2 =
CASE
	WHEN ISNULL(F.Address2, '''') <> ISNULL(S.Address_2, '''')
	THEN S.Address_2
	ELSE F.Address2
END,
 F.Zip_Post_Code =
CASE
	WHEN ISNULL(F.Zip_Post_Code, '''') <> ISNULL(S.Zip_Post_Code, '''')
	THEN S.Zip_Post_Code
	ELSE F.Zip_Post_Code
END,
 F.PerformanceFee =
CASE
	WHEN ISNULL(F.PerformanceFee, '''') <> ISNULL(S.Performance_Fee, '''')
	THEN S.Performance_Fee
	ELSE F.PerformanceFee
END,
 F.ManagementFee =
CASE
	WHEN ISNULL(F.ManagementFee, '''') <> ISNULL(S.Management_Fee, '''')
	THEN S.Management_Fee
	ELSE F.ManagementFee
END,
 F.MinimumInvestment =
CASE
	WHEN ISNULL(F.MinimumInvestment, '''') <> ISNULL(S.Minimum_Investment, '''')
	THEN S.Minimum_Investment
	ELSE F.MinimumInvestment
END,
 F.SubscriptionTerms =
CASE
	WHEN ISNULL(F.SubscriptionTerms, '''') <> ISNULL(S.Subscription_Terms, '''')
	THEN S.Subscription_Terms
	ELSE F.SubscriptionTerms
END,
 F.RedemptionTerms =
CASE
	WHEN ISNULL(F.RedemptionTerms, '''') <> ISNULL(S.Redemption_Terms, '''')
	THEN S.Redemption_Terms
	ELSE F.RedemptionTerms
END,
 F.HighWaterMark =
CASE
	WHEN ISNULL(F.HighWaterMark, '''') <> ISNULL(S.High_Water_Mark, '''')
	THEN S.High_Water_Mark
	ELSE F.HighWaterMark
END,
 F.HurdleRate =
CASE
	WHEN ISNULL(F.HurdleRate, '''') <> ISNULL(S.Hurdle_Rate, '''')
	THEN S.Hurdle_Rate
	ELSE F.HurdleRate
END,
 F.Telephone =
CASE
	WHEN ISNULL(F.Telephone, '''') <> ISNULL(S.Telephone, '''')
	THEN S.Telephone
	ELSE F.Telephone
END,
 F.Country =
CASE
	WHEN ISNULL(F.Country, '''') <> ISNULL(S.Country, '''')
	THEN S.Country
	ELSE F.Country
END,
 F.PrimeBroker =
CASE
	WHEN ISNULL(F.PrimeBroker, '''') <> ISNULL(S.Prime_Broker, '''')
	THEN S.Prime_Broker
	ELSE F.PrimeBroker
END,
 F.FundDuration =
CASE
	WHEN ISNULL(F.FundDuration, '''') <> ISNULL(S.Fund_Duration, '''')
	THEN S.Fund_Duration
	ELSE F.FundDuration
END,
 F.HeadTrader =
CASE
	WHEN ISNULL(F.HeadTrader, '''') <> ISNULL(S.Head_Trader, '''')
	THEN S.Head_Trader
	ELSE F.HeadTrader
END,
 F.Sectors =
CASE
	WHEN ISNULL(F.Sectors, '''') <> ISNULL(S.Sectors, '''')
	THEN S.Sectors
	ELSE F.Sectors
END,
 F.Domicile =
CASE
	WHEN ISNULL(F.Domicile, '''') <> ISNULL(S.Domicile, '''')
	THEN S.Domicile
	ELSE F.Domicile
END,
 F.Currency =
CASE
	WHEN ISNULL(F.Currency, '''') <> ISNULL(S.Currency, '''')
	THEN S.Currency
	ELSE F.Currency
END,
 F.MarketCaps =
CASE
	WHEN ISNULL(F.MarketCaps, '''') <> ISNULL(S.Market_Caps, '''')
	THEN S.Market_Caps
	ELSE F.MarketCaps
END,
 F.Regions =
CASE
	WHEN ISNULL(F.Regions, '''') <> ISNULL(S.Regions, '''')
	THEN S.Regions
	ELSE F.Regions
END,
 F.Countries =
CASE
	WHEN ISNULL(F.Countries, '''') <> ISNULL(S.Countries, '''')
	THEN S.Countries
	ELSE F.Countries
END
FROM dbo.tbl_Funds F
INNER JOIN dbo.[' +  @TableName + '] S ON
ISNULL(S.Fund_Id,'''') = ISNULL(F.FundId, '''')
	AND ISNULL(S.ISIN_or_Ref_Code, '''') = ISNULL(F.ISIN_OR_RefCode,'''')'

EXEC (@UpdateSQLBatch_2)

SET @SQL =
'INSERT INTO dbo.tbl_Funds(
[ManagementCompany],
	[FundName],
	[ISIN_OR_RefCode],
	[FundId],
	[Portfoliomanager],
	[CEO_OR_COO],
	[Marketingmanager],
	[HeadTrader],
	[Primarycontact],
	[Telephone],
	[Contactemailaddress],
	[Address1],
	[Address2],
	[City],
	[Zip_Post_Code],
	[Country],
	[GeneralEmailAddress],
	[Website],
	[Administrator],
	[PrimeBroker],
	[LegalAdvisors],
	[Auditor],
	[FundCapacity_US_M],
	[TotalGroupAssets_US_M],
	[FundType],
	[FundDuration],
	[Approaches],
	[Sectors],
	[MarketCaps],
	[Regions],
	[Countries],
	[AUM_US_m],
	[Currency],
	[Domicile],
	[Strategies],
	[StrategyDescription],
	[HurdleRate],
	[HighWaterMark],
	[MinimumInvestment],
	[ManagementFee],
	[PerformanceFee],
	[SubscriptionTerms],
	[RedemptionTerms]
)
SELECT
	[Management_Company],
	[Fund_Name],
	[ISIN_or_Ref_Code],
	[Fund_Id],
	[Portfolio_manager],
	[CEO_or_COO],
	[Marketing_manager],
	[Head_Trader],
	[Primary_contact],
	[Telephone],
	[Contact_email_address],
	[Address_1],
	[Address_2],
	[City],
	[Zip_Post_Code],
	[Country],
	[General_Email_Address],
	[Website],
	[Administrator],
	[Prime_Broker],
	[Legal_Advisors],
	[Auditor],
	[Fund_Capacity_US_m],
	[Total_Group_Assets_US_m],
	[Fund_Type],
	[Fund_Duration],
	[Approaches],
	[Sectors],
	[Market_Caps],
	[Regions],
	[Countries],
	[AUM_US_m],
	[Currency],
	[Domicile],
	[Strategies],
	[Strategy_Description],
	[Hurdle_Rate],
	[High_Water_Mark],
	[Minimum_Investment],
	[Management_Fee],
	[Performance_Fee],
	[Subscription_Terms],
	[Redemption_Terms]
 FROM dbo.[' +  @TableName + '] F
 WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM dbo.tbl_Funds T
					WHERE T.FundId = F.Fund_Id
						AND ISNULL(T.ISIN_OR_RefCode, '''') = ISNULL(F.ISIN_or_Ref_Code, '''')
						AND ISNULL(T.ManagementCompany,'''') = ISNULL(F.Management_Company,'''')
						AND ISNULL(T.FundName,'''') = ISNULL(F.Fund_Name,'''')
				  )'

EXEC (@SQL)

IF EXISTS(
			SELECT TOP 1 1
			FROM INFORMATION_SCHEMA.COLUMNS  
			WHERE TABLE_NAME = @TableName
				AND COLUMN_NAME LIKE '%Monthly_AUM%'
		)
BEGIN
	DECLARE @VALUE VARCHAR(MAX); 
	SELECT @VALUE = COALESCE(@VALUE + ' ' + CONCAT('ALTER TABLE dbo.[' + TABLE_NAME + '] ALTER COLUMN [' , COLUMN_NAME, '] VARCHAR(20);') , CONCAT('ALTER TABLE dbo.[' + TABLE_NAME + '] ALTER COLUMN [' , COLUMN_NAME, '] VARCHAR(20);')) 
	FROM INFORMATION_SCHEMA.COLUMNS  
	WHERE TABLE_NAME = @TableName
		AND COLUMN_NAME LIKE '%Monthly_AUM%'
	EXEC (@VALUE)
	EXEC [dbo].[Up_Insert_Monthly_AUM_Data] @TableName
END

IF EXISTS(
			SELECT TOP 1 1
			FROM INFORMATION_SCHEMA.COLUMNS  
			WHERE TABLE_NAME = @TableName
				AND COLUMN_NAME LIKE '%Monthly_NAV%'
		)
BEGIN
	DECLARE @VALUE1 VARCHAR(MAX); 
	SELECT @VALUE1 = COALESCE(@VALUE1 + ' ' + CONCAT('ALTER TABLE dbo.[' + TABLE_NAME + '] ALTER COLUMN [' , COLUMN_NAME, '] VARCHAR(20);') , CONCAT('ALTER TABLE dbo.[' + TABLE_NAME + '] ALTER COLUMN [' , COLUMN_NAME, '] VARCHAR(20);')) 
	FROM INFORMATION_SCHEMA.COLUMNS  
	WHERE TABLE_NAME = @TableName
		AND COLUMN_NAME LIKE '%Monthly_NAV%'
	EXEC (@VALUE1)
	EXEC [dbo].[Up_Insert_Monthly_NAV_Data] @TableName
END

IF EXISTS(
			SELECT TOP 1 1
			FROM INFORMATION_SCHEMA.COLUMNS  
			WHERE TABLE_NAME = @TableName
				AND COLUMN_NAME LIKE '%Monthly_Return%'
		)
BEGIN
	DECLARE @VALUE2 VARCHAR(MAX); 
	SELECT @VALUE2 = COALESCE(@VALUE2 + ' ' + CONCAT('ALTER TABLE dbo.[' + TABLE_NAME + '] ALTER COLUMN [' , COLUMN_NAME, '] VARCHAR(20);') , CONCAT('ALTER TABLE dbo.[' + TABLE_NAME + '] ALTER COLUMN [' , COLUMN_NAME, '] VARCHAR(20);')) 
	FROM INFORMATION_SCHEMA.COLUMNS  
	WHERE TABLE_NAME = @TableName
		AND COLUMN_NAME LIKE '%Monthly_Return%'
	EXEC (@VALUE2)
	EXEC [dbo].[Up_Insert_Monthly_Return_Data] @TableName
END

EXEC  [dbo].[Up_Insert_Additional_Column_Data] @TableName

END TRY

BEGIN CATCH 

	    SET @ErrorMessage = 'The SP Up_Insert_FundData errored out due to ' + ERROR_MESSAGE()
        SET @ErrorSeverity = ERROR_SEVERITY();  
        SET @ErrorState = ERROR_STATE();  
  
    RAISERROR (@ErrorMessage,   
               @ErrorSeverity, 
               @ErrorState 
               );  
END CATCH