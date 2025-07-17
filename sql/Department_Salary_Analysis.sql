-- Task: Departmental Average Salary Analysis with Threshold Comparison

-- Step 1: Create the database
CREATE DATABASE CompanyDB;

-- Step 2: Use the database
USE CompanyDB;

-- Step 3: Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    Name VARCHAR(50)
);

-- Step 4: Insert sample data into Departments
INSERT INTO Departments (DepartmentID, Name) VALUES
(1, 'Marketing'),
(2, 'Research'),
(3, 'Development');

-- Step 5: Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Step 6: Insert sample data into Employees
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'John Doe', 1, 60000.00),
(2, 'Jane Smith', 1, 70000.00),
(3, 'Alice Johnson', 1, 65000.00),
(4, 'Bob Brown', 1, 75000.00),
(5, 'Charlie Wilson', 1, 80000.00),
(6, 'Eva Lee', 2, 70000.00),
(7, 'Michael Clark', 2, 75000.00),
(8, 'Sarah Davis', 2, 80000.00),
(9, 'Ryan Harris', 2, 85000.00),
(10, 'Emily White', 2, 90000.00),
(11, 'David Martinez', 3, 95000.00),
(12, 'Jessica Taylor', 3, 100000.00),
(13, 'William Rodriguez', 3, 105000.00);

-- Step 7: Final query - Departmental Average Salary Analysis
-- Objective: Show only departments with average salary above the overall average salary	
WITH DepartmentStats AS (
    -- Calculate avg, min, max salary and number of employees per department
    SELECT 
        d.Name AS DepartmentName,
        AVG(e.Salary) AS AverageSalary,
        MIN(e.Salary) AS MinSalary,
        MAX(e.Salary) AS MaxSalary,
        COUNT(e.EmployeeID) AS NumberOfEmployees
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    GROUP BY d.Name
),
OverallAverage AS (
    -- Calculate overall average salary across all employees
    SELECT AVG(Salary) AS OverallAvgSalary FROM Employees
)

-- Final output: Only departments where average salary > overall average
SELECT 
    ds.DepartmentName,
    ds.AverageSalary,
    ds.MinSalary,
    ds.MaxSalary,
    ds.NumberOfEmployees
FROM DepartmentStats ds
JOIN OverallAverage oa
ON ds.AverageSalary > oa.OverallAvgSalary;


ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '#Krishna7';
FLUSH PRIVILEGES;
