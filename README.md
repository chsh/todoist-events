todoist-events
==============

# What is this?

In the event calendar for Todoist, this program is a filter for generating a calendar that granted an end time.

You can read it by subscribing in the Calendar application on your Mac information of events in the premium version of Todoist , but no " all day " or " start time" then you will only be able to specify , the 1st , the calendar , the latter in the case of the former it becomes the events of 1 hour if .

Using this filter , "end time" will be able to set for each event.


# And how do I use it?

In the place where you write a task , write the end time . It is may be written the start time , but it will be ignored .

Example

- Task of two hours ( 10:00 to 12:00 ) + date and time setting
- Quite a long task ( 3 days ) + date setting
- Half day task (6hours) + date and time setting

I recognize the part of the end time hyphen (- ) . In the place where the enclosed either in brackets, as in (mins) n (days | | hours)
They are recognized even if it is the unit number + time . Brackets are not only seen the beginning part , but for me it had been enclosed is easy to see kana .

# How do I set ?

Usse heroku for easy ops. :-)

## The clone the repository

Clone the repository from https://github.com/chsh/todoist-events

## Create the app to heroku

Heroku configuration shoule be done before.
Review this per https://devcenter.heroku.com/articles/creating-apps.

Change to the directory of the repository ,

`` `shell
heroku create
git push heroku master
`` `

## Set the environment variable

- Calendar URL of TODOIST_EVENTS_URL Todoist
- Token to be included in the PRIVATE_TOKEN URL

## Run (Calendar URL)

https://app-name.herokuapp.com/?key=PRIVATE_TOKEN

You can use this url for subscribing on your Calendar app.

# License

MIT

It's very appriciate for your contribution! Please send me feature request or pull request. :)


