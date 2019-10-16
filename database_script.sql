USE [master]
GO
/****** Object:  Database [CJLSFOODSPAYROLL]    Script Date: 17/10/2019 12:45:26 AM ******/
CREATE DATABASE [CJLSFOODSPAYROLL]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CJLSFOODSPAYROLL', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\CJLSFOODSPAYROLL.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CJLSFOODSPAYROLL_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\CJLSFOODSPAYROLL_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
EXEC sys.sp_db_vardecimal_storage_format N'CJLSFOODSPAYROLL', N'ON'
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET QUERY_STORE = OFF
GO
USE [CJLSFOODSPAYROLL]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [CJLSFOODSPAYROLL]
GO
/****** Object:  UserDefinedFunction [dbo].[computeAttendanceGrossPay]    Script Date: 17/10/2019 12:45:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[computeAttendanceGrossPay](@attendanceid int)
returns float
as
begin
declare @regularpay as float = (select regularpay from attendance where attendanceid = @attendanceid)
declare @overtimepay as float = (select overtimepay from attendance where attendanceid = @attendanceid)
return @regularpay+@overtimepay
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeAttendanceOvertimePay]    Script Date: 17/10/2019 12:45:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeAttendanceOvertimePay](@PayrollDetailID int, @OvertimeHoursWorked int,@DayType varchar(50))
returns float
as
begin
declare @EmployeeID as int = (select EmployeeID from PayrollDetail where PayrollDetailID=@PayrollDetailID)
declare @HourlyRate as float = (Select hourlyrate from employee where EmployeeID=@EmployeeID)
declare @overtimePay as float = @HourlyRate * @OvertimeHoursWorked * 1.25

if @DayType='Regular'
return @overtimePay*2
else if @DayType='Special'
return @overtimePay*1.30
return @overtimePay
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeAttendanceRegularPay]    Script Date: 17/10/2019 12:45:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeAttendanceRegularPay](@PayrollDetailID int, @RegularHoursWorked int, @DayType varchar(50))
returns float
as
begin
declare @EmployeeID as int = (select EmployeeID from PayrollDetail where PayrollDetailID=@PayrollDetailID)
declare @HourlyRate as float = (Select hourlyrate from employee where EmployeeID=@EmployeeID)
declare @regularPay as float = @HourlyRate * @regularhoursworked

if @DayType='Regular'
return @regularPay*2
if @DayType='Special'
return @regularPay*1.30
else if @DayType='Normal'
return @regularPay
return @regularPay
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeContribution]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeGrossPay]    Script Date: 17/10/2019 12:45:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeGrossPay](@PayrollDetailID int)
returns float
as
begin
declare @RegularPay as float = (select RegularPay from PayrollDetail where PayrollDetailID=@PayrollDetailID)
declare @OverTimePay as float = (select OvertimePay from PayrollDetail where PayrollDetailID=@PayrollDetailID)
return round(@RegularPay+@OvertimePay,2)
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeNetPay]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeOverTime]    Script Date: 17/10/2019 12:45:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ComputeOverTime](@PayrollDetailID int)
returns float
as
begin
return round((select Sum(OvertimePay) from Attendance where PayrollDetailsID=@PayrollDetailID),2)
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputePagIBIG]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[computePayment]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputePhilHealth]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[computeRegularPay]    Script Date: 17/10/2019 12:45:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[computeRegularPay](@PayrollDetailID int)
returns float
as
begin
return round((select sum(RegularPay) from Attendance where PayrollDetailsID = @PayrollDetailID),2)
end
GO
/****** Object:  UserDefinedFunction [dbo].[ComputeSSS]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTax]    Script Date: 17/10/2019 12:45:26 AM ******/
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
	set @TaxPercentRate = (select PercentRate from Taxrate where TaxRateID=1)
if @DeductedMonthlySalary > 20833 and @DeductedMonthlySalary < 33333
	begin
	set @TaxPercentRate = (select PercentRate from Taxrate where TaxRateID=2);
	set @CLAmount = 20833/@AverageWorkDaysAMonth*@TotalDays;
	end
if @DeductedMonthlySalary >= 33333/@AverageWorkDaysAMonth*@TotalDays and @DeductedMonthlySalary < 66667/@AverageWorkDaysAMonth*@TotalDays
	begin
	set @Total = 2500/@AverageWorkDaysAMonth*@TotalDays;
	set @TaxPercentRate = (select PercentRate from Taxrate where TaxRateID=3);
	set @CLAmount = 33333/@AverageWorkDaysAMonth*@TotalDays;
	end
