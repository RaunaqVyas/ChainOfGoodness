const mongoose = require('mongoose')

const ThreadSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  content: [{
    type: {
      type: String,
      required: true
    },
    content: {
      type: String,
      required: true
    }
  }],
  link: {
    type: String,
  },
  createdBy: {
    type:  String,
    ref: 'User',
    required: true
  },
  likes: [{
    type: String,
    ref: 'User' 
  }],
  Colour: {
    type: String,
    required: true
  },
  displayName: {
    type: String,
    required: true
  },
  image:{
    type: String,
    required: false
  }
}, {timestamps: true})

module.exports = mongoose.model('Thread', ThreadSchema)
