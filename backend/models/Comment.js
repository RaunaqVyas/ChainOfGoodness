const mongoose = require('mongoose')

const CommentSchema = new mongoose.Schema({
  content: {
    type: String,
    required: true
  },
  createdBy: {
    type: String,
    ref: 'User',
    required: true
  },
  thread: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Thread',
    required: true
  },
  likes: [{
    type: String,
    ref: 'User'
  }]
}, {timestamps: true})

module.exports = mongoose.model('Comment', CommentSchema)
