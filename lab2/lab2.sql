create database lab2;
use lab2;

CREATE TABLE Person (
  `pid` int PRIMARY KEY auto_increment,
  `firstName` varchar(55) NOT NULL,
  `lastName` varchar(55) NOT NULL,
  `email` varchar(255) NOT NULL,
  `affiliation` varchar(255) NOT NULL,
  `startDate` DATE NOT NULL,
  `endDate` varchar(255) NULL
);

CREATE TABLE Student (
  `pid` int primary key,
  `program` varchar(55) not null,
  foreign key (`pid`) references Person(`pid`)
);

CREATE TABLE Employee (
  `pid` int primary key,
  foreign key (`pid`) references Person(`pid`),
  `phone` int not null,
  `office` varchar(55) not null,
  `supervisor_pid` int,
  foreign key (`supervisor_pid`) references Employee(`pid`)
);

CREATE TABLE Academic (
  `pid` int primary key,
  foreign key (`pid`) references Employee(`pid`)
);

CREATE TABLE Advises (
  `student_id` int,
  `academic_id` int,
  primary key (`student_id`, `academic_id`),
  foreign key (`student_id`) references Student(`pid`),
  foreign key (`academic_id`) references Academic(`pid`)
);

CREATE TABLE NonAcademic (
  `pid` int primary key,
  foreign key (`pid`) references Employee(`pid`)
);

CREATE TABLE Faculty (
  `pid` int primary key,
  `position` varchar(55) not null,
  foreign key (`pid`) references Academic(`pid`)
);

CREATE TABLE Administrative (
  `pid` int primary key,
  `position` varchar(55) not null,
  foreign key (`pid`) references NonAcademic(`pid`)
);

CREATE TABLE Technical (
  `pid` int primary key,
  `position` varchar(55) not null,
  foreign key (`pid`) references NonAcademic(`pid`)
);

CREATE TABLE Laboratory(
  `labId` int primary key auto_increment,
  `name` varchar(55) not null,
  `building` varchar(55) not null,
  `roomNumber` int not null,
  `discipline` varchar(55) not null,
  `pid` int not null,
  foreign key (`pid`) references Faculty(`pid`)
);

CREATE TABLE ResearchProject(
  `code` int primary key auto_increment,
  `title` varchar(55) not null,
  `startDate` DATE not null,
  `endDate` DATE null,
  `status` varchar(55) not null
);

CREATE TABLE Budget (
  `budgetLine` int primary key auto_increment,
  `amountGranted` float not null,
  `amountDisbursed` float not null,
  `startDate` DATE not null,
  `endDate` DATE null,
  `pid` int not null,
  foreign key (`pid`) references Academic(`pid`)
);

CREATE TABLE Attached(
  `pid` int,
  `labId` int,
  primary key (`pid`, `labId`),
  foreign key (`pid`) references Person(`pid`),
  foreign key (`labId`) references Laboratory(`labId`)
);

CREATE TABLE FundsLab(
  `labId` int,
  `budgetLine` int,
  primary key (`labId`, `budgetLine`),
  foreign key (`labId`) references Laboratory(`labId`),
  foreign key (`budgetLine`) references Budget(`budgetLine`)
);

CREATE TABLE FundsProject(
  `code` int,
  `budgetLine` int,
  primary key (`code`, `budgetLine`),
  foreign key (`code`) references ResearchProject(`code`),
  foreign key (`budgetLine`) references Budget(`budgetLine`)
);

CREATE TABLE Participates(
  `role` varchar(55) not null,
  `pid` int,
  `code` int,
  primary key(`pid`, `code`),
  foreign key (`pid`) references Person(`pid`),
  foreign key (`code`) references ResearchProject(`code`)
);

CREATE TABLE Certification(
  `code` int primary key,
  `title` varchar(55) not null,
  `issuingAuthority` varchar(55) not null,
  `validityPeriod` varchar(55) not null,
  `safetyLevel` varchar(55) not null
);

CREATE TABLE EquipementModel(
  `modelId` int primary key auto_increment,
  `commercialName` varchar(55) not null,
  `manufacturer` varchar(55) not null,
  `category` varchar(55) not null,
  `requiredEnvironement` varchar(55) not null,
  `trainingMandatory` varchar(55) not null
);

