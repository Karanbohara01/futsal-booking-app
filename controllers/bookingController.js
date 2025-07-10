const Booking = require('../models/Booking');
const Futsal = require('../models/Futsal');

exports.createBooking = async (req, res, next) => {
    try {
        const { futsalId, date, time_slot } = req.body;

        // The user's ID is available from our 'protect' middleware
        const userId = req.user.id;

        // --- Basic Validation ---
        const futsal = await Futsal.findById(futsalId);
        if (!futsal) {
            return res.status(404).json({ success: false, error: 'Futsal not found' });
        }

        // You can add more advanced logic here, like checking if the time slot
        // is already taken for that specific date. For now, we'll keep it simple.

        const booking = await Booking.create({
            futsal: futsalId,
            user: userId,
            date,
            time_slot,
        });

        res.status(201).json({
            success: true,
            data: booking,
        });
    } catch (error) {
        console.error(error);
        res.status(400).json({
            success: false,
            error: 'Could not create booking. ' + error.message,
        });
    }
};
exports.getMyBookings = async (req, res, next) => {
    try {
        const bookings = await Booking.find({ user: req.user.id }).populate('futsal', 'name address');

        res.status(200).json({
            success: true,
            count: bookings.length,
            data: bookings,
        });
    } catch (error) {
        console.error(error);
        res.status(400).json({
            success: false,
            error: 'Could not fetch bookings.',
        });
    }
};