if @DeductedMonthlySalary >= 66667/@AverageWorkDaysAMonth*@TotalDays and @DeductedMonthlySalary < 166667/@AverageWorkDaysAMonth*@TotalDays
	begin
	set @Total = 10833.33/@AverageWorkDaysAMonth*@TotalDays;
	set @TaxPercentRate = (select PercentRate from Taxrate where TaxRateID=4);
	set @CLAmount = 66667/@AverageWorkDaysAMonth*@TotalDays;
	end
if @DeductedMonthlySalary >= 166667/@AverageWorkDaysAMonth*@TotalDays and @DeductedMonthlySalary < 666667/@AverageWorkDaysAMonth*@TotalDays
	begin
	set @Total = 40833.33/@AverageWorkDaysAMonth*@TotalDays
	set @TaxPercentRate = (select PercentRate from Taxrate where TaxRateID=5);
	set @CLAmount = 166667/@AverageWorkDaysAMonth*@TotalDays;
	end
if @DeductedMonthlySalary >= 666667/@AverageWorkDaysAMonth*@TotalDays
	begin
	set @Total = 200833.33/@AverageWorkDaysAMonth*@TotalDays
	set @TaxPercentRate = (select PercentRate from Taxrate where TaxRateID=6);
	set @CLAmount = 666667/@AverageWorkDaysAMonth*@TotalDays;
	end

return round(((@DeductedMonthlySalary-@CLAmount)*@TaxPercentRate+@Total)/@AverageWorkDaysAMonth*@TotalDays,2);
end
GO
/****** Object:  UserDefinedFunction [dbo].[computeTermsRemaining]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalContributions]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalDeductions]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalOverTimeHours]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalRegularHours]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getFormattedEmpID]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[GetTotalDaysOf]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  Table [dbo].[Attendance]    Script Date: 17/10/2019 12:45:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attendance](
	[AttendanceID] [int] IDENTITY(1,1) NOT NULL,
	[AttendanceDate] [datetime] NULL,
	[RegularHoursWorked] [float] NOT NULL,
	[OverTimeHoursWorked] [float] NOT NULL,
	[PayrollDetailsID] [int] NULL,
	[DayType] [varchar](50) NULL,
	[RegularPay]  AS ([dbo].[ComputeAttendanceRegularPay]([PayrollDetailsID],[RegularHoursWorked],[DayType])),
	[OvertimePay]  AS ([dbo].[computeattendanceOvertimePay]([Payrolldetailsid],[overtimehoursworked],[daytype])),
	[Total]  AS ([dbo].[computeAttendanceGrossPay]([attendanceid])),
 CONSTRAINT [PK__Attendan__8B69263C06378183] PRIMARY KEY CLUSTERED 
(
	[AttendanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 17/10/2019 12:45:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[BranchID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK__Branch__A1682FA5AC73CC73] PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contribution]    Script Date: 17/10/2019 12:45:26 AM ******/
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
/****** Object:  Table [dbo].[ContributionType]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  Table [dbo].[Deduction]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  Table [dbo].[DeductionsTypes]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  Table [dbo].[Employee]    Script Date: 17/10/2019 12:45:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [int] IDENTITY(1000,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NOT NULL,
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
	[Status] [varchar](50) NOT NULL,
	[IsPhilhealthActive] [bit] NOT NULL,
	[IsSSSActive] [bit] NOT NULL,
	[IsIncomeTaxActive] [bit] NOT NULL,
	[IsPagibigActive] [bit] NOT NULL,
	[EmployeeTypeID] [int] NOT NULL,
	[Emp_ID] [varchar](50) NULL,
	[PayrollGroupID] [int] NULL,
	[DateAdded] [datetime] NULL,
	[BranchID] [int] NULL,
	[FullName]  AS (((([FirstName]+' ')+[MiddleName])+' ')+[LastName]),
	[CivilStatus] [varchar](50) NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeType]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  Table [dbo].[Leave]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  Table [dbo].[Loan]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  Table [dbo].[LoanPayment]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  Table [dbo].[Payroll]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  Table [dbo].[PayrollDetail]    Script Date: 17/10/2019 12:45:27 AM ******/
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
	[TotalContributions]  AS ([dbo].[computetotalcontributions]([EmployeeID],[PayrollDetailID],[PayrollID])),
	[TotalDeductions]  AS ([dbo].[ComputeTotalDeductions]([PayrollDetailID])),
	[OvertimePay]  AS ([dbo].[ComputeOverTime]([PayrollDetailID])),
	[RegularPay]  AS ([dbo].[Computeregularpay]([payrolldetailid])),
	[GrossPay]  AS ([dbo].[computegrosspay]([PayrollDetailID])),
	[NetPay]  AS ([dbo].[ComputeNetPay]([PayrollDetailID])),
 CONSTRAINT [PK__PayrollD__010127A9AB92AB29] PRIMARY KEY CLUSTERED 
