﻿USE [master]
GO
/****** Object:  Database [CJLSFOODSPAYROLL]    Script Date: 9/25/2019 3:25:10 PM ******/
CREATE DATABASE [CJLSFOODSPAYROLL]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CJLSFOODSPAYROLL', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\CJLSFOODSPAYROLL.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CJLSFOODSPAYROLL_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\CJLSFOODSPAYROLL_log.ldf' , SIZE = 335872KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CJLSFOODSPAYROLL].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET ARITHABORT OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET  MULTI_USER 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET QUERY_STORE = OFF
GO
USE [CJLSFOODSPAYROLL]
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeContribution]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeContribution](
@ContributionTypeID int,
@PayrollDetailID int
)
returns float
as
begin
declare @AverageMonthlyWorkingDays as float = (select IIF(RequiredDaysAWeek=5,261,IIF(RequiredDaysAWeek=6,313,0))/12.0 from PayrollDetail inner join Employee on PayrollDetail.EmployeeID = Employee.EmployeeID where PayrollDetailID=@PayrollDetailID)
declare @TotalDays as int = (select TotalDays from PayrollDetail where PayrollDetailID=@PayrollDetailID)
declare @MonthlySalary as float = (select MonthlySalary from PayrollDetail inner join Employee on PayrollDetail.EmployeeID = Employee.EmployeeID where PayrollDetailID = @PayrollDetailID)
declare @Grosspay as float = (select GrossPay from PayrollDetail where PayrollDetailID=@PayrollDetailID)
declare @Amount as float
if(@ContributionTypeID=1)
	return isnull(dbo.ComputePhilHealth(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays),0);
else if(@ContributionTypeID=2)
	return isnull(dbo.ComputeSSS(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays),0);
else if(@ContributionTypeID=3)
	return isnull(dbo.ComputePagibig(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays),0);
else if(@ContributionTypeID=4)
	return isnull(dbo.ComputeTax(@Grosspay,@AverageMonthlyWorkingDays,@TotalDays),0);
return 0;
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeGrossPay]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ComputeGrossPay](@EmployeeID int, @PayrollDetailID int)
returns float
as
begin
declare @TotalRegularHours as float = (select TotalRegularHours from PayrollDetail where PayrollDetailID = @PayrollDetailID)
declare @HourlyRate as float = (select HOurlyRate from Employee where EmployeeID = @EmployeeID)
return @TotalRegularHours*@HourlyRate+dbo.ComputeOVertime(@EmployeeID,@PayrollDetailID)
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeNetPay]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeNetPay](@PayrollDetailID float)
returns float
as
begin
declare @GrossPay as float = (select GrossPay from PayrollDetail where PayrollDetailID=@PayrollDetailID)
declare @Deductions as float = ISNULL((select TotalDeductions from PayrollDetail where PayrollDetailID=@PayrollDetailID),0)
return @GrossPay-@Deductions
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeOverTime]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeOverTime](@EmployeeID int, @PayrollDetailID int)
returns float
as
begin
declare @TotalOvertimeHours as float = (select TotalOverTimeHours from PayrollDetail where PayrollDetailID = @PayrollDetailID)
declare @HourlyRate as float = (select HOurlyRate from Employee where EmployeeID = @EmployeeID)	
return @TotalOvertimeHours*(@HourlyRate*1.25)
end

