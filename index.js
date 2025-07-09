// index.js

require('dotenv').config(); // ✅ MUST BE THE FIRST LINE
console.log('index.js has been loaded'); // 👈 ADD THIS LINE
const futsalRoutes = require('./routes/futsal'); // 👈 Add this line

const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const authRoutes = require('./routes/auth');


// Initialize the app
const app = express();

// Connect to Database
connectDB();

// Middlewares
app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/futsal', futsalRoutes);


// Basic route for testing
app.get('/', (req, res) => {
    res.send('Welcome to the Futsal Booking API!');
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});