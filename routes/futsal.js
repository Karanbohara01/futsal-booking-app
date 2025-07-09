const express = require('express');
const { createFutsal, getFutsals } = require('../controllers/futsalController');
const { protect } = require('../middleware/auth');

const router = express.Router();

// The main route in this file is relative to /api/futsal
router.route('/').post(protect, createFutsal)
    .get(getFutsals);

module.exports = router;