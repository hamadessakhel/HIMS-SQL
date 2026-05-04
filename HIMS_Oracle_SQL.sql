-- ============================================================
-- Hospital Information Management System (HIMS)
-- Student: Hamad Khan | SAP ID: 65069
-- Program: BSCS | Instructor: Ihthisham Ullah
-- Riphah International University - Database Systems Project
-- Tool: Oracle SQL Developer
-- ============================================================


-- ============================================================
-- SECTION 1: DROP TABLES
-- ============================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Bill CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Appointment CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Room CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Doctor CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Department CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Patient CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL; -- Ignore errors if tables don't exist yet
END;
/


-- ============================================================
-- SECTION 2: CREATE TABLES (Normalized to 3NF)
-- ============================================================

-- 2.1 Department Table
CREATE TABLE Department (
    Department_ID   NUMBER(5)       PRIMARY KEY,
    Department_Name VARCHAR2(100)   NOT NULL UNIQUE
);

-- 2.2 Patient Table
CREATE TABLE Patient (
    Patient_ID      NUMBER(6)       PRIMARY KEY,
    Name            VARCHAR2(100)   NOT NULL,
    Gender          VARCHAR2(10)    NOT NULL,
    Date_of_Birth   DATE            NOT NULL,
    Contact_Number  VARCHAR2(15)    NOT NULL UNIQUE,
    Address         VARCHAR2(255),
    CONSTRAINT chk_patient_gender CHECK (Gender IN ('Male', 'Female', 'Other'))
);

-- 2.3 Doctor Table
CREATE TABLE Doctor (
    Doctor_ID       NUMBER(6)       PRIMARY KEY,
    Name            VARCHAR2(100)   NOT NULL,
    Specialization  VARCHAR2(100)   NOT NULL,
    Contact_Number  VARCHAR2(15)    NOT NULL UNIQUE,
    Department_ID   NUMBER(5)       NOT NULL,
    CONSTRAINT fk_doctor_dept FOREIGN KEY (Department_ID)
        REFERENCES Department(Department_ID)
);

-- 2.4 Room Table (Optional as per proposal)
CREATE TABLE Room (
    Room_ID         NUMBER(5)       PRIMARY KEY,
    Room_Number     VARCHAR2(10)    NOT NULL UNIQUE,
    Room_Type       VARCHAR2(50)    NOT NULL,
    Status          VARCHAR2(20)    DEFAULT 'Available' NOT NULL,
    CONSTRAINT chk_room_type   CHECK (Room_Type IN ('General', 'Private', 'ICU', 'Emergency')),
    CONSTRAINT chk_room_status CHECK (Status IN ('Available', 'Occupied', 'Under Maintenance'))
);

-- 2.5 Appointment Table
CREATE TABLE Appointment (
    Appointment_ID   NUMBER(7)      PRIMARY KEY,
    Patient_ID       NUMBER(6)      NOT NULL,
    Doctor_ID        NUMBER(6)      NOT NULL,
    Appointment_Date DATE           NOT NULL,
    Status           VARCHAR2(20)   DEFAULT 'Scheduled' NOT NULL,
    Room_ID          NUMBER(5),
    CONSTRAINT fk_appt_patient FOREIGN KEY (Patient_ID)
        REFERENCES Patient(Patient_ID),
    CONSTRAINT fk_appt_doctor  FOREIGN KEY (Doctor_ID)
        REFERENCES Doctor(Doctor_ID),
    CONSTRAINT fk_appt_room    FOREIGN KEY (Room_ID)
        REFERENCES Room(Room_ID),
    CONSTRAINT chk_appt_status CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled'))
);

-- 2.6 Bill Table
CREATE TABLE Bill (
    Bill_ID         NUMBER(7)       PRIMARY KEY,
    Patient_ID      NUMBER(6)       NOT NULL,
    Appointment_ID  NUMBER(7),
    Total_Amount    NUMBER(10, 2)   NOT NULL,
    Bill_Date       DATE            DEFAULT SYSDATE NOT NULL,
    Payment_Status  VARCHAR2(20)    DEFAULT 'Pending' NOT NULL,
    CONSTRAINT fk_bill_patient      FOREIGN KEY (Patient_ID)
        REFERENCES Patient(Patient_ID),
    CONSTRAINT fk_bill_appointment  FOREIGN KEY (Appointment_ID)
        REFERENCES Appointment(Appointment_ID),
    CONSTRAINT chk_bill_amount  CHECK (Total_Amount > 0),
    CONSTRAINT chk_payment_stat CHECK (Payment_Status IN ('Pending', 'Paid', 'Partial'))
);


