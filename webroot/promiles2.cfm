<!---Authorization Credentials--->
<cfset variables.Username="webrsys">
<cfset variables.Password="webr774">
<cfset variables.CompanyCode="weby">

<cfscript>
PRIMEEnterpriseV1 PRIME = new PRIMEEnterpriseV1();

//Authorization Credentials
Credentials c = new Credentials();
c.Username = "webrsys";
c.Password = "webr774";
c.CompanyCode = "weby";


//Build Trip
Trip t = new Trip();

TripLeg[] Legs = new TripLeg[2];

//Origin
TripLeg t = new TripLeg();
t.LocationText = "77611";
Legs[0] = t;

//Destination
t = new TripLeg();
t.LocationText = "90210";
Legs[1] = t;

t.TripLegs = Legs;


//Set Options
t.Options = new TripOptions();


//Set Routing Options
RoutingOptions ro = new RoutingOptions();
ro.RoutingMethod = com.promiles.PRIME.Enterprise.RouteMethod.PRACTICAL;
ro.AvoidTollRoads = false;
ro.BorderOpen = true;
ro.DoRouteOptimization = false;

t.Options.Routing = ro;

//Itinerary
ItineraryOptions io = new ItineraryOptions();
io.AnchorTimeIsTripStart = true;
io.ItineraryAnchorTime = DateTime.Now;
io.MilesBetweenFuelStops = (Int16)800;
io.MinutesAtDOTRest = (Int16)480;
io.MinutesAtFuelStop = (Int16)30;
io.MinutesAtOrigin = (Int16)60;
io.MinutesAtStop = (Int16)60;
io.MinutesDrivingBetweenRests = (Int16)600;
io.UseTeamMode = false;

t.Options.Itinerary = io;


//Fuel Optimization
FuelOptimizationOptions fo = new FuelOptimizationOptions();
fo.DesiredEndGallons = (Int16)60;
fo.DistanceOOR = (Int16)5;
fo.MinimumGallonsToPurchase = (Int16)50;
fo.MinimumTankGallonsDesired = (Int16)50;
fo.StartGallons = (Int16)100;
fo.UnitMPG = 6.0M;
fo.UseAllStopsNetwork = true;
fo.UnitTankCapacity = (Int16)200;

t.Options.FuelOptimization = fo;

//State what we want back;
t.GetDrivingDirections = true;
t.GetFuelOptimization = true;
t.GetItinerary = true;
t.GetMapPoints = true;
t.GetStateBreakout = true;
t.GetTruckStopsOnRoute = true;
t.VehicleType = VehicleType.Tractor2AxleTrailer2Axle;

Trip rt = PRIME.RunTrip(c, t, PriceProvider.PROMILES_RETAIL);

