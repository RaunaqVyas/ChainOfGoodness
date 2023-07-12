const express = require('express')
const router = express.Router()
const Comment = require('../models/Comment')
const authMiddleware = require('../middelewares/authMiddleware');

// Create a comment
router.post('/createComment', authMiddleware, async (req, res) => {
  const comment = new Comment({
    content: req.body.content,
    createdBy: req.body.createdBy,
    thread: req.body.thread
  })

  try {
    const newComment = await comment.save()
    res.status(201).json(newComment)
  } catch (err) {
    res.status(400).json({ message: err.message })
  }
})

// ...

module.exports = router
