# Little Image Printer for iOS

Author: David Wilkinson
Web: http://dopiaza.org/
Twitter: @dopiaza

Copyright (c) 2013 David Wilkinson

## v0.2: 5th March 2013

General overhaul and tidy up of the code.

- Change copyright from Lumen Services Limited to David Wilkinson to reflect the fact that this is a personal project, not a commercial one
- Switch to DPZ class prefix
- Add printer management screens
- Update icons and images
- Use navigation controller instead of modal popups
- Enable/disable buttons as appropriate
- Tidy up directory structure

## v0.1: 4th March 2013

Initial release.

This app was put together in approximately five and a half hours at the Little Printer Hack Day, hosted by BERG in London on the 2nd March 2013. Many thanks to BERG for hosting the day and providing the pizza, it was great fun. 

Given the time constraints under which it was built, it's all a bit rough and ready, so here are a few quick notes:

- Deployment target is set to iOS 6.1 right now. That's not really essential, it should (I think) be fine under 5.0, probably even 4.3.
- It's nominally a universal app, but only the iPhone UI has been built so far.
- The UI is, shall we say, 'basic'
- The 'Manage Printers' button doesn't do anything. The printer code is hardwired at the moment (edit LMNPrinterManager.m)
