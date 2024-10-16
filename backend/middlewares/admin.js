// middlewares/adminMiddleware.js

const jwt = require('jsonwebtoken');

// Middleware สำหรับตรวจสอบว่าเป็นแอดมินหรือไม่
const isAdmin = (req, res, next) => {
    if (!req.user || req.user.role !== 'admin') { // ตรวจสอบ role ของผู้ใช้ใน token
        return res.status(403).json({ message: "Access denied. Admins only." });
    }
    next(); // ดำเนินการต่อถ้าเป็นแอดมิน
};


module.exports = isAdmin;