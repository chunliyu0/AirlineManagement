# AirlineManagement
![image](https://github.com/ycl11761/AirlineManagement/blob/master/airline.png)</br>
## Problem Description
Design a database that could be used by an airline. The following data should be considered:

***Employees***
- first name
- middle name
- last name
- SSN
- home address
- job (title, description)
 - which planes are they allowed to work on
- pay
- direct supervisor (another employee)

***Airports***
- name
- city
- state
- which terminal(s) are available to us
 - at each terminal there are usually multiple gates to/from which the flights
arrive/leave
- which planes can land here (if the plane is too big, the airport may not be able to handle it)
- hangar capacity (how many planes I can keep overnight) [1]
- actual planes that are currently at this airport (either overnight, awaiting maintenance or
excess planes that we aren’t using currently) 
- fees associated with this airport (airport, city and state taxes, other airport fees)

***Flight Routes***
- airport from which the flight departs
- airport to which the flight arrives
- length of the flight
- refreshments (snacks or full meals and drinks) and whether they are included or are extra

***Airplanes (and their maintenance)***
- a manufacturer [2] and a model number
- date the plane was built
- capacity (first class, business class, economy plus, economy); this is then broken down by
rows and individual seats per row that can be tracked individually
- propulsion method (jet, propeller or hypersonic)
entertainment options (wifi, tv, movies)
- what crew is required to operate it (number of pilots and flight attendants)
- range of how far the plane can fly
- for each plane in our fleet we also want to track its current location (in transit or at one of
the airports) and availability (available, retired or requires maintenance)
 - if it requires maintenance, what is being done, who is doing it and when we expect for it
to be finished
 - we also need to keep a record of performed airplane maintenance (when and what was
done, and who performed the work) and a schedule of when and what is due

***Scheduled Flights***
- flight number (not really unique)
- which plane we are using
- route being flown
- the crew that is working (pilots, flight attendant(s))
- number of available seats and individual seat assignments (I can pay for a specific seat
ahead of time, or I can just pay for the flight and then get a seat assigned when I check in)
- price for each class (first/business/economy plus/economy)
- scheduled, projected and actual time of departure and arrival
- scheduled and actual airport/terminal/gates for both departure and arrival
- flight status (scheduled – on time, scheduled – delayed, in progress – on time, in progress –
late, completed)

***Customer Transactions***
- which customer
- which flight(s)
- when was the flight booked
- price paid (or frequent flier miles used)
 - broken down to taxes, fees and actual flight price
- credit card details
- then for each trip (can be multiple flights)
 - whether and when the customer checked in [3]
 - if there was any checked luggage (if so, extra charges – how much, when the payment
was made and the credit card used)
- any refunds/price adjustments (how much and reason)

***Customers***
- first name
- middle name
- last name
- date of birth
- home address
- phone number
- frequent flyer number (if available)


[1] we can assume that each plane takes up the same amount of space, for simplicity’s sake</br>
[2] company name will suffice</br>
[3] I can purchase (in a single transaction) a round trip to Paris. Leaving now and coming back in 2 weeks. When I
check in for my way there, I will check in to all the flights on the way to Paris (let’s say Syracuse to JFK and then JFK
to Paris). Then a day before coming back I would check in for the trip back (Paris -> JFK and JFK -> Syracuse)</br>
