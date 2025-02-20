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




