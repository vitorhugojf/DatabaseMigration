use OKR_COACH_MT;

CREATE TABLE `__EFMigrationsHistory` (
    `MigrationId` varchar(95) NOT NULL,
    `ProductVersion` varchar(32) NOT NULL,
    CONSTRAINT `PK___EFMigrationsHistory` PRIMARY KEY (`MigrationId`)
);

CREATE TABLE `AspNetRoles` (
    `Id` char(36) NOT NULL,
    `Name` varchar(256) NULL,
    `NormalizedName` varchar(256) NULL,
    `ConcurrencyStamp` longtext NULL,
    `NameRole` longtext NULL,
    `Enabled` bit NOT NULL,
    CONSTRAINT `PK_AspNetRoles` PRIMARY KEY (`Id`)
);

CREATE TABLE `Image` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `PictureBase64` longtext NOT NULL,
    CONSTRAINT `PK_Image` PRIMARY KEY (`Id`)
);

CREATE TABLE `Location` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `Country` varchar(80) NOT NULL,
    `City` varchar(80) NOT NULL,
    `State` varchar(80) NOT NULL,
    `PostalCode` varchar(50) NULL,
    CONSTRAINT `PK_Location` PRIMARY KEY (`Id`)
);

CREATE TABLE `Objective` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `Description` longtext NULL,
    `ObjectiveDesc` longtext NULL,
    `OverallScore` decimal(65, 30) NOT NULL,
    `Difficulty` int NOT NULL,
    `ChanceOfSuccess` int NOT NULL,
    CONSTRAINT `PK_Objective` PRIMARY KEY (`Id`)
);

CREATE TABLE `AspNetRoleClaims` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `RoleId` char(36) NOT NULL,
    `ClaimType` longtext NULL,
    `ClaimValue` longtext NULL,
    CONSTRAINT `PK_AspNetRoleClaims` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_AspNetRoleClaims_AspNetRoles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `AspNetRoles` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `CellUnit` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `ImageId` char(36) NULL,
    `SuperiorCellId` char(36) NULL,
    `Name` longtext NULL,
    `Cell` int NOT NULL,
    `IsDirectory` bit NOT NULL,
    CONSTRAINT `PK_CellUnit` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_CellUnit_Image_ImageId` FOREIGN KEY (`ImageId`) REFERENCES `Image` (`Id`) ON DELETE SET NULL,
    CONSTRAINT `FK_CellUnit_CellUnit_SuperiorCellId` FOREIGN KEY (`SuperiorCellId`) REFERENCES `CellUnit` (`Id`) ON DELETE NO ACTION
);

CREATE TABLE `KeyResult` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `Description` longtext NULL,
    `Score` decimal(65, 30) NOT NULL,
    `ObjectiveId` char(36) NOT NULL,
    CONSTRAINT `PK_KeyResult` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_KeyResult_Objective_ObjectiveId` FOREIGN KEY (`ObjectiveId`) REFERENCES `Objective` (`Id`) ON DELETE NO ACTION
);

