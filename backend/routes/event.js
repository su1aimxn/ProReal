const express = require('express');
const { getEvents, getEvent, createEvent, updateEvent, deleteEvent } = require('../controllers/eventController');
const authenticateToken = require("../middlewares/auth");

const router = express.Router();

// Get all events (protected route)
router.get('/', authenticateToken, getEvents);

// Get a specific event by ID (protected route)
router.get('/:id', authenticateToken, getEvent);

// Create a new event (protected route)
router.post('/', authenticateToken, createEvent);

// Update an existing event by ID (protected route)
router.put('/:id', authenticateToken, updateEvent);

// Delete an event by ID (protected route)
router.delete('/:id', authenticateToken, deleteEvent);

module.exports = router;
