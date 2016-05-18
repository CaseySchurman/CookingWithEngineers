$(document).ready(function()
{
    var COOKIE_NAME = "adjust"; // Cookie name
    var YES = 1;
    var NO = 0;
    var yesButton = document.getElementById("yesBtn");
    var noButton = document.getElementById("noBtn");
    var okayButton = document.getElementById("okayBtn");
    
    yesButton.addEventListener("click", function()
    {
        // Store that the user does want to adjust in the cookie
        document.cookie = COOKIE_NAME + "=" + YES.toString();
        
        document.getElementById("ElevationBanner").setAttribute("class", "dHide");
    });
    
    noButton.addEventListener("click", function()
    {
        // Store that the user does NOT want to adjust in the cookie
        document.cookie = COOKIE_NAME + "=" + NO.toString();
        
        document.getElementById("ElevationBanner").setAttribute("class", "dHide");
    });
    
    okayButton.addEventListener("click", function()
    {
        document.getElementById("ElevationNoLocation").setAttribute("class", "dHide");
    });
});