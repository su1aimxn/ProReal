const express = require('express'); 
const mongoose = require('mongoose'); 
const dotenv = require('dotenv');
const app = express();
app.use(express.json())

dotenv.config();//ต้องเรียกใช้.env

// ConnectDB
mongoose.connect(process.env.MONGO_URI, {
}).then(() => console.log('MongoDB connected'))
.catch(err => console.log(err));

const productRoutes = require("./routes/event");
app.use("/api/events", productRoutes);

const authRoutes = require ("./routes/auth");
app.use("/api/auth", authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));