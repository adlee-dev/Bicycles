# mpcs51030-2016-summer-project-viking4821
mpcs51030-2016-summer-project-viking4821 created by GitHub Classroom

# Bicycles!

Bicycles! app created by Andrew Lee (my GitHub userid at the time was viking4821)

## Acknowledgements

Image for appliction icon and splash screen obtained from http://www.publicdomainpictures.net/pictures/120000/nahled/mountain-bicycle-silhouette-1432853168GHH.jpg

Various custom icon images (blue tint) from icons8.com  
License: https://icons8.com/license/

Map feature in application based on https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/ and Locations playground from class

UIPickerView implementation based on http://codewithchris.com/uipickerview-example/

Creation of UIBarButtonItems in UINavigationBar based on http://stackoverflow.com/a/24641521/3113924

Resolved issue with incorrectly colored navigation bar using http://stackoverflow.com/questions/22413193/dark-shadow-on-navigation-bar-during-segue-transition-after-upgrading-to-xcode-5

Splash screen display logic based on http://stackoverflow.com/a/31954066/3113924 and http://stackoverflow.com/a/38327281/3113924

Resolved issue with auto-sized table cells usin http://stackoverflow.com/a/30497510/3113924

NSCoding, table view structures and other areas based on previous assignments, including FoodTracker, GitHubIssues, GoAskADuck, etc.

## Notes

In my original app proposal I indicated that the app would contain a UICollectionView function for storing photos taken by the user. I ultimately decided that this feature didn't really fit the direction of the app.

The Splash screen will appear after system dialogs (specifically the system asking about Location Services authorization) despite not being the initial event or return to the application (as initiated by the user). I'm assuming that such alerts are the system interjecting in to the application as an overlay and so my application still gets the applicationDidBecomeActive notification.

