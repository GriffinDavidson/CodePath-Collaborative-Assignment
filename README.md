# Social app for gym goers

## Table of Contents

1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
1. [Schema](#Schema)

## Overview

Find a fellow workout partner or coach at your gym who goes around the same time.

### Description

Fill out your preferred gym times, and locations, goals, and this will connect you with people looking for the same thing, and can also include coaches or personal trainers.

### App Evaluation

[Evaluation of your app across the following attributes]

- **Category: Social Media**
- **Mobile:**
- **Story:**
- **Market: Everyday people + fitness enthusiasts**
- **Habit:**
- **Scope:**

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- User logs in to profile
- User has a basic profile page.
- User Profile page includes photo, bio, and preferred gyms.
- List of nearby gyms sorted by selected location/nearby
- Each gym entry has name/picture/rating/hours/phone.
- Each gym has count of members on app attending gym

**Optional Nice-to-have Stories**

- Able to list member's of a selected gym.
- Social grid of nearby members of app to view profiles.
- Submit a price for a selected gym if known.
- Confim if gym or not or closed(API may pull wrong info)
- Users can upload photos on gym page.

### 2. Screen Archetypes

- Login Page or create account page
  - [list associated required story here]
  - ...
- Table view or grid of nearby gyms
  - [list associated required story here]
  - ...

### 3. Navigation

**Tab Navigation** (Tab to Screen)

- User sees the list of gyms
- User bio and profile page
- Possible social page or favorites

**Flow Navigation** (Screen to Screen)

- User logs on or creates account
  - Takes to nearby gyms page to search by location
  - ...
- Bio page of information about hte logged on user
  - Settings button on page to change user profile info
  - ...

## Wireframes

[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema

[This section will be completed in Unit 9]

---

### Models

### Users

| Property      | Type   | Description                                                      |
| ------------- | ------ | ---------------------------------------------------------------- |
| userId        | String | Unique identifier for users                                      |
| firstName     | String | user name                                                        |
| lastName      | String | user name                                                        |
| profileImage  | File   | User uploaded profile image                                      |
| userBio       | String | User entered bio                                                 |
| preferredGym  | Dict   | Selection from list of discrete values describing ideal gym type |
| favGyms       | List   | Favorited Gyms                                                   |
| recentSearces | List   | List of recent gym searches                                      |

### Gyms

| Property       | Type   | Description                                        |
| -------------- | ------ | -------------------------------------------------- |
| gymId          | String | Unique identifier for gyms                         |
| gymType        | Dict   | List of discrete values describing the type of gym |
| gymLocation    | String | lat:long                                           |
| gymDescription | String | Gym text description                               |

---

### Networking

#### Home Screen

- (Read/GET) Query all nearby gyms
- (Read/GET) Query all my friends
- [OPTIONAL: List endpoints if using existing API such as Yelp]

#### Onboarding Screen

- (Create/POST) Post user information (String, Profile Image) from form

#### Profile Screen

- (Read/GET) Query user info from database

#### Edit Profile Screen

- (Update/POST) Post updated user information

#### Search Screen

- (Read/GET) Query database for gyms

#### Search Results Screen

- (Read/GET) Display results of query

#### Map Screen

- (Read/GET) Query database for nearby gyms, given current position

---
