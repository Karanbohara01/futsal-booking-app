const Futsal = require('../models/Futsal');
const axios = require("axios")
exports.createFutsal = async (req, res, next) => {
    try {
        req.body.owner = req.user.id;

        if (req.user.role !== 'owner') {
            return res.status(403).json({
                success: false,
                error: 'User is not authorized to add a futsal ground'
            });
        }

        // --- Geocoding Logic with OpenCage ---
        const geocodeUrl = `${process.env.OPENCAGE_GEOCODE_URL}?key=${process.env.OPENCAGE_API_KEY}&q=${encodeURIComponent(req.body.address)}&limit=1`;

        const geoResponse = await axios.get(geocodeUrl);

        if (geoResponse.data.results.length === 0) {
            return res.status(400).json({ success: false, error: 'Could not find location for the address provided' });
        }

        const locationData = geoResponse.data.results[0].geometry;

        const location = {
            type: 'Point',
            coordinates: [locationData.lng, locationData.lat],
        };

        req.body.location = location;
        // --- End Geocoding Logic ---

        const futsal = await Futsal.create(req.body);

        res.status(201).json({
            success: true,
            data: futsal,
        });
    } catch (error) {
        console.error(error);
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

exports.updateFutsal = async (req, res, next) => {
    try {
        let futsal = await Futsal.findById(req.params.id);

        if (!futsal) {
            return res.status(404).json({ success: false, error: `Futsal not found with id of ${req.params.id}` });
        }

        // Make sure user is the futsal owner
        if (futsal.owner.toString() !== req.user.id) {
            return res.status(401).json({ success: false, error: 'User not authorized to update this futsal' });
        }

        futsal = await Futsal.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true,
        });

        res.status(200).json({ success: true, data: futsal });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};


exports.deleteFutsal = async (req, res, next) => {
    try {
        const futsal = await Futsal.findById(req.params.id);

        if (!futsal) {
            return res.status(404).json({ success: false, error: `Futsal not found with id of ${req.params.id}` });
        }

        // Make sure user is the futsal owner
        if (futsal.owner.toString() !== req.user.id) {
            return res.status(401).json({ success: false, error: 'User not authorized to delete this futsal' });
        }

        await futsal.deleteOne();

        res.status(200).json({ success: true, data: {} });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

exports.getMyFutsals = async (req, res, next) => {
    try {
        // req.user.id is available from the protect middleware
        const futsals = await Futsal.find({ owner: req.user.id });

        if (!futsals) {
            return res.status(404).json({ success: false, error: 'No futsals found for this user' });
        }

        res.status(200).json({
            success: true,
            count: futsals.length,
            data: futsals,
        });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

exports.getFutsalsInRadius = async (req, res, next) => {
    try {
        const { address, distance } = req.params;

        // Get lat/lng from geocoder
        const geocodeUrl = `${process.env.OPENCAGE_GEOCODE_URL}?key=${process.env.OPENCAGE_API_KEY}&q=${encodeURIComponent(address)}&limit=1`;
        const geoResponse = await axios.get(geocodeUrl);

        if (geoResponse.data.results.length === 0) {
            return res.status(400).json({ success: false, error: 'Could not find location for the address provided' });
        }

        const { lng, lat } = geoResponse.data.results[0].geometry;

        // Calculate radius using radians
        // Divide distance by radius of Earth (Earth Radius = 6,378 km)
        const radius = distance / 6378;

        const futsals = await Futsal.find({
            location: { $geoWithin: { $centerSphere: [[lng, lat], radius] } },
        });

        res.status(200).json({
            success: true,
            count: futsals.length,
            data: futsals,
        });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};