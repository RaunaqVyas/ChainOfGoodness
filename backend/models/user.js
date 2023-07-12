const mongoose = require('mongoose')

const UserSchema = new mongoose.Schema({
  _id: {
    type: String,
    required: true,
    alias: 'cognitoId'
  },
  username: {
    type: String,
    required: true
  },
  email: {
    type: String,
    required: true
  },
  following: [{
    type: String,
    ref: 'User'
  }]
})

module.exports = mongoose.model('User', UserSchema)
