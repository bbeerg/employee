-- โครงสร้างฐานข้อมูลระบบจัดการข้อมูลการปฏิบัติงานของพนักงาน (MySQL / MariaDB)

-- 1. ตาราง admins (ผู้ดูแลระบบ)
CREATE TABLE admins (
    admin_id VARCHAR(20) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'admin'
);

-- 2. ตาราง departments (แผนก)
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL UNIQUE
);

-- 3. ตาราง positions (ตำแหน่ง)
CREATE TABLE positions (
    position_id INT PRIMARY KEY AUTO_INCREMENT,
    position_name VARCHAR(50) NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- 4. ตาราง employees (พนักงาน)
-- is_active: 1 = ใช้งานอยู่, 0 = ถูกลบ/ลาออก (Soft Delete)
CREATE TABLE employees (
    employee_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    position_id INT NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (position_id) REFERENCES positions(position_id)
);

-- 5. ตาราง attendance_logs (การบันทึกเวลาเข้า-ออกงาน)
-- Composite Key (employee_id + work_date) = 1 แถวต่อคนต่อวัน
-- ใช้ ON DELETE RESTRICT เพื่อป้องกันประวัติหายเมื่อมีการลบพนักงานจริง (ใช้ Soft Delete แทน)
CREATE TABLE attendance_logs (
    employee_id VARCHAR(20) NOT NULL,
    work_date DATE NOT NULL,
    shift_start_time TIME DEFAULT '09:00:00',
    shift_end_time TIME DEFAULT '18:00:00',
    check_in_time DATETIME NULL,
    check_out_time DATETIME NULL,
    remark TEXT NULL,
    ot_hours DECIMAL(4,2) DEFAULT 0.00,
    total_work_hours DECIMAL(4,2) DEFAULT 0.00,
    photo_url VARCHAR(255) NULL,
    work_status VARCHAR(20) DEFAULT 'มา',
    PRIMARY KEY (employee_id, work_date),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT
);

-- 6. ตาราง holidays (วันหยุด)
-- UNIQUE ที่ holiday_date กันวันหยุดซ้ำ
CREATE TABLE holidays (
    holiday_id VARCHAR(20) PRIMARY KEY,
    holiday_name VARCHAR(100) NOT NULL,
    holiday_date DATE NOT NULL UNIQUE
);
