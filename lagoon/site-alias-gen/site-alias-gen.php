<?php
   $pipe="/tmp/self.site.yml";
   $input=__DIR__."/example.self.site.yml";
   $mode=0600;
   if(!file_exists($pipe)) {
      posix_mkfifo($pipe,$mode);
   }

   while(true) {
    file_put_contents($pipe, file_get_contents($input));
    sleep(1);
}

?>
