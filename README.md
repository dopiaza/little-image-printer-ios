# Little Image Printer for iOS

Author: David Wilkinson
Web: http://dopiaza.org/
Twitter: @dopiaza

Copyright (c) 2013 David Wilkinson
Little Image Printer is an app for iOS that will allow you to take photos on your iOS device, make some basic adjustments and send them to your Little Printer using BERG Cloud's Direct Print API.

The original app was put together in approximately five and a half hours at the Little Printer Hack Day, hosted by BERG in London on the 2nd March 2013. Many thanks to BERG for hosting the day and providing the pizza, it was great fun. 

Little Image Printer development is ongoing - the goal here being to transform the app from a quick hack into something more generally useful.

## Building Little Image Printer

Little Image Printer now uses [GPUImage](https://github.com/BradLarson/GPUImage) to make the brightness/contrast adjustments. This is the first step towards a system that will allow us to do more complex image manipulation later. This does mean, however, that there a couple of extra steps you must now take to build Little Image Printer.

The simplest method is to set up a new workspace containing both the Little Image Printer and the GPUImage projects. All you should then need to do is to go to the Build Settings for the Little Image Printer target and ensure that the User Header Paths include the path to the correct location where you stored the GPUImage project. So, for example, if you have both the Little Image Printer and GPUImage repositories cloned alongside each other, within the same parent directory, you will need to set the User Header Search Paths to `"${PROJECT_DIR}/../GPUImage/framework/"`, and be sure to set that to `"recursive"`. Once you've done that, you should be good to go.