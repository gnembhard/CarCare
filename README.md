# final-project-gnembhard
final-project-gnembhard created by GitHub Classroom
# CarCare+

## Table of Contents
- [Overview](#overview)
- [App Evaluation](#app-evaluation)
- [Product Spec](#product-spec)
  - [User Stories](#user-stories)
  - [Screen Archetypes](#screen-archetypes)
  - [Navigation](#navigation)
- [Wireframes](#wireframes)
- [Schema](#schema)
  - [Models](#models)
  - [Networking](#networking)

---

## Overview
**Description:**  
CarCare+ is an app designed to help users manage their car maintenance and care schedules. Users can track services, get reminders, and find tips to keep their vehicle in top condition.

---

## App Evaluation
- **Category:** Automotive / Utility  
- **Mobile:** Yes, mobile application only  
- **Story:** Helps car owners stay on top of maintenance tasks and repairs  
- **Market:** Car owners and enthusiasts  
- **Habit:** Daily or weekly check-ins depending on user preferences  
- **Scope:** Medium — focuses on maintenance tracking, reminders, and tips  

---

## Product Spec

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

## Wireframes
<img width="1920" height="1080" alt="Final Project Wireframe" src="https://github.com/user-attachments/assets/e3b3962f-cef0-42b5-9c4b-20939dd7df3e" />

---
## Progress as of Unit 8 
Gif:
![Screen+Recording+2025-11-28+at+9 52 02%E2%80%AFPM](https://github.com/user-attachments/assets/8ae32c84-7b40-4d29-94cd-3b6493b57e74)

## Progress as of Unit 9

## Schema

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

