
# CarCare

## Table of Contents
- [Overview](#overview)
- [App Evaluation](#app-evaluation)
- [Product Spec](#product-spec)
  - [User Stories](#user-stories)
  - [Screen Archetypes](#screen-archetypes)
  - [Navigation](#navigation)
- [Wireframes](#wireframes)
- [Progress as of Unit 8](#progress-as-of-unit-8)
- [Progress as of Unit 9](#progress-as-of-unit-9)
- [Demo Video](#demo-video)
- [Completed User Stories](#completed-user-stories)
  - [Models](#models)
  - [Networking](#networking)
  - [Final Video](#final-video)
  - [License](#license)

---

## Overview
CarCare is an app designed to help users manage their car maintenance schedules. It integrates with the **NHTSA API** to fetch vehicle data and uses **Firebase** for authentication, data storage, and image persistence. Users can add vehicles, track service history, and receive notifications for upcoming maintenance to keep their cars in top condition.

Time spent: 8 hours
---

## App Evaluation
- **Category:** Automotive / Utility  
- **Mobile:** Yes, mobile application only  
- **Story:** Helps car owners stay on top of maintenance tasks and repairs  
- **Market:** Car owners and enthusiasts  
- **Habit:** Daily or weekly check-ins depending on user preferences  
- **Scope:** Medium — focuses on maintenance tracking, and reminders 

---

## Product Spec
**Required Functions**
- [x] Login / Signup (Firebase) 
- [x] Use of External API (NHTSA)
- [x] Backend data/image persistence (Firebase) 

**Screens / Archetypes**
- [x] Splash / Intro Screen 
- [x] Dashboard 
- [x] List View of Cars 
- [x] Car Detail View
- [x] Profile View
- [x] Edit Car
- [x] Edit Profile
- [x] Add Car


### 1. User Stories

**Required (Must-have Stories)**  
- User can register an account and log in  
- User can add their vehicle information  
- User can track maintenance history and upcoming service reminders  
- User can receive notifications for scheduled maintenance  


**Optional (Nice-to-have Stories)**  
- User can share maintenance logs with a mechanic  
- User can attach photos of car issues or parts  
- User can set custom service intervals  

---

### 2. Screen Archetypes
- **Login Screen**  
  - Required User Feature: User can log in or register  

- **Dashboard / Home Screen**  
  - Shows upcoming maintenance, alerts, and tips  

- **Vehicle Detail Screen**  
  - Displays car information and maintenance history  

- **Add Maintenance Screen**  
  - User can log a new service or maintenance task  


---

### 3. Navigation

**Tab Navigation (Tab → Screen)**  
- Home → Dashboard  
- Vehicles → Vehicle List / Details  

**Flow Navigation (Screen → Screen)**  
- Login → Dashboard  
- Vehicle List → Vehicle Detail → Add Maintenance  


---

### **Authentication**
- [x] User can create an account  
- [x] User can log in  
- [x] User can log out  
- [x] User sees an error message when login fails  
- [x] User session persists while app is open  

### **Car Management**
- [x] User can add a car  
- [x] User can view a list of cars  
- [x] User can view car details  


### **Maintenance Logs**
- [x] User can add maintenance logs for a specific car  
- [x] Maintenance logs display in real time with Firestore listener  
- [x] Each log shows type, date, mileage, and optional notes
- [x] User can delete maintance log item  

### **Profile**
- [x] User can view their profile and email  
- [x] User can access Edit Profile screen  
- [x] User can update profile picture  
- [x] User can update password  



### Models
| Property      | Type   | Description                                   |
|---------------|--------|-----------------------------------------------|
| username      | String | unique id for the user account                |
| password      | String | user's password for login authentication     |
| vehicleName   | String | name of the user's vehicle                    |
| lastService   | Date   | date of last maintenance                      |
| nextService   | Date   | date of upcoming maintenance                  |
| serviceNotes  | String | notes for maintenance or issues               |

### Networking
**Network Requests by Screen:**  
- [GET] /users - retrieve user data  
- [POST] /login - user login  
- [POST] /register - create a new account  
- [GET] /vehicles - get list of user vehicles  
- [POST] /vehicles - add new vehicle  
- [GET] /maintenance - fetch maintenance history  
- [POST] /maintenance - log a new maintenance record

## License
 Copyright 2025 Giovanni Nembhard

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

