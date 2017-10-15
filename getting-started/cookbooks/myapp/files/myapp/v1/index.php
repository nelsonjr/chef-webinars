<?php
header('X-Source: ' . gethostname());
header('X-Version: 1.0');
header('Content-Type: text/plain');
header('Cache-Control: must-revalidate');
header('Cache-Control: no-cache');
?>
  _____ _           __  __          __  _     _                    _____
 / ____| |         / _| \ \        / / | |   (_)                  |_   _|
| |    | |__   ___| |_   \ \  /\  / /__| |__  _ _ __   __ _ _ __    | |
| |    | '_ \ / _ \  _|   \ \/  \/ / _ \ '_ \| | '_ \ / _` | '__|   | |
| |____| | | |  __/ |      \  /\  /  __/ |_) | | | | | (_| | |     _| |_
 \_____|_| |_|\___|_|       \/  \/ \___|_.__/|_|_| |_|\__,_|_|    |_____|


<?php
echo 'Hello from ' . gethostname() . '!';
echo "\n\n";
echo "It's " . date('r') . ' around here';
?>
