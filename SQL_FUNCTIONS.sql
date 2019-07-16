create function dbo.ComputeTotalContributions(@EmployeeID int, @TotalDays int)
returns float
as
BEGIN
declare @total as float
declare @MonthlySalary as float
set @MonthlySalary = (select Employee.MonthlySalary from Employee where EmployeeID = @EmployeeID) -- getmonthlysalary
set @total += dbo.ComputePagIBIG(@MonthlySalary,@TotalDays)
END