const express = require('express')
const router = express.Router()
const User = require('../models/user')


// Create a user
router.post('/createUser', async (req, res) => {
    const user = new User({
      _id: req.body.cognitoId,
      username: req.body.username,
      email: req.body.email,
    })
  
    try {
      const newUser = await user.save()
      res.status(201).json(newUser)
    } catch (err) {
      res.status(400).json({ message: err.message })
    }
  })

//Delete

router.delete('/deleteAll', async (req, res) => {
    try {
        await User.deleteMany({ cognitoId: null });
        res.status(200).json({ message: "All users have been deleted." });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

  
// Follow a user
router.put('/follow/:id', async (req, res) => {
    const { currentUser } = req.body;
    const toFollowUserCognitoId = req.params.id;
    console.log(`CurrentUser: ${currentUser}`);
    console.log(`ToFollowUser: ${toFollowUserCognitoId}`);

    const currentUserObj = await User.findOne({ _id: currentUser });
    const toFollowUserObj = await User.findOne({ _id: toFollowUserCognitoId });
    
    console.log(`currentUserObj: ${JSON.stringify(currentUserObj)}`);
    console.log(`toFollowUserObj: ${JSON.stringify(toFollowUserObj)}`);

    if(!currentUserObj || !toFollowUserObj) {
        return res.status(404).json({ message: "User not found" });
    }

    if(!currentUserObj.following.includes(toFollowUserCognitoId)) {
        currentUserObj.following.push(toFollowUserCognitoId);
        await currentUserObj.save();
        res.status(200).json({ message: "User followed" });
    } else {
        res.status(400).json({ message: "Already following" });
    }
});



// Unfollow a user
router.put('/unfollow/:id', async (req, res) => {
  try {
    const userToUnfollow = await User.findById(req.params.id)

    if (!userToUnfollow) {
      return res.status(404).json({message: "User not found"})
    }

    const currentUser = await User.findById(req.body.userId)

    if (currentUser.following.includes(req.params.id)) {
      currentUser.following = currentUser.following.filter(id => id.toString() !== req.params.id)
      await currentUser.save()
      res.json(currentUser)
    } else {
      res.status(400).json({message: "You are not following this user"})
    }
  } catch(err) {
    res.status(500).json({message: err.message})
  }
})

module.exports = router
