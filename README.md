# Data Transfer using WIFI Flutter Application

## Introduction

This project involves in transferring real time data such as temperature from rasperberrypi to flutter application. This application has three major features.
1. The app collects real time data and stores in a local sqlite database
2. The app allows you to download this real time data in a csv format in local stoarage
3. The app provides you with visualization of the data using line charts

## Instructions to use the project


### Rasperberry pi side

1. Download this repository on pi
2. Copy the flask_app folder to the desktop
3. Open the terminal on rasperberrypi and got the directory of flask_app folder
4. Run the following command to run the the flask server to host the api to push data.
   Note: The ExposeAPI script generates random temparature data.
   ``` source venv/bin/activate ```
   ``` python ExposeAPI.py  ```
5. The exposed server URL ``` http://x.x.x.x:5500 ``` and the local newtowrk ip address ```x.x.x.x``` of pi can be found out using ``` ifconfig ``` command
   

### Flutter App side

1. Clone this repository to you local computer folder
2. Using Android Studio import the project as a flutter application
3. Click on build option on android studio IDE and select ```Flutter -> Build APK```
4. Copy the apk file from ```build->outputs->flutter-apk->app-release.apk``` to the desired location and run the app on android device (or) Download the apk file from the repository home folder
6. Once the app is opened give the URL generated on pi side and to connect
8. Now you can visualise the real time data on home screen and visualize charts by clicking the view charts button

*** ⚠️ Note: Make sure both the pi and app are connected to the same wifi network.  ***

## Instructions to add new attributes

1. Modify the ```ExposeAPI.py```  script by adding new key-value attribute in the json structure part of the code
2. In the flutter app code three changes have to be made
   a. In file ```databasehelper.dart``` Add a new attribute to ```PiDataModel``` class methods and also add the new attribute in  create table statement in ```_createDB``` method
   b. In main.dart file add a new key-value pair in ```dataObj```  variable
   c. In ```chartspage.dart``` copy the old charts code under the given column children and Change the Y axes data accordingly

