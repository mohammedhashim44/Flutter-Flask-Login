# Flutter-Flask-Login
Flutter app integrated with Flask server with login and registration functionalities 

## DEMO

https://user-images.githubusercontent.com/40318362/135168946-4afbc4e9-3ba1-485d-a534-e8cf84df247e.mp4

![image](https://user-images.githubusercontent.com/40318362/135170054-8519b654-b9fa-4aeb-8bf1-687e6b4c330a.png)
Dashboard Screenshot

#### Resources used to build this projects and I found usefull:
- [REST Api in Flutter](https://medium.com/globant/easy-way-to-implement-rest-api-calls-in-flutter-9859d1ab5396)
- [Abstraction in Flutter](https://medium.com/flutter-community/abstraction-in-flutter-what-is-it-how-can-it-speed-up-my-development-da3c50532568)
- [Encapsulation of flutter Dio](https://developpaper.com/the-realization-of-the-second-encapsulation-of-flutter-dio/)

#### Flutter Project Have:
- Register and Login logic
- Https calls
- Bloc for design pattern and state managment
- Build runner for generating JSON classes
- Service Locator

#### Libraries used for Flutter:
- shared_preferences
- http
- get_it
- flutter_bloc
- dio
- build_runner
- json_serializable

## How to setup
### Clone the repo 

### Flask Part
- Python version used is `3.8.5`
- Go to  `flask_app` directory
- Install the required packages by running  `pip3 install -r requirements.txt`
- Open the terminal and type `python3 run.py` .The server will start and the database will be created 
- The server will run on `http://0.0.0.0:5000/`
- To access admin panel go to `http://0.0.0.0:5000/admin/`
### Flutter Part
- Open the `flutter_app` with android studio 
- Run the project, it will take some time to install the dependencies 
- When the app is ready make sure the phone and the laptop are in the same network 
- Check the IP of the laptop by using `ipconfig` for windows and `ifconfig` for Linux
- When you get the IP go to the settings in the app and change the URL as shown in the GIF above 

### That's all, the app now should work as in the GIF 

#### Note: if it didn't work, check your firewall and make sure the port is allowed to respond for external requests, to check if the connection is established, open the browser in the phone and go to `http://YOU_IP:5000/` , if it shows Hello World text, then the firewall is setup and the server is working in the network 
#### For Linux the code to allow the port is `sudo iptables -A INPUT -p tcp --dport 5000 -j ACCEPT` , where 5000 is the port number