CREATE TABLE `AspNetUsers` (
    `Id` char(36) NOT NULL,
    `UserName` varchar(256) NULL,
    `NormalizedUserName` varchar(256) NULL,
    `NormalizedEmail` varchar(256) NULL,
    `EmailConfirmed` bit NOT NULL,
    `PasswordHash` longtext NULL,
    `SecurityStamp` longtext NULL,
    `ConcurrencyStamp` longtext NULL,
    `PhoneNumber` longtext NULL,
    `PhoneNumberConfirmed` bit NOT NULL,
    `TwoFactorEnabled` bit NOT NULL,
    `LockoutEnd` datetime(6) NULL,
    `LockoutEnabled` bit NOT NULL,
    `AccessFailedCount` int NOT NULL,
    `CompanyInUseId` char(36) NOT NULL,
    `CellUnitId` char(36) NULL,
    `ImageId` char(36) NULL,
    `LocationId` char(36) NULL,
    `Active` bit NOT NULL,
    `Login` longtext NULL,
    `Nome` longtext NULL,
    `Email` varchar(256) NULL,
    `CelPhonePersonal` int NULL,
    `CelPhoneComercial` int NULL,
    `Gender` varchar(10) NULL,
    `Occupation` varchar(100) NULL,
    `LinkedIn` varchar(150) NULL,
    `Description` longtext NULL,
    `Language` longtext NULL,
    `DateOfBirth` datetime NULL,
    `ProfileType` int NOT NULL,
    CONSTRAINT `PK_AspNetUsers` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_AspNetUsers_CellUnit_CellUnitId` FOREIGN KEY (`CellUnitId`) REFERENCES `CellUnit` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_AspNetUsers_Image_ImageId` FOREIGN KEY (`ImageId`) REFERENCES `Image` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_AspNetUsers_Location_LocationId` FOREIGN KEY (`LocationId`) REFERENCES `Location` (`Id`) ON DELETE NO ACTION
);

CREATE TABLE `HistoryKeyResuls` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `KeyResultId` char(36) NOT NULL,
    `Score` decimal(65, 30) NOT NULL,
    `CheckedAt` datetime NOT NULL,
    `Rating` decimal(65, 30) NOT NULL,
    `Difficulty` decimal(65, 30) NOT NULL,
    CONSTRAINT `PK_HistoryKeyResuls` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_HistoryKeyResuls_KeyResult_KeyResultId` FOREIGN KEY (`KeyResultId`) REFERENCES `KeyResult` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `AspNetUserClaims` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `UserId` char(36) NOT NULL,
    `ClaimType` longtext NULL,
    `ClaimValue` longtext NULL,
    CONSTRAINT `PK_AspNetUserClaims` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_AspNetUserClaims_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `AspNetUserLogins` (
    `LoginProvider` varchar(128) NOT NULL,
    `ProviderKey` varchar(128) NOT NULL,
    `ProviderDisplayName` longtext NULL,
    `UserId` char(36) NOT NULL,
    CONSTRAINT `PK_AspNetUserLogins` PRIMARY KEY (`LoginProvider`, `ProviderKey`),
    CONSTRAINT `FK_AspNetUserLogins_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `AspNetUserRoles` (
    `UserId` char(36) NOT NULL,
    `RoleId` char(36) NOT NULL,
    CONSTRAINT `PK_AspNetUserRoles` PRIMARY KEY (`UserId`, `RoleId`),
    CONSTRAINT `FK_AspNetUserRoles_AspNetRoles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `AspNetRoles` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_AspNetUserRoles_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `AspNetUserTokens` (
    `UserId` char(36) NOT NULL,
    `LoginProvider` varchar(128) NOT NULL,
    `Name` varchar(128) NOT NULL,
    `Value` longtext NULL,
    CONSTRAINT `PK_AspNetUserTokens` PRIMARY KEY (`UserId`, `LoginProvider`, `Name`),
    CONSTRAINT `FK_AspNetUserTokens_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `Company` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `MainCompanyId` char(36) NULL,
    `ImageId` char(36) NULL,
    `Name` varchar(50) NOT NULL,
    `ResponsableName` varchar(50) NOT NULL,
    `Email` varchar(50) NOT NULL,
    `Telephone` varchar(20) NOT NULL,
    `SocialName` varchar(200) NOT NULL,
    `Cnpj` varchar(20) NOT NULL,
    `Description` varchar(500) NULL,
    `Language` varchar(20) NOT NULL,
    `LicenseType` varchar(20) NOT NULL,
    `NumberOfUsers` int NOT NULL,
    `NumberOfUsersRegistered` int NOT NULL,
    `NumberOfSubCompanies` int NOT NULL,
    `NumberOfSubCompaniesRegistered` int NOT NULL,
    `UserId` char(36) NULL,
    CONSTRAINT `PK_Company` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Company_Image_ImageId` FOREIGN KEY (`ImageId`) REFERENCES `Image` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_Company_Company_MainCompanyId` FOREIGN KEY (`MainCompanyId`) REFERENCES `Company` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_Company_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE NO ACTION
);

CREATE TABLE `Formation` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `Degree` varchar(80) NOT NULL,
    `Institution` varchar(80) NOT NULL,
    `Course` varchar(50) NOT NULL,
    `Description` varchar(200) NULL,
    `Finished` bit NOT NULL,
    `UserId` char(36) NOT NULL,
    CONSTRAINT `PK_Formation` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Formation_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `AuthMethod` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `CompanyId` char(36) NOT NULL,
    `Name` varchar(50) NOT NULL,
    CONSTRAINT `PK_AuthMethod` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_AuthMethod_Company_CompanyId` FOREIGN KEY (`CompanyId`) REFERENCES `Company` (`Id`) ON DELETE NO ACTION
);

CREATE TABLE `CompanyRole` (
    `CompanyId` char(36) NOT NULL,
    `RoleId` char(36) NOT NULL,
    CONSTRAINT `PK_CompanyRole` PRIMARY KEY (`CompanyId`, `RoleId`),
    CONSTRAINT `FK_CompanyRole_Company_CompanyId` FOREIGN KEY (`CompanyId`) REFERENCES `Company` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_CompanyRole_AspNetRoles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `AspNetRoles` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `CompanyUser` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `CompanyId` char(36) NOT NULL,
    `UserId` char(36) NOT NULL,
    CONSTRAINT `PK_CompanyUser` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_CompanyUser_Company_CompanyId` FOREIGN KEY (`CompanyId`) REFERENCES `Company` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_CompanyUser_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `Domain` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `CompanyId` char(36) NOT NULL,
    `Domain` varchar(50) NOT NULL,
    CONSTRAINT `PK_Domain` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Domain_Company_CompanyId` FOREIGN KEY (`CompanyId`) REFERENCES `Company` (`Id`) ON DELETE NO ACTION
);

CREATE TABLE `Sector` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `Text` varchar(500) NOT NULL,
    `Value` varchar(500) NOT NULL,
    `Description` varchar(500) NULL,
    `ExternalCode` varchar(500) NULL,
    `Group` varchar(500) NULL,
    `CompanyId` char(36) NOT NULL,
    CONSTRAINT `PK_Sector` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Sector_Company_CompanyId` FOREIGN KEY (`CompanyId`) REFERENCES `Company` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `Team` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `ImageId` char(36) NULL,
    `LeaderId` char(36) NULL,
    `DeputyLeaderId` char(36) NULL,
    `CompanyId` char(36) NOT NULL,
    `NameTeam` longtext NULL,
    `Description` longtext NULL,
    `Mission` longtext NULL,
    `Vision` longtext NULL,
    `Values` longtext NULL,
    CONSTRAINT `PK_Team` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Team_Company_CompanyId` FOREIGN KEY (`CompanyId`) REFERENCES `Company` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_Team_AspNetUsers_DeputyLeaderId` FOREIGN KEY (`DeputyLeaderId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_Team_Image_ImageId` FOREIGN KEY (`ImageId`) REFERENCES `Image` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_Team_AspNetUsers_LeaderId` FOREIGN KEY (`LeaderId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE NO ACTION
);

CREATE TABLE `OKR` (
    `Id` char(36) NOT NULL,
    `Active` bit NOT NULL,
    `ObjectiveId` char(36) NOT NULL,
    `OwnerId` char(36) NULL,
    `CoachId` char(36) NULL,
    `OKRSuperiorId` char(36) NULL,
    `CellUnitId` char(36) NOT NULL,
    `TeamId` char(36) NULL,
    `CompanyId` char(36) NOT NULL,
    `StartAt` datetime NOT NULL,
    `FinishedAt` datetime NOT NULL,
    `UpdatedAt` datetime NOT NULL,
    `Tipo` int NOT NULL,
    `Rating` decimal(65, 30) NOT NULL,
    `Status` int NOT NULL,
    CONSTRAINT `PK_OKR` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_OKR_CellUnit_CellUnitId` FOREIGN KEY (`CellUnitId`) REFERENCES `CellUnit` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_OKR_AspNetUsers_CoachId` FOREIGN KEY (`CoachId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_OKR_Company_CompanyId` FOREIGN KEY (`CompanyId`) REFERENCES `Company` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_OKR_OKR_OKRSuperiorId` FOREIGN KEY (`OKRSuperiorId`) REFERENCES `OKR` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_OKR_Objective_ObjectiveId` FOREIGN KEY (`ObjectiveId`) REFERENCES `Objective` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_OKR_AspNetUsers_OwnerId` FOREIGN KEY (`OwnerId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE NO ACTION,
    CONSTRAINT `FK_OKR_Team_TeamId` FOREIGN KEY (`TeamId`) REFERENCES `Team` (`Id`) ON DELETE SET NULL
);

CREATE TABLE `TeamUser` (
    `Id` char(36) NOT NULL,
    `UserId` char(36) NOT NULL,
    `TeamId` char(36) NOT NULL,
    CONSTRAINT `PK_TeamUser` PRIMARY KEY (`UserId`, `TeamId`),
    CONSTRAINT `FK_TeamUser_Team_TeamId` FOREIGN KEY (`TeamId`) REFERENCES `Team` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_TeamUser_AspNetUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AspNetUsers` (`Id`) ON DELETE CASCADE
);

CREATE INDEX `IX_AspNetRoleClaims_RoleId` ON `AspNetRoleClaims` (`RoleId`);

CREATE INDEX `RoleNameIndex` ON `AspNetRoles` (`NormalizedName`);

CREATE INDEX `IX_AspNetUserClaims_UserId` ON `AspNetUserClaims` (`UserId`);

CREATE INDEX `IX_AspNetUserLogins_UserId` ON `AspNetUserLogins` (`UserId`);

CREATE INDEX `IX_AspNetUserRoles_RoleId` ON `AspNetUserRoles` (`RoleId`);

CREATE INDEX `IX_AspNetUsers_CellUnitId` ON `AspNetUsers` (`CellUnitId`);

CREATE INDEX `IX_AspNetUsers_ImageId` ON `AspNetUsers` (`ImageId`);

CREATE INDEX `IX_AspNetUsers_LocationId` ON `AspNetUsers` (`LocationId`);

CREATE INDEX `EmailIndex` ON `AspNetUsers` (`NormalizedEmail`);

CREATE UNIQUE INDEX `UserNameIndex` ON `AspNetUsers` (`NormalizedUserName`);

CREATE INDEX `IX_AuthMethod_CompanyId` ON `AuthMethod` (`CompanyId`);

CREATE UNIQUE INDEX `IX_CellUnit_ImageId` ON `CellUnit` (`ImageId`);

CREATE INDEX `IX_CellUnit_SuperiorCellId` ON `CellUnit` (`SuperiorCellId`);

CREATE INDEX `IX_Company_ImageId` ON `Company` (`ImageId`);

CREATE INDEX `IX_Company_MainCompanyId` ON `Company` (`MainCompanyId`);

CREATE INDEX `IX_Company_UserId` ON `Company` (`UserId`);

CREATE INDEX `IX_CompanyRole_RoleId` ON `CompanyRole` (`RoleId`);

CREATE INDEX `IX_CompanyUser_CompanyId` ON `CompanyUser` (`CompanyId`);

CREATE INDEX `IX_CompanyUser_UserId` ON `CompanyUser` (`UserId`);

CREATE INDEX `IX_Domain_CompanyId` ON `Domain` (`CompanyId`);

CREATE INDEX `IX_Formation_UserId` ON `Formation` (`UserId`);

CREATE INDEX `IX_HistoryKeyResuls_KeyResultId` ON `HistoryKeyResuls` (`KeyResultId`);

CREATE INDEX `IX_KeyResult_ObjectiveId` ON `KeyResult` (`ObjectiveId`);

CREATE INDEX `IX_OKR_CellUnitId` ON `OKR` (`CellUnitId`);

CREATE INDEX `IX_OKR_CoachId` ON `OKR` (`CoachId`);

CREATE INDEX `IX_OKR_CompanyId` ON `OKR` (`CompanyId`);

CREATE INDEX `IX_OKR_OKRSuperiorId` ON `OKR` (`OKRSuperiorId`);

CREATE UNIQUE INDEX `IX_OKR_ObjectiveId` ON `OKR` (`ObjectiveId`);

CREATE INDEX `IX_OKR_OwnerId` ON `OKR` (`OwnerId`);

CREATE INDEX `IX_OKR_TeamId` ON `OKR` (`TeamId`);

CREATE INDEX `IX_Sector_CompanyId` ON `Sector` (`CompanyId`);

CREATE INDEX `IX_Team_CompanyId` ON `Team` (`CompanyId`);

CREATE INDEX `IX_Team_DeputyLeaderId` ON `Team` (`DeputyLeaderId`);

CREATE UNIQUE INDEX `IX_Team_ImageId` ON `Team` (`ImageId`);

CREATE INDEX `IX_Team_LeaderId` ON `Team` (`LeaderId`);

CREATE INDEX `IX_TeamUser_TeamId` ON `TeamUser` (`TeamId`);

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
VALUES ('20190618175337_v1_0_0', '2.1.4-rtm-31024');