const express = require('express');
const { createBooking, getMyBookings } = require('../controllers/bookingController');
const { protect } = require('../middleware/auth');

const router = express.Router();
router.use(protect);

router.route('/').post(createBooking);
router.route('/mybookings').get(getMyBookings);
module.exports = router;