-- ============================================================
-- SECTION 3: INSERT SAMPLE DATA
-- ============================================================

-- 3.1 Departments
INSERT INTO Department VALUES (1, 'Cardiology');
INSERT INTO Department VALUES (2, 'Neurology');
INSERT INTO Department VALUES (3, 'Orthopedics');
INSERT INTO Department VALUES (4, 'Pediatrics');
INSERT INTO Department VALUES (5, 'General Medicine');

-- 3.2 Patients
INSERT INTO Patient VALUES (101, 'Ahmed Raza',    'Male',   DATE '1990-03-15', '03001234567', 'House 5, Islamabad');
INSERT INTO Patient VALUES (102, 'Sana Malik',    'Female', DATE '1985-07-22', '03111234567', 'Street 12, Rawalpindi');
INSERT INTO Patient VALUES (103, 'Usman Ali',     'Male',   DATE '2000-11-05', '03211234567', 'Block C, Lahore');
INSERT INTO Patient VALUES (104, 'Ayesha Khan',   'Female', DATE '1995-01-30', '03311234567', 'F-10, Islamabad');
INSERT INTO Patient VALUES (105, 'Bilal Hussain', 'Male',   DATE '1978-09-18', '03411234567', 'Model Town, Lahore');

-- 3.3 Doctors
INSERT INTO Doctor VALUES (201, 'Dr. Tariq Mahmood', 'Cardiologist',    '03501234567', 1);
INSERT INTO Doctor VALUES (202, 'Dr. Nadia Iqbal',   'Neurologist',     '03601234567', 2);
INSERT INTO Doctor VALUES (203, 'Dr. Kashif Mirza',  'Orthopedic',      '03701234567', 3);
INSERT INTO Doctor VALUES (204, 'Dr. Sara Baig',     'Pediatrician',    '03801234567', 4);
INSERT INTO Doctor VALUES (205, 'Dr. Imran Shah',    'General Physician','03901234567', 5);

-- 3.4 Rooms
INSERT INTO Room VALUES (301, 'R-101', 'General',   'Available');
INSERT INTO Room VALUES (302, 'R-102', 'Private',   'Available');
INSERT INTO Room VALUES (303, 'R-201', 'ICU',       'Occupied');
INSERT INTO Room VALUES (304, 'R-202', 'Emergency', 'Available');
INSERT INTO Room VALUES (305, 'R-301', 'General',   'Under Maintenance');

-- 3.5 Appointments
INSERT INTO Appointment VALUES (401, 101, 201, DATE '2025-05-01', 'Completed', 301);
INSERT INTO Appointment VALUES (402, 102, 202, DATE '2025-05-03', 'Completed', 302);
INSERT INTO Appointment VALUES (403, 103, 203, DATE '2025-05-05', 'Scheduled', NULL);
INSERT INTO Appointment VALUES (404, 104, 204, DATE '2025-05-07', 'Scheduled', NULL);
INSERT INTO Appointment VALUES (405, 105, 205, DATE '2025-05-10', 'Cancelled', NULL);
INSERT INTO Appointment VALUES (406, 101, 202, DATE '2025-05-12', 'Scheduled', NULL);
INSERT INTO Appointment VALUES (407, 102, 201, DATE '2025-05-15', 'Scheduled', 304);

-- 3.6 Bills
INSERT INTO Bill VALUES (501, 101, 401, 5000.00,  DATE '2025-05-01', 'Paid');
INSERT INTO Bill VALUES (502, 102, 402, 7500.00,  DATE '2025-05-03', 'Paid');
INSERT INTO Bill VALUES (503, 103, 403, 3000.00,  DATE '2025-05-05', 'Pending');
INSERT INTO Bill VALUES (504, 104, 404, 4500.00,  DATE '2025-05-07', 'Partial');
INSERT INTO Bill VALUES (505, 105, NULL, 1500.00, DATE '2025-05-10', 'Pending');

COMMIT;


-- ============================================================
-- SECTION 4: UPDATE & DELETE OPERATIONS
-- ============================================================

-- Update appointment status
UPDATE Appointment
SET Status = 'Completed'
WHERE Appointment_ID = 403;

-- Update payment status
UPDATE Bill
SET Payment_Status = 'Paid'
WHERE Bill_ID = 503;

-- Update room status when patient is discharged
UPDATE Room
SET Status = 'Available'
WHERE Room_ID = 303;

-- Delete a cancelled appointment (safe delete)
DELETE FROM Bill
WHERE Appointment_ID = 405;

DELETE FROM Appointment
WHERE Appointment_ID = 405 AND Status = 'Cancelled';

