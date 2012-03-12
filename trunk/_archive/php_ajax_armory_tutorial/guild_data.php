<?
  
  header('Content-Type: text/html; charset=utf-8');
  
  $self = $_SERVER[PHP_SELF];
  $eol = "\n";
  
  // FUNCTIONS
  
  function show_header() {
    echo '
    <html>
    <head>
    <title>Getting data from WoW-Armory with XML,PHP,AJAX and CURL</title>
    <script type="text/javascript" src="armory.js"></script>
    </head>
    <body>
    ';    
  }
  
  function show_footer() {
    echo '
    </body>
    </html>
    ';
  }
  
  function show_form() {
   
    echo '<form>';
    echo '<table>';
    echo '<tr>';
      echo '<th>Server</th>';
      echo '<th>Guild</th>';
      echo '<th>Region</th>';
      echo '<th>Language</th>';
    echo '</tr>';
    echo '<tr>';
      echo '<td><input name="guild_server" value="'.$_GET[guild_server].'" type="text"></td>';
      echo '<td><input name="guild_name" value="'.$_GET[guild_name].'" type="text"></td>';
      echo '<td><select name="region">
        <option value="us">North America</option>
        <option value="eu">Europe</option>
        </select>
        </td>';
      echo '<td><select name="lang">
        <option value="en">English (GB)</option>
        <option value="us">English (US)</option>
        <option value="de">German (DE)</option>
        </select>
        </td>';
      echo '<td><input type="submit"></td>';
    echo '</tr>';
    echo '</table>';
    echo '</form>'.$eol;
    
  }
  
  function replace_space($str) {
    return str_replace(" ","+",$str);
  }

  // BUILD THE PAGE
  
  show_header();  

  //show the form
  show_form();
  
  $guild_name = replace_space($_GET[guild_name]);
  $guild_server = replace_space($_GET[guild_server]);
  
  if(($guild_name != "") && ($guild_server != "")) 
  {

    $lang = $_GET[lang];
    $region = $_GET[region];

    echo '<h2>'.$guild_name.' on '.$guild_server.' - Region: '.$region.', Lang: '.$lang.'</h2>';
    
    if($region == "us") {
      $armory_server = 'http://www.wowarmory.com/';
    } elseif($region == "eu") {
      $armory_server = 'http://eu.wowarmory.com/';
    }

    $armory_url = $armory_server.'guild-info.xml?r='.$guild_server.'&gn='.$guild_name;
    
    class guild_data 
    {
      public function get_xml($lang,$url) 
      {
        $ch = curl_init();
        if ($lang == 'de')
          $header[] = 'Accept-Language: de-de';
        elseif ($lang == 'en')
          $header[] = 'Accept-Language: en-gb';
        elseif ($lang == 'us')
          $header[] = 'Accept-Language: en-us';
        $browser = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)';
        curl_setopt ($ch, CURLOPT_URL, $url);
        curl_setopt ($ch, CURLOPT_HTTPHEADER, $header); 
        curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, 15);
        curl_setopt ($ch, CURLOPT_USERAGENT, $browser);
        $url_string = curl_exec($ch);
        return simplexml_load_string($url_string);
        curl_close($ch);
      }
    } 
    
    
    $guild_data = new guild_data();
    $xml_guild_data = $guild_data->get_xml($lang,$armory_url);
    
    echo '<p>Click on the character name to retrieve information via AJAX.</p>';
    
    echo '<table border="1">';
    echo '<tr>';
    echo '  <th><a href="'.$self.'?o=1">#</a></th>';
    echo '  <th><a href="'.$self.'?o=2">level</a></th>';
    echo '  <th><a href="'.$self.'?o=3">name</a></th>';
    echo '  <th><a href="'.$self.'?o=4">genderId</a></th>';
    echo '  <th><a href="'.$self.'?o=5">raceId</a></th>';
    echo '  <th><a href="'.$self.'?o=6">classId</a></th>';
    echo '  <th><a href="'.$self.'?o=7">rank</a></th>';
    echo '  <th><a href="'.$self.'?o=8">achPoints</a></th>';
    echo '  <th><a href="'.$self.'?o=9">armory</a></th>';
    echo '  <th><a href="'.$self.'?o=9">ajax field</a></th>';
    echo '</tr>'.$eol;
    
    $i=1;
    foreach($xml_guild_data->guildInfo->guild->members->character as $char) {
      echo '<tr>';
      echo '<td>'.$i.'</td>';
      echo '<td>'.$char['level'].'</td>';
      echo '<td><a href="#'.$char['name'].'" onclick="getAjax(\''.$armory_server.'\',\''.$guild_server.'\',\''.$char['name'].'\',\'tab'.$i.'\',\''.$lang.'\');return false;">'.$char['name'].'</a></td>';
      echo '<td>'.$char['genderId'].'</td>';
      echo '<td>'.$char['raceId'].'</td>';
      echo '<td>'.$char['classId'].'</td>';
      echo '<td>'.$char['rank'].'</td>';
      echo '<td>'.$char['achPoints'].'</td>';
      echo '<td><a target="_blank" href="'.$armory_server.'character-sheet.xml?'.$char['url'].'">Armory</a></td>';
      echo '<td id="tab'.$i.'"></td>';
      echo '</tr>'.$eol;
      $i++;
    }
    echo '</table>';
    
    //show dump
    //echo '<pre>';
    //var_dump($xml_guild_data);
    //echo '</pre>';
    
  }
  
  show_footer();  
  
?>