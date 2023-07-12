require('dotenv').config()

const express = require('express')
const app = express()
const mongoose = require('mongoose')

mongoose.connect(process.env.DATABASE_URl,{useNewUrlparser: true})
const db =mongoose.connection
db.on('error',(error) => console.error(error))
db.once('open', () => console.log('Connected to database'))

app.use(express.json())
const usersRouter = require('./routes/users.js')
app.use('/users',usersRouter)
const threadRouter = require('./routes/threads.js'); 
app.use('/threads', threadRouter);


app.listen(3213,() => console.log("server Started"))