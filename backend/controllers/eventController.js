// controllers/eventController.js
const Event = require('../models/event');

// getEvents -- get All Events
exports.getEvents = async (req, res) => {
    try {
        const events = await Event.find();
        res.json(events);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// getEvent -- get a single event by ID
exports.getEvent = async (req, res) => {
    try {
        const event = await Event.findById(req.params.id);

        if (!event) return res.status(404).json({ message: 'Event not found' });

        res.json(event);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// createEvent -- create New Event
exports.createEvent = async (req, res) => {
    const { eventName, description, eventDate, startTime, endTime } = req.body;

    // ปรับเวลาให้เป็นเที่ยงวันเพื่อลดปัญหาการเลื่อนวัน
    const adjustedEventDate = new Date(eventDate);
    adjustedEventDate.setHours(12);

    const event = new Event({
        eventName,
        description,
        eventDate: adjustedEventDate,
        startTime,
        endTime
    });

    try {
        const newEvent = await event.save();
        res.status(201).json(newEvent);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};


// updateEvent -- update an event by ID
exports.updateEvent = async (req, res) => {
    try {
        const { eventName, description, eventDate, startTime, endTime } = req.body;

        // ปรับเวลาให้เป็นเที่ยงวันเพื่อลดปัญหาการเลื่อนวัน
        const adjustedEventDate = new Date(eventDate);
        adjustedEventDate.setHours(12);

        const updatedEvent = await Event.findByIdAndUpdate(
            req.params.id,
            { eventName, description, eventDate: adjustedEventDate, startTime, endTime },
            { new: true }
        );

        if (!updatedEvent) return res.status(404).json({ message: 'Event not found' });

        res.json(updatedEvent);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
};


// deleteEvent -- delete an event by ID
exports.deleteEvent = async (req, res) => {
    try {
        const event = await Event.findByIdAndDelete(req.params.id);

        if (!event) return res.status(404).json({ message: 'Event not found' });
        
        res.json({ message: 'Event deleted' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
