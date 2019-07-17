create function dbo.ComputeTotalContributions(@EmployeeID int, @PayrollID int)
returns float
as
begin
declare @MonthlySalary as float = (select Employee.MonthlySalary from Employee where EmployeeID=@EmployeeID)
declare @TotalDays as float = (select Payroll.TotalDays from Payroll where PayrollID=@PayrollID)

declare @SSS as float = (select dbo.ComputeSSS(@MonthlySalary,@TotalDays));
declare @PAGIBIG as float = (select dbo.ComputePagIBIG(@MonthlySalary,@TotalDays));
declare @PHILHEALTH as float = (select dbo.ComputePhilHealth(@MonthlySalary,@TotalDays));
declare @DeductedMonthlySalary as float = @MonthlySalary-@SSS-@PAGIBIG-@PHILHEALTH;
declare @TAX as float = (select dbo.ComputeTax(@DeductedMonthlySalary,@TotalDays));
return @SSS+@PAGIBIG+@PHILHEALTH+@TAX
end