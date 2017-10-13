* Switch to postgres
* Make sure all indices are there
* Make sure everything is tested
* Documentation


Users

Users can participate in chats by creating Conversations with other users. They are identified by a unique ID and email. Using the API, you may change the email and password of each user.

Resource representations

Name	Type	Description
`id`	integer	User's unique ID
`email`	string	User's unique Email
`password`	string	User's password. Must match password_confirmation
`password_confirmation`	string

Actions

-All requests must be urlencoded

Action 				HTTP request 			Description
Create a User 		`POST` /users 			Creates a new user
List users 			`GET` /users 			Returns a list of users in application
Update a user 		`PUT` /users/{user_id} 	Updates the user's information
View a user 		`GET` /users/{user_id} 	Returns user's information
Delete a user 		`DELETE` /users/{user_id} 	Deletes the user


Create a user

Creates a new user in the application.

Users are identified by a unique ID and email address. 

`POST /api/v1/users`


Request body

Name, type, description

`email` 		string		User's email. Must be unique.
`password`		string



== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
