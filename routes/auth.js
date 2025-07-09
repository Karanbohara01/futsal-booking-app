const express = require('express');
const { register, login, getMe } = require('../controllers/userController');
const { protect } = require('../middleware/auth');
console.log('routes/auth.js has been loaded'); // 👈 ADD THIS LINE


const router = express.Router();

router.post('/register', register);
router.post('/login', login); // ✅ Corrected: 'protect' middleware removed
router.get('/me', protect, getMe);

module.exports = router;