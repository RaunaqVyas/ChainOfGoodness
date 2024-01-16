# Chain of Goodness iOS App

## Introduction

**Chain of Goodness** is an innovative iOS app developed for a Non-Profit Organization. This app leverages cutting-edge technologies like Swift, SwiftUI, Express.js/Node.js, MongoDB, and various AWS services to deliver a seamless and impactful user experiences.

Apart from its techincal details Chain Of Goodness is an app created to further peoples interest in volunteering and International Development 



## Features Demo

### Authentication (AWS Cognito)
The app ensures secure user authentication through AWS Cognito. A custom Lambda function plays a crucial role in connecting AWS Cognito with the MongoDB database, enhancing security. Once the users use AWS cognito confrim sign up the lambda function triggers and suers are saved to the mongoDB database

**Custom Lambda Function:**
```
import axios from 'axios';

export const handler = async (event) => {
    // Extract the necessary attributes from the Cognito event
    const { sub, email } = event.request.userAttributes;
    let username = event.request.userAttributes.preferred_username || event.userName; 

    try {
        // Post the user data to custom Express server
        await axios.post('https://68e9-65-95-87-240.ngrok-free.app/users/createUser', {
            cognitoId: sub,
            username: username,
            email: email
        });

        // Log success
        console.log('User successfully created in MongoDB for user:', sub);
    } catch (error) {
        // Log error
        console.error('Error creating user in MongoDB:', error);
    }

    return event;
};

```
**Signup and sign in example:**
https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/419af8cd-eaad-4f23-a25a-26d5373ba479

**Signup and sign in views:**
The views look like this please feel free to watch the video above the see the entire thing in action

<img width="171" alt="Screenshot 2024-01-16 at 9 35 30 AM" src="https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/897a3fe0-63d3-4af9-a316-2f4c597ff834">


<img width="162" alt="Screenshot 2024-01-16 at 9 36 17 AM" src="https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/10786f66-a835-4dc8-aec2-8dd7f088b4b5">





### UI and Animation (SwiftUI 3.0)

My app showcases advanced UI components and custom animations created using SwiftUI 3.0, adhering to the MVVM design pattern. Below are some examples of my UI components and animations.

**Custom opening animation:**

![openingClosing](https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/ed015544-b1e1-4bfa-8cc0-6a25373dc41c)

_Opening and closing: Check out the custom opening and closing of views with matched geometry effect._

**Swiping and sliding animation:**

![swipingMoving](https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/3e5541bf-8992-4988-ba13-606cfef4710e)

_Sliding: See sliding of views with paralax and blur._

**Moving Views:**

![MovingBlob](https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/431b68ab-708e-4d07-86b5-efcfe34c638c)

_Blob view: Check out the moving blob._

_Credit: This animation design and UI was inspired by [Figma]([https://www.figma.com](https://www.figma.com/community/file/1010544184877672084/design-code-design-system)) ._


 **Custom Text Editor**:
 
 

### Backend (Express.js/Node.js and MongoDB)
The backend architecture, built with Express.js/Node.js and MongoDB, efficiently manages user data including likes, posts, and followers. It's scalable and efficient for data storage and management.

#### Data Flow Diagram:
The diagram below illustrates the data flow within the backend architecture:

![Data Flow Diagram](https://kroki.io/graphviz/svg/eNptUMtOwzAQvOcrVjlww6iEx6EKUqsgXgWkWFUPVQ8OXqWmwTZ2gCLEv7OJ0pBEOdm7M2PPjFS5E3YLN_ATgBN6J5WLF-k0AG0kwtpvhcU4M_vNNAhAPfOZtbAuRIZFHNIINIeEwfXeOvT-nrdos2Gv_uSJ3qIT5uJlh1rWgkejc5PMW_phTkQpMuGxJs1WnEcthSbg0QHorW-NL5XOw67N46sRVxMGy3TBaamMhhTfP9CXfhCBlEN7p6x2Brw0TuQIR6QtncJPUfTijH4aNeIUvTW6ydb7btDsGQNORfUF_7H6tZwzuHurPC1tYYQka4n50tW10-FIpAtWp8FG_YDfIz10i75kdc8ogaojoGL__gGNfrVV)

Key Components:
1. **iOS App**: Interacts with the backend using URLSession for network requests.
2. **Express.js/Node.js Backend**: Handles HTTP requests, business logic, and interacts with MongoDB.
3. **MongoDB Database**: Stores application data like users, posts, likes, and followers.
4. **AWS S3**: Manages image storage with keys stored in MongoDB.
5. **AWS Hosting**: Hosts the entire backend infrastructure, ensuring scalability and reliability.

This architecture ensures a robust and scalable solution for managing user interactions and data in the application.



### Storage (AWS S3)

AWS S3 is utilized for secure and scalable storage. By using S3, I no longer needed to store images in the database directly, allowing me to save space and enhance the app's performance and reliability.

**Data Flow Diagram:**


![Data Flow Diagram](https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/d88fb1cf-148b-4973-8b39-fd5d80007220)

**Example of image being uploaded:**

![Image Being Uploaded](https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/27677794-13e4-4187-98ff-c62b861dfe6f)

**Example of image being retrieved:**

![Image Being Retrieved](https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/286fc766-b1c6-4bf4-913d-1843fa575b0e)



## Usage
Here's how users can interact with the app:
1. **Creating posts**: Users can create posts, also known as chains, from the home page. The purpose of these chains is to spread positive messages, share opportunities related to volunteering, and much more. As long as users are continuing the chain of goodness, anything can be posted.
2. **Viewing other user Posts and communities**:Users can view and join communities that match their interests. They can also find volunteer opportunities through these chains.  


## Roadmap
I am constantly working to enhance the app. Some of the upcoming features include:
- **Feature 1**: Messaging System
- **Feature 2**: Enhanced Notification system
- **Feature 3**: Kindness Barter System 

