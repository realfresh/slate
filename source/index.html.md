---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

toc_footers:
  - <a href='https://www.cloudwaitress.com'>Back to home</a>
  - <a href='https://support.cloudwaitress.com'>Support documentation</a>
  - <a href='https://admin.cloudwaitress.com'>Admin dashboard</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the CloudWaitress API documentation. Contact us if you have any questions

# Authentication

> To authorize, use this code:

```shell
curl https://api.cloudwaitress.com/v1/...
  -H "Authorization: YOUR_API_KEY"
```

> Make sure to replace `YOUR_API_KEY` with your API key.

CloudWaitress uses API keys to allow access to the API. Register a new API key under your restaurant settings.

CloudWaitress expects for the API key to be included in all API requests to the server in a header that looks like the following:

# Ratelimit

There is a limit of 60 requests in a 60 second period. After 60 seconds has passed, your limit will be reset.

The following headers will be present in each response and will indicate your rate limit details

Header | Description
--------- | -----------
X-Rate-Limit-Limit | The number of API requests per 60 seconds allowed
X-Rate-Limit-Remaining | The number of API requests you have remaining for this 60 second period
X-Rate-Limit-Expiry | The unix timestamp (milliseconds) at which the current 60 second period will expire

# Response Format

> Success response, will contain additional fields relating to request

```json
{
  "outcome": 0
}
```

> Error response with message key for description

```json
{
  "outcome": 1,
  "message": "Error message"
}
```

All responses follow a standardised JSON format. The "outcome" key indicates whether the operation was a success. 

If the "outcome" is 0, the operation is successful and the response will contain additional data relating to the request.

If the "outcome" is 1, it indicates an error occurred. The "message" key will provide a description of the error.

# Order Model

## Base Object

Field | Description
--------- | -----------
_id | The unique ID of the object
created | A unix timestamp of the order creation time (milliseconds)
restaurant_id | The unique ID of the restaurant associated with the order
organisation_id | The unique ID of the organisation associated with the order
number | The order number as shown to the customer and restaurant staff
status | The status of the order, can be unconfirmed, confirmed, ready, on_route, complete
notes | Any order notes as entered by the customer
bill | See OrderBill object 
payment | See OrderPayment object 
customer | See OrderCustomer object 
promos | See OrderPromo object. Contains an array of the OrderPromo object 
dishes | See OrderDish object. Contains an array of the OrderDish object 
config | See OrderConfig object 
ready_in | See OrderReadyIn object. This field optional and may be undefined depending on the restaurants settings
delivery_in | See OrderDeliveryIn object. This field optional and may be undefined depending on the restaurants settings

## OrderBill

Represents the order totals as shown to the customer

Field | Type | Description
--------- | ----------- | -----------
currency | string | 3 letter code currency of the bill
total | number | Total order value as number
total_cents | number | Total order value in cents
cart | number | Total value of the customers cart
discount | number | Total value of any discount that has been applied
taxes | OrderTax | Contains an array of OrderTax objects
tax_in_prices | boolean | Indicates whether the prices include tax or whether tax has been added onto the cart total
fees | OrderFee | Contains an array of OrderFee objects

## OrderFee

Represents a fee that may be added to the customers cart based on certain conditions

Field | Type | Description
--------- | ----------- | -----------
_id | string | Unique ID of the fee
name | string | The display name
fixed_value | number | The fixed value of this fee
percent_value | number | The percentage value of this fee
value | number | The final value of this fee which is added to the customers cart
is_payment_fee | boolean | Indicates if this fee is due to a payment based condition
voided | boolean | Indicates whether this fee has been voided

## OrderTax

Represents the order totals as shown to the customer

Field | Type | Description
--------- | ----------- | -----------
_id | string | Unique ID of the tax 
name | string | The display name of this tax
rate | number | The % value of this tax, 10% is simply the value 10
compound | boolean | Whether this tax value should compound with order taxes
amount | number | The value of this tax in the customers bill

## OrderPayment

Represents the payment details relating to an order

Field | Type | Description
--------- | ----------- | -----------
method | string | cash, card, stripe, paypal, paygate_payweb, poli_pay, ipay88, bambora_apac
currency | string | The final payment currency, may be different if an online payment processor is used
total | number | The final payment total
total_cents | number | The final payment total in cents
status | string | success, pending, error
reference | string | The reference payment ID as returned by a payment processor
reference_status | string | The reference payment status as returned by a payment processor
error | string | The error description if an error occurred with the payment

## OrderCustomer

Represents the customer details relating to the order

Field | Type | Description
--------- | ----------- | -----------
_id | string | Unique customer ID
name | string | Name as entered by the customer
phone | string | Phone number entered by the customer
email | string | Email entered by the customer

## OrderPromos

Represents the payment details relating to the order

Field | Type | Description
--------- | ----------- | -----------
_id | string | Unique ID of this promo
name | string | Display name
code | string | The code entered by a customer to redeem this promo
fixed_discount | number | Fixed discount value of the promo
percent_discount | number | Percentage discount value of the promo
min_order | number / "" | Minimum cart order required
max_uses | number / "" | Maximum total uses allowed by this promo
auto_apply | boolean | Is this promo automatically applied if possible
once_per_customer | boolean | Indicates promo limited to one use per customer
logged_in_only | boolean | Indicates promo is only for customers who are registered
valid_times | Array<{ "start": number, "end": number }> | Array of objects containing the keys start and end. Each of this has a unix timestamp (milliseconds) indicating the valid periods of this promo
disabled | boolean | Indicates whether promo has been disabled by the restaurant

