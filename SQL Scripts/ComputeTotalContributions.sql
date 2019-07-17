create function dbo.ComputeTotalContributions(@EmployeeID int, @PayrollDetailID int)
returns float
as
begin
declare @MonthlySalary as float = (select Employee.MonthlySalary from Employee where EmployeeID=@EmployeeID)
declare @TotalDays as float = (select PayrollDetail.TotalDays from PayrollDetail where PayrollDetailID=@PayrollDetailID)
declare @AverageMonthlyWorkingDays as float = round((select IIF(RequiredDaysAWeek=5,261,IIF(RequiredDaysAWeek=6,313,0))/12.0 from Employee),0)
declare @SSS as float = (select dbo.ComputeSSS(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays));
declare @PAGIBIG as float = (select dbo.ComputePagIBIG(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays));
declare @PHILHEALTH as float = (select dbo.ComputePhilHealth(@MonthlySalary,@AverageMonthlyWorkingDays,@TotalDays));
declare @DeductedMonthlySalary as float = @MonthlySalary-@SSS-@PAGIBIG-@PHILHEALTH;
declare @TAX as float = (select dbo.ComputeTax(@DeductedMonthlySalary,@AverageMonthlyWorkingDays,@TotalDays));
return @SSS+@PAGIBIG+@PHILHEALTH+@TAX
end
drop function ComputeTotalContributions
alter table PayrollDetail
add TotalContributions as dbo.ComputeTotalContributions(EmployeeID,PayrollDetailID)
alter table PayrollDetail
drop column TotalContributions

select * from PayrollDetail
select * from Employee

select dbo.ComputeTotalContributions(1021,106)