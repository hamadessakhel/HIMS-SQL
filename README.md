- Hospital Information Management System (HIMS) Database

A fully normalized, relational database system designed to efficiently store, manage, and retrieve hospital-related data[cite: 1]. This project was developed as the final submission for the **Database Systems** course at **Riphah International University**.

The HIMS database addresses the inefficiencies of manual record-keeping by eliminating data redundancy and ensuring consistency through a structured Oracle SQL architecture.

-  Key Features
* **Comprehensive Patient Management:** Register patients and maintain comprehensive appointment and billing histories.
* **Staff & Department Tracking:** Store doctor credentials, specializations, and departmental assignments.
* **Appointment Scheduling:** Book and track appointments, linking patients with specific doctors and physical rooms.
* **Automated Billing System:** Generate bills linked to appointments and track payment statuses (Paid, Pending, Partial).
* **Data Integrity & Normalization:** Fully normalized up to Third Normal Form (3NF) to eliminate transitive dependencies and repeating groups.
* **Strict Constraints:** Enforces data reliability using `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, and `DEFAULT` constraints across all tables.

-  📂 Database Schema
The database consists of 6 core tables connected via strict Entity-Relationship rules:
1. **`Department`**: Stores unique departments within the hospital.
2. **`Doctor`**: Stores doctor details; linked to `Department` (Many-to-One).
3. **`Patient`**: Stores patient demographics and contact information.
4. **`Room`**: Manages physical hospital rooms and their current availability status.
5. **`Appointment`**: The central junction linking Patients, Doctors, and Rooms.
6. **`Bill`**: Tracks financial transactions linked to specific Patients and Appointments.

-  📊 Views for Analytics
To simplify reporting, the following virtual tables (Views) are included in the SQL script:
* `vw_Patient_Appointments`: Consolidates patient, doctor, and department details for scheduled visits.
* `vw_Patient_Billing`: Aggregates total bills, amounts paid, and outstanding balances per patient.
* `vw_Doctor_Workload`: Calculates the number of Completed, Scheduled, and Cancelled appointments per doctor.
* `vw_Room_Status`: Displays real-time room occupancy and scheduled patients.

-  🚀 Tech Stack
* **Language:** Oracle SQL
* **Development Environment:** Oracle SQL Developer

-  💻 Getting Started
Follow these steps to deploy the database locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/hamadessakhel/HIMS-SQL.git
   ```
2. **Open your IDE:** Launch Oracle SQL Developer (or your preferred SQL client).
3. **Load the script:** Open the `HIMS_Oracle_SQL.sql` file.
4. **Run the script:** Execute the file (press `F5` in SQL Developer) to automatically create the tables, enforce constraints, insert sample data, and generate all views[cite: 1].
5. **Test the queries:** You can now run the advanced `JOIN`, `GROUP BY`, and Subquery statements included at the bottom of the script to test the database's reporting capabilities[cite: 1].

-  🎓 Academic Context
. **Institution:** Riphah International University
. **Program:** BS Computer Science (BSCS)
* **Author:** Hamad Khan (SAP ID: 65069)
* **Instructor:** Ihthisham Ullah
```
