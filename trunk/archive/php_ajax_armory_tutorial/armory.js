
  function getAjax(aserver,gserver,char,targetbox,lang) {
    document.getElementById(targetbox).innerHTML = "Searching...";
    var url = "get_char_data_xml.php?lang=" + lang + "&char=" + char + "&gserver=" + gserver + "&aserver=" + aserver;
    retrieveURL(url,targetbox);
  }

  function retrieveURL(myurl,mytarget)
  {
    var container;
    //alert(myurl);
    if (mytarget) {
      container = document.getElementById(mytarget);
    } else {
      container = document.getElementById("ajaxtargetbox");
    }
    //alert(container);
    var request = false;
    if (window.XMLHttpRequest) 
    {
      request = new XMLHttpRequest();
    }
    else if (window.ActiveXObject) 
    {
      try {
        request = new ActiveXObject("Msxml2.XMLHTTP");
      }
      catch (e)
      {
        try
        {
          request = new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch (e) {}
      }
    }
    request.open("GET", myurl, true);
    request.onreadystatechange = function() 
    {
      if (request.readyState == 4) 
      { 
        container.innerHTML = request.responseText;
      }
    }
    request.send(null);
  }