const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");

// Register
exports.register = async (req, res) => {
    const { user_name, password, name, lname, role, email } = req.body;
    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = new User({ user_name, password: hashedPassword, name, lname, role, email });
        await user.save();
        res.status(201).send("User registered");
    } catch (err) {
        res.status(400).send(err.message);
    }
};

// Login
exports.login = async (req, res) => {
    const { user_name, password } = req.body;
    try {
        const user = await User.findOne({ user_name });
        if (!user) return res.status(400).send("User not found");

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(400).send("Invalid credentials");

        const accessToken = jwt.sign(
            { userId: user._id, role: user.role },  // เพิ่ม role ใน payload
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: "1h" }
        );

        const refreshToken = jwt.sign(
            { userId: user._id, role: user.role },  // เพิ่ม role ใน payload
            process.env.REFRESH_TOKEN_SECRET
        );

        res.json({ user, accessToken, refreshToken });
    } catch (err) {
        res.status(500).send(err.message);
    }
};


// Refresh
exports.refresh = async (req, res) => {
    const { token } = req.body;
    if (!token) return res.sendStatus(401);
    jwt.verify(token, process.env.REFRESH_TOKEN_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);
        const accessToken = jwt.sign(
            { userId: user.userId },
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: "15m" }
        );
        res.json({ accessToken });
    });
};

// Get All Users
exports.getUsers = async (req, res) => {
    try {
        const users = await User.find();
        res.json(users);
    } catch (err) {
        res.status(500).send(err.message);
    }
};

// Get User by ID
exports.getUserById = async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) return res.status(404).send("User not found");
        res.json(user);
    } catch (err) {
        res.status(500).send(err.message);
    }
};

exports.getCurrentUser = async (req, res) => {
    try {
      const userId = req.user.userId;
      const user = await User.findById(userId);
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }
      res.json({
        id: user.id,
        user_name: user.user_name, // Ensure consistency in field names
        name: user.name,
        lname: user.lname,
        role: user.role,
        email: user.email,
      });
    } catch (err) {
      console.error(err);
      res.status(500).json({ message: "Server error" });
    }
  };
  

// Update User
exports.updateUser = async (req, res) => {
    const { name, lname, email } = req.body;
    try {
      const user = await User.findById(req.params.id);
      if (!user) return res.status(404).send("User not found");
  
      // อัปเดตเฉพาะฟิลด์ที่ไม่ใช่ role
      if (name) user.name = name;
      if (lname) user.lname = lname;
      if (email) user.email = email;
  
      await user.save();
      res.json({ message: "User updated", user });
    } catch (err) {
      res.status(500).send(err.message);
    }
  };
  
// Delete User
exports.deleteUser = async (req, res) => {
    try {
        const user = await User.findByIdAndDelete(req.params.id);
        if (!user) return res.status(404).send("User not found");
        res.json({ message: "User deleted" });
    } catch (err) {
        res.status(500).send(err.message);
    }
};


exports.addUser = async (req, res) => {
    const { user_name, password, name, lname, role, email } = req.body;
    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = new User({ user_name, password: hashedPassword, name, lname, role, email });
        await user.save();
        res.status(201).send("Add Success");
    } catch (err) {
        res.status(400).send(err.message);
    }
};
