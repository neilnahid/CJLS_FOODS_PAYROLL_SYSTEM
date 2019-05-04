--drop table tbl_Users
create table EmployeeTypes
(
	EmployeeTypesID int primary key identity(100,100),
	EmployeeNameTitle varchar(50),
	SalaryRate float
)
--drop table tbl_Employees
create table Employees
(
	EmployeeID int primary key identity(1000,1),
	FirstName varchar(50),
	LastName varchar(50),
	DateOfBirth datetime,
	Age int,
	ContactNumber int,
	Address varchar(255),
	Gender varchar(25),
	AvailableLeaves int,
	EmployeeTypeID int foreign key references EmployeeTypes(EmployeeTypesID)
)
--drop table tbl_Users
create table Users
(
	UserID INT NOT NULL PRIMARY KEY identity (1,1),
	Username varchar(100),
	Password varchar(100),
	SecretQuestion varchar(50),
	SecretAnswer varchar(50)
)
--drop table tbl_DeductionsType
create table DeductionsTypes
(
	DeductionTypeID int primary key identity(1,1),
	DeductionName varchar(50),
	DeductionReferenceId varchar(50)
)

create table DeductionLogs(
	DeductionsLogId int primary key identity(1,1),
	DeductionTypeID int foreign key references DeductionsTypes(DeductionTypeID),
	Amount float,
	DateApplied datetime
)
CREATE TABLE Payrolls(
	PayrollID int primary key identity(1,1),
	EmployeeID int foreign key references Employees(EmployeeID),
	TotalDeductions float,
	TotalContributions float,
	NumberOfHoursWorked float,
	OvertimeWorked float,
	OvertimePay float,
	Netpay float
)

 /* REFRESH TABLES COMMAND*/
 drop table Users
 drop table Employees
 drop table EmployeeTypes
 drop table DeductionsLogs
 drop table DeductionsTypes
 drop table Payrolls

-- -- Get a list of tables and views in the current database
-- select name from sys.tables

insert into DeductionsTypes
values('Sales Short','DED_SALE_SHORT'),
('Inventory','DED_INVENTORY'),
('Excess Meal','DED_EXCSS_MEAL'),
('Incomplete Uniform','DED_INC_UNIFROM'),
('Cash Advance/Loan','DED_CA_'),
('Late','DED_LATE')