CREATE TABLE EquipementUnit(
  `serialNo` int primary key,
  `aquisitionDate` DATE not null,
  `purchaseCost` float not null,
  `status` varchar(55) not null,
  `portable` varchar(55) not null,
  `labId` int not null,
  foreign key (`labId`) references Laboratory(`labId`),
  `modelId` int not null,
  foreign key (`modelId`) references EquipementModel(`modelId`)
);

CREATE TABLE Requires(
  `code` int,
  `modelId` int,
  primary key (`code`, `modelId`),
  foreign key (`code`) references Certification(`code`),
  foreign key (`modelId`) references EquipementModel(`modelId`)
);

CREATE TABLE Holds(
  `grade` varchar(55) not null,
  `issueDate` DATE not null,
  `expirationDate` DATE not null,
  `code` int,
  `pid` int,
  primary key (`code`, `pid`),
  foreign key (`code`) references Certification(`code`),
  foreign key (`pid`) references Person(`pid`)
);

CREATE TABLE Reservation(
  `resId` int primary key auto_increment,
  `submissionTS` TIMESTAMP not null,
  `plannedStart` DATE not null,
  `plannedEnd` DATE not null,
  `purpose` varchar(55) not null,
  `status` varchar(55) not null,
  `approver_pid` int,
  foreign key (`approver_pid`) references Person(`pid`),
  `maker_pid` int not null,
  foreign key (`maker_pid`) references Person(`pid`),
  `code` int not null,
  foreign key (`code`) references ResearchProject(`code`)
);

CREATE TABLE Reserves(
  `resId` int, 
  `serialNo` int,
  primary key (`resId`, `serialNo`),
  foreign key (`resId`) references Reservation(`resId`),
  foreign key (`serialNo`) references EquipementUnit(`serialNo`)
);

CREATE TABLE Maintenance(
  `serialNo` int,
  `startTS` TIMESTAMP,
  primary key (`serialNo`, `startTS`),
  `endTS` TIMESTAMP not null,
  `type` varchar(55) not null,
  `description` varchar(255) not null,
  `cost` float not null,
  `outcome` varchar(55) not null,
  foreign key (`serialNo`) references EquipementUnit(`serialNo`) on delete cascade,
  `pid` int not null,
  foreign key (`pid`) references Technical(`pid`)
);

CREATE TABLE CalibrationRecord(
  `serialNo` int,
  `calibDate` DATE,
  primary key (`serialNo`, `calibDate`),
  `calibrationType` varchar(55) not null,
  `result` varchar(55) not null,
  `remarks` varchar(55) not null,
  `nextDueDate` DATE not null,
  foreign key (`serialNo`) references EquipementUnit(`serialNo`) on delete cascade
);


CREATE TABLE Consumable(
  `consId` int primary key auto_increment,
  `name` varchar(55) not null,
  `unitOfMeasure` varchar(55) not null,
  `hazardLevel` varchar(55) not null,
  `reorderThreshold` varchar(55) not null
);

CREATE TABLE Supplier(
  `suppId` int primary key auto_increment,
  `name` varchar(55) not null,
  `contactEmail` varchar(55) not null,
  `phone` int not null
);

CREATE TABLE Stocks(
  `consId` int,
  `labId` int,
  primary key (`consId`, `labId`),
  foreign key (`consId`) references Consumable(`consId`),
  foreign key (`labId`) references Laboratory(`labId`),
  `storageCondition` varchar(55) not null,
  `lastRestockDate` DATE not null,
  `quantityOnHand` int not null,
  `pid` int not null,
  foreign key (`pid`) references Technical(`pid`),
  `monitoringSince` DATE not null
);

CREATE TABLE Consumes(
  `consId` int,
  `labId` int,
  `resId` int,
  primary key (`consId`, `labId`, `resId`),
  foreign key (`consId`, `labId`) references Stocks(`consId`, `labId`),
  foreign key (`resId`) references Reservation(`resId`),
  `quantityUsed` int not null
);

CREATE TABLE Supplies(
  `consId` int,
  `labId` int,
  `suppId` int,
  primary key (`consId`, `labId`, `suppId`),
  foreign key (`consId`) references Consumable(`consId`),
  foreign key (`labId`) references Laboratory(`labId`),
  foreign key (`suppId`) references Supplier(`suppId`),
  `unitPrice` float not null
);