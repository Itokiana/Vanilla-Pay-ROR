# Implement Vanilla Pay with Ruby On Rails

It's tested with **ruby 2.7.1** and **Ruby On Rails '~> 6.0.3', '>= 6.0.3.3'**

## Requirements
- Add **gem 'httparty'** into your Gemfile
- Add **gem 'openssl'** into your Gemfile

## Steps
### Step 1
Type this command on the terminal in the root of the project to be ensure that every dependencies are installed

    bundle install

### Step 2
Create **payment_controller.rb** in the controller folder of the app and paste the script

> **NB:** You can choose another name af your controller

### Step 3
Create 3 routes in the **config/routes.rb** such as:

   
	get "/get_token_vanilla_pay", to:  "payment#get_token_vanilla_pay" # To get access-token
    post "/init_vanilla_pay", to:  "payment#init_vanilla_pay" # To init payment
    get "/vanilla_pay_notification", to:  "payment#webhook_for_vanilla_pay_notification" # To recipe vanilla pay notification

> **NB:** You choose the name of routes but the important is the routes point to the correct action of the payment controller

### Step 4
Add your **client_id** , **client_secret** , **public_key** and **private_key** in ***.env*** file or in another way.
For example in ***.env*** file:

    VANILLA_PAY_CLIENT_ID=sdqrywlkl...
    VANILLA_PAY_CLIENT_SECRET=sdqrywlkl...
    VANILLA_PAY_PUBLIC_KEY=sdqrywlkl...
    VANILLA_PAY_PRIVATE_KEY=sdqrywlkl...

> **NB:** 
> 
>  - You must use **24 bytes** for **public_key** and **private_key** for DES-3 encrypt and decrypt even if Vanilla Pay gives you more than
> 24 bytes for the two keys
>  - For more informations about **client_id** , **client_secret** , **public_key** and **private_key**, please contact Vanilla Pay directly
