const express = require('express');
const { createFutsal, getFutsals, getFutsal, updateFutsal, deleteFutsal, getMyFutsals, getFutsalsInRadius } = require('../controllers/futsalController');
const { protect } = require('../middleware/auth');

const router = express.Router();

// The main route in this file is relative to /api/futsal
router.route('/').post(protect, createFutsal)
    .get(getFutsals);
router.route('/myfutsals').get(protect, getMyFutsals);
router.route('/radius/:address/:distance').get(getFutsalsInRadius);


router
    .route('/:id')
    .get(getFutsal)
    .put(protect, updateFutsal)    // 👈 Add this
    .delete(protect, deleteFutsal);

module.exports = router;