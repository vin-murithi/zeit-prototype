# zeit

Zeit - productivity app

Target Audience: Anyone with a task they are struggling to concentrate on.
Purpose: A tool to help people to focus on tasks and track invested time

Features:
-The app allows you to specify what you are focusing on.
-The app uses the Pomodoro technique which requires 25 minutes of concentration and a 5 minute break.
You repeat this four times to add app to a block of 2 hours of pure concentration
-The app then logs your activities over time.
It provides a summary of your top three tasks but it also let's you select individual tasks and view how much time you have dedicated to it. Remember, numbers don't lie. Log as many hours as you can on the important stuff.

This is a test prototype to determine whether the app achieves it's purpose and whether it should be pursued further.
Feedback is the currency I appreciate the most at the moment.

Technologies
The app is made with flutter, designed with figma and implemented with your productivity in mind.


How to get the most from the app:
-Limit your focus: Just start with the goal of doing one session for one task
-Leveraging breaks: If you plan to work for long, the breaks become just as important as the work
A break allows your concetration to replenish because your brain expends energy while concetrating.
The best way to take a break is the boring way
Dont use phones or social media. Boredom means the brain is ready to concetrate on some stimuli and what better stimuli, than that thing you have to do
Breaks also enable you to rest your eyes, stretch, hydrate or do a chore in between.
-Dont worry about what you have to do, Just start and keep at it.


Things I would appreciate feedback on
1. If the App serves it's purpose [A tool to help people to focus on tasks and track invested time]
2. User interface problems [faulty buttons, obscured content, hard to read text, distracting colors]
3. Logic probelms [Not Saving sessions completed, crashing unexpectedly]
4. Possible improvements [what do you feel you need from the app that it lacks]
5. Anything to be honest.

Google feedback form: https://forms.gle/xMWS8fCXjNDHK2cU8

---

Improvements:
UI
Color theme: get 60, 30, 10 colors.
Improve fonts: session counter and countdown dial, buttons and cards
Improve cards: spacing, color, elevation [create a standard]
Improve listItems: spacing, color, elevation [create a standard]
Improve Buttons: Sizing, color, elevation [create a standard]
-Primary acttion buttons
-Primary feature buttons
Improve TabBar:)
    -Source: https://stackoverflow.com/questions/63314082/flutter-how-to-make-a-custom-tabbar

Neumorphic buttons. x

Colors:
    -white color (255,53,53,53)
    -black color (255,237,237,237)

List Items:
    -not cards:)
    -Thin bottom border:)
Tab Switcher:
    -rounded:)
    -90% of screen:)
History Summary
 - Make total tasks and hour cards larger
 -Make pie chart shorter



Featureset
Calendar
-Add past sessions to calendar:)
-Enable clicking on date to view sessions done:)
Sounds
-Add notifications for events sessions and breaks:)
Delete a task
-remove it from taskList and session map:)
-present confirmation dialog:)
-show success status notification
-refresh task List
Settings page:)
Dark mode:)
Delete all your session data
-type something before deleting
Feedback
-Add ability to add anonymous feedback & Suggestions.
Theatrics and animations.
-Once a 4/4 session finishes, the screen gets some nice animation akin to iphone's imessages
-Pulsating buttons for first time users [Task Add, Start Pomodoro]
    Source: https://youtu.be/tATcalbChr4
Timing
-Allow for other Session Break configurations
    -make them contants 25/5,  50/10, 100/20
Add Cancel button when adding tasks.
Notification
    -Notify once breaks and sessions end


Bugs
-Delete and update between taskList and task map :)
-After cancelling break, Once you start pomodoro it doesnt go to break:)
-Button container missbehaving.:)
-Make the dial radius depend on device width:)
-Make keyboard dismissible on clicking anywhere else on screen. and the task input field as well.:)
-Marked dates UI misbehaving:)
-Increase the button container size:)
-Apply Dark theme to delete alert dialogue in TaskHistory:)

**************Task Logs******************************
25-07-2022
Settings
	-dark theme
    
Settings page
 -Profile (Avatar and Name)

  General
 -Light and dark mode:)
 -Time: dropdown

  Account
 -Delete account and all data: text input
 -Logout

  Feedback
 -Report bug
 -Give Feedback

---

Documentation.
-main.dart - entry of app
-constants.dart - holds apps constants like colors
Screens folder
-home_screen.dart - holds the home screen for the app
Components Folder
-body.dart - containers the body for home_screen.dart
