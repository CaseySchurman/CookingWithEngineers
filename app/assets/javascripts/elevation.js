/*************************************************************
 * Purpose: Gets the elevation of the user using the navigator
 *          geolocation feature.
 * 
 * Entry: None.
 * 
 * Exit: The elevation is returned
 *************************************************************/
$(document).ready(function()
{
    // If the navigator geolocation feature is supported
    // by the browser, find the user's location
    if (navigator.geolocation)
    {
        // Get the user's current latitude and longitude
        // and use that to get the user's elevation
        navigator.geolocation.getCurrentPosition
        (
            // Success function
            function(position)
            {
                var latLang;
                var location = [];
                var pos;
                var elevator;
                
                // Store user's latitude and longitude
                latLang = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
                
                location.push(latLang); // Add the user's location to the location array
                pos = { 'locations': location } // Store the locations into pos
                
                // Create new Google Elevation Service passing in the
                // user's current location
                elevator = new google.maps.ElevationService(location);
                
                // Using the Elevation Service, get the user's elevation
                elevator.getElevationForLocations(pos, function(result, status)
                {
                    // If the elevator worked
                    if(status = google.maps.ElevationStatus.OK)
                    {
                        // If a location was found
                        if (result[0])
                        {
                            // Send result to function to manipulate page data
                            ManipulatePage(result[0].elevation);
                        }
                    }
                    
                });
            },
            
            // Error function
            function()
            {
                // No location found
                noLocationError(true);
            }
        );
        
        /*OLD CODE THAT DIDN'T WORK DUE
        TO CROSS SITE REQUEST
        
        $.getJSON(googleURL, function(data)
        {
            // Use "data" to find elevation
        });*/
    }
    // Navigator geolocation not supported
    else
    {
        // Browser does not support geolocation
        noLocationError(false);
    }

/*************************************************************
 * Purpose: To convert the user's elevation from meters to
 *          feet and use that data to adjust cooking times
 *          and temperatures. (Work in progress).
 * 
 * Entry:   The elevation (will be in meters).
 * 
 * Exit:    (At the moment) Displays elevation in feet to the
 *          screen.
 *************************************************************/
function ManipulatePage(elevInMeters)
{
    var elevInFeet = elevInMeters * 3.28084;
    
    //alert("Your elevation is " + elevInFeet.toFixed(2) + " feet above sea level.")
}

/*************************************************************
 * Purpose: Displays error/reason why no location was found
 *          for a user.
 * 
 * Entry: Is the browser supported or not.
 * 
 * Exit: Error message is displayed.
 *************************************************************/
function noLocationError(supported)
{
    if (supported)
    {
        // Browser is supported, but no location was found
        alert('No location could be found.')
    }
    else
    {
        // Browser does not support geolocation
        alert('ERROR: Browser does not support geolocation.')
    }
}});