if (rt.ResponseStatus == ResponseType.SUCCESS)
{
    TripTitle.Text = rt.TripLegs[0].LocationText + " to " + rt.TripLegs[rt.TripLegs.Length - 1].LocationText;
    TripDistAndTime.Text = "<b>Distance: </b>" + rt.Results.TripMiles.ToString() + "   <b>Time:</b>" + Utility.GetTimeText(rt.Results.TripMinutes);

    StringBuilder sb = new StringBuilder();
    sb.Append("<br/><br/><b>State Breakout</b>");
    sb.Append("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"DocListTable\">");
    sb.Append("<thead><tr><th>State</th><th>Non Toll Miles</th><th>Toll Miles</th><th>TotalMiles</th><th>Tax Owed</th><tr></thead>");


    //State Breakout
    foreach (StateBreakoutRow sr in rt.Results.StateMileage)
    {
sb.Append("<tr>");
sb.Append("<td>" + sr.State + "</td>");
sb.Append("<td>" + sr.NonTollMiles.ToString() + "</td>");
sb.Append("<td>" + sr.TollMiles.ToString() + "</td>");
sb.Append("<td>" + sr.TotalMiles.ToString() + "</td>");
sb.Append("<td>" + sr.TaxOwed.ToString() + "</td>");
sb.Append("</tr>");
    }

    sb.Append("</table><br/><br/>");

    StateBreakout.Text = sb.ToString();

    //Driving Directions
    sb = new StringBuilder();
    sb.Append("<b>Driving Directions</b>");
    sb.Append("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"DocListTable\">");
    sb.Append("<thead><tr><th>Man.</th><th>Road</th><th>Leg Dist</th><th>Minutes</th><th>Dist At Start</th><tr></thead>");

    foreach (DirectionRow dr in rt.Results.DrivingDirections)
    {
sb.Append("<tr>");
sb.Append("<td>" + dr.Maneuver + "</td>");
sb.Append("<td>" + dr.Road + "</td>");
sb.Append("<td>" + dr.LegDistance.ToString() + "</td>");
sb.Append("<td>" + Utility.GetTimeText(dr.Time) + "</td>");
sb.Append("<td>" + dr.DistanceAtStart.ToString() + "</td>");
sb.Append("</tr>");
    }

    sb.Append("</table><br/><br/>");

    DrivingDirections.Text = sb.ToString();

    //Itinerary
    sb = new StringBuilder();
    sb.Append("<b>Itinerary</b>");
    sb.Append("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"DocListTable\">");
    sb.Append("<thead><tr><th>Type</th><th>Location</th><th>Arrival Date</th><th>Leg Miles</th><th>LegsMinutes</th><th>Time At Stop</th><tr></thead>");
    foreach (ItineraryRow ir in rt.Results.Itinerary)
    {
sb.Append("<tr>");
sb.Append("<td>" + ir.StopType.ToString() + "</td>");
sb.Append("<td>" + ir.Location + "</td>");
sb.Append("<td>" + ir.ArrivalDate + "</td>");
sb.Append("<td>" + ir.LegMiles.ToString() + "</td>");
sb.Append("<td>" + Utility.GetTimeText(ir.LegMinutes) + "</td>");
sb.Append("<td>" + Utility.GetTimeText(ir.AtStopMinutes) + "</td>");
sb.Append("</tr>");
    }

    sb.Append("</table><br/><br/>");
    Itinerary.Text = sb.ToString();

    //Truck Stops
    sb = new StringBuilder();
    sb.Append("<b>Truck Stops</b>");
    sb.Append("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"DocListTable\">");
    sb.Append("<thead><tr><th>Name</th><th>Location</th><th>City</th><th>State</th><th>Retail Pirce</th><th>Price Date</th><tr></thead>");
    foreach (TruckStop ts in rt.Results.TruckStopsOnRoute)
    {
sb.Append("<tr>");
sb.Append("<td>" + ts.Name + "</td>");
sb.Append("<td>" + ts.Location + "</td>");
sb.Append("<td>" + ts.City + "</td>");
sb.Append("<td>" + ts.State + "</td>");
sb.Append("<td>" + ts.RetailPrice.ToString() + "</td>");
sb.Append("<td>" + ts.PriceDate.ToShortDateString() + "</td>");
sb.Append("</tr>");
    }

    sb.Append("</table><br/><br/>");

    TruckStops.Text = sb.ToString();

    //Fuel Optimization
    sb = new StringBuilder();
    sb.Append("<b>Fuel Optimization</b><br/>");


    if (rt.Results.FuelOptimization.IsOptimized)
    {

foreach (FuelOptimizationNetworkResult fnr in rt.Results.FuelOptimization.NetworkResults)
{
    sb.Append("<b>Network:</b>" + fnr.NetworkName);
    sb.Append("    <b>Savings Per Gallon:</b>" + fnr.EstimatedSavingsPerGallon.ToString());
    sb.Append("    <b>Estimated Trip Savings:</b>" + fnr.EstimatedTripSavings.ToString());
    sb.Append("<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" class=\"DocListTable\">");
    sb.Append("<thead><tr><th>Name</th><th>Location</th><th>City</th><th>State</th><th>Gallons</th><th>Price</th><th>Total</th><tr></thead>");

    foreach (FuelOptimizationRow frow in fnr.FuelOptimizationRows)
    {

sb.Append("<tr>");
sb.Append("<td>" + frow.TruckStopName + "</td>");
sb.Append("<td>" + frow.Location + "</td>");
sb.Append("<td>" + frow.City + "</td>");
sb.Append("<td>" + frow.State + "</td>");
sb.Append("<td>" + frow.GallonsToBuy.ToString() + "</td>");
sb.Append("<td>" + frow.RetailPrice.ToString() + "</td>");
sb.Append("<td>" + (frow.RetailPrice * frow.GallonsToBuy).ToString() + "</td>");
sb.Append("</tr>");
    }

    sb.Append("</table><br/><br/>");
}

    }

    else
    {
sb.Append("No optimization performed. No fuel purchases necessary.<br/><br/>");
    }

    FuelOptimization.Text = sb.ToString();
}
else
{
    TripTitle.Text = "Error: " + rt.ResponseMessage;
}
</cfscript>