GO
/****** Object:  UserDefinedFunction [dbo].[ComputePagIBIG]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ComputePagIBIG](@MonthlySalary float, @AverageWorkDaysAMonth float, @TotalDays float)
returns float
as
BEGIN
declare @PAGIBIGRate as float;
set @PAGIBIGRate = (select PercentageRate from ContributionType where Name='Pagibig')
IF @MonthlySalary <= 1500
	set @PAGIBIGRate=0.01
ELSE
	set @PAGIBIGRate=0.02
IF @MonthlySalary > 5000
	set @MonthlySalary = 5000
return round(@MonthlySalary*@PAGIBIGRate/@AverageWorkDaysAMonth*@TotalDays,2)
END
GO
/****** Object:  UserDefinedFunction [dbo].[computePayment]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[computePayment](@LoanID int)
returns float
as
begin
return round((select Amount/Terms from Loan where LoanID=@LoanID),2)
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputePhilHealth]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ComputePhilHealth](@MonthlySalary float, @AverageWorkDaysAMonth float, @TotalDays float)
RETURNS FLOAT
AS
BEGIN
IF @MonthlySalary < 10000
	SET @MonthlySalary = 10000
ELSE 
BEGIN 
	IF @MonthlySalary > 40000
		SET @MonthlySalary = 40000
END
declare @PhilHealthRate float;
set @PhilHealthRate = (select PercentageRate from ContributionType where Name='PhilHealth')
return round(@MonthlySalary*@PhilHealthRate/2/@AverageWorkDaysAMonth*@TotalDays,2)
END
GO
/****** Object:  UserDefinedFunction [dbo].[computeRegularPay]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[computeRegularPay](@PayrollDetailID int,@employeeID int)
returns float
as
begin
declare @hourlyRate as float = (select HourlyRate from Employee where EmployeeID=@employeeID)
declare @TotalRegularHours as int = (select TotalRegularHours from PayrollDetail where PayrollDetailID=@PayrollDetailID)
return round(@hourlyRate * @TotalRegularHours,2)
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeSSS]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ComputeSSS](@MonthlySalary float, @AverageWorkDaysAMonth float,@TotalDays float)
returns float
as
BEGIN
declare @MSC as float
declare @SSSRate as float
set @SSSRate = (select ContributionType.PercentageRate from ContributionType where Name='SSS')

IF @MonthlySalary < 2250
	set @MSC = 2000.00;
ELSE
	BEGIN
		IF @MonthlySalary >= 19750
		set @MSC = 20000.00;
		ELSE
			BEGIN			
				set @MSC = round(@MonthlySalary/500,0)*500 -- round off by 500 to get to nearest MSC
			END
	END
return round(@MSC*@SSSRATE/@AverageWorkDaysAMonth*@TotalDays,2)
END
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeTax]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeTax](@DeductedMonthlySalary float, @AverageWorkDaysAMonth float,@TotalDays float)
returns float
as
begin
declare @TaxPercentRate as float = 0;
declare @CLAmount as float = 0;
declare @Total as float = 0;

if @DeductedMonthlySalary <= 20833/@AverageWorkDaysAMonth*@TotalDays
	set @TaxPercentRate = 0;
if @DeductedMonthlySalary > 20833 and @DeductedMonthlySalary < 33333
	begin
	set @TaxPercentRate = 0.2;
	set @CLAmount = 20833/@AverageWorkDaysAMonth*@TotalDays;
	end
if @DeductedMonthlySalary >= 33333/@AverageWorkDaysAMonth*@TotalDays and @DeductedMonthlySalary < 66667/@AverageWorkDaysAMonth*@TotalDays
	begin
	set @Total = 2500/@AverageWorkDaysAMonth*@TotalDays;
	set @TaxPercentRate = 0.25;
	set @CLAmount = 33333/@AverageWorkDaysAMonth*@TotalDays;
	end
if @DeductedMonthlySalary >= 66667/@AverageWorkDaysAMonth*@TotalDays and @DeductedMonthlySalary < 166667/@AverageWorkDaysAMonth*@TotalDays
	begin
	set @Total = 10833.33/@AverageWorkDaysAMonth*@TotalDays;
	set @TaxPercentRate = 0.30;
	set @CLAmount = 66667/@AverageWorkDaysAMonth*@TotalDays;
	end
if @DeductedMonthlySalary >= 166667/@AverageWorkDaysAMonth*@TotalDays and @DeductedMonthlySalary < 666667/@AverageWorkDaysAMonth*@TotalDays
	begin
	set @Total = 40833.33/@AverageWorkDaysAMonth*@TotalDays
	set @TaxPercentRate = 0.32;
	set @CLAmount = 166667/@AverageWorkDaysAMonth*@TotalDays;
	end
if @DeductedMonthlySalary >= 666667/@AverageWorkDaysAMonth*@TotalDays
	begin
	set @Total = 200833.33/@AverageWorkDaysAMonth*@TotalDays
	set @TaxPercentRate = 0.35;
	set @CLAmount = 666667/@AverageWorkDaysAMonth*@TotalDays;
	end

return round(((@DeductedMonthlySalary-@CLAmount)*@TaxPercentRate+@Total)/@AverageWorkDaysAMonth*@TotalDays,2);
end
GO
/****** Object:  UserDefinedFunction [dbo].[computeTermsRemaining]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[computeTermsRemaining](@LoanID int, @Terms int)
returns int
as
begin
return (select @Terms-count(*) from LoanPayment where LoanID = @LoanID)
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalContributions]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeTotalContributions](@EmployeeID int, @PayrollDetailID int, @PayrollID int)
returns float
as
begin
declare @MonthlySalary as float = (select Employee.MonthlySalary from Employee where EmployeeID=@EmployeeID)
declare @GrossPay as float = (select PayrollDetail.GrossPay from PayrollDetail where PayrollDetailID=@PayrollDetailID)
declare @TotalDays as float = (select PayrollDetail.TotalDays from PayrollDetail where PayrollDetailID=@PayrollDetailID and PayrollID=@PayrollID)
declare @AverageMonthlyWorkingDays as float = (select IIF(RequiredDaysAWeek=5,261,IIF(RequiredDaysAWeek=6,313,0))/12.0 from Employee where EmployeeID=@EmployeeID)

--var declarations
declare @SSS float, @PAGIBIG float, @PHILHEALTH float, @DeductedMonthlySalary float,
		@TAX float
IF (select Employee.IsSSSActive from Employee where EmployeeID=@EmployeeID)=1
 set @SSS = (select dbo.ComputeSSS(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays));
ELSE
set @SSS = 0;
IF (select Employee.IsPagibigActive from Employee where EmployeeID=@EmployeeID)=1
set @PAGIBIG = (select dbo.ComputePagIBIG(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays));
ELSE
set @PAGIBIG = 0;
IF (select Employee.IsPhilhealthActive from Employee where EmployeeID=@EmployeeID)=1
set @PHILHEALTH = (select dbo.ComputePhilHealth(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays));
ELSE
set @PHILHEALTH = 0;
IF (select Employee.IsPhilhealthActive from Employee where EmployeeID=@EmployeeID)=1
set @PHILHEALTH = (select dbo.ComputePhilHealth(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays));
ELSE
set @PHILHEALTH = 0;

set @DeductedMonthlySalary = @GrossPay-@SSS-@PAGIBIG-@PHILHEALTH;

IF (select Employee.IsIncomeTaxActive from Employee where EmployeeID=@EmployeeID)=1
set @TAX = (select dbo.ComputeTax(@DeductedMonthlySalary,@AverageMonthlyWorkingDays,@TotalDays));
ELSE
set @TAX = 0;
return @SSS+@PAGIBIG+@PHILHEALTH+@TAX
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalDeductions]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeTotalDeductions](@PayrollDetailID int)
returns float
as
begin
declare @dayToDayDeduction as float = (select sum(isnull(deduction.amount,0)) from Attendance left join Deduction on Attendance.AttendanceID=Deduction.AttendanceID where Attendance.PayrollDetailsID = @PayrollDetailID)
declare @loanPayment as float = (select sum(isnull(loanpayment.amountpaid,0)) from LoanPayment where LoanPayment.PayrollDetailID = @PayrollDetailID)
declare @contribution as float = (select sum(isnull(contribution.amount,0)) from Contribution where Contribution.PayrollDetailID = @PayrollDetailID)

return round(isnull(@dayToDayDeduction,0)+isnull(@loanPayment,0)+isnull(@contribution,0),2)
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalOverTimeHours]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ComputeTotalOverTimeHours](@PayrollDetailID float)
returns float
as
begin
return (select SUM(OverTimeHoursWorked) from Attendance where PayrollDetailsID=@PayrollDetailID)
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalRegularHours]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ComputeTotalRegularHours](@PayrollDetailID float)
returns float
as
begin
return (select SUM(RegularHoursWorked) from Attendance where PayrollDetailsID=@PayrollDetailID)
end
GO
/****** Object:  UserDefinedFunction [dbo].[getFormattedEmpID]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[getFormattedEmpID](@EmployeeID int)
returns varchar(50)
as
begin
declare @DateAdded as date = (select DateAdded from Employee where EmployeeID=@EmployeeID)
declare @count as int = (select count(*) from Employee where dateAdded = @DateAdded)
return concat(@dateAdded,'-',cast(@count as varchar(50)))
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetTotalDaysOf]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[GetTotalDaysOf](@PayrollDetailsID int)
returns int
as
begin
return (select count(*) from Attendance where PayrollDetailsID=@PayrollDetailsID and RegularHoursWorked>0)
end
GO
/****** Object:  Table [dbo].[Attendance]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attendance](
	[AttendanceDate] [datetime] NULL,
	[RegularHoursWorked] [float] NOT NULL,
	[OverTimeHoursWorked] [float] NOT NULL,
	[AttendanceID] [int] IDENTITY(1,1) NOT NULL,
	[PayrollDetailsID] [int] NULL,
	[MinutesLate] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AttendanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contribution]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contribution](
	[ContributionLogID] [int] IDENTITY(1,1) NOT NULL,
	[ContributionTypeID] [int] NULL,
	[PayrollDetailID] [int] NULL,
	[Amount]  AS ([dbo].[ComputeContribution]([ContributionTypeID],[PayrollDetailID])),
PRIMARY KEY CLUSTERED 
(
	[ContributionLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContributionType]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContributionType](
	[ContributionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[PercentageRate] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[ContributionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Deduction]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Deduction](
	[DeductionsLogId] [int] IDENTITY(1,1) NOT NULL,
	[DeductionTypeID] [int] NULL,
	[Amount] [float] NOT NULL,
	[AttendanceID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeductionsLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeductionsTypes]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeductionsTypes](
	[DeductionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[DeductionReferenceId] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[DeductionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [int] IDENTITY(1000,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[FullName]  AS (([FirstName]+' ')+[LastName]),
	[Gender] [varchar](25) NOT NULL,
	[DateOfBirth] [datetime] NOT NULL,
	[Age]  AS (datediff(year,[DateOfBirth],getdate())),
	[ContactNumber] [varchar](50) NOT NULL,
	[Address] [varchar](255) NOT NULL,
	[AvailableLeaves] [int] NOT NULL,
	[HourlyRate] [float] NOT NULL,
	[DailyRequiredHours] [int] NOT NULL,
	[DailyRate]  AS ([HourlyRate]*[DailyRequiredHours]),
	[RequiredDaysAWeek] [int] NOT NULL,
	[MonthlySalary]  AS (round((([HourlyRate]*[DailyRequiredHours])*case when [RequiredDaysAWeek]=(5) then (261) else case when [RequiredDaysAWeek]=(6) then (313)  end end)/(12),(2))) PERSISTED,
	[SSSID] [varchar](50) NULL,
	[PagIbigID] [varchar](50) NULL,
	[PhilhealthID] [varchar](50) NULL,
	[TINID] [varchar](50) NULL,
	[Branch] [varchar](50) NULL,
	[Status] [varchar](50) NOT NULL,
	[IsPhilhealthActive] [bit] NOT NULL,
	[IsSSSActive] [bit] NOT NULL,
	[IsIncomeTaxActive] [bit] NOT NULL,
	[IsPagibigActive] [bit] NOT NULL,
	[EmployeeTypeID] [int] NOT NULL,
	[Emp_ID] [varchar](50) NULL,
	[PayrollGroupID] [int] NULL,
	[DateAdded] [datetime] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeType]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeType](
	[EmployeeTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Leave]    Script Date: 9/25/2019 3:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Leave](
	[LeaveID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[LeaveDate] [date] NOT NULL,
	[IsPaidLeave] [bit] NOT NULL,
 CONSTRAINT [PK__Leave__796DB979F4C0C9AE] PRIMARY KEY CLUSTERED 
(
	[LeaveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Loan]    Script Date: 9/25/2019 3:25:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Loan](
	[LoanID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[Amount] [float] NULL,
	[LoanType] [varchar](50) NOT NULL,
	[AmountRemaining]  AS (round([dbo].[computeTermsRemaining]([LoanID],[Terms])*([Amount]/[Terms]),(2))),
	[TotalPaid]  AS (round(([Terms]-[dbo].[computeTermsRemaining]([LoanID],[Terms]))*([Amount]/[Terms]),(2))),
	[Terms] [int] NOT NULL,
	[TermsRemaining]  AS ([dbo].[computeTermsRemaining]([LoanID],[Terms])),
	[IsPaid]  AS (CONVERT([bit],case when [dbo].[computeTermsRemaining]([LoanID],[Terms])>(0) then (0) else (1) end)),
	[AmountPerPayroll]  AS (round([Amount]/[Terms],(2))),
 CONSTRAINT [PK__Loan__4F5AD43784B9B230] PRIMARY KEY CLUSTERED 
(
	[LoanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoanPayment]    Script Date: 9/25/2019 3:25:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoanPayment](
	[LoanPaymentID] [int] IDENTITY(1,1) NOT NULL,
	[LoanID] [int] NOT NULL,
	[PayrollDetailID] [int] NULL,
	[AmountPaid]  AS ([dbo].[computePayment]([LoanID])),
 CONSTRAINT [PK__LoanPaym__5BA74D5C6DAD6842] PRIMARY KEY CLUSTERED 
(
	[LoanPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payroll]    Script Date: 9/25/2019 3:25:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payroll](
	[PayrollID] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[PayrollGroupID] [int] NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK__Payrolls__99DFC692C97E6E4B] PRIMARY KEY CLUSTERED 
(
	[PayrollID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollDetail]    Script Date: 9/25/2019 3:25:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollDetail](
	[PayrollDetailID] [int] IDENTITY(1,1) NOT NULL,
	[PayrollID] [int] NULL,
	[EmployeeID] [int] NULL,
	[TotalDays]  AS ([dbo].[GetTotalDaysOf]([PayrollDetailID])),
	[TotalRegularHours]  AS ([dbo].[ComputeTotalRegularHours]([PayrollDetailID])),
	[TotalOverTimeHours]  AS ([dbo].[ComputeTotalOvertimeHours]([PayrollDetailID])),
	[RegularPay]  AS ([dbo].[computeRegularPay]([PayrollDetailID],[EmployeeID])),
	[OvertimePay]  AS ([dbo].[computeOvertime]([EmployeeID],[PayrollDetailID])),
	[GrossPay]  AS ([dbo].[ComputeRegularPay]([PayrollDetailID],[EmployeeID])+[dbo].[ComputeOvertime]([EmployeeID],[PayrollDetailID])),
	[TotalContributions]  AS ([dbo].[computetotalcontributions]([EmployeeID],[PayrollDetailID],[PayrollID])),
	[TotalDeductions]  AS ([dbo].[ComputeTotalDeductions]([PayrollDetailID])),
	[NetPay]  AS ([dbo].[ComputeNetPay]([PayrollDetailID])),
 CONSTRAINT [PK__PayrollD__010127A9AB92AB29] PRIMARY KEY CLUSTERED 
(
	[PayrollDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollGroup]    Script Date: 9/25/2019 3:25:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollGroup](
	[PayrollGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PayrollGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 9/25/2019 3:25:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [varchar](50) NULL,
	[Username] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[SecretQuestion] [varchar](50) NULL,
	[SecretAnswer] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Attendance] ON 

INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-01T00:00:00.000' AS DateTime), 12, 0, 2251, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-02T00:00:00.000' AS DateTime), 12, 0, 2252, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-03T00:00:00.000' AS DateTime), 12, 0, 2253, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-04T00:00:00.000' AS DateTime), 0, 0, 2254, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-05T00:00:00.000' AS DateTime), 12, 0, 2255, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-06T00:00:00.000' AS DateTime), 12, 0, 2256, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-07T00:00:00.000' AS DateTime), 12, 0, 2257, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-09-30T00:00:00.000' AS DateTime), 8, 0, 2286, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-01T00:00:00.000' AS DateTime), 8, 0, 2287, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-02T00:00:00.000' AS DateTime), 8, 0, 2288, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-03T00:00:00.000' AS DateTime), 8, 0, 2289, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-04T00:00:00.000' AS DateTime), 8, 0, 2290, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-05T00:00:00.000' AS DateTime), 8, 0, 2291, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-06T00:00:00.000' AS DateTime), 8, 0, 2292, NULL, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-09-30T00:00:00.000' AS DateTime), 8, 0, 2293, 1267, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-01T00:00:00.000' AS DateTime), 8, 0, 2294, 1267, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-02T00:00:00.000' AS DateTime), 8, 0, 2295, 1267, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-03T00:00:00.000' AS DateTime), 8, 0, 2296, 1267, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-04T00:00:00.000' AS DateTime), 8, 0, 2297, 1267, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-05T00:00:00.000' AS DateTime), 8, 0, 2298, 1267, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-06T00:00:00.000' AS DateTime), 8, 0, 2299, 1267, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-09-25T02:08:18.653' AS DateTime), 5, 0, 2300, 1268, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-09-26T02:08:18.653' AS DateTime), 5, 0, 2301, 1268, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-09-27T02:08:18.653' AS DateTime), 5, 0, 2302, 1268, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-09-28T02:08:18.653' AS DateTime), 5, 0, 2303, 1268, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-09-29T02:08:18.653' AS DateTime), 5, 0, 2304, 1268, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-09-30T02:08:18.653' AS DateTime), 5, 0, 2305, 1268, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-01T02:08:18.653' AS DateTime), 5, 0, 2306, 1268, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-09-30T00:00:00.000' AS DateTime), 5, 0, 2307, 1266, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-01T00:00:00.000' AS DateTime), 5, 0, 2308, 1266, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-02T00:00:00.000' AS DateTime), 5, 2, 2309, 1266, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-03T00:00:00.000' AS DateTime), 5, 0, 2310, 1266, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-04T00:00:00.000' AS DateTime), 5, 0, 2311, 1266, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-05T00:00:00.000' AS DateTime), 5, 0, 2312, 1266, 0)
INSERT [dbo].[Attendance] ([AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [AttendanceID], [PayrollDetailsID], [MinutesLate]) VALUES (CAST(N'2019-10-06T00:00:00.000' AS DateTime), 5, 0, 2313, 1266, 0)
SET IDENTITY_INSERT [dbo].[Attendance] OFF
SET IDENTITY_INSERT [dbo].[Contribution] ON 

INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (281, 2, 1266)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (282, 2, 1268)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (283, 2, 1270)
SET IDENTITY_INSERT [dbo].[Contribution] OFF
SET IDENTITY_INSERT [dbo].[ContributionType] ON 

INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (1, N'PhilHealth', 0.0275)
INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (2, N'SSS', 0.04)
INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (3, N'Pagibig', 0.02)
INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (4, N'Tax', 0)
SET IDENTITY_INSERT [dbo].[ContributionType] OFF
SET IDENTITY_INSERT [dbo].[Deduction] ON 

INSERT [dbo].[Deduction] ([DeductionsLogId], [DeductionTypeID], [Amount], [AttendanceID]) VALUES (1018, 4, 25, NULL)
INSERT [dbo].[Deduction] ([DeductionsLogId], [DeductionTypeID], [Amount], [AttendanceID]) VALUES (1019, 6, 25, NULL)
INSERT [dbo].[Deduction] ([DeductionsLogId], [DeductionTypeID], [Amount], [AttendanceID]) VALUES (1023, 10, 50, 2290)
INSERT [dbo].[Deduction] ([DeductionsLogId], [DeductionTypeID], [Amount], [AttendanceID]) VALUES (1024, 6, 25, NULL)
INSERT [dbo].[Deduction] ([DeductionsLogId], [DeductionTypeID], [Amount], [AttendanceID]) VALUES (1025, 2, 22, 2293)
INSERT [dbo].[Deduction] ([DeductionsLogId], [DeductionTypeID], [Amount], [AttendanceID]) VALUES (1026, 3, 14, 2294)
SET IDENTITY_INSERT [dbo].[Deduction] OFF
SET IDENTITY_INSERT [dbo].[DeductionsTypes] ON 

INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (1, N'Sales Short', N'DED_SALE_SHORT')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (2, N'Inventory', N'DED_INVENTORY')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (3, N'Excess Meal', N'DED_EXCSS_MEAL')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (4, N'Incomplete Uniform', N'DED_INC_UNIFROM')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (6, N'Late', N'DED_LATE')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (10, N'Other', N'DED_OTHER')
SET IDENTITY_INSERT [dbo].[DeductionsTypes] OFF
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Branch], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded]) VALUES (1041, N'Neil Francis', N'Nahid', N'Agsoy', N'Male', CAST(N'1998-04-13T00:00:00.000' AS DateTime), N'+639123456789', N'Looc Norte, Asturias, Cebu', 2, 50, 5, 6, N'00-1234567-0', N'0000-0000-0000', N'00-123456789-0', N'123-123-123-123', N'Main', N'Active', 0, 1, 0, 0, 3, N'2019-09-16-1', 7, CAST(N'2019-09-16T21:48:36.637' AS DateTime))
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Branch], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded]) VALUES (1042, N'asd', N'asd', N'asd', N'Male', CAST(N'1998-10-07T00:00:00.000' AS DateTime), N'+639289066258', N'asdsa', 5, 55, 8, 6, N'', NULL, NULL, NULL, N'asd', N'Active', 0, 0, 0, 0, 3, N'2019-09-22-1', 7, CAST(N'2019-09-22T03:57:59.270' AS DateTime))
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Branch], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded]) VALUES (1043, N'Aldren ', N'Getutua', N'Jabonero', N'Male', CAST(N'2019-09-25T00:00:00.000' AS DateTime), N'+639123456789', N'731 B Little Baguio St. Mambaling Cebu City', 3, 62, 8, 5, N'00-1234567-0', N'0000-0000-0000', N'00-123456789-0', N'000-000-000-000', N'Qualfon', N'Active', 1, 1, 1, 1, 5, N'2019-09-25-1', 6, CAST(N'2019-09-25T11:57:51.213' AS DateTime))
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Branch], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded]) VALUES (1044, N'will', N'be', N'smith', N'Male', CAST(N'2000-08-04T00:00:00.000' AS DateTime), N'+639663194180', N'baragay makaputhaw demodyablo', 2, 66, 6, 6, NULL, NULL, NULL, NULL, N'1', N'Terminated', 0, 0, 0, 0, 6, N'2019-09-25-2', 2, CAST(N'2019-09-25T14:16:07.357' AS DateTime))
SET IDENTITY_INSERT [dbo].[Employee] OFF
SET IDENTITY_INSERT [dbo].[EmployeeType] ON 

INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (3, N'Crew')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (4, N'Cashier')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (5, N'Admin')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (6, N'Commissary')
SET IDENTITY_INSERT [dbo].[EmployeeType] OFF
SET IDENTITY_INSERT [dbo].[Leave] ON 

INSERT [dbo].[Leave] ([LeaveID], [EmployeeID], [LeaveDate], [IsPaidLeave]) VALUES (14, 1041, CAST(N'2019-10-04' AS Date), 1)
INSERT [dbo].[Leave] ([LeaveID], [EmployeeID], [LeaveDate], [IsPaidLeave]) VALUES (15, 1041, CAST(N'2019-09-22' AS Date), 1)
SET IDENTITY_INSERT [dbo].[Leave] OFF
SET IDENTITY_INSERT [dbo].[Loan] ON 

INSERT [dbo].[Loan] ([LoanID], [EmployeeID], [Amount], [LoanType], [Terms]) VALUES (1, 1042, 100, N'Cash Advance', 3)
INSERT [dbo].[Loan] ([LoanID], [EmployeeID], [Amount], [LoanType], [Terms]) VALUES (2, 1041, 100, N'Loan', 3)
SET IDENTITY_INSERT [dbo].[Loan] OFF
SET IDENTITY_INSERT [dbo].[LoanPayment] ON 

INSERT [dbo].[LoanPayment] ([LoanPaymentID], [LoanID], [PayrollDetailID]) VALUES (1, 1, 1267)
INSERT [dbo].[LoanPayment] ([LoanPaymentID], [LoanID], [PayrollDetailID]) VALUES (2, 2, 1268)
INSERT [dbo].[LoanPayment] ([LoanPaymentID], [LoanID], [PayrollDetailID]) VALUES (3, 1, 1269)
INSERT [dbo].[LoanPayment] ([LoanPaymentID], [LoanID], [PayrollDetailID]) VALUES (4, 2, 1270)
INSERT [dbo].[LoanPayment] ([LoanPaymentID], [LoanID], [PayrollDetailID]) VALUES (5, 1, 1271)
SET IDENTITY_INSERT [dbo].[LoanPayment] OFF
SET IDENTITY_INSERT [dbo].[Payroll] ON 

INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (1142, CAST(N'2019-09-30T00:00:00.000' AS DateTime), CAST(N'2019-10-07T00:00:00.000' AS DateTime), 7, CAST(N'2019-09-23T00:00:00.000' AS DateTime))
INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (1143, CAST(N'2019-09-25T02:08:18.653' AS DateTime), CAST(N'2019-10-02T00:00:00.000' AS DateTime), 7, CAST(N'2019-09-25T00:00:00.000' AS DateTime))
INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (1144, CAST(N'2019-09-25T11:42:17.600' AS DateTime), CAST(N'2019-10-03T00:00:00.000' AS DateTime), 7, CAST(N'2019-09-25T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Payroll] OFF
SET IDENTITY_INSERT [dbo].[PayrollDetail] ON 

INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1266, 1142, 1041)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1267, 1142, 1042)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1268, 1143, 1041)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1269, 1143, 1042)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1270, 1144, 1041)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1271, 1144, 1042)
SET IDENTITY_INSERT [dbo].[PayrollDetail] OFF
SET IDENTITY_INSERT [dbo].[PayrollGroup] ON 

INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name]) VALUES (2, N'Yearly Group')
INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name]) VALUES (5, N'Everyone')
INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name]) VALUES (6, N'Monthly Group')
INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name]) VALUES (7, N'Weekly Group')
SET IDENTITY_INSERT [dbo].[PayrollGroup] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserId], [FullName], [Username], [Password], [SecretQuestion], [SecretAnswer]) VALUES (4, N'Neil', N'admin', N'admin', N'who are you?', N'1234')
SET IDENTITY_INSERT [dbo].[Users] OFF
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_IsPhilhealthActive]  DEFAULT ((0)) FOR [IsPhilhealthActive]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_IsSSSActive]  DEFAULT ((0)) FOR [IsSSSActive]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_IsIncomeTaxActive]  DEFAULT ((0)) FOR [IsIncomeTaxActive]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_IsPagibigActive]  DEFAULT ((0)) FOR [IsPagibigActive]
GO
ALTER TABLE [dbo].[Attendance]  WITH CHECK ADD  CONSTRAINT [FK__Attendanc__Payro__08012052] FOREIGN KEY([PayrollDetailsID])
REFERENCES [dbo].[PayrollDetail] ([PayrollDetailID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Attendance] CHECK CONSTRAINT [FK__Attendanc__Payro__08012052]
GO
ALTER TABLE [dbo].[Contribution]  WITH CHECK ADD FOREIGN KEY([ContributionTypeID])
REFERENCES [dbo].[ContributionType] ([ContributionTypeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Contribution]  WITH CHECK ADD  CONSTRAINT [FK__Contribut__Payro__1A1FD08D] FOREIGN KEY([PayrollDetailID])
REFERENCES [dbo].[PayrollDetail] ([PayrollDetailID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Contribution] CHECK CONSTRAINT [FK__Contribut__Payro__1A1FD08D]
GO
ALTER TABLE [dbo].[Deduction]  WITH CHECK ADD FOREIGN KEY([DeductionTypeID])
REFERENCES [dbo].[DeductionsTypes] ([DeductionTypeID])
GO
ALTER TABLE [dbo].[Deduction]  WITH CHECK ADD  CONSTRAINT [FK_Deduction_Attendance] FOREIGN KEY([AttendanceID])
REFERENCES [dbo].[Attendance] ([AttendanceID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Deduction] CHECK CONSTRAINT [FK_Deduction_Attendance]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([PayrollGroupID])
REFERENCES [dbo].[PayrollGroup] ([PayrollGroupID])
GO
ALTER TABLE [dbo].[Leave]  WITH CHECK ADD  CONSTRAINT [FK__Leave__EmployeeI__1B9E04AB] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
ALTER TABLE [dbo].[Leave] CHECK CONSTRAINT [FK__Leave__EmployeeI__1B9E04AB]
GO
ALTER TABLE [dbo].[Loan]  WITH CHECK ADD  CONSTRAINT [FK__Loan__EmployeeID__088B3037] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
ALTER TABLE [dbo].[Loan] CHECK CONSTRAINT [FK__Loan__EmployeeID__088B3037]
GO
ALTER TABLE [dbo].[LoanPayment]  WITH CHECK ADD  CONSTRAINT [FK__LoanPayme__LoanI__5E94F66B] FOREIGN KEY([LoanID])
REFERENCES [dbo].[Loan] ([LoanID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LoanPayment] CHECK CONSTRAINT [FK__LoanPayme__LoanI__5E94F66B]
GO
ALTER TABLE [dbo].[LoanPayment]  WITH CHECK ADD FOREIGN KEY([PayrollDetailID])
REFERENCES [dbo].[PayrollDetail] ([PayrollDetailID])
GO
ALTER TABLE [dbo].[Payroll]  WITH CHECK ADD  CONSTRAINT [FK__Payroll__Payroll__3E2826D9] FOREIGN KEY([PayrollGroupID])
REFERENCES [dbo].[PayrollGroup] ([PayrollGroupID])
GO
ALTER TABLE [dbo].[Payroll] CHECK CONSTRAINT [FK__Payroll__Payroll__3E2826D9]
GO
ALTER TABLE [dbo].[PayrollDetail]  WITH CHECK ADD  CONSTRAINT [FK__PayrollDe__Emplo__097F5470] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PayrollDetail] CHECK CONSTRAINT [FK__PayrollDe__Emplo__097F5470]
GO
ALTER TABLE [dbo].[PayrollDetail]  WITH CHECK ADD  CONSTRAINT [FK__PayrollDe__Payro__2E26C93A] FOREIGN KEY([PayrollID])
REFERENCES [dbo].[Payroll] ([PayrollID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PayrollDetail] CHECK CONSTRAINT [FK__PayrollDe__Payro__2E26C93A]
GO
/****** Object:  StoredProcedure [dbo].[sp_addLoanPayment]    Script Date: 9/25/2019 3:25:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_addLoanPayment](
@PayrollDetailID int)
as
declare @EmployeeID as int = (select EmployeeID from PayrollDetail where PayrollDetailID=@PayrollDetailID)

declare activeLoans cursor for select LoanID from Loan where EmployeeID = @EmployeeID and IsPaid = 0;
declare @LoanID as int;
open activeLoans
fetch next from activeLoans into @LoanID
while @@FETCH_STATUS = 0
begin
if(ISNULL(@LoanID,0)!=0) 
insert into LoanPayment(PayrollDetailID,LoanID) values(@payrollDetailID,@LoanID)
end
close activeLoans
deallocate activeLoans
GO
/****** Object:  StoredProcedure [dbo].[sp_SearchEmployee]    Script Date: 9/25/2019 3:25:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_SearchEmployee](@string varchar(50))
as
select * from Employee 
where Employee.FullName like '%'+@string+'%'
or Employee.FirstName like '%'+@string+'%'
or Employee.LastName like '%'+@string+'%'
or Employee.Emp_ID like '%'+@string+'%'
GO
/****** Object:  StoredProcedure [dbo].[sp_updateEmployee]    Script Date: 9/25/2019 3:25:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_updateEmployee]
@fname varchar(50),
@lname varchar(50),
@mname varchar(50),
@dob datetime,
@age int,
@contact varchar(50),
@address varchar(50),
@gender varchar(50),
@availableLeaves varchar(50),
@pagibig varchar(50),
@sss varchar(50),
@philhealth varchar(50),
@tin varchar(50),
@branch varchar(50),
@empId int,
@status varchar(50)
as
update Employees
set FirstName = @fname, LastName = @lname, MiddleName = @mname, DateOfBirth = @dob, Age = @age , ContactNumber = @contact, Address = @address, Gender = @gender, AvailableLeaves = @availableLeaves, PagIbigID = @pagibig, SSSID = @sss, PhilhealthID = @philhealth, TINID = @tin, Status = @status where EmployeeID = @empId 
GO
USE [master]
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET  READ_WRITE 
GO
