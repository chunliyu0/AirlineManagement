/*
 * CSE.581.M004 SPRING 15.Intro D/Base Mngmt Syst.
 * Created by Chunli Yu [cyu22@syr.edu]
 * Last modification date: 2015-04-18 02:52:59.963
 * tables Creation
 */

-- Table: Personals
IF OBJECT_ID('Personals', 'U') IS NOT NULL DROP TABLE Personals
CREATE TABLE Personals (
    PersonId VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(30)  NOT NULL,
    MiddleName VARCHAR(30),
    LastName VARCHAR(30)  NOT NULL,
    PhoneNumber VARCHAR(15)  NOT NULL,
);

-- Table: Addresses
IF OBJECT_ID('Addresses', 'U') IS NOT NULL DROP TABLE Addresses
CREATE TABLE Addresses (
    PersonId VARCHAR(10)  PRIMARY KEY REFERENCES Personals(PersonId),
    Street1 VARCHAR(100)  NOT NULL,
    Street2 VARCHAR(100),
	City VARCHAR(15)  NOT NULL,
    USState VARCHAR(2)  NOT NULL,
    Zipcode VARCHAR(5)   NOT NULL,
);

-- Table: Jobs
IF OBJECT_ID('Jobs', 'U') IS NOT NULL DROP TABLE Jobs
CREATE TABLE Jobs (
    JobId INT PRIMARY KEY IDENTITY(1, 1),
    JobTitle VARCHAR(30)  NOT NULL,
    JobDescription TEXT,
);

-- Table: Customers
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers
CREATE TABLE Customers (
    CustomerId VARCHAR(10)  PRIMARY KEY REFERENCES Personals(PersonId),
    FrequentFlyerNumber VARCHAR(15),
);

-- Table: CreditCardTypes
IF OBJECT_ID('CreditCardTypes', 'U') IS NOT NULL DROP TABLE CreditCardTypes
CREATE TABLE CreditCardTypes (
    CardTypeId INT PRIMARY KEY IDENTITY(1, 1),
    CardTypeName VARCHAR(30)  NOT NULL,
);

-- Table: CreditCardDetails
IF OBJECT_ID('CreditCardDetails', 'U') IS NOT NULL DROP TABLE CreditCardDetails
CREATE TABLE CreditCardDetails (
    CardNumber VARCHAR(20)  PRIMARY KEY,
    Holder VARCHAR(10)  NOT NULL REFERENCES Customers(CustomerId),
    CardType INT  NOT NULL REFERENCES CreditCardTypes(CardTypeId),
    ExpirationMonth INT  NOT NULL,
    ExpirationYear INT  NOT NULL,
);

-- Table: Employees
IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees
CREATE TABLE Employees (
    EmployeeId VARCHAR(10) PRIMARY KEY REFERENCES Personals(PersonId),
    JobId INT NOT NULL REFERENCES Jobs(JobId),
    DirectSupervisor VARCHAR(10) REFERENCES Employees(EmployeeId),
    SSN VARCHAR(20)  NOT NULL,
    Salary DECIMAL(10,2)  NOT NULL,
);

-- Table: PropulsionMethods
IF OBJECT_ID('PropulsionMethods', 'U') IS NOT NULL DROP TABLE PropulsionMethods
CREATE TABLE PropulsionMethods (
    PropulsionId INT PRIMARY KEY IDENTITY(1, 1),
    PropulsionMethod VARCHAR(30)  NOT NULL,
);

-- Table: Manufacturers
IF OBJECT_ID('Manufacturers', 'U') IS NOT NULL DROP TABLE Manufacturers
CREATE TABLE Manufacturers (
    ManufacturerId VARCHAR(10) PRIMARY KEY,
    ManufacturerName VARCHAR(50)  NOT NULL,
);

-- Table: PlaneModels
IF OBJECT_ID('PlaneModels', 'U') IS NOT NULL DROP TABLE PlaneModels
CREATE TABLE PlaneModels (
    ManufacturerId VARCHAR(10) REFERENCES Manufacturers(ManufacturerId),
    ModelNumber VARCHAR(10)  NOT NULL,
    PropulsionMethod INT NOT NULL REFERENCES PropulsionMethods(PropulsionId),
    NumberOfPilots INT  NOT NULL,
    NumberOfAttendants INT  NOT NULL,
    FlyRange INT  NOT NULL,
	PRIMARY KEY(ManufacturerId,ModelNumber)
);

