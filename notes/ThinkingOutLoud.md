# Thinking Out Loud

The open-ended nature of this is fun, and also....what should I make???

## Possible Features

Based on the description of the users and a review of the information available in the data set, these seem like questions that would be interesting for users and possible to answer based on the data:

* What are all the food trucks available right now?
* What are the newest food trucks?  (Based on permit approval date, and not having previous permits)
* What food trucks are closest to my current location, or some other location that I specify?
* Where can I find a specific food item?  (Though food items is an unstructured text field that can be answered with varying degrees of specificity, and spelling, and punctuation...)
* Where should we eat today??? (Because making choices is hard, and sometimes you just need someone - or something - to decide for you)
* Where should we eat today - within a given geographic radius, and maybe also filtering on a particular food item that sounds really good?

## Dealing with Data

A UI would be a nice deliverable, but data is the foundation of the application.  I wanted to start on the data side and put a good foundation in place that would support different features served through a UI or an API.

I spent a long time weighing different options for storing the data.  These are some options I considered:

* In-memory caching using ETS (Erlang Term Storage) and the Cachex library.  Given the size of the data set, storing it in memory wouldn't consume a lot of resources.  It would be nice from a performance perspective not to make a database call if it isn't needed.  It would be easy to configure a check that would either use cached data or fetch fresh data if the cache is empty or hasn't been updated within some period of time.  Querying the cache would work great for listing all the food trucks or grabbing a random one.  But....query capabilities for searching on food items or working with location data would be more limited.

* Using Postgres and the PostGIS extension for location data.  I've worked with Postgres and feel comfortable with it.  I haven't worked with geolocation data or the PostGIS extension, but it looks cool and would be interesting to learn.  Using Postges would allow setting up indexes on multiple columns for performance, and I could maybe do something with `fooditems` to make that more searchable. But...then I need a strategy for keeping my copy of the data up to date.  It looks like the source data is refreshed weekly, but might be refreshed at other times too.  It would be easy to set up a scheduled task in the application that would fetch the current data and update the database, but I would need to use caution on two fronts.  
  * If the application is running on multiple nodes, I wouldn't want all of the nodes to run the database update task.  I remember reading an article where someone solved this in their application configuration.  I don't remember the solution, but I could probably Google it again.  Or the easier approach could be using something like a Lambda function that ran on a cron schedule and called an endpoint in the app that would kick off the refresh.  I've implemented that before, and it worked well.
  * When the data is updated - I would need to make sure the implementation didn't lock the whole table and create downtime.  If I iterate over the new data and update a row at a time, that should work out fine.

I decided to go with Postgres as a better foundation for the features I think would be most useful, but then I spent more time looking at the [API documentation](https://dev.socrata.com/foundry/data.sfgov.org/rqzj-sfat) and realized it has more query capabilities than I realized.  So...I decided to call the API directly and not store a copy of the data at all, for now.

## Domain Model

Keeping Domain Driven Design in mind, I still wanted to create a context layer that would form the "public" API within my application, and a data service that would handle calling the underlying API and translating the response into the domain model for my application.

This is the domain model I created:

FoodTruck

* id - number -  mapping to `locationid` (and hopefully unique)
* name - text -  mapping to `Applicant`
* address - text - mapping to `Address`
* menu - text - mapping to `FoodItems`
* latitude - number - mapping to `Latitude`
* longitude - number - mapping to `Longitude`
* has_prior_permit? - boolean - mapping to `PriorPermit`

Two notes related to querying:

* The `Location` field is used for mapping locations.  The value appears to be `(latitude, longitude)`
* The `PriorPermit` field is used to capture whether the applicant had a prior permit.  Based on the sample data, they appear to be using the numbers 0 and 1 as booleans.

## What I actually got done

Not a whole lot....wow, time goes fast.  

* Created the [FoodTruck](../lib/food_truck/food_truck.ex) module
* Defined the data model using a struct and typespecs
* Created a base method that calls the underlying API and fetches all trucks with permits in APPROVED status.  This filter seemed to make sense as a default since trucks that aren't approved won't be available for lunch
* Created helper methods that translated the raw data into the domain model for my application.  Some of these helper methods would make more sense as private functions, but I wanted the ability to write tests over them in isolation.  I made them public and used doctests to verify my logic.  I don't know if I would leave them in forever or take them out later on when I have more tests over the truly public methods
* Created basic tests that mock out the API call and confirm handling of 200 and 4xx responses
* Tested my function manually by running the application using IEx.  (And made lots of adjustments as I saw the real responses and caught some different anomalies that come up with the data set.)
* Pulled the Postgres config out since I didn't need it anymore
* Set the base URL for the API as a property on the environment and referred to it from there in both the source code and the test for consistency.
* Put a really basic UI screen together that would show the data.  I used LiveView and fetched the data after the Websocket connection was made to avoid fetching it twice.  Although now that I type that - maybe I should have done it the other way around.  I wanted to get something up on the screen right away without making the user wait, and I didn't want to hit the API twice on the mounted hook (before and after the websocket connection was established).  The API call is fast enough that it doesn't matter much on my machine with my current internet connection, but of course it could be a lot different for users in different situations.  In a real application, I would work with my UI/UX team to know what the user experience should be.
* I used the core components provided in the newest version of Phoenix to put the table together.  


## What I would do next with more time

* Capture the output of an API call with 2-3 records and save it to a file.  Add a test where the mock API call would return the contents of that file.  Confirm that the `list_trucks` function processed that data and returned the expected response.
* Handle API call failures in the UI and show a messages.
* Write tests for the UI.
* Add a simple form in the UI that would allow the user to start filtering/searching.
* Update the context layer to accept the form inputs from the UI and tranlate them into query parameters that the underlying API would understand.
* Wire the front end and back end together to submit the form and display the updated results.
* I could optimize the API call by adding a `$select` query parameter and only pulling back the columns that I need.
* I could add pagination to the query instead of pulling back all the results at once.  