USE [master]
GO
/****** Object:  Database [CJLSFOODSPAYROLL]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[computeAttendanceGrossPay]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeAttendanceOvertimePay]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeAttendanceRegularPay]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeContribution]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeGrossPay]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeNetPay]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeOverTime]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputePagIBIG]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[computePayment]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputePhilHealth]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[computeRegularPay]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeSSS]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTax]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[computeTermsRemaining]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalContributions]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalDeductions]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalOverTimeHours]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ComputeTotalRegularHours]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getFormattedEmpID]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[GetTotalDaysOf]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[Attendance]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[Branch]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[Contribution]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[ContributionType]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[Deduction]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[DeductionsTypes]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[Employee]    Script Date: 13/10/2019 1:32:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [int] IDENTITY(1000,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NOT NULL,
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
	[FullName]  AS (((([FirstName]+' ')+[middlename])+' ')+[lastname]),
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeType]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[Leave]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[Loan]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[LoanPayment]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[Payroll]    Script Date: 13/10/2019 1:32:26 AM ******/
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
/****** Object:  Table [dbo].[PayrollDetail]    Script Date: 13/10/2019 1:32:27 AM ******/
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
/****** Object:  Table [dbo].[PayrollGroup]    Script Date: 13/10/2019 1:32:27 AM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 13/10/2019 1:32:27 AM ******/
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

INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (1, CAST(N'2019-10-07T21:23:53.497' AS DateTime), 8, 0, 1, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (2, CAST(N'2019-10-08T21:23:53.497' AS DateTime), 8, 0, 1, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (3, CAST(N'2019-10-09T21:23:53.497' AS DateTime), 8, 0, 1, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (4, CAST(N'2019-10-10T21:23:53.497' AS DateTime), 8, 0, 1, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (5, CAST(N'2019-10-11T21:23:53.497' AS DateTime), 8, 0, 1, N'Regular')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (6, CAST(N'2019-10-12T21:23:53.497' AS DateTime), 0, 0, 1, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (7, CAST(N'2019-10-13T21:23:53.497' AS DateTime), 0, 0, 1, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (8, CAST(N'2019-10-14T21:23:53.497' AS DateTime), 8, 0, 1, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (9, CAST(N'2019-10-15T00:00:00.000' AS DateTime), 8, 0, 3, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (10, CAST(N'2019-10-16T00:00:00.000' AS DateTime), 8, 0, 3, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (11, CAST(N'2019-10-17T00:00:00.000' AS DateTime), 8, 0, 3, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (12, CAST(N'2019-10-18T00:00:00.000' AS DateTime), 8, 0, 3, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (13, CAST(N'2019-10-19T00:00:00.000' AS DateTime), 8, 0, 3, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (14, CAST(N'2019-10-20T00:00:00.000' AS DateTime), 8, 0, 3, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (15, CAST(N'2019-10-21T00:00:00.000' AS DateTime), 8, 0, 3, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (16, CAST(N'2019-10-22T00:00:00.000' AS DateTime), 8, 0, 3, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (17, CAST(N'2019-10-15T00:00:00.000' AS DateTime), 8, 0, 2, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (18, CAST(N'2019-10-16T00:00:00.000' AS DateTime), 8, 0, 2, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (19, CAST(N'2019-10-17T00:00:00.000' AS DateTime), 8, 0, 2, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (20, CAST(N'2019-10-18T00:00:00.000' AS DateTime), 8, 0, 2, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (21, CAST(N'2019-10-19T00:00:00.000' AS DateTime), 8, 0, 2, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (22, CAST(N'2019-10-20T00:00:00.000' AS DateTime), 8, 0, 2, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (23, CAST(N'2019-10-21T00:00:00.000' AS DateTime), 8, 0, 2, N'Normal')
INSERT [dbo].[Attendance] ([AttendanceID], [AttendanceDate], [RegularHoursWorked], [OverTimeHoursWorked], [PayrollDetailsID], [DayType]) VALUES (24, CAST(N'2019-10-22T00:00:00.000' AS DateTime), 8, 0, 2, N'Normal')
SET IDENTITY_INSERT [dbo].[Attendance] OFF
SET IDENTITY_INSERT [dbo].[Branch] ON 

INSERT [dbo].[Branch] ([BranchID], [Name], [IsActive]) VALUES (1, N'Main', 1)
INSERT [dbo].[Branch] ([BranchID], [Name], [IsActive]) VALUES (2, N'asd', 1)
INSERT [dbo].[Branch] ([BranchID], [Name], [IsActive]) VALUES (10, N'Main1', 0)
INSERT [dbo].[Branch] ([BranchID], [Name], [IsActive]) VALUES (11, N'Tabunok', 0)
SET IDENTITY_INSERT [dbo].[Branch] OFF
SET IDENTITY_INSERT [dbo].[Contribution] ON 

INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (1, 2, 1)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (2, 2, 2)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (3, 1, 3)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (4, 2, 3)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (5, 3, 3)
INSERT [dbo].[Contribution] ([ContributionLogID], [ContributionTypeID], [PayrollDetailID]) VALUES (6, 4, 3)
SET IDENTITY_INSERT [dbo].[Contribution] OFF
SET IDENTITY_INSERT [dbo].[ContributionType] ON 

INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (1, N'PhilHealth', 0.0275)
INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (2, N'SSS', 0.04)
INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (3, N'Pagibig', 0.02)
INSERT [dbo].[ContributionType] ([ContributionTypeID], [Name], [PercentageRate]) VALUES (4, N'Tax', 0)
SET IDENTITY_INSERT [dbo].[ContributionType] OFF
SET IDENTITY_INSERT [dbo].[DeductionsTypes] ON 

INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (1, N'Sales Short', N'DED_SALE_SHORT')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (2, N'Inventory', N'DED_INVENTORY')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (3, N'Excess Meal', N'DED_EXCSS_MEAL')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (4, N'Incomplete Uniform', N'DED_INC_UNIFROM')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (6, N'Late', N'DED_LATE')
INSERT [dbo].[DeductionsTypes] ([DeductionTypeID], [Name], [DeductionReferenceId]) VALUES (10, N'Other', N'DED_OTHER')
SET IDENTITY_INSERT [dbo].[DeductionsTypes] OFF
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded], [BranchID]) VALUES (1, N'Neil', N'qwe', N'qwe', N'Male', CAST(N'1998-04-10T00:00:00.000' AS DateTime), N'+639289066258', N'Looc Norte, Asturias, Cebu', 5, 50, 8, 6, N'00-1234567-0', NULL, NULL, NULL, N'Active', 0, 1, 0, 0, 4, N'1009-19-1', 7, NULL, 1)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [MiddleName], [LastName], [Gender], [DateOfBirth], [ContactNumber], [Address], [AvailableLeaves], [HourlyRate], [DailyRequiredHours], [RequiredDaysAWeek], [SSSID], [PagIbigID], [PhilhealthID], [TINID], [Status], [IsPhilhealthActive], [IsSSSActive], [IsIncomeTaxActive], [IsPagibigActive], [EmployeeTypeID], [Emp_ID], [PayrollGroupID], [DateAdded], [BranchID]) VALUES (2, N'qwe', N'qwe', N'qwe', N'Male', CAST(N'1998-10-04T00:00:00.000' AS DateTime), N'+639289066258', N'asd', 5, 50, 8, 5, N'00-1234567-0', N'0000-0000-0000', N'00-123456789-0', N'000-000-000-000', N'Active', 1, 1, 1, 1, 5, N'1009-19-2', 7, NULL, 1)
SET IDENTITY_INSERT [dbo].[Employee] OFF
SET IDENTITY_INSERT [dbo].[EmployeeType] ON 

INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (5, N'Admin')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (4, N'Cashier')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (6, N'Commissary')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (3, N'Crew')
INSERT [dbo].[EmployeeType] ([EmployeeTypeID], [Name]) VALUES (15, N'zzz')
SET IDENTITY_INSERT [dbo].[EmployeeType] OFF
SET IDENTITY_INSERT [dbo].[Leave] ON 

INSERT [dbo].[Leave] ([LeaveID], [EmployeeID], [LeaveDate], [IsPaidLeave]) VALUES (1, 1, CAST(N'2019-10-04' AS Date), 1)
SET IDENTITY_INSERT [dbo].[Leave] OFF
SET IDENTITY_INSERT [dbo].[Payroll] ON 

INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (1, CAST(N'2019-10-07T21:23:53.497' AS DateTime), CAST(N'2019-10-14T00:00:00.000' AS DateTime), 7, CAST(N'2019-10-07T00:00:00.000' AS DateTime))
INSERT [dbo].[Payroll] ([PayrollID], [StartDate], [EndDate], [PayrollGroupID], [DateCreated]) VALUES (2, CAST(N'2019-10-15T00:00:00.000' AS DateTime), CAST(N'2019-10-22T00:00:00.000' AS DateTime), 7, CAST(N'2019-10-10T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Payroll] OFF
SET IDENTITY_INSERT [dbo].[PayrollDetail] ON 

INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (1, 1, 1)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (2, 2, 1)
INSERT [dbo].[PayrollDetail] ([PayrollDetailID], [PayrollID], [EmployeeID]) VALUES (3, 2, 2)
SET IDENTITY_INSERT [dbo].[PayrollDetail] OFF
SET IDENTITY_INSERT [dbo].[PayrollGroup] ON 

INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name], [NumberOfDays]) VALUES (2, N'Yearly Group', 15)
INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name], [NumberOfDays]) VALUES (5, N'Everyone', 15)
INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name], [NumberOfDays]) VALUES (6, N'Monthly Group', 15)
INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name], [NumberOfDays]) VALUES (7, N'Weekly Group', 7)
INSERT [dbo].[PayrollGroup] ([PayrollGroupID], [Name], [NumberOfDays]) VALUES (11, N'Semi Monthly', 15)
SET IDENTITY_INSERT [dbo].[PayrollGroup] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserId], [FullName], [Username], [Password], [SecretQuestion], [SecretAnswer], [UserType], [Status], [EmployeeID]) VALUES (1, N'Neil Francis Nahid', N'admin', N'!Mrniceknight1', N'who are you?', N'1234', N'Owner', N'Active', 1)
INSERT [dbo].[Users] ([UserId], [FullName], [Username], [Password], [SecretQuestion], [SecretAnswer], [UserType], [Status], [EmployeeID]) VALUES (2, N'Neil Francis Nahid', N'admin', N'admin', N'who are you?', N'1234', N'Owner', N'Active', 2)
SET IDENTITY_INSERT [dbo].[Users] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Branch__737584F6E9381A43]    Script Date: 13/10/2019 1:32:27 AM ******/
ALTER TABLE [dbo].[Branch] ADD  CONSTRAINT [UQ__Branch__737584F6E9381A43] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [u_empTypeName]    Script Date: 13/10/2019 1:32:27 AM ******/
ALTER TABLE [dbo].[EmployeeType] ADD  CONSTRAINT [u_empTypeName] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [u_payrollGroupName]    Script Date: 13/10/2019 1:32:27 AM ******/
ALTER TABLE [dbo].[PayrollGroup] ADD  CONSTRAINT [u_payrollGroupName] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
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
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK__Employee__Branch__4376EBDB] FOREIGN KEY([BranchID])
REFERENCES [dbo].[Branch] ([BranchID])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK__Employee__Branch__4376EBDB]
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
/****** Object:  StoredProcedure [dbo].[sp_addLoanPayment]    Script Date: 13/10/2019 1:32:27 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_SearchEmployee]    Script Date: 13/10/2019 1:32:27 AM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_updateEmployee]    Script Date: 13/10/2019 1:32:27 AM ******/
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
/****** Object:  Trigger [dbo].[applyEmployeeIDFormat]    Script Date: 13/10/2019 1:32:27 AM ******/
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
