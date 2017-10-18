## Ralph Chat ##
Simple RESTful Chat API that allows users to have send messages to one another and outputs a log of their message. 

Every route besides UsersController#create, SessionsController#create, and SessionsController#destroy require you to have a request header with an 'Authorization' key.

I'll go over the implementation in interviews, but here is a high level of the routes:


    POST   /api/v1/sessions
Request body:

    { 'session': { 'email': {user email}, 'password': {password} } }

Returns `user` object which has an `auth_token` to be used for the request header `Authorization` key.


----------


    DELETE /api/v1/sessions/:id
`:id` is auth_token. Destroys `auth_token` and generates new one for next time.


----------


    GET    /api/v1/users

Gets list of users


----------


    POST   /api/v1/users

Create a new user. Email must be unique.

Request body:

    { 'user': { 'email': {unique_email}, 'password': {password}, 'password_confirmation': {password} } }


----------


    GET    /api/v1/conversations

Get current user's conversations


----------


    POST   /api/v1/conversations


Create a conversation with another user. If conversation exists, it returns the existing one.

Request body:

    { 'conversation': { 'user2_id': {recipient_user_id} } }

----------

    GET    /api/v1/conversations/:conversation_id/messages

Get list of messages from conversation


----------


    POST   /api/v1/conversations/:conversation_id/messages

Create new message in conversation 

Request body:

    { 'message': { 'content': {message_content} } }

