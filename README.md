# Little Image Printer for iOS

Little Image Printer is an app for iOS that will allow you to take photos on your iOS device, make some basic adjustments and send them to your Little Printer using BERG Cloud's Direct Print API.

This app was put together in approximately five and a half hours at the Little Printer Hack Day, hosted by BERG in London on the 2nd March 2013. Many thanks to BERG for hosting the day and providing the pizza, it was great fun. 

Given the time constraints under which it was built, it's all a bit rough and ready, so here are a few quick notes:

- Deployment target is set to iOS 6.1 right now. That's not really essential, it should (I think) be fine under 5.0, probably even 4.3.
- It's nominally a universal app, but only the iPhone UI has been built so far.
- The UI is, shall we say, 'basic'
- The 'Manage Printers' button doesn't do anything. The printer code is hardwired at the moment (edit LMNPrinterManager.m)

I do plan to do more work on this app, so consider this a starting point. I don't currently have a formal To Do list for it, but some of the things I'd quite like to do are:

- Release under an open source licence
- Finish 'Manage Printers'
- Tidy up UI
- Add iPad UI
- Add more interesting Filters (Hipstamatic/Instagram style)

The first couple of things there are pretty easy and will problem happen very soon. The rest might take a little longer. 
