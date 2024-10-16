const mongoose = require('mongoose');

const userschema = new mongoose.Schema(
    {
    user_name: { type: String, required: true },
    password: { type: String, required: true },
    name: { type: String, required: true },
    lname: { type: String, required: true },
    role: { type: String, required: true },
    email: { type: String, required: true }
    },
    {Timestamp : true, versionKey : false}
);
const Users = mongoose.model('Users',userschema)
module.exports = Users;
// module.exports = mongoose.model('Users', users);