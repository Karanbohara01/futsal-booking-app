const User = require('../models/User');

// register
exports.register = async (req, res, next) => {
    try {
        // Get details from the request body
        const { name, email, password, role } = req.body;

        // Create user in the database
        const user = await User.create({
            name,
            email,
            password,
            role,
        });

        // 🔽 Create token
        const token = user.getSignedJwtToken();

        res.status(201).json({
            success: true,
            message: 'User registered successfully',
            token,
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            error: error.message,
        });
    }
};