# Order API
## Get Orders

```shell
curl https://api.cloudwaitress.com/v1/orders \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: YOUR_API_KEY" \ 
  -d `
    {
      "restaurant_id": "xxxxxxx",
      "limit": 10,
      "page": 1,
      "sort": { "created": -1 },
    }
  `
```

> Returns

```json
{
  "outcome": 0,
  "count": 90,
  "items": [
    {
        "_id": "123",
        "notes": "",
        "created": 1553398645547,
        "updated": null,
        "restaurant_id": "123",
        "organisation_id": "123",
        "status": "unconfirmed",
        "number": 200,
        "bill": {
            "currency": "USD",
            "total": 10,
            "total_cents": 1000,
            "cart": 10,
            "discount": 0,
            "taxes": [
                {
                    "_id": "123",
                    "name": "GST",
                    "rate": 10,
                    "compound": false,
                    "amount": 0.91
                }
            ],
            "tax_in_prices": true,
            "fees": []
        },
        "payment": {
            "method": "cash",
            "currency": "USD",
            "total": 10,
            "total_cents": 1000,
            "status": "success",
            "reference": null,
            "reference_status": null,
            "error": null
        },
        "customer": {
            "_id": "123",
            "name": "John Doe",
            "phone": "1234 1234",
            "email": "name@example.com"
        },
        "promos": [],
        "dishes": [
          {
              "_id" : "H1x3H2LZV", 
              "type" : "standard", 
              "menu_id" : "rJMFG38ZN", 
              "category_id" : "BJb0Z3IbN", 
              "name" : "Hawaiian", 
              "display_name" : "", 
              "price" : 6, 
              "subtitle" : "", 
              "tags" : [], 
              "status" : null, 
              "ingredients" : [
                  {
                      "_id" : "rkjKBnU-N", 
                      "name" : "Tomato Base", 
                      "active" : true
                  }, 
                  {
                      "_id" : "HkOcB3U-4", 
                      "name" : "Ham", 
                      "active" : true
                  }, 
                  {
                      "_id" : "SkCqB3UZV", 
                      "name" : "Pineapple", 
                      "active" : true
                  }, 
                  {
                      "_id" : "B1FornIWN", 
                      "name" : "Cheese", 
                      "active" : true
                  }
              ], 
              "option_sets" : [
                  {
                      "_id" : "SkQoU2UbV", 
                      "name" : "Base Choice", 
                      "display_name" : "", 
                      "conditions" : {
                          "required" : true, 
                          "multi_select" : false, 
                          "quantity_select" : false, 
                          "min_options" : 1, 
                          "max_options" : "", 
                          "free_amount" : ""
                      }, 
                      "options" : [
                          {
                              "_id" : "2y53KyrXg", 
                              "name" : "Gluten Free", 
                              "price" : "4.0", 
                              "quantity" : 1
                          }
                      ]
                  }, 
                  {
                      "_id" : "rJI3G4uZV", 
                      "name" : "Extra Toppings", 
                      "display_name" : "", 
                      "conditions" : {
                          "required" : false, 
                          "multi_select" : true, 
                          "quantity_select" : false, 
                          "min_options" : 1, 
                          "max_options" : "", 
                          "free_amount" : ""
                      }, 
                      "options" : [
            
                      ]
                  }, 
                  {
                      "_id" : "-ef37By_T", 
                      "name" : "Extra Swirls / Sauces", 
                      "display_name" : "", 
                      "conditions" : {
                          "required" : false, 
                          "multi_select" : true, 
                          "quantity_select" : false, 
                          "min_options" : "", 
                          "max_options" : "", 
                          "free_amount" : ""
                      }, 
                      "options" : [
            
                      ]
                  }
              ], 
              "price_type" : "standard", 
              "choices" : [
            
              ], 
              "qty" : 1, 
              "notes" : ""
          }
        ],
        "config": {
            "service" : "pickup", 
            "due" : "later", 
            "date" : "2019-03-11", 
            "time" : "08:30", 
            "destination" : "", 
            "destination_misc" : "", 
            "lat" : 0, 
            "lng" : 0, 
            "distance" : -1, 
            "driving_time" : -1, 
            "zone" : "", 
            "table" : "", 
            "table_id" : "", 
            "table_password" : "", 
            "number_of_people" : "", 
            "confirmed" : true
        },
        "ready_in": {
           "timestamp": 1553398891787
        },
        "delivery_in": {
           "timestamp": 1553398891787
        }
    }
  ]
}
```

This endpoint retrieves all kittens.

### HTTP Request

`POST https://api.cloudwaitress.com/v1/orders`

### Request Parameters

Key | Required | Description
--------- | ------- | -----------
restaurant_id | yes | The ID of the restaurant to query orders from
limit | yes | The number of orders to include in the request. Maximum is 20
page | yes | Specifies which page of orders to retrieve. A value of 1 with the limit 10 will return the first 10 orders based on the sort value. A value of 2 will return orders 10-20.
sort | yes | Species how the orders will be sorted. The value to {"created": -1} sorts orders from new to old. A value of {"created": 1} will sort the orders from old to new.

### Response Parameters

Key | Type | Description
--------- | ----------- | -----------
count | number | The total amount of orders available to query from
items | Order[] | List of orders based on request limit, page and sort. See order model for details

