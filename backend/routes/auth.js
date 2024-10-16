const express = require("express");
const router = express.Router();
const authenticateToken = require("../middlewares/auth"); 
const isAdmin  = require("../middlewares/admin"); // นำเข้า isAdmin
const { register, login, refresh, getUserById, updateUser, deleteUser, getUsers,addUser, getCurrentUser } = require("../controllers/authController");

// Routes สำหรับการลงทะเบียนและเข้าสู่ระบบ
router.post("/register", register);
router.post("/login", login);
router.post("/refresh", refresh);

// Routes สำหรับผู้ใช้ที่ต้องการสิทธิ์แอดมิน
router.get('/users/:id', authenticateToken, isAdmin, getUserById);  // ตรวจสอบ token และ role ของแอดมิน
router.put('/users/:id', authenticateToken, isAdmin, updateUser);  // ตรวจสอบ token และ role ของแอดมิน
router.delete('/users/:id', authenticateToken, isAdmin, deleteUser);  // ตรวจสอบ token และ role ของแอดมิน
router.get('/users', authenticateToken, isAdmin, getUsers);  
router.post('/users/add', authenticateToken, isAdmin, addUser);  // ตรวจสอบ token และ role ของแอดมิน
// ตรวจสอบ token และ role ของแอดมิน

// Route สำหรับดึงข้อมูลผู้ใช้ปัจจุบัน
router.get('/me', authenticateToken, getCurrentUser);

module.exports = router;
