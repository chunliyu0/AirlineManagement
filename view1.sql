--SELECT * FROM DepartureInformation

--Find the departure information include airport, time, terminal and gate
CREATE VIEW DepartureInformation AS
      SELECT r.DepartureAirpport, r.ArrivalAirport, ft.ScheduledDepartureTime, 
	         t.TerminalName, g.GateName
		FROM dbo.FlightRoutes r, dbo.ScheduledFlights f,dbo.ScheduledFlightTimes ft,
		     dbo.ScheduledFlightGates fg, dbo.Terminals t,dbo.Gates g
		WHERE f.FlightRouteId = r.FlightRouteId
			AND f.ScheduledFlightId = ft.ScheduledFlightId
			AND f.ScheduledFlightId = fg.ScheduledFlightId
			AND fg.ScheduledDepartureGate=g.GateId
			AND g.TerminalId=t.TerminalId