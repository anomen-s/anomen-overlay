<?php

# Debugging routines

# use either mode 'a' or 'w'
$debugLog = @fopen('./.debuglog','w');

function wikidebug($msg)
{
    global $debugLog;
    @fwrite($debugLog, "$msg\n");
}

function closeWikiDebugLog()
{
  global $debugLog;
  @fclose($debugLog);
}

register_shutdown_function('closeWikiDebugLog');

?>