create function dbo.ComputePagIBIG(@EmployeeID int, @TotalDays int)
returns float
as
BEGIN
declare @MonthlySalary as float
set @MonthlySalary = (select Employee.MonthlySalary from Employee where EmployeeID = @EmployeeID) -- getmonthlysalary
declare @contribution as float

set @contribution = IIF(@MonthlySalary>5000,100.0/30.0*@TotalDays,@MonthlySalary*0.02) --compute contribution
set @contribution = round(@contribution,2)
return @contribution
END