COMMIT;


-- ============================================================
-- SECTION 5: SQL QUERIES
-- ============================================================

-- ── Q1: Display all patients with their assigned doctors and department ──
SELECT
    p.Patient_ID,
    p.Name            AS Patient_Name,
    p.Gender,
    d.Name            AS Doctor_Name,
    d.Specialization,
    dept.Department_Name,
    a.Appointment_Date,
    a.Status          AS Appointment_Status
FROM
    Appointment a
    INNER JOIN Patient    p    ON a.Patient_ID    = p.Patient_ID
    INNER JOIN Doctor     d    ON a.Doctor_ID     = d.Doctor_ID
    INNER JOIN Department dept ON d.Department_ID = dept.Department_ID
ORDER BY
    a.Appointment_Date;


-- ── Q2: Count total appointments per doctor ──
SELECT
    d.Doctor_ID,
    d.Name          AS Doctor_Name,
    d.Specialization,
    COUNT(a.Appointment_ID) AS Total_Appointments
FROM
    Doctor d
    LEFT JOIN Appointment a ON d.Doctor_ID = a.Doctor_ID
GROUP BY
    d.Doctor_ID, d.Name, d.Specialization
ORDER BY
    Total_Appointments DESC;


-- ── Q3: Show total billing amount per patient ──
SELECT
    p.Patient_ID,
    p.Name          AS Patient_Name,
    COUNT(b.Bill_ID)        AS Total_Bills,
    SUM(b.Total_Amount)     AS Total_Amount_Due,
    SUM(CASE WHEN b.Payment_Status = 'Paid' THEN b.Total_Amount ELSE 0 END) AS Amount_Paid,
    SUM(CASE WHEN b.Payment_Status != 'Paid' THEN b.Total_Amount ELSE 0 END) AS Amount_Pending
FROM
    Patient p
    LEFT JOIN Bill b ON p.Patient_ID = b.Patient_ID
GROUP BY
    p.Patient_ID, p.Name
ORDER BY
    Total_Amount_Due DESC;


-- ── Q4: List all scheduled appointments with room details ──
SELECT
    a.Appointment_ID,
    p.Name          AS Patient_Name,
    d.Name          AS Doctor_Name,
    a.Appointment_Date,
    r.Room_Number,
    r.Room_Type,
    r.Status        AS Room_Status
FROM
    Appointment a
    INNER JOIN Patient p ON a.Patient_ID = p.Patient_ID
    INNER JOIN Doctor  d ON a.Doctor_ID  = d.Doctor_ID
    LEFT  JOIN Room    r ON a.Room_ID    = r.Room_ID
WHERE
    a.Status = 'Scheduled'
ORDER BY
    a.Appointment_Date;


-- ── Q5: Subquery — Patients who have been billed more than the average bill ──
SELECT
    p.Patient_ID,
    p.Name      AS Patient_Name,
    b.Total_Amount,
    b.Payment_Status
FROM
    Patient p
    INNER JOIN Bill b ON p.Patient_ID = b.Patient_ID
WHERE
    b.Total_Amount > (SELECT AVG(Total_Amount) FROM Bill)
ORDER BY
    b.Total_Amount DESC;


-- ── Q6: Doctors with NO appointments (using subquery) ──
SELECT
    Doctor_ID,
    Name,
    Specialization
FROM
    Doctor
WHERE
    Doctor_ID NOT IN (
        SELECT DISTINCT Doctor_ID FROM Appointment
    );


-- ── Q7: Department-wise appointment summary ──
SELECT
    dept.Department_Name,
    COUNT(a.Appointment_ID)     AS Total_Appointments,
    COUNT(DISTINCT a.Patient_ID) AS Unique_Patients
FROM
    Department dept
    LEFT JOIN Doctor      d ON dept.Department_ID = d.Department_ID
    LEFT JOIN Appointment a ON d.Doctor_ID        = a.Doctor_ID
GROUP BY
    dept.Department_Name
ORDER BY
    Total_Appointments DESC;


-- ── Q8: Full patient profile with latest appointment and bill ──
SELECT
    p.Patient_ID,
    p.Name              AS Patient_Name,
    p.Contact_Number,
    MAX(a.Appointment_Date)  AS Last_Visit,
    SUM(b.Total_Amount)      AS Lifetime_Billing
FROM
    Patient     p
    LEFT JOIN Appointment a ON p.Patient_ID = a.Patient_ID
    LEFT JOIN Bill        b ON p.Patient_ID = b.Patient_ID
GROUP BY
    p.Patient_ID, p.Name, p.Contact_Number
