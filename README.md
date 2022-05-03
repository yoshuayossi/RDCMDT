# RDCMDT

Home Assignment 

This is the result of the home assignment that i have created before. I have created a Project that has 4 pages, including Login, Dashboard, Register and Make Transfer page. I created this Project following the instructions on https://github.com/RDCMDT/mdt-homework-instruction. This is the screen capture of the Project i have made.
<img width="1396" alt="Screen Shot 1" src="https://user-images.githubusercontent.com/104811042/166434910-ae325d45-45fd-4b33-8bc7-35ddff8e06eb.png">
<img width="874" alt="Screen Shot 2" src="https://user-images.githubusercontent.com/104811042/166435053-98c17521-61f2-439f-86c3-ac203a16bdc9.png">

This project comes with 2 main part : Model & ViewController. I have 2 model here : User and WebServices model. I used this file to handle all process that related to data APIs, including all HTTP Requests. Also i have 4 ViewController to handle UI & control each page that i mentioned earlier. I used 4 pods library to support this project : Alamofire, SwiftyJSON, iProgressHUD and Fontawesome.swift. 
<img width="479" alt="Screen Shot 2022-05-03 at 17 08 17" src="https://user-images.githubusercontent.com/104811042/166436502-e45ed440-4cb3-4edc-8f96-2ed055aa582c.png">
  1. Alamofire : to perform HTTPs requests
  2. SwiftyJSON : to deal with JSON data
  3. iProgressHUD : to display loading animations
  4. Fontawesome.swift : to integrate fontawesome icons to this project, so it is easy using fontawesome icons

I used file Constant.swift to set up a global variables so i can use it on every process.
<img width="620" alt="Screen Shot 2022-05-03 at 17 17 27" src="https://user-images.githubusercontent.com/104811042/166437207-c7c3a047-26bc-49b4-8544-38e7b3a76bca.png">

As i mentioned before, i used WebServices.swift to handle all the process that relate to data APIs, including login, register, getting user data, getting transactions history, getting payees and making transfer. Here is the example code. 
<img width="938" alt="Screen Shot 2022-05-03 at 17 23 48" src="https://user-images.githubusercontent.com/104811042/166437919-10d6e9c8-928b-41cb-b840-88b39301b7fd.png">
I used token that i get from login process and i put on every HTTP requests's header process (except register). 
I used 4 View Controller to deal with 4 page that i mentioned earlier: Login, Register, Dashboard and Make Transfer. I used this file to handle all logic to control the UI Flow and to communicate with WebServices model. Here is the sample usage of LoginViewController.
<img width="966" alt="Screen Shot 2022-05-03 at 17 34 37" src="https://user-images.githubusercontent.com/104811042/166439288-9a1b4f02-b348-47c1-855f-e859cc554ebb.png">
On the above code, it handle event on user click login button. Whenever user click on login button, it checked user and password textinput and call _checkLogin_ function on WebServices model to handle login process and call _/login_ API. If the return is true, this controller will redirect to Dashboard Page.
On Dashboard Page, it performs 2 async process on init : Get Data Balance and Get Transaction History. 
<img width="962" alt="Screen Shot 2022-05-03 at 17 44 40" src="https://user-images.githubusercontent.com/104811042/166440231-23ddcb14-ea09-4bb5-a31f-37767f342164.png">
I used UITableView component to handle Transaction data. It used section header to group this transaction data based on transaction's date. I used TransactionTableViewCell file to handle UI logic on table's cell. Here is the code.
<img width="892" alt="Screen Shot 2022-05-03 at 17 46 00" src="https://user-images.githubusercontent.com/104811042/166440818-3af05f50-9b89-46fe-84d7-5558332686d6.png">
If users click on Make Transfer button, they'll be redirected to Make Transfer Page. On Make Transfer Page, it performs form input that consist of 3 elements : account number, amount and description. For account number, i used pickerview component to handle the payees data. It call getPayees function on WebServices model and put on pickerview. Here is the code.
<img width="576" alt="Screen Shot 2022-05-03 at 17 56 25" src="https://user-images.githubusercontent.com/104811042/166441541-36560d49-5e40-4bde-9043-11e255b96f6c.png">
<img width="859" alt="Screen Shot 2022-05-03 at 17 56 58" src="https://user-images.githubusercontent.com/104811042/166441561-fa44362d-adba-45f0-870b-349100667b25.png">
If the user click on Transfer Now button, it will call the _doTransfer_ function on WebServices model and perform transfer process. If it return true on process, they will be redirected to Dashboard Page. Everytime Dashboard Page appears, it call initElement function and performs reload data balance dan transaction history. Here is the code.
<img width="911" alt="Screen Shot 2022-05-03 at 17 59 33" src="https://user-images.githubusercontent.com/104811042/166442170-f9cbcd38-26da-4f2c-9495-13714f91f12a.png">
<img width="582" alt="Screen Shot 2022-05-03 at 18 01 51" src="https://user-images.githubusercontent.com/104811042/166442184-75978ddc-c91e-4a34-9543-a101797c2d8f.png">
On Register Page, it consist of 3 elements : username, password and confirm password. If the user click on register button, it will call _doRegister_ and _checkLogin_ function on WebServices model. And if it return true, they will be redirected to Dashboard Page. Here is the code.
<img width="982" alt="Screen Shot 2022-05-03 at 18 04 42" src="https://user-images.githubusercontent.com/104811042/166442602-ca3ba7d7-0945-4979-a6f8-ad5ee3ff637a.png">

I also have created some unit testing on this project, including login test, get balance test, get transaction data test, make transfer test, get data payees test and register test. Here is the code.
<img width="984" alt="Screen Shot 2022-05-03 at 18 08 29" src="https://user-images.githubusercontent.com/104811042/166442890-1654a4d6-d1ed-4bd8-9368-44f2691cf8a8.png">

So, i have finished this project and i'll wait for the next stage. Thank you :)
