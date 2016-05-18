$(document).ready(function() {

  //Initialize Event listeners 
  $('#user_username').blur(validateAvailability);
  $('#user_username').keyup(validateUsername);
  $('#user_email').blur(validateAvailability);
  $('#user_email').keyup(validateEmail);
  $('#user_password').keyup(validatePassword);
  $('#user_password_confirmation').keyup(validateConfirmation);
  
  //Strikethrough animation.
  function StrikeThrough(index, div, text) {
    //Place the text into _text to be manipulated frequently.    
    var _text = text;
    //If index == the length of the text, the entire string is struck through.
    if (index >= _text.length)
        return false;
    var sToStrike = _text.substr(0, index + 1);
    //Substring that holds the rest of the text that will not be struck through.
    var sAfter = (index < (_text.length - 1)) ? _text.substr(index + 1, _text.length - index) : "";
    //Strike through sToStrike in the <td> and move sAfter out of the strike.
    $(div).html("<strike>" + sToStrike + "</strike>" + sAfter);
    //Function to wait 50ms before calling StrikeThrough again recursively.
    window.setTimeout(function() {
        StrikeThrough(index + 1, div, _text);
    }, 50);
  }
  
  //Reverse strikethrough animation.
  function ClearStrikeThrough(index, div, text)
  {
    //Place the text into _text to be manipulated frequently.
    var _text = text;
    //If index == -1, than position [0] is not struck through, stop clearing.
    if (index == -1)
        return false;
    //Substring that will hold the text to strike through.
    var sToStrike = _text.substr(0, index);
    //Substring that holds the rest of the text that will not be struck through.
    var sAfter = (index > 0) ? _text.substr(index, _text.length - 1) : _text;
    //Strike through sToStrike in the <td> and move sAfter out of the strike.
    $(div).html("<strike>" + sToStrike + "</strike>" + sAfter);
    //Function to wait 50ms before calling ClearStrikeThrough again recursively.
    window.setTimeout(function() {
        ClearStrikeThrough(index - 1, div, _text);
    }, 50);
  }
  
  //Timer helper function to perform animation with delay.
  function TimerHelper(seconds, div, identifier, text)
  {
    var minutes = seconds - seconds % 60;
    minutes = minutes / 60;
    var tempSeconds = seconds % 60;
    if (tempSeconds < 10)
    { 
      $(div).html(minutes + ":0" + tempSeconds);
    }
    else if (tempSeconds == 0)
    {
      $(div).html(minutes + ":00");
    }
    else
    {
      $(div).html(minutes + ":" + tempSeconds);
    }
    
    if (seconds == 0)
    {
      document.getElementById('alarmbell').play();
      StrikeThrough(0, identifier, text);
      return false; 
    }
    
    window.setTimeout(function() {
      TimerHelper(seconds - 1, div, identifier, text);  
    }, 1000);
  }
  
  //Timer countdown animation.
  function GetTimer(div)
  {
    var timerContent = $(div).text();
    var seconds = 0;
    var j = 1;
    for (var i = timerContent.length - 1; i > -1; --i)
    {
      if (i != timerContent.length - 3)
      {
        seconds += Number(timerContent[i]) * j;
        j = j * 10;
      }
      else
      {
        j = 60;
      }
    }
    return seconds;
  }
  
  //Monitor for advanced search requests.
  $('#advancedbox').change(function(){
    if (this.checked == true)
      $('#advancedsearch').show();
      else
      $('#advancedsearch').hide();
  });
  
  //Monitor the change in the checklistbox class objects
  $('.checklistbox').change(function(){
    var alt = $(this).attr('id');
    //Acquire the associated id and use the className checklisttest to build
    //an identifier for jQuery.
    var identifier = "#" + alt + ".checklisttext";
    var timer = '#' + alt + ".checklisttimer";
    var seconds = 0;
    //Initialize tdtext, the variable which will hold the text content of the
    //element.
    var tdtext = "";
    //If checked is true, place the element's text content into tdtext
    //and begin striking through that text.
    if (this.checked == true)
    {
      tdtext = $(identifier).text();
      seconds = GetTimer(timer);
      if (seconds > 0)
      {
        TimerHelper(seconds, timer, identifier, tdtext);
      }
      else
      {
        StrikeThrough(0, identifier, tdtext);
      }
    }
    else
    {
      //If it is unchecked, remove the strikethrough with a reverse
      //animation.
      tdtext = $(identifier).text();
      ClearStrikeThrough(tdtext.length - 1, identifier, tdtext);
    }
  });
  
  
  //Holds the previous value of the the Servings number_field to resore the
  //textContent of the adjustablequantity divs prior to multiplying them.
  var previousCoefficient = 1;
  
  //Grabs the Servings number_field and attaches a change event listener
  //that acquires all the adjustablequantity divs and changes their textContent
  //according to the numeric value in the field 
  $("#Servings").change(function(){
    //Place the coefficient into the changedVal var.
    var changedVal = Number($(this).val());
    //Assure that the value is a number that does not equal 0, and is
    //also not characters.
    if (isNaN(changedVal) != true && Number(changedVal) > 0)
    {
      //Retrive all DOMs matching the adjustablequantity class name.
      var ingredientQuantities = document.querySelectorAll(".adjustablequantity");
      //Loop through each DOM changing its textContent accordingly.
      for (var i = 0; i < ingredientQuantities.length; i++)
      {
        ingredientQuantities[i].textContent = (Number(ingredientQuantities[i].textContent) / previousCoefficient * changedVal);
      }
      //Change the previousCoefficient to be the recently applied changedVal.
      previousCoefficient = changedVal;
    }
  });
    
  function validateAvailability()
  {
    var obj = $(this);
    
    if(obj.val().length === 0)
      showError(obj, getObjectName(obj) + " is a required field");
    else
    {
      $.ajax(
      {
        type: "GET",
        url: "/users/existing.json",
        data: getAjaxData(obj),
        dataType: "text",
        
        success: function(data)
        {
          if (data === "exists")
            showError(obj, getErrorMsg(obj));
          else
          {
            removeError(obj);
            obj.keyup();
          }
        }
      });
    }
    return false;
  }
  
  function validateUsername()
  {
    var obj = $(this);
    var len = obj.val().length;
    
    if (len < 3)
      showError(obj, "Username length must be at least 3 characters.");
    else if (len > 25)
      showError(obj, "Username cannot be longer than 25 characters.");
    else
      removeError(obj);
  }
  
  function validateEmail()
  {
    var obj = $(this);
    var Regex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Za-z]{2,20}$/i;
    if (!Regex.test(obj.val()))
      showError(obj, "Email form is invalid.");
    else
      removeError(obj);
  }
  
  function validatePassword()
  {
    var obj = $(this);
    
    if (obj.val().length === 0)
      showError(obj, "Password is a required field.");
    else
    {
      if (obj.val().length < 6)
        showError(obj, "Password must be at least 6 characters.");
      else if (obj.val().length > 35)
        showError(obj, "Password cannot be greater than 35 characters.");
      else
        removeError(obj);
    }
  }
  
  function validateConfirmation()
  {
    var obj = $(this);
    var pwd = $('#user_password').val();
    if( obj.val() != pwd )
      showError(obj, "Confirmation does not match password.");
    else
      removeError(obj);
  }
  
  function showError(obj, msg)
  {
    $('span', obj.parent()).text(msg).removeClass('error').
                            addClass('error_show');
    obj.addClass('errorfield');
  }
  
  function removeError(obj)
  {
    $('span', obj.parent()).text("").removeClass('error_show').
                            addClass('');
    obj.removeClass('errorfield');
  }
  function getAjaxData(obj)
  {
    if(obj.attr('id') === 'user_username')
      return { username: obj.val() }
    else
      return { email: obj.val() }
  }
  
  function getErrorMsg(obj)
  {
    if(obj.attr('id') === 'user_username')
      return "Username is already in use.";
    else
      return "Email address has already been registered.";
  }
  
  function getObjectName(obj)
  {
    if(obj.attr('id') === 'user_username')
      return "Username";
    else
      return "Email";
  }
});