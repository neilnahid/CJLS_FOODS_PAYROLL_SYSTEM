--drop table tbl_Users
create table tbl_EmployeeTypes
(
	EmployeeTypesID int primary key identity(100,100),
	EmployeeNameTitle varchar(50),
	SalaryRate float
)
--drop table tbl_Employees
create table tbl_Employees
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
	EmployeeTypeID int foreign key references tbl_EmployeeTypes(EmployeeTypesID)
)

--drop table tbl_Users
create table tbl_Users
(
	UserID INT NOT NULL PRIMARY KEY identity (1,1),
	Username varchar(100),
	Password varchar(100),
	EmployeeID int foreign key references tbl_Employees(EmployeeID),
	SecretQuestion varchar(50),
	SecretAnswer varchar(50)
)

--drop table tbl_Deductions
create table tbl_DeductionsType
(
	DeductionTypeID int primary key identity(1000,1000),
	DeductionName varchar(50),
	DeductionFlatRate float,
	DeductionPercentRate float
)

create table tbl_DeductionsLog(
	DeductionsLogID int primary key identity(1,1),
	EmployeeID int foreign key references tbl_Employees(EmployeeID),
	DeductionTypeID int foreign key references tbl_DeductionsType(DeductionTypeID)
)

--drop table tbl_Contributions
CREATE TABLE tbl_ContributionsType
(
	ContributionsTypeID int primary key identity(1000,1000),
	ContributionName varchar(50),
	ContributionFlatRate float,
	ContributionPercentRate float
)

--drop table tbl_ContributionsLog
create table tbl_ContributionsLog(
	ContributionsLogID int primary key identity(1,1),
	EmployeeID int foreign key references tbl_Employees(EmployeeID),
	ContributionsTypeID int foreign key references tbl_ContributionsType(ContributionsTypeID)
)

CREATE TABLE tbl_Payroll(
	PayrollID int primary key identity(1,1),
	EmployeeID int foreign key references tbl_Employees(EmployeeID),
	TotalDeductions float,
	TotalContributions float,
	NumberOfHoursWorked float,
	OvertimeWorked float,
	OvertimePay float,
	Netpay float
)

-- /* REFRESH TABLES COMMAND*/
-- drop table tbl_Users
-- drop table tbl_Employees
-- drop table tbl_EmployeeTypes
-- drop table tbl_DeductionsLog
-- drop table tbl_DeductionsType
-- drop table tbl_ContributionsLog
-- drop table tbl_ContributionsType
-- drop table tbl_Payroll

-- -- Get a list of tables and views in the current database
-- select name from sys.tables