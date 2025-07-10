const mongoose = require('mongoose');

const FutsalSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Please add a name'],
        trim: true,
    },
    address: {
        type: String,
        required: [true, 'Please add an address'],
    },
    // We will add the GeoJSON location field later for map functionality
    // location: { ... }
    price_per_hour: {
        type: Number,
        required: [true, 'Please add a price per hour'],
    },
    images: {
        type: [String],
        default: ['no-photo.jpg'],
    },
    location: {
        type: {
            type: String,
            enum: ['Point'],
        },
        coordinates: {
            type: [Number], // [longitude, latitude]
            index: '2dsphere', // Creates a geospatial index for fast queries
        },
    },
    owner: {
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('Futsal', FutsalSchema);