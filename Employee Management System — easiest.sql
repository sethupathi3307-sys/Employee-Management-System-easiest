create database project;

use project;

-- 1. Create Departments Table
CREATE TABLE Departments (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name NVARCHAR(50) NOT NULL
);

-- 2. Create Employees Table
CREATE TABLE Employees (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    department_id INT,
    CONSTRAINT FK_Employees_Departments FOREIGN KEY (department_id) 
        REFERENCES Departments(department_id)
);

-- 3. Create Salaries Table
CREATE TABLE Salaries (
    salary_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT UNIQUE,
    salary_amount DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Salaries_Employees FOREIGN KEY (employee_id) 
        REFERENCES Employees(employee_id) ON DELETE CASCADE
);

-- 4. Create Attendance Table
CREATE TABLE Attendance (
    attendance_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT,
    work_date DATE NOT NULL,
    status NVARCHAR(10) CHECK (status IN ('Present', 'Absent', 'Leave')),
    CONSTRAINT FK_Attendance_Employees FOREIGN KEY (employee_id) 
        REFERENCES Employees(employee_id) ON DELETE CASCADE
);

-- Populate Sample Data
INSERT INTO Departments (department_name) VALUES 
('Engineering'), ('Human Resources'), ('Marketing'), ('Finance');

INSERT INTO Employees (first_name, last_name, email, hire_date, department_id) VALUES
('Rohan', 'Sharma', 'rohan@example.com', '2023-05-15', 1),
('Priya', 'Patel', 'priya@example.com', '2024-01-10', 2),
('Amit', 'Kumar', 'amit@example.com', '2025-03-20', 1),
('Neha', 'Singh', 'neha@example.com', '2025-07-11', 3),
('Vikram', 'Verma', 'vikram@example.com', '2022-11-01', 4);

INSERT INTO Salaries (employee_id, salary_amount) VALUES
(1, 75000.00), (2, 48000.00), (3, 90000.00), (4, 52000.00), (5, 45000.00);

INSERT INTO Attendance (employee_id, work_date, status) VALUES
(1, '2026-08-01', 'Present'),
(2, '2026-08-01', 'Present'),
(3, '2026-08-01', 'Absent');


SELECT e.employee_id, e.first_name, e.last_name, s.salary_amount
FROM Employees e
INNER JOIN Salaries s ON e.employee_id = s.employee_id
WHERE s.salary_amount > 50000;

SELECT TOP 1 e.employee_id, e.first_name, e.last_name, s.salary_amount
FROM Employees e
INNER JOIN Salaries s ON e.employee_id = s.employee_id
ORDER BY s.salary_amount DESC;


SELECT d.department_name, CAST(AVG(s.salary_amount) AS DECIMAL(10,2)) AS avg_salary
FROM Departments d
INNER JOIN Employees e ON d.department_id = e.department_id
INNER JOIN Salaries s ON e.employee_id = s.employee_id
GROUP BY d.department_name;


SELECT d.department_name, COUNT(e.employee_id) AS total_employees
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

SELECT employee_id, first_name, last_name, hire_date
FROM Employees
WHERE YEAR(hire_date) > 2024;

SELECT 
    t.name AS TableName,
    p.rows AS RecordCount
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1);

SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    tr.name AS ReferencedTable
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id;