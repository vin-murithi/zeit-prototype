# zeit

Target Audience: Anyone with a task they are struggling to concentrate on.
Purpose: A tool to help people to focus on tasks and track invested time
Features:
-The app allows you to specify what you are focusing on.
-The app uses the Pomodoro technique which requires 25 minutes of concetration and a 5 minute break.
You repeat this four times to add app to a block of 2 hours of pure concetration
-The app then logs your activities over time.
It provides a summary of your top three tasks but it also let's you select individual tasks and view how much time you have dedicated to it. Remember, numbers don't lie. Try to log as many hours as you can to the tasks important to you.
-The app only counts 25 min sessions that were completed and not canceled in between.

This is a test prototype to determine whether the app achieves it's purpose and whether it should be pursued further.
Feedback is the currency I appreciate the most at the moment.

Technologies
The app is made with flutter, designed with figma and implemented with your productivity in mind.

How to achieve purpose:
-Limit your focus: Just start with the goal of doing one session for one task
-Leveraging breaks: If you plan to work for long, the breaks become just as important as the work
A break allows your concetration to replenish because your brain expends energy while concetrating.
The best way to take a break is the boring way
Dont use phones or social media, that boredom means the brain is ready to concetrate on some stimuli and what better stimuli, than that thing you have to do
Breaks also enable you to rest your eyes, stretch, hydrate or do a chore in between.
-Dont worry about what you have to do, Just start and keep at it.

---
C:\Users\USER\.android\avd\Pixel_2_API_30.avd

Improvements:
UI
Color theme: get 60, 30, 10 colors.
Improve fonts: session counter and countdown dial, buttons and cards
Improve cards: spacing, color, elevation [create a standard]
Improve listItems: spacing, color, elevation [create a standard]
Improve Buttons: Sizing, color, elevation [create a standard]
-Primary acttion buttons
-Primary feature buttons

Featureset
Calendar
-Add past sessions to calendar:)
-Enable clicking on date to view sessions done:)
Sounds
-Add notifications for events sessions and breaks
Delete a task
-remove it from taskList and session map:)
-present confirmation dialog
-show success status notification
-refresh task List
Settings page
Dark mode
Delete all your session data
-type something before deleting
Feedback
-Add ability to add anonymous feedback & Suggestions.

Bugs
-Delete and update between taskList and task map :)
-After cancelling break, Once you start pomodoro it doesnt go to break:)
-Button container missbehaving.
-Make the dial radius depend on device width

---

Documentation.
-main.dart - entry of app
-constants.dart - holds apps constants like colors
Screens folder
-home_screen.dart - holds the home screen for the app
Components Folder
-body.dart - containers the body for home_screen.dart
