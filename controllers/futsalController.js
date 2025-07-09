const Futsal = require('../models/Futsal');
exports.createFutsal = async (req, res, next) => {
    try {
        // Add the logged-in user as the owner
        req.body.owner = req.user.id;

        // Check if the user is an owner
        if (req.user.role !== 'owner') {
            return res.status(403).json({
                success: false,
                error: 'User is not authorized to add a futsal ground'
            });
        }

        const futsal = await Futsal.create(req.body);

        res.status(201).json({
            success: true,
            data: futsal,
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            error: error.message,
        });
    }
};

exports.getFutsals = async (req, res, next) => {
    try {
        const futsals = await Futsal.find();

        res.status(200).json({
            success: true,
            count: futsals.length,
            data: futsals,
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            error: error.message,
        });
    }
};

exports.getFutsal = async (req, res, next) => {
    try {
        const futsal = await Futsal.findById(req.params.id);

        if (!futsal) {
            return res.status(404).json({
                success: false,
                error: `Futsal not found with id of ${req.params.id}`
            });
        }

        res.status(200).json({
            success: true,
            data: futsal,
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            error: error.message,
        });
    }
};