const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
    eventName: { type: String, required: true },
    description: { type: String, required: true },
    eventDate: { type: Date, required: true },
    startTime: { type: String, required: true },
    endTime: { type: String, required: true },
  
}, { 
    timestamps: true, 
    versionKey: false 
});

module.exports = mongoose.model('Event', eventSchema);
