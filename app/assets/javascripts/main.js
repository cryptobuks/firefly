$(function () {

  $('select').select2();

  var isMobile = {
    Android: function() {
      return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function() {
      return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function() {
      return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function() {
      return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function() {
      return navigator.userAgent.match(/IEMobile/i);
    },
    any: function() {
      return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
  };

  if (isMobile.any()) {
    $('#bgvid').remove();
  };

  //set initial size
  setTimeout(function() {
    var initSize = $('#bgvid').outerHeight();
    $('#h').css("height", initSize);
  }, 1000);

  //if resize change size
  $( window ).resize(function() {
    var videoSize = $('#bgvid').outerHeight();

    $('#h').css("height", videoSize);
  });

  //side menu
  $('#menuToggle, .menu-close').on('click', function(){
    $('#menuToggle').toggleClass('active');
    $('body').toggleClass('body-push-toleft');
    $('#theMenu').toggleClass('menu-open');
  });

    $('[data-toggle="tooltip"]').tooltip({'placement': 'top', 'html': 'true'});


  //validate observer registration
  $.validator.addMethod("checkemail",
    function(value, element) {
        var result = false;
        $.ajax({
            type:"GET",
            async: false,
            url: "/api/v1/validate/observer?email=" + encodeURI(value),
            success: function(msg) {
                result = (msg['check'] == "bad") ? false : true;
            }
        });
        return result;
    },
    "Ticket with this email already exists."
  );

  $("#new_observer").validate({
    rules: {
      "observer[email]": {
        required: true,
        checkemail: true
      },
      "observer[name]": {
        required: true
      }
    },
    messages: {
      "observer[name]": "Please enter your name",
      "observer[checkemail]": "Ticket with this email already exists"
    }
  });

  $('.datatable').DataTable({
    // ajax: ...,
    // autoWidth: false,
    // pagingType: 'full_numbers',
    // processing: true,
    // serverSide: true,

    // Optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about available options.
    // http://datatables.net/reference/option/pagingType
  });

  //adding team member
  $(".try-to-add-member").click(function(){
    
    var member_email = $(".new-member-email-address").val();

    console.log(member_email);

    $.ajax({
      type: "GET",
      url: "/api/v1/process/lookup/hacker?email="+member_email,
      success: function(data){
        console.log(data);

        if (data.status == '200') {
          console.log('200');
        } else if (data.status == '500') {
          console.log('500');
        } else {
          console.log('other');
        };
        
      },
      failure: function(errMsg) {
        console.log(errMsg);
      }
    });

  });

});
