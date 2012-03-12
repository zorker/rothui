<?

  $armory_server = $_GET[aserver];
  $guild_server = $_GET[gserver];
  $guild_char = $_GET[char];
  $lang = $_GET[lang];
  $armory_xml_file = 'character-sheet.xml';
  $url = $armory_server.$armory_xml_file.'?r='.$guild_server.'&n='.$guild_char;
  
  class char_data 
  {
  
    public function get_xml($url,$lang) 
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
      return $url_string;
      curl_close($ch);
    }
  } 
  
  $char_data = new char_data();
  $xml_char_data = $char_data->get_xml($url,$lang);
  
  echo $xml_char_data->characterInfo->character['race'];  
  echo ', ';
  echo $xml_char_data->characterInfo->character['gender'];  
  echo ', ';
  echo $xml_char_data->characterInfo->character['class'];  
  echo ', ';
  echo $xml_char_data->characterInfo->character['prefix'];  
  echo ', ';
  echo $xml_char_data->characterInfo->character['suffix'];  
  echo ', ';
  
  foreach($xml_char_data->characterInfo->characterTab->professions->skill as $skill) {
    echo $skill[name].' '.$skill[value].'/'.$skill[max];
    echo ', ';
  }

  //echo $tooltip_data;
  
  
?>