ORDER BY
    Last_Visit DESC NULLS LAST;


-- ── Q9: Available rooms ──
SELECT
    Room_ID,
    Room_Number,
    Room_Type,
    Status
FROM
    Room
WHERE
    Status = 'Available'
ORDER BY
    Room_Type;


-- ── Q10: Monthly revenue report ──
SELECT
    TO_CHAR(Bill_Date, 'YYYY-MM')   AS Bill_Month,
    COUNT(Bill_ID)                  AS Total_Bills,
    SUM(Total_Amount)               AS Total_Revenue,
    SUM(CASE WHEN Payment_Status = 'Paid'    THEN Total_Amount ELSE 0 END) AS Collected,
    SUM(CASE WHEN Payment_Status != 'Paid'   THEN Total_Amount ELSE 0 END) AS Pending
FROM
    Bill
GROUP BY
    TO_CHAR(Bill_Date, 'YYYY-MM')
ORDER BY
    Bill_Month;


-- ============================================================
-- SECTION 6: VIEWS
-- ============================================================

-- View 1: Patient-Doctor appointment summary
CREATE OR REPLACE VIEW vw_Patient_Appointments AS
SELECT
    p.Patient_ID,
    p.Name              AS Patient_Name,
    p.Gender,
    p.Contact_Number,
    d.Name              AS Doctor_Name,
    d.Specialization,
    dept.Department_Name,
    a.Appointment_ID,
    a.Appointment_Date,
    a.Status            AS Appointment_Status
FROM
    Appointment   a
    INNER JOIN Patient     p    ON a.Patient_ID    = p.Patient_ID
    INNER JOIN Doctor      d    ON a.Doctor_ID     = d.Doctor_ID
    INNER JOIN Department  dept ON d.Department_ID = dept.Department_ID;

-- Usage: SELECT * FROM vw_Patient_Appointments WHERE Appointment_Status = 'Scheduled';


-- View 2: Billing summary per patient
CREATE OR REPLACE VIEW vw_Patient_Billing AS
SELECT
    p.Patient_ID,
    p.Name                          AS Patient_Name,
    p.Contact_Number,
    COUNT(b.Bill_ID)                AS Total_Bills,
    SUM(b.Total_Amount)             AS Total_Amount_Due,
    SUM(CASE WHEN b.Payment_Status = 'Paid'
             THEN b.Total_Amount ELSE 0 END) AS Amount_Paid,
    SUM(CASE WHEN b.Payment_Status != 'Paid'
             THEN b.Total_Amount ELSE 0 END) AS Amount_Pending
FROM
    Patient  p
    LEFT JOIN Bill b ON p.Patient_ID = b.Patient_ID
GROUP BY
    p.Patient_ID, p.Name, p.Contact_Number;

-- Usage: SELECT * FROM vw_Patient_Billing WHERE Amount_Pending > 0;


-- View 3: Doctor workload per department
CREATE OR REPLACE VIEW vw_Doctor_Workload AS
SELECT
    d.Doctor_ID,
    d.Name                          AS Doctor_Name,
    d.Specialization,
    dept.Department_Name,
    COUNT(a.Appointment_ID)         AS Total_Appointments,
    COUNT(CASE WHEN a.Status = 'Completed'  THEN 1 END) AS Completed,
    COUNT(CASE WHEN a.Status = 'Scheduled'  THEN 1 END) AS Scheduled,
    COUNT(CASE WHEN a.Status = 'Cancelled'  THEN 1 END) AS Cancelled
FROM
    Doctor       d
    INNER JOIN Department  dept ON d.Department_ID = dept.Department_ID
    LEFT  JOIN Appointment a   ON d.Doctor_ID      = a.Doctor_ID
GROUP BY
    d.Doctor_ID, d.Name, d.Specialization, dept.Department_Name;

-- Usage: SELECT * FROM vw_Doctor_Workload ORDER BY Total_Appointments DESC;


-- View 4: Room occupancy status
CREATE OR REPLACE VIEW vw_Room_Status AS
SELECT
    r.Room_ID,
    r.Room_Number,
    r.Room_Type,
    r.Status                        AS Room_Status,
    p.Name                          AS Current_Patient,
    a.Appointment_Date
FROM
    Room         r
    LEFT JOIN Appointment a ON r.Room_ID    = a.Room_ID
                           AND a.Status     = 'Scheduled'
    LEFT JOIN Patient     p ON a.Patient_ID = p.Patient_ID;

-- Usage: SELECT * FROM vw_Room_Status WHERE Room_Status = 'Occupied';


-- ============================================================
-- END OF SCRIPT
-- ============================================================