(
	[PayrollDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollGroup]    Script Date: 17/10/2019 12:45:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollGroup](
	[PayrollGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[NumberOfDays] [int] NOT NULL,
 CONSTRAINT [PK__Employee__042E028C3DDA428B] PRIMARY KEY CLUSTERED 
(
	[PayrollGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaxRate]    Script Date: 17/10/2019 12:45:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxRate](
	[TaxRateID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[PercentRate] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[TaxRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 17/10/2019 12:45:27 AM ******/
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
	[UserType] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[EmployeeID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Attendance] ON 

INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1097, CAST(N'2019-10-16T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1098, CAST(N'2019-10-17T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1099, CAST(N'2019-10-18T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1100, CAST(N'2019-10-19T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1101, CAST(N'2019-10-20T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1102, CAST(N'2019-10-21T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1103, CAST(N'2019-10-22T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1104, CAST(N'2019-10-23T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1105, CAST(N'2019-10-24T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1106, CAST(N'2019-10-25T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1107, CAST(N'2019-10-26T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1108, CAST(N'2019-10-27T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1109, CAST(N'2019-10-28T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1110, CAST(N'2019-10-29T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1111, CAST(N'2019-10-30T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1112, CAST(N'2019-10-31T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1113, CAST(N'2019-11-01T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1114, CAST(N'2019-11-02T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1115, CAST(N'2019-11-03T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1116, CAST(N'2019-11-04T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1117, CAST(N'2019-11-05T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1118, CAST(N'2019-11-06T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1119, CAST(N'2019-11-07T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1120, CAST(N'2019-11-08T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1121, CAST(N'2019-11-09T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1122, CAST(N'2019-11-10T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1123, CAST(N'2019-11-11T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1124, CAST(N'2019-11-12T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1125, CAST(N'2019-11-13T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1126, CAST(N'2019-11-14T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1127, CAST(N'2019-11-15T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1128, CAST(N'2019-11-16T10:47:48.353' AS DateTime), 8, 0, 1012, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1129, CAST(N'2019-10-16T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1130, CAST(N'2019-10-17T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1131, CAST(N'2019-10-18T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1132, CAST(N'2019-10-19T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1133, CAST(N'2019-10-20T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1134, CAST(N'2019-10-21T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1135, CAST(N'2019-10-22T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1136, CAST(N'2019-10-23T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1137, CAST(N'2019-10-24T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1138, CAST(N'2019-10-25T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1139, CAST(N'2019-10-26T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1140, CAST(N'2019-10-27T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1141, CAST(N'2019-10-28T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1142, CAST(N'2019-10-29T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1143, CAST(N'2019-10-30T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1144, CAST(N'2019-10-31T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1145, CAST(N'2019-11-01T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1146, CAST(N'2019-11-02T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1147, CAST(N'2019-11-03T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1148, CAST(N'2019-11-04T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1149, CAST(N'2019-11-05T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1150, CAST(N'2019-11-06T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1151, CAST(N'2019-11-07T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1152, CAST(N'2019-11-08T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1153, CAST(N'2019-11-09T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1154, CAST(N'2019-11-10T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1155, CAST(N'2019-11-11T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1156, CAST(N'2019-11-12T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1157, CAST(N'2019-11-13T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1158, CAST(N'2019-11-14T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1159, CAST(N'2019-11-15T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1160, CAST(N'2019-11-16T10:47:48.353' AS DateTime), 8, 0, 1013, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1161, CAST(N'2019-10-16T00:00:00.000' AS DateTime), 8, 0, 1014, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1162, CAST(N'2019-10-17T00:00:00.000' AS DateTime), 8, 0, 1014, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1163, CAST(N'2019-10-18T00:00:00.000' AS DateTime), 8, 0, 1014, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1164, CAST(N'2019-10-19T00:00:00.000' AS DateTime), 0, 0, 1014, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1165, CAST(N'2019-10-20T00:00:00.000' AS DateTime), 0, 0, 1014, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1166, CAST(N'2019-10-21T00:00:00.000' AS DateTime), 0, 0, 1014, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1167, CAST(N'2019-10-22T00:00:00.000' AS DateTime), 8, 0, 1014, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1168, CAST(N'2019-10-23T00:00:00.000' AS DateTime), 8, 0, 1014, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1169, CAST(N'2019-10-16T00:00:00.000' AS DateTime), 8, 0, 1015, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1170, CAST(N'2019-10-17T00:00:00.000' AS DateTime), 8, 0, 1015, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1171, CAST(N'2019-10-18T00:00:00.000' AS DateTime), 8, 0, 1015, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1172, CAST(N'2019-10-19T00:00:00.000' AS DateTime), 8, 0, 1015, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1173, CAST(N'2019-10-20T00:00:00.000' AS DateTime), 8, 0, 1015, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1174, CAST(N'2019-10-21T00:00:00.000' AS DateTime), 0, 0, 1015, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1175, CAST(N'2019-10-22T00:00:00.000' AS DateTime), 0, 0, 1015, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1176, CAST(N'2019-10-23T00:00:00.000' AS DateTime), 0, 0, 1015, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1177, CAST(N'2019-11-17T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1178, CAST(N'2019-11-18T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1179, CAST(N'2019-11-19T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1180, CAST(N'2019-11-20T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1181, CAST(N'2019-11-21T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1182, CAST(N'2019-11-22T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1183, CAST(N'2019-11-23T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1184, CAST(N'2019-11-24T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1185, CAST(N'2019-11-25T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1186, CAST(N'2019-11-26T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1187, CAST(N'2019-11-27T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1188, CAST(N'2019-11-28T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1189, CAST(N'2019-11-29T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1190, CAST(N'2019-11-30T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1191, CAST(N'2019-12-01T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1192, CAST(N'2019-12-02T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1193, CAST(N'2019-12-03T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1194, CAST(N'2019-12-04T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1195, CAST(N'2019-12-05T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
GO
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1196, CAST(N'2019-12-06T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1197, CAST(N'2019-12-07T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1198, CAST(N'2019-12-08T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1199, CAST(N'2019-12-09T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1200, CAST(N'2019-12-10T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1201, CAST(N'2019-12-11T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1202, CAST(N'2019-12-12T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1203, CAST(N'2019-12-13T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1204, CAST(N'2019-12-14T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1205, CAST(N'2019-12-15T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1206, CAST(N'2019-12-16T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1207, CAST(N'2019-12-17T10:47:48.353' AS DateTime), 8, 0, 1018, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1208, CAST(N'2019-11-17T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1209, CAST(N'2019-11-18T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1210, CAST(N'2019-11-19T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1211, CAST(N'2019-11-20T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1212, CAST(N'2019-11-21T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1213, CAST(N'2019-11-22T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1214, CAST(N'2019-11-23T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1215, CAST(N'2019-11-24T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1216, CAST(N'2019-11-25T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1217, CAST(N'2019-11-26T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1218, CAST(N'2019-11-27T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1219, CAST(N'2019-11-28T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1220, CAST(N'2019-11-29T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1221, CAST(N'2019-11-30T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1222, CAST(N'2019-12-01T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1223, CAST(N'2019-12-02T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1224, CAST(N'2019-12-03T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1225, CAST(N'2019-12-04T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1226, CAST(N'2019-12-05T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1227, CAST(N'2019-12-06T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1228, CAST(N'2019-12-07T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1229, CAST(N'2019-12-08T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1230, CAST(N'2019-12-09T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1231, CAST(N'2019-12-10T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1232, CAST(N'2019-12-11T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1233, CAST(N'2019-12-12T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1234, CAST(N'2019-12-13T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1235, CAST(N'2019-12-14T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1236, CAST(N'2019-12-15T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1237, CAST(N'2019-12-16T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1238, CAST(N'2019-12-17T10:47:48.353' AS DateTime), 8, 0, 1019, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1239, CAST(N'2019-11-17T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1240, CAST(N'2019-11-18T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1241, CAST(N'2019-11-19T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1242, CAST(N'2019-11-20T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1243, CAST(N'2019-11-21T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1244, CAST(N'2019-11-22T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1245, CAST(N'2019-11-23T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1246, CAST(N'2019-11-24T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1247, CAST(N'2019-11-25T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1248, CAST(N'2019-11-26T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1249, CAST(N'2019-11-27T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1250, CAST(N'2019-11-28T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1251, CAST(N'2019-11-29T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1252, CAST(N'2019-11-30T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1253, CAST(N'2019-12-01T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1254, CAST(N'2019-12-02T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1255, CAST(N'2019-12-03T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1256, CAST(N'2019-12-04T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1257, CAST(N'2019-12-05T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1258, CAST(N'2019-12-06T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1259, CAST(N'2019-12-07T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1260, CAST(N'2019-12-08T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1261, CAST(N'2019-12-09T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1262, CAST(N'2019-12-10T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1263, CAST(N'2019-12-11T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1264, CAST(N'2019-12-12T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1265, CAST(N'2019-12-13T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1266, CAST(N'2019-12-14T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1267, CAST(N'2019-12-15T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1268, CAST(N'2019-12-16T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1269, CAST(N'2019-12-17T10:47:48.353' AS DateTime), 8, 0, 1020, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1270, CAST(N'2019-10-24T00:00:00.000' AS DateTime), 8, 0, 1021, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1271, CAST(N'2019-10-25T00:00:00.000' AS DateTime), 8, 0, 1021, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1272, CAST(N'2019-10-26T00:00:00.000' AS DateTime), 8, 0, 1021, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1273, CAST(N'2019-10-27T00:00:00.000' AS DateTime), 8, 0, 1021, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1274, CAST(N'2019-10-28T00:00:00.000' AS DateTime), 8, 0, 1021, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1275, CAST(N'2019-10-29T00:00:00.000' AS DateTime), 8, 0, 1021, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1276, CAST(N'2019-10-30T00:00:00.000' AS DateTime), 8, 0, 1021, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1277, CAST(N'2019-10-24T00:00:00.000' AS DateTime), 8, 0, 1022, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1278, CAST(N'2019-10-25T00:00:00.000' AS DateTime), 8, 0, 1022, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1279, CAST(N'2019-10-26T00:00:00.000' AS DateTime), 8, 0, 1022, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1280, CAST(N'2019-10-27T00:00:00.000' AS DateTime), 8, 0, 1022, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1281, CAST(N'2019-10-28T00:00:00.000' AS DateTime), 8, 0, 1022, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1282, CAST(N'2019-10-29T00:00:00.000' AS DateTime), 8, 0, 1022, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1283, CAST(N'2019-10-30T00:00:00.000' AS DateTime), 8, 0, 1022, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1284, CAST(N'2019-10-24T00:00:00.000' AS DateTime), 8, 0, 1023, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1285, CAST(N'2019-10-25T00:00:00.000' AS DateTime), 8, 0, 1023, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1286, CAST(N'2019-10-26T00:00:00.000' AS DateTime), 8, 0, 1023, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1287, CAST(N'2019-10-27T00:00:00.000' AS DateTime), 8, 0, 1023, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1288, CAST(N'2019-10-28T00:00:00.000' AS DateTime), 8, 0, 1023, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1289, CAST(N'2019-10-29T00:00:00.000' AS DateTime), 8, 0, 1023, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1290, CAST(N'2019-10-30T00:00:00.000' AS DateTime), 8, 0, 1023, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1291, CAST(N'2019-10-24T00:00:00.000' AS DateTime), 8, 0, 1024, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1292, CAST(N'2019-10-25T00:00:00.000' AS DateTime), 8, 0, 1024, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1293, CAST(N'2019-10-26T00:00:00.000' AS DateTime), 8, 0, 1024, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1294, CAST(N'2019-10-27T00:00:00.000' AS DateTime), 8, 0, 1024, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1295, CAST(N'2019-10-28T00:00:00.000' AS DateTime), 8, 0, 1024, N'Normal')
GO
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1296, CAST(N'2019-10-29T00:00:00.000' AS DateTime), 8, 0, 1024, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1297, CAST(N'2019-10-30T00:00:00.000' AS DateTime), 8, 0, 1024, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1298, CAST(N'2019-10-24T00:00:00.000' AS DateTime), 8, 0, 1025, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1299, CAST(N'2019-10-25T00:00:00.000' AS DateTime), 8, 0, 1025, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1300, CAST(N'2019-10-26T00:00:00.000' AS DateTime), 8, 0, 1025, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1301, CAST(N'2019-10-27T00:00:00.000' AS DateTime), 8, 0, 1025, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1302, CAST(N'2019-10-28T00:00:00.000' AS DateTime), 8, 0, 1025, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1303, CAST(N'2019-10-29T00:00:00.000' AS DateTime), 8, 0, 1025, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1304, CAST(N'2019-10-30T00:00:00.000' AS DateTime), 8, 0, 1025, N'Normal')
SET IDENTITY_INSERT [dbo].[Attendance] OFF
SET IDENTITY_INSERT [dbo].[Branch] ON 

INSERT [dbo].[Branch] ([BranchID], [Name], [IsActive]) VALUES (1, N'Main', 1)
INSERT [dbo].[Branch] ([BranchID], [Name], [IsActive]) VALUES (2, N'Teletech', 1)
INSERT [dbo].[Branch] ([BranchID], [Name], [IsActive]) VALUES (3, N'TechMahindra', 1)
SET IDENTITY_INSERT [dbo].[Branch] OFF
SET IDENTITY_INSERT [dbo].[Contribution] ON 

INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1019, 1, 1012)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1020, 2, 1012)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1021, 3, 1012)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1022, 4, 1012)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1023, 1, 1014)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1024, 2, 1014)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1025, 3, 1014)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1026, 4, 1014)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1027, 1, 1015)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1028, 2, 1015)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1029, 3, 1015)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1030, 4, 1015)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1031, 1, 1016)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1032, 2, 1016)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1033, 3, 1016)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1034, 4, 1016)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1035, 1, 1017)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1036, 2, 1017)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1037, 3, 1017)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1038, 4, 1017)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1039, 1, 1021)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1040, 2, 1021)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1041, 3, 1021)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1042, 4, 1021)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1043, 1, 1024)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1044, 2, 1024)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1045, 3, 1024)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1046, 4, 1024)
SET IDENTITY_INSERT [dbo].[Contribution] OFF
SET IDENTITY_INSERT [dbo].[ContributionType] ON 

INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (1, N'PhilHealth', 0.12)
INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (2, N'SSS', 0.04)
INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (3, N'Pagibig', 0.02)
INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (4, N'Tax', 0)
SET IDENTITY_INSERT [dbo].[ContributionType] OFF
SET IDENTITY_INSERT [dbo].[Deduction] ON 

INSERT [dbo].[Deduction] ([DeductionsLogId], [DeductionTypeID], [Amount], [AttendanceID]) VALUES (1, 3, 25, 1162)
INSERT [dbo].[Deduction] ([DeductionsLogId], [DeductionTypeID], [Amount], [AttendanceID]) VALUES (2, 3, 0, NULL)
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

INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded], [BranchID], [CivilStatus]) VALUES (1007, N'Neil Francis', N'', N'Agsoy', N'Male', CAST(N'2019-10-16T10:34:29.260' AS DateTime), N'+639289066258', N'Cebu City', 0, 50, 8, 5, N'00-1234567-0', N'1234-1234-1234', N'00-123456789-0', N'000-000-000-000', N'Active', 1, 1, 1, 1, 5, N'1016-19-1', 3, NULL, 1, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded], [BranchID], [CivilStatus]) VALUES (1008, N'Jeason', N'', N'Yu', N'Male', CAST(N'1998-04-10T00:00:00.000' AS DateTime), N'+639289066258', N'Cebu', 5, 5, 8, 5, NULL, NULL, NULL, NULL, N'Active', 0, 0, 0, 0, 5, N'1016-19-1', 3, NULL, 1, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded], [BranchID], [CivilStatus]) VALUES (1009, N'Jerome', N'', N'Violon', N'Male', CAST(N'1996-07-10T00:00:00.000' AS DateTime), N'+639229665793', N'Talisay City', 5, 50, 8, 6, NULL, NULL, NULL, NULL, N'Active', 0, 0, 0, 0, 5, N'1016-19-1', 3, NULL, 1, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded], [BranchID], [CivilStatus]) VALUES (1010, N'Jerico', N'delpuso', N'Dela Cruz', N'Male', CAST(N'2019-10-16T11:17:18.147' AS DateTime), N'+639224099376', N'Cebu CIty', 5, 50, 8, 6, N'00-1234567-0', N'0000-0000-0000', N'00-123456789-0', N'000-000-000-000', N'Active', 1, 1, 1, 1, 5, N'1016-19-1', 3, NULL, 2, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded], [BranchID], [CivilStatus]) VALUES (1011, N'Mamerto', N'', N'Salahid', N'Male', CAST(N'2019-10-16T11:27:50.273' AS DateTime), N'+639225099376', N'Mabolo', 5, 50, 8, 5, NULL, NULL, NULL, NULL, N'Active', 0, 0, 0, 0, 5, N'1016-19-1', 3, NULL, 1, NULL)
SET IDENTITY_INSERT [dbo].[Employee] OFF
SET IDENTITY_INSERT [dbo].[EmployeeType] ON 

INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (4, N'Administrator')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (8, N'Commissary')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (7, N'Crew')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (5, N'Payroll Officer')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (6, N'Staff')
SET IDENTITY_INSERT [dbo].[EmployeeType] OFF
SET IDENTITY_INSERT [dbo].[Leave] ON 

INSERT [dbo].[Leave] ([LeaveID], [EmployeeID], [LeaveDate], [IsPaidLeave]) VALUES (1010, 1007, CAST(N'2019-10-17' AS Date), 1)
INSERT [dbo].[Leave] ([LeaveID], [EmployeeID], [LeaveDate], [IsPaidLeave]) VALUES (1011, 1007, CAST(N'2019-10-18' AS Date), 1)
INSERT [dbo].[Leave] ([LeaveID], [EmployeeID], [LeaveDate], [IsPaidLeave]) VALUES (1012, 1007, CAST(N'2019-10-19' AS Date), 1)
INSERT [dbo].[Leave] ([LeaveID], [EmployeeID], [LeaveDate], [IsPaidLeave]) VALUES (1013, 1007, CAST(N'2019-10-20' AS Date), 1)
INSERT [dbo].[Leave] ([LeaveID], [EmployeeID], [LeaveDate], [IsPaidLeave]) VALUES (1014, 1007, CAST(N'2019-10-21' AS Date), 1)
SET IDENTITY_INSERT [dbo].[Leave] OFF
SET IDENTITY_INSERT [dbo].[Loan] ON 

INSERT [dbo].[Loan] ([LoanID], [EmployeeID], [Amount], [LoanType], [Terms]) VALUES (1003, 1007, 8700, N'Cash Advance', 1)
SET IDENTITY_INSERT [dbo].[Loan] OFF
SET IDENTITY_INSERT [dbo].[LoanPayment] ON 

INSERT [dbo].[LoanPayment] ([LoanPaymentID], [LoanID], [PayrollDetailID]) VALUES (1003, 1003, 1014)
SET IDENTITY_INSERT [dbo].[LoanPayment] OFF
SET IDENTITY_INSERT [dbo].[Payroll] ON 

INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (1009, CAST(N'2019-10-16T10:47:48.353' AS DateTime), CAST(N'2019-11-16T10:47:48.353' AS DateTime), 1, CAST(N'2019-10-16T00:00:00.000' AS DateTime))
INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (1010, CAST(N'2019-10-16T00:00:00.000' AS DateTime), CAST(N'2019-10-23T00:00:00.000' AS DateTime), 3, CAST(N'2019-10-16T00:00:00.000' AS DateTime))
INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (1011, CAST(N'2019-10-24T00:00:00.000' AS DateTime), CAST(N'2019-10-30T00:00:00.000' AS DateTime), 3, CAST(N'2019-10-16T00:00:00.000' AS DateTime))
INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (1012, CAST(N'2019-11-17T10:47:48.353' AS DateTime), CAST(N'2019-12-17T10:47:48.353' AS DateTime), 1, CAST(N'2019-10-16T00:00:00.000' AS DateTime))
INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (1013, CAST(N'2019-10-24T00:00:00.000' AS DateTime), CAST(N'2019-10-30T00:00:00.000' AS DateTime), 3, CAST(N'2019-10-17T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Payroll] OFF
SET IDENTITY_INSERT [dbo].[PayrollDetail] ON 

INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1012, 1009, 1007)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1013, 1009, 1008)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1014, 1010, 1007)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1015, 1010, 1010)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1016, 1011, 1007)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1017, 1011, 1010)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1018, 1012, 1008)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1019, 1012, 1009)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1020, 1012, 1011)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1021, 1013, 1007)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1022, 1013, 1008)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1023, 1013, 1009)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1024, 1013, 1010)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1025, 1013, 1011)
SET IDENTITY_INSERT [dbo].[PayrollDetail] OFF
SET IDENTITY_INSERT [dbo].[PayrollGroup] ON 

INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name], [NumberOfDays]) VALUES (1, N'Monthly', 31)
INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name], [NumberOfDays]) VALUES (2, N'Semi Monthly', 15)
INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name], [NumberOfDays]) VALUES (3, N'Weekly', 7)
SET IDENTITY_INSERT [dbo].[PayrollGroup] OFF
SET IDENTITY_INSERT [dbo].[TaxRate] ON 

INSERT [dbo].[TaxRate] ([TaxRateID], [Name], [PercentRate]) VALUES (1, N'CL_0', 0)
INSERT [dbo].[TaxRate] ([TaxRateID], [Name], [PercentRate]) VALUES (2, N'CL_1', 0.2)
INSERT [dbo].[TaxRate] ([TaxRateID], [Name], [PercentRate]) VALUES (3, N'CL_2', 0.25)
INSERT [dbo].[TaxRate] ([TaxRateID], [Name], [PercentRate]) VALUES (4, N'CL_3', 0.3)
INSERT [dbo].[TaxRate] ([TaxRateID], [Name], [PercentRate]) VALUES (5, N'CL_4', 0.32)
INSERT [dbo].[TaxRate] ([TaxRateID], [Name], [PercentRate]) VALUES (6, N'CL_5', 0.35)
SET IDENTITY_INSERT [dbo].[TaxRate] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserId], [FullName], [Username], [Password], [SecretQuestion], [SecretAnswer], [UserType], [Status], [EmployeeID]) VALUES (5, N'Owner', N'admin', N'@1CJLSfoods', N'What is your mother''s maiden name?', N'123', N'Owner', N'Active', NULL)
INSERT [dbo].[Users] ([UserId], [FullName], [Username], [Password], [SecretQuestion], [SecretAnswer], [UserType], [Status], [EmployeeID]) VALUES (1009, NULL, N'neil_francis__agsoy', N'J4bon3roR3y@1', N'What is your mother''s maiden name?', N'Getutua', N'Payroll Officer', N'Active', 1007)
INSERT [dbo].[Users] ([UserId], [FullName], [Username], [Password], [SecretQuestion], [SecretAnswer], [UserType], [Status], [EmployeeID]) VALUES (1010, NULL, N'jeason__yu', N'cjlsfoods', NULL, NULL, N'Payroll Officer', N'Active', 1008)
INSERT [dbo].[Users] ([UserId], [FullName], [Username], [Password], [SecretQuestion], [SecretAnswer], [UserType], [Status], [EmployeeID]) VALUES (1011, NULL, N'jerome_bonifacio_violon', N'cjlsfoods', NULL, NULL, N'Payroll Officer', N'Active', 1009)
INSERT [dbo].[Users] ([UserId], [FullName], [Username], [Password], [SecretQuestion], [SecretAnswer], [UserType], [Status], [EmployeeID]) VALUES (1012, NULL, N'mamerto__salahid', N'cjlsfoods', NULL, NULL, N'Payroll Officer', N'Active', 1011)
SET IDENTITY_INSERT [dbo].[Users] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Branch__737584F6E9381A43]    Script Date: 17/10/2019 12:45:27 AM ******/
ALTER TABLE [dbo].[Branch] ADD  CONSTRAINT [UQ__Branch__737584F6E9381A43] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [u_empTypeName]    Script Date: 17/10/2019 12:45:27 AM ******/
ALTER TABLE [dbo].[EmployeeType] ADD  CONSTRAINT [u_empTypeName] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [u_payrollGroupName]    Script Date: 17/10/2019 12:45:27 AM ******/
ALTER TABLE [dbo].[PayrollGroup] ADD  CONSTRAINT [u_payrollGroupName] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_MiddleName]  DEFAULT ('') FOR [MiddleName]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_IsPhilhealthActive]  DEFAULT ((0)) FOR [IsPhilhealthActive]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_IsSSSActive]  DEFAULT ((0)) FOR [IsSSSActive]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_IsIncomeTaxActive]  DEFAULT ((0)) FOR [IsIncomeTaxActive]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_IsPagibigActive]  DEFAULT ((0)) FOR [IsPagibigActive]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT ('Single') FOR [CivilStatus]
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
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK__Employee__Branch__4376EBDB] FOREIGN KEY([BranchID])
REFERENCES [dbo].[Branch] ([BranchID])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK__Employee__Branch__4376EBDB]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeID])
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK__Employee__Payrol__599B3724] FOREIGN KEY([PayrollGroupID])
REFERENCES [dbo].[PayrollGroup] ([PayrollGroupID])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK__Employee__Payrol__599B3724]
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
ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
/****** Object:  StoredProcedure [dbo].[sp_addLoanPayment]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_SearchEmployee]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_updateEmployee]    Script Date: 17/10/2019 12:45:27 AM ******/
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
/****** Object:  Trigger [dbo].[applyEmployeeIDFormat]    Script Date: 17/10/2019 12:45:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger [dbo].[applyEmployeeIDFormat] on [dbo].[Employee] after insert
as
begin
declare @employeeID as int = (select employeeID from inserted)
declare @count as int = (select count(*) from Employee where DateAdded=getdate())
update Employee set Emp_ID = concat(format(getdate(),'MM'),format(getdate(),'dd'),'-',format(getdate(),'yy'),'-',@count+1) where EmployeeID=@employeeID
end
GO
ALTER TABLE [dbo].[Employee] ENABLE TRIGGER [applyEmployeeIDFormat]
GO
USE [master]
GO
ALTER DATABASE [CJLSFOODSPAYROLL] SET  READ_WRITE 
GO
