$(document).ready(function() {

  //Initialize Event listeners 
  $('#user_username').blur(validateAvailability);
  $('#user_username').keyup(validateUsername);
  $('#user_email').blur(validateAvailability);
  $('#user_email').keyup(validateEmail);
  $('#user_password').keyup(validatePassword);
  $('#user_password_confirmation').keyup(validateConfirmation);
  
  function StrikeThrough(index, div, text) {
    var _text = text;
    if (index >= _text.length)
        return false;
    var sToStrike = _text.substr(0, index + 1);
    var sAfter = (index < (_text.length - 1)) ? _text.substr(index + 1, _text.length - index) : "";
    $(div).html("<strike>" + sToStrike + "</strike>" + sAfter);
    window.setTimeout(function() {
        StrikeThrough(index + 1, div, _text);
    }, 50);
  }
  
  function ClearStrikeThrough(index, div, text)
  {
    var _text = text;
    if (index == -1)
        return false;
    var sToStrike = _text.substr(0, index);
    var sAfter = (index > 0) ? _text.substr(index, _text.length - 1) : _text;
    $(div).html("<strike>" + sToStrike + "</strike>" + sAfter);
    window.setTimeout(function() {
        ClearStrikeThrough(index - 1, div, _text);
    }, 50);
  }
    
  $('.checklistbox').change(function(){
    var alt = $(this).attr('id');
    var identifier = "#" + alt + ".checklisttext";
    var c = this.checked;
    var tdtext = "";
    if (c == true)
    {
      tdtext = $(identifier).text(); 
      StrikeThrough(0, identifier, tdtext);
    }
    else
    {
      tdtext = $(identifier).text();
      ClearStrikeThrough(tdtext.length - 1, identifier, tdtext);
    }
    
    $('p').css('color', c);
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
                            addClass('error');
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