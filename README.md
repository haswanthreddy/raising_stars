# Assignment Brief Approach:
based on the screens provided in pdf and shark tank pitch, the organisation goal is to provide for overall growth of child, let's say for child to be part of the process he needs to purchase the plan / subscription in this case we are calling it `program`, so `admin` handles creating a program for a `user` (kid), program contains what activities at what `frequency` in a week or daily should be performed in `repetition`, the `program activities` contains that plan. user could see is details with tasks route, either daily or weekly and could filter based on day or week of the program (ex: day - 3 or week 4). User can mark an activity done which is stored in `user_activity`, for a certain day if an activity is exists in user_activity it is done.

## MODELS

### Activity
represents each activity like playing, listening to sound, mobility, has attributes like frequency and repition which are default ones if not set in `program_activity` by `admin` this is used

### Admin
admin model represents an employee, handles creating `activity` and `program` for an `user`

### Program
represents a overall plan for a certain duration for an `user` by an `admin`

### Program Activity
bridge model between `program` and `activity`, has again the attributes frequency and repetition here they could customise as needed

### User
represents end user, can see his daily tasks which are in turn `program activities` for naming convenience set as tasks, which he can mark it done

### User Activity
represents if an activity for a certain day has been done or not



## Tooling
Ruby
  - 3.4.1
    
Rails 
  - 8
    
DB
  - Sqlite
    
Authentication
-  rails authentication generators
  
Test
-  RSpec


# Setup
after cloning change to the Dir. and 
```
bundle install
```

create db
```
rails db:create
```

migrate
```
rails db:migrate
```

seed
```
rails db:seed
```

Start server
```
bin/dev
```

## screen - 1
https://www.loom.com/share/5c9a06be19a84f1996b18e1a9caf6ed4?sid=c4eb079f-81bc-45fe-8989-4afa8132cda3
- the api requries admin `authentication`
```
http://127.0.0.1:3000/api/v1/admins/programs/1/program_activities
```

sample data
```
{
    "code": 200,
    "status": "success",
    "data": [
        {
            "id": 1,
            "program_id": 1,
            "activity_id": 1,
            "frequency": "weekly",
            "repetition": 3,
            "created_at": "2025-04-24T11:25:35.651+05:30",
            "updated_at": "2025-04-24T11:25:35.651+05:30"
        },
        {
            "id": 2,
            "program_id": 1,
            "activity_id": 2,
            "frequency": "weekly",
            "repetition": 2,
            "created_at": "2025-04-24T11:25:35.651+05:30",
            "updated_at": "2025-04-24T11:25:35.651+05:30"
        },
        {
            "id": 3,
            "program_id": 1,
            "activity_id": 3,
            "frequency": "daily",
            "repetition": 1,
            "created_at": "2025-04-24T11:25:35.651+05:30",
            "updated_at": "2025-04-24T11:25:35.651+05:30"
        },
        {
            "id": 4,
            "program_id": 1,
            "activity_id": 4,
            "frequency": "daily",
            "repetition": 2,
            "created_at": "2025-04-24T11:25:35.651+05:30",
            "updated_at": "2025-04-24T11:25:35.651+05:30"
        },
        {
            "id": 5,
            "program_id": 1,
            "activity_id": 5,
            "frequency": "daily",
            "repetition": 2,
            "created_at": "2025-04-24T11:25:35.651+05:30",
            "updated_at": "2025-04-24T11:25:35.651+05:30"
        },
        {
            "id": 6,
            "program_id": 1,
            "activity_id": 6,
            "frequency": "daily",
            "repetition": 2,
            "created_at": "2025-04-24T11:25:35.651+05:30",
            "updated_at": "2025-04-24T11:25:35.651+05:30"
        },
        {
            "id": 7,
            "program_id": 1,
            "activity_id": 7,
            "frequency": "daily",
            "repetition": 10,
            "created_at": "2025-04-24T11:25:35.651+05:30",
            "updated_at": "2025-04-24T11:25:35.651+05:30"
        },
        {
            "id": 8,
            "program_id": 1,
            "activity_id": 8,
            "frequency": "weekly",
            "repetition": 1,
            "created_at": "2025-04-24T11:25:35.651+05:30",
            "updated_at": "2025-04-24T11:25:35.651+05:30"
        }
    ]
}
```

## screen - 2
https://www.loom.com/share/f945d8efdf444981803545d4f43a49d3?sid=34a48a57-e0d8-457b-9c01-fa0b3f7a123d
the api for screen one 
- requires `authentication`
```
http://127.0.0.1:3000/api/v1/users/1/tasks
```

sample data
```
{
    "code": 200,
    "status": "success",
    "message": "Daily tasks successfully fetched",
    "data": [
        {
            "id": 1,
            "name": "Stimulus Explosion",
            "repetition": 3,
            "frequency": "weekly",
            "done": false,
            "activity_id": 1
        },
        {
            "id": 3,
            "name": "Auditory Memory 2",
            "repetition": 1,
            "frequency": "daily",
            "done": false,
            "activity_id": 3
        },
        {
            "id": 4,
            "name": "Auditory Magic",
            "repetition": 2,
            "frequency": "daily",
            "done": false,
            "activity_id": 4
        },
        {
            "id": 5,
            "name": "Knowledge Boosters",
            "repetition": 2,
            "frequency": "daily",
            "done": false,
            "activity_id": 5
        },
        {
            "id": 6,
            "name": "Talk to listen",
            "repetition": 2,
            "frequency": "daily",
            "done": false,
            "activity_id": 6
        },
        {
            "id": 7,
            "name": "Energy Ball",
            "repetition": 10,
            "frequency": "daily",
            "done": false,
            "activity_id": 7
        },
        {
            "id": 8,
            "name": "Visual Solfege",
            "repetition": 1,
            "frequency": "weekly",
            "done": false,
            "activity_id": 8
        }
    ]
}
```



# API Documentation
https://documenter.getpostman.com/view/17773357/2sB2ixkZfJ

