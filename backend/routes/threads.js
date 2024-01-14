const express = require('express');
const router = express.Router();
const Thread = require('../models/Thread');
const User = require('../models/user'); 
const authMiddleware = require('../middelewares/authMiddleware');

const colorPalette = [
  "#c5aae7",
  "#7896f0",
  "#94a6f2",
  "#dc94db",
  "#a8aff0",
  "#dd9ee0",
  "#7db4f4",
  "#ccc4e9",
  "#c4a5d2",
];


// Create a thread
router.post('/createThread', authMiddleware, async (req, res) => {
  try {
    const randomColor = colorPalette[Math.floor(Math.random() * colorPalette.length)];
    const user = await User.findById(req.user.id); // Find the user by Cognito sub

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const thread = new Thread({
      title: req.body.title,
      description: req.body.description,
      content: req.body.content,
      link: req.body.link,
      createdBy: user._id, // Use the _id of the user document
      Colour: randomColor,
      displayName: user.username
    });

    const savedThread = await thread.save();
    res.status(201).json(savedThread);
  } catch (err) {
    res.status(400).json({ message: err.message });
  } 
});

// Delete a thread by ID and User ID
router.delete('/deleteThread/:id', authMiddleware, async (req, res) => {
  try {
    const thread = await Thread.findOne({ _id: req.params.id, createdBy: req.user.id });

    if (!thread) {
      return res.status(404).json({ message: "Thread not found or you do not have permission to delete this thread." });
    }

    await thread.remove();
    res.json({ message: 'Thread deleted successfully' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});


// Get a thread by user ID
router.get('/userThreads/:id', authMiddleware, async (req, res) => {
  try {
    const threads = await Thread.find({ createdBy: req.user.id });
    res.json(threads);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});


// Edit a thread content by ID
router.put('/editThread/:id', authMiddleware, async (req, res) => {
  try {
    let thread = await Thread.findById(req.params.id);

    if (thread.createdBy.toString() !== req.user.id) {
      return res.status(403).json({ message: "You do not have permission to edit this thread." });
    }

    // Update the thread with new data
    thread.title = req.body.title;
    thread.description = req.body.description;
    thread.content = req.body.content;
    thread.link = req.body.link;
    
    const updatedThread = await thread.save();
    res.json(updatedThread);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});


// Get all threads
router.get('/allThreads', async (req, res) => {
  try {
    const threads = await Thread.find({});
    res.json(threads);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});


//Delete all 

router.delete('/deleteAllThreads', async (req, res) => {
  try {
    await Thread.deleteMany({});
    res.status(200).json({ message: 'All threads deleted successfully.' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});


module.exports = router;