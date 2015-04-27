/*************************************************************
 * Purpose: Gets the elevation of the user using the navigator
 *          geolocation feature.
 * 
 * Entry:   None.
 * 
 * Exit:    The elevation is returned
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
                var latLang;        // Google object that will hold latitude and longitude
                var location = [];  // Array of locations (latLang objects)
                var pos;            // Holds the user's full location
                var elevator;       // Google object for the elevation service
                
                // Store user's latitude and longitude
                latLang = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
                
                location.push(latLang);          // Add the user's location to the location array
                pos = { 'locations': location }; // Store the locations into pos
                
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
                            // Create the cookie
                            createCookie(result[0].elevation);
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
 * Exit:    
 *************************************************************/
function createCookie(elevInMeters)
{
    // Elevation that will trigger recipe adjustment (in feet)
    const ADJUST_ELEV = 3000;
    
    // Convert elevation from meters to feet
    var elevInFeet = elevInMeters * 3.28084;
    var confirmation = "We noticed that you are above 5000ft. Would you like to " +
                       "adjust cooking times and temperatures according to your " +
                       "elevation?";
    
    // If elevation is higher than the adjustment elevation
    // and a cookie does not already exist, prompt user
    if (elevInFeet >= ADJUST_ELEV && checkCookie("adjust") == false)
    {
        var cName = "adjust";   // Cookie name
        const YES = 1;          // Cannot just do 1.toString(), must be a variable
        const NO = 0;           // See comment on previous line
        
        // Ask user if they would like to adjust cooking times and temperatures
        if (confirm(confirmation))
        {
            // Store that the user does want to adjust in the cookie
            document.cookie = cName + "=" + YES.toString();
        }
        else
        {
            // Store that the user does not want to adjust in the cookie
            document.cookie = cName + "=" + NO.toString();
        }
    }
}

/*************************************************************
 * Purpose: Gets the value in the cookie to see if the user
 *          wants to adjust recipe cooking times and temperatures
 *          according to their elevation.
 * 
 * Entry:   The name of the cookie.
 * 
 * Exit:    Returns the value in the cookie.
 *************************************************************/
function getCookie(cName)
{
    var name = cName + "=";
    var cookie = "";
    var found = false;
    
    // Split the cookie, delimited by semi-colon
    var splitCookie = document.cookie.split(';');
    
    // Loop through cookie pieces looking for the value that it holds
    for (var i = 0; i < splitCookie.length && found == false; i++)
    {
        // Get next element of the cookie
        var cookieVal = splitCookie[i];
        
        // Remove any spaces at the beginning
        while (cookieVal.charAt(0) == ' ')
            cookieVal = cookieVal.substring(1);
        
        // If the cookie is found
        if (cookieVal.indexOf(name) == 0)
        {
            cookie = cookieVal.substring(name.length, cookieVal.length);
            found = true;
        }
    }
    
    return cookie;
}

/*************************************************************
 * Purpose: Looks to see if there is a cookie that already
 *          exists with the name that is passed in.
 * 
 * Entry: Is the browser supported or not.
 * 
 * Exit: Error message is displayed.
 *************************************************************/
function checkCookie(cName)
{
    var cookie = getCookie(cName);  // Get the cookie named <cName>
    var exists = false;             // Assume we have not found the cookie
    
    // If cookie variable is not empty, then
    // the requested cookie exists
    if (cookie !== "")
        exists = true;
        
    return exists;
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
    const ALREADY_NOTIFIED = -1;
    
    // If the user has not been notified already
    // that their location could not be found
    if (getCookie("adjust") != ALREADY_NOTIFIED)
    {
        // If the browser is supported
        if (supported)
        {
            // Browser is supported, but no location was found
            alert('No location could be found.');
        }
        else
        {
            // Browser does not support geolocation
            alert('ERROR: Browser does not support some features of this website.');
        }
        
        // Set cookie to "already notified"
        document.cookie = "adjust=" + ALREADY_NOTIFIED.toString();
    }
}});