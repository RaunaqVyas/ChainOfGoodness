# Chain of Goodness iOS App

## Introduction

**Chain of Goodness** is an innovative iOS app developed for a Non-Profit Organization. This app leverages cutting-edge technologies like Swift, SwiftUI, Express.js/Node.js, MongoDB, and various AWS services to deliver a seamless and impactful user experiences.

Apart from its techincal details chain of goodness is an app created to further 



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

<!-- Add screenshots or gif URLs here -->
Custom opening animation
![UI Screenshot](url-to-ui-screenshot)
Swiping and sliding animation
https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/2d0d28ff-4439-4f83-902d-94496175da2d
Moving Views


### Custom complex views
Further the app leverages custom UI views that I made using UIViewRepresentable. Take the custom text editor as an example

 **Custom Text Editor**:
 
 

### Backend (Express.js/Node.js and MongoDB)
The backend architecture, built with Express.js/Node.js and MongoDB, efficiently manages user data including likes, posts, and followers. It's scalable and efficient for data storage and management.

### Storage (AWS S3)
AWS S3 is utilized for secure and scalable storage. By using S3 I no longer needed to store Images in the database directly allowing me to save space and enhance the app's performance and reliability.

<!-- Insert Data Flow Diagram URL here -->
**Data Flow Diagram:**
![Screenshot 2024-01-16 at 9 15 32 AM](https://github.com/RaunaqVyas/chain_Of_Goodness/assets/44106026/d88fb1cf-148b-4973-8b39-fd5d80007220)

**Example of image being uploaded and retrieved:**


### Server (AWS Elastic Beanstalk)
AWS Elastic Beanstalk offers on-demand server capacity, ensuring the app remains responsive, even during peak times.


## Usage
Here's how users can interact with the app:
1. **Creating posts**: [Explain how]
2. **Viewing other user Posts and communities**: [Explain how]

## Roadmap
We're constantly working to enhance the app. Some of our upcoming features include:
- **Feature 1**: [Description]
- **Feature 2**: [Description]
- **Feature 3**: [Description]

