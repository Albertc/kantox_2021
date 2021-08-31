## Kantox technical evaluation by Albert Català<br />Implementation of a checkout system with pricing rules by product

### Test Requirements in `technical evaluation.pdf`

You are the lead programmer for a small chain of supermarkets. You are required to make a simple
cashier function that adds products to a cart and displays the total price.
You have the following test products registered:


|Product code  | Name          | Price |
|--------------|---------------|-------|
|GR1           | Green tea     |  3.11 |
|SR1           | Strawberries  |  5.00 |
|CF1           | Coffee        | 11.23 |


#### Special conditions:

- The CEO is a big fan of buy-one-get-one-free offers and of green tea. He wants us to add a
rule to do this.
- The COO, though, likes low prices and wants people buying strawberries to get a price
discount for bulk purchases. If you buy 3 or more strawberries, the price should drop to £4.50
- The CTO is a coffee addict. If you buy 3 or more coffees, the price of all coffees should drop
to two thirds of the original price.
Our check-out can scan items in any order, and because the CEO and COO change their minds
often, it needs to be flexible regarding our pricing rules.

The interface to our checkout looks like this (shown in ruby):

```ruby
co = Checkout.new(pricing_rules)
co.scan(item)
co.scan(item)
price = co.total
```

Implement a checkout system that fulfills these requirements.

Test data:

|Basket             | Total price expected |
|-------------------|----------------------|
|GR1,SR1,GR1,GR1,CF1| 22.45                |
|GR1,GR1            | 3.11                 |
|SR1,SR1,GR1,SR1    | 16.61                |
|GR1,CF1,SR1,CF1,CF1| 30.57                |


### Technical Requirements

- Ruby 2.5.8
- Run `bundle install` before checking from console or running tests

### How to use

First of all we need to create the products:

```Ruby
  tea        = Product.new(code: 'GR1',name: 'Green tea', price: '3.11')
  strawberry = Product.new(code: 'SR1',name: 'Strawberries', price: '5')
  coffe      = Product.new(code: 'CF1',name: 'Coffe', price: '11.23')
```

Then we can specify the pricing rules and add them into an array.

Each pricing rule is represented by an object of the class `PricingRule` and its attributes are:
- `name`[String]: We will use it to determine which calculation we apply
- `arguments`[Hash]: Contains the variables that depends on the rule itself, all the rules have the `:product` argument

This pricing rules, according the [special conditions](#specialconditions) are:

| PricingRule.name                  | PricingRule.Arguments                 | Description - referring to a product  |
|-----------------------------------|---------------------------------------|---------------------------------------|
|`'pay_fewer_units'`                  |`:product`[String]: product code <br /> `:units_to_get`[integer]: Are the units that the user adds to the basket<br /> `:units_to_pay`[integer]: Are the units that will pay |The user get a number of units for free, for a given number of units <br /><sub>The 1st case in the [special conditions](#specialconditions)</sub> <br />i.e. "pay one and get another one free" => `units_to_get=2` `units_to_pay=1` <br />i.e. "pay 2 and get 3" => `units_to_get=3` `units_to_pay=2`|
|`'new_price_by_units'`               |`:product`[String]: product code <br /> `:units`[integer]<br /> `:price`[float]              |If the user buys a minimum units, the price of that product change<br /><sub>The 2nd case in the [special conditions](#specialconditions)</sub>|
|`'discount_on_item_price_by_units'`  |`:product`[String]: product code <br /> `:units`[integer]<br /> `:percent_discount`[float].  |If the user buys a minumim units, the price of that product will decrease a percentatge<br /><sub>The 3rd case in the [special conditions](#specialconditions)</sub>|



Example:

```Ruby
pricing_rules = []
pricing_rules = << ShoppingCart::PricingRule.new(
                     'discount_on_item_price_by_units',
                      product: tea,
                      units: '4',
                      percent_discount: 33.3
                   )
pricing_rules = << ShoppingCart::PricingRule.new(
                     'new_price_by_units',
                      product: strawberry,
                      units: '3',
                      price: 4.5
                   )
```


This `promotional_rules` array is the paremeter we pass to the init of our checkout system, thurough the class `Basket`:

```Ruby
basket = ShoppingCart::Basket.new(pricing_rules)
```

Then we add to the basket the products that we scan, one by one, like in a supermarket

```Ruby
basket.scan(tea)
basket.scan(strawberry)
basket.scan(strawberry)
basket.scan(strawberry)
basket.scan(coffe)
basket.scan(coffe)
```

And the method `total` of the instance `basket` gives us the total amount: `price = basket.total`

Puting it all together in a ruby console, could be something like:

```Ruby
Dir["app/**/*.rb"].each { |file| require_relative file }
Dir["lib/**/*.rb"].each { |file| require_relative file }

tea        = Product.new(code: 'GR1',name: 'Green tea', price: '3.11')
strawberry = Product.new(code: 'SR1',name: 'Strawberries', price: '5')
coffe      = Product.new(code: 'CF1',name: 'Coffe', price: '11.23')

pricing_rules = []
pricing_rules << ShoppingCart::PricingRule.new('discount_on_item_price_by_units',
                                                 product: tea,
                                                 units: '4',
                                                 units: '4')
pricing_rules << ShoppingCart::PricingRule.new('new_price_by_units',
                                                 product: strawberry,
                                                 units: '3',
                                                 price: 4.5)

basket = ShoppingCart::Basket.new(pricing_rules)

basket.scan(tea)
basket.scan(strawberry)
basket.scan(strawberry)
basket.scan(strawberry)
basket.scan(coffe)
basket.scan(coffe)

puts basket.total
```

### Testing

Execute `bundle exec rspec` within the project folder
