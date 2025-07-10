const mongoose = require('mongoose');

const BookingSchema = new mongoose.Schema({
    date: {
        type: Date,
        required: true,
    },
    time_slot: {
        type: String, // e.g., "7:00 AM - 8:00 AM"
        required: true,
    },
    status: {
        type: String,
        enum: ['confirmed', 'cancelled'],
        default: 'confirmed',
    },
    user: {
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true,
    },
    futsal: {
        type: mongoose.Schema.ObjectId,
        ref: 'Futsal',
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('Booking', BookingSchema);