-- Table: EntertainmentOptions
IF OBJECT_ID('EntertainmentOptions', 'U') IS NOT NULL DROP TABLE EntertainmentOptions
CREATE TABLE EntertainmentOptions (
    EntertainmentOptionId  INT  PRIMARY KEY IDENTITY(1, 1),
    EntertainmentName VARCHAR(30)   NOT NULL,
);

-- Table: AirplaneEntertainments
IF OBJECT_ID('AirplaneEntertainments', 'U') IS NOT NULL DROP TABLE AirplaneEntertainments
CREATE TABLE AirplaneEntertainments (
    ManufacturerId VARCHAR(10),
    ModelNumber VARCHAR(10),
    EntertainmentOptionId  INT REFERENCES EntertainmentOptions (EntertainmentOptionId),
	PRIMARY KEY (ManufacturerId,ModelNumber, EntertainmentOptionId),
	FOREIGN KEY  (ManufacturerId, ModelNumber) REFERENCES PlaneModels (ManufacturerId, ModelNumber)
);

-- Table: CanWork
IF OBJECT_ID('CanWork', 'U') IS NOT NULL DROP TABLE CanWork
CREATE TABLE CanWork (
    EmployeeId VARCHAR(10) REFERENCES Employees(EmployeeId),
    ManufacturerId VARCHAR(10),
    ModelNumber VARCHAR(10),
	PRIMARY KEY(EmployeeId, ManufacturerId,ModelNumber),
	FOREIGN KEY  (ManufacturerId, ModelNumber) REFERENCES PlaneModels (ManufacturerId, ModelNumber)	
);

-- Table: Airports
IF OBJECT_ID('Airports', 'U') IS NOT NULL DROP TABLE Airports
CREATE TABLE Airports (
    AirportId VARCHAR(5) PRIMARY KEY,
    AirportName VARCHAR(50)  NOT NULL,
    HangarCapacity INT NOT NULL DEFAULT 0,
);

-- Table: AirportLocations
IF OBJECT_ID('AirportLocations', 'U') IS NOT NULL DROP TABLE AirportLocations
CREATE TABLE AirportLocations (
    AirportId VARCHAR(5) PRIMARY KEY REFERENCES Airports(AirportId),
    City VARCHAR(15)   NOT NULL,
	USState VARCHAR(2)   NOT NULL
);

-- Table: FeeTypes
IF OBJECT_ID('FeeTypes', 'U') IS NOT NULL DROP TABLE FeeTypes
CREATE TABLE FeeTypes (
    FeeTypeId INT PRIMARY KEY IDENTITY(1, 1),
    FeeTypeName VARCHAR(30)  NOT NULL,
);

-- Table: AirportFees
IF OBJECT_ID('AirportFees', 'U') IS NOT NULL DROP TABLE AirportFees
CREATE TABLE AirportFees (
    AirportId VARCHAR(5) REFERENCES Airports(AirportId),
    FeeTypeId INT REFERENCES FeeTypes(FeeTypeId),
	Fees DECIMAL(8,2),
	PRIMARY KEY(AirportId,FeeTypeId)
);

-- Table: CanLand
IF OBJECT_ID('CanLand', 'U') IS NOT NULL DROP TABLE CanLand
CREATE TABLE CanLand (
    AirportId VARCHAR(5) REFERENCES Airports(AirportId),
    ManufacturerId VARCHAR(10),
    ModelNumber VARCHAR(10),
	PRIMARY KEY(AirportId,ManufacturerId,ModelNumber),
	FOREIGN KEY  (ManufacturerId, ModelNumber) REFERENCES PlaneModels (ManufacturerId, ModelNumber)
);

-- Table: Availabilities
IF OBJECT_ID('Availabilities', 'U') IS NOT NULL DROP TABLE Availabilities
CREATE TABLE Availabilities (
    AvailabilityId INT  PRIMARY KEY IDENTITY(1, 1),
    AvailabilityStatus VARCHAR(30)  NOT NULL,
);

-- Table: Airplanes
IF OBJECT_ID('Airplanes', 'U') IS NOT NULL DROP TABLE Airplanes
CREATE TABLE Airplanes (
    PlaneId VARCHAR(6)  PRIMARY KEY,
    ManufactureId VARCHAR(10)  NOT NULL,
    ModelNumber VARCHAR(10)  NOT NULL,
    ManufactureDate DATE  NOT NULL,
    AvailabilityId INT NOT NULL,
    CurrentLocation VARCHAR(5) REFERENCES Airports(AirportId),
);

-- Table: Services
IF OBJECT_ID('Services', 'U') IS NOT NULL DROP TABLE Services
CREATE TABLE Services (
    ServiceId INT PRIMARY KEY IDENTITY(1, 1),
    ServiceName VARCHAR(100)  NOT NULL,
    ServiceDescription TEXT,
);

-- Table: MaintenanceRecords
IF OBJECT_ID('MaintenanceRecords', 'U') IS NOT NULL DROP TABLE MaintenanceRecords
CREATE TABLE MaintenanceRecords (
    MaintenanceId INT  PRIMARY KEY IDENTITY(1, 1),
    PlaneId VARCHAR(6)  NOT NULL REFERENCES Airplanes(PlaneId),
    ExpectedDate DATE  NOT NULL,
    MantenancedDate DATE,
    WorkBeingDone INT  NOT NULL REFERENCES Services(ServiceId),
    MantenanceMan VARCHAR(10)  NOT NULL REFERENCES Employees(EmployeeId),
    MaintenanceDescription TEXT,
);

-- Table: FlightRoutes
IF OBJECT_ID('FlightRoutes', 'U') IS NOT NULL DROP TABLE FlightRoutes
CREATE TABLE FlightRoutes (
    FlightRouteId INT  PRIMARY KEY IDENTITY(1, 1),
    DepartureAirpport VARCHAR(5)  NOT NULL REFERENCES Airports(AirportId),
    ArrivalAirport VARCHAR(5)  NOT NULL REFERENCES Airports(AirportId),
    FlightDuration TIME(0)  NOT NULL,
    FlightDistance DECIMAL(10,2) NOT NULL,
);

-- Table: RefreshmentOptions
IF OBJECT_ID('RefreshmentOptions', 'U') IS NOT NULL DROP TABLE RefreshmentOptions
CREATE TABLE RefreshmentOptions (
    RefreshmentOptionId INT PRIMARY KEY IDENTITY(1, 1),
    RefreshmentName VARCHAR(30)  NOT NULL,
);

-- Table: FlightRefreshments
IF OBJECT_ID('FlightRefreshments', 'U') IS NOT NULL DROP TABLE FlightRefreshments
CREATE TABLE FlightRefreshments (
    FlightRouteId INT REFERENCES FlightRoutes(FlightRouteId),
    RefreshmentId INT REFERENCES RefreshmentOptions(RefreshmentOptionId),
    Cost INT,
	PRIMARY KEY(FlightRouteId,RefreshmentId)
);

-- Table: ScheduledFlights
IF OBJECT_ID('ScheduledFlights', 'U') IS NOT NULL DROP TABLE ScheduledFlights
CREATE TABLE ScheduledFlights (
    ScheduledFlightId INT PRIMARY KEY IDENTITY(1, 1),
    FlightRouteId INT NOT NULL REFERENCES FlightRoutes(FlightRouteId),
    FlightNumber VARCHAR(15)  NOT NULL,
    AvailableSeats INT  NOT NULL DEFAULT 0,
    PlaneId VARCHAR(6)  NOT NULL REFERENCES Airplanes(PlaneId),
);

-- Table: Crew
IF OBJECT_ID('Crew', 'U') IS NOT NULL DROP TABLE Crew
CREATE TABLE Crew (
    EmployeeId VARCHAR(10)   REFERENCES Employees(EmployeeId),
    ScheduledFlightId INT  REFERENCES ScheduledFlights(ScheduledFlightId),
	PRIMARY KEY(EmployeeId,ScheduledFlightId)
);

-- Table: Terminals
IF OBJECT_ID('Terminals', 'U') IS NOT NULL DROP TABLE Terminals
CREATE TABLE Terminals (
    TerminalId INT PRIMARY KEY IDENTITY(1, 1),
    TerminalName VARCHAR(10)  NOT NULL,
    AirportId VARCHAR(5)  NOT NULL REFERENCES Airports(AirportId),
    TerminalDescription TEXT,
);

-- Table: Gates
IF OBJECT_ID('Gates', 'U') IS NOT NULL DROP TABLE Gates
CREATE TABLE Gates (
    GateId INT PRIMARY KEY IDENTITY(1, 1),
    GateName VARCHAR(2)  NOT NULL,
    TerminalId INT NOT NULL REFERENCES Terminals(TerminalId),
);

-- Table: ScheduledFlightGates
IF OBJECT_ID('ScheduledFlightGates', 'U') IS NOT NULL DROP TABLE ScheduledFlightGates
CREATE TABLE ScheduledFlightGates (
    ScheduledFlightId INT  PRIMARY KEY REFERENCES ScheduledFlights(ScheduledFlightId),
    ScheduledDepartureGate INT  NOT NULL REFERENCES Gates(GateId),
    ScheduledArrivalGate INT  NOT NULL REFERENCES Gates(GateId),
    ActuralDepartureGate INT REFERENCES Gates(GateId),
    ActuralArrivalGate INT REFERENCES Gates(GateId),
);

-- Table: ScheduledFlightTimes
IF OBJECT_ID('ScheduledFlightTimes', 'U') IS NOT NULL DROP TABLE ScheduledFlightTimes
CREATE TABLE ScheduledFlightTimes (
    ScheduledFlightId INT  PRIMARY KEY REFERENCES ScheduledFlights(ScheduledFlightId),
    ScheduledDepartureTime DATETIME  NOT NULL,
    ScheduledArrivalTime DATETIME  NOT NULL,
    ProjectedDepartureTime DATETIME,
    ProjectedArrivalTime DATETIME,
    ActuralDepartureTime DATETIME,
    ActuralArrivalTime DATETIME,
);

-- Table: Classes
IF OBJECT_ID('Classes', 'U') IS NOT NULL DROP TABLE Classes
CREATE TABLE Classes (
    ClassId INT PRIMARY KEY IDENTITY(1, 1),
    ClassName VARCHAR(15)  NOT NULL,
);

-- Table: Seats
IF OBJECT_ID('Seats', 'U') IS NOT NULL DROP TABLE Seats
CREATE TABLE Seats (
    SeatId INT PRIMARY KEY IDENTITY(1, 1),
    ClassId INT NOT NULL REFERENCES Classes(ClassId),
    RowNumber INT  NOT NULL,
    ColumnLetter CHAR(1)  NOT NULL,
    ManufacturerId VARCHAR(10),
    ModelNumber VARCHAR(10),
	FOREIGN KEY  (ManufacturerId, ModelNumber) REFERENCES PlaneModels (ManufacturerId, ModelNumber)
);

-- Table: Prices
IF OBJECT_ID('Prices', 'U') IS NOT NULL DROP TABLE Prices
CREATE TABLE Prices (
    ScheduledFlightId INT REFERENCES ScheduledFlights(ScheduledFlightId),
    ClassId INT REFERENCES Classes(ClassId),
    Price DECIMAL(10,2)  NOT NULL,
	PRIMARY KEY(ScheduledFlightId,ClassId)
);

-- Table: Trips
IF OBJECT_ID('Trips', 'U') IS NOT NULL DROP TABLE Trips
CREATE TABLE Trips (
    TripId INT PRIMARY KEY IDENTITY(1, 1),
    DateBooked DATETIME  NOT NULL,
    CustomerId VARCHAR(10)  NOT NULL REFERENCES Customers(CustomerId),
    CheckInTime DATETIME,
);

-- Table: Tickets
IF OBJECT_ID('Tickets', 'U') IS NOT NULL DROP TABLE Tickets
CREATE TABLE Tickets (
    TicketId VARCHAR(11) PRIMARY KEY,
    ScheduledFlightId INT  NOT NULL REFERENCES ScheduledFlights(ScheduledFlightId),
    CheckInTime DATETIME  NOT NULL,
);

-- Table: Reservations
IF OBJECT_ID('Reservations', 'U') IS NOT NULL DROP TABLE Reservations
CREATE TABLE Reservations (
    TicketId VARCHAR(11) PRIMARY KEY,
	SeatId INT REFERENCES Seats(SeatId),
	TripId INT,
	ReservationDescription TEXT
);

-- Table: Costs
IF OBJECT_ID('Costs', 'U') IS NOT NULL DROP TABLE Costs
CREATE TABLE Costs (
    CostId INT PRIMARY KEY IDENTITY(1, 1),
    FeeType INT NOT NULL REFERENCES FeeTypes (FeeTypeId),
    TicketId VARCHAR(11)  NOT NULL REFERENCES Reservations(TicketId),
    CostDollars DECIMAL(10,2)  NOT NULL,
    CostMiles INT,
);

-- Table: Payments
IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE Payments
CREATE TABLE Payments (
    CardNumber VARCHAR(20) REFERENCES CreditCardDetails (CardNumber),
    TripId INT REFERENCES Trips(TripId),
    Paytime DATETIME  NOT NULL,
    PaymentDescription TEXT,
	PRIMARY KEY(CardNumber,TripId)
);
-- End of file.

