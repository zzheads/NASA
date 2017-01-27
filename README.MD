# NASA

<img src="/NASA/Assets.xcassets/AppIcon.appiconset/icon-180.png">

<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-orange.svg?style=flat" alt="Swift 3 compatible" /></a>
[![StackShare](https://img.shields.io/badge/tech-stack-0690fa.svg?style=flat)](https://stackshare.io/zzheads/zzheads-at-gmail-com) [![Build Status](https://travis-ci.org/Jintin/Swimat.svg?branch=master)](https://travis-ci.org/Jintin/Swimat)

NASAApp is iOS application using NASA API's'. Application have 3 main features.


## APOD
APOD is Astronomy Picture of the Day. 
On the initial screen when apps loaded you can see APOD for yesterday. You can choose any correct date using picker view on the same screen.
You can see images media and youtube videos media as well. Every APOD have own explanation, which you can see pressing button "Explanation" on the bottom toolbar.
Also you can save presented image in photo library (app will ask permissions for using photo library offcourse).

<img src="/NASA/Resources/Screenshots/ss-02.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-03.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-04.png" width= "200"> 
<img src="/NASA/Resources/Screenshots/ss-05.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-06.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-07.png" width= "200"> 
<img src="/NASA/Resources/Screenshots/ss-08.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-09.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-10.png" width= "200"> 

## Mars Rover Postcard Maker:
Using NASA Mars Imagery API you can get images asset for one of three current Mars rovers (Curiosity, Opportunity, Spirit), for selected or for all cameras, for selected Sol (Mars day).
After that you can select any presented image for adding text on it, saving in photo library or sending it by email.

<img src="/NASA/Resources/Screenshots/ss-11.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-12.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-13.png" width= "200">
<img src="/NASA/Resources/Screenshots/ss-14.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-15.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-16.png" width= "200">
<img src="/NASA/Resources/Screenshots/ss-17.png" width= "200"> 

Also you can apply one or some filters from filters-preset-buttons.

<img src="/NASA/Resources/Screenshots/ss-24.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-25.png" width= "200">

## Eye-In-the-Sky: 
Using NASA Earth Landsat8 Imagery API you can get images of choosen location. You can choose location using your current position, or by entered latitude+longitude values or by entering address or placemark of needed location. After location is chosen you see image asset for it, taken by Landsat8 (usually it take a pic of location every 16 days), so you can choose any and see it on datail view. You can save this image in photolibrary or send it by email as well.

<img src="/NASA/Resources/Screenshots/ss-18.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-19.png" width= "200"> <img src="/NASA/Resources/Screenshots/ss-20.png" width= "200">
<img src="/NASA/Resources/Screenshots/ss-21.png" width= "200">

## Space sounds: 
There is one more half-implemented feature. On the 'Sounds' screen you can enter search phrase and get a list of available space sounds in the table view.
There should be option to play these sounds, but application have to be authenticated by soundcloud.com service for that, but it does not yet. So you can not play sound right now.

<img src="/NASA/Resources/Screenshots/ss-23.png" width= "200">

### Third-party libraries used in application:
1. [Nuke](https://github.com/kean/Nuke) - A powerful image loading and caching framework which allows for hassle-free image loading in your app - often in one line of code. 
2. [Preheat](https://github.com/kean/Preheat) - Automates preheating (prefetching) of content in UITableView and UICollectionView.
Both libraries was installed manually, very detailed [installation guide](https://github.com/kean/Nuke/blob/master/Documentation/Guides/Installation%20Guide.md)
For using it in the project you just have to import needed library, like "#import Nuke".
Nuke used in project for fast loading images with double-layers cache support.
Preheat used for preheatting images when loading big array of images in collection view (in RoverPhotosCollectionViewController)

<img src="/NASA/Assets.xcassets/NASA_logo.imageset/NASA_logo.png" width="80">
This application uses [NASA API](https://api.nasa.gov/index.html)
