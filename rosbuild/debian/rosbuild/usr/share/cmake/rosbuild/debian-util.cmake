
execute_process(COMMAND date +%F-%0k-%0M-%0S%z
  OUTPUT_VARIABLE DEBIAN_SNAPSHOT_SUFFIX
  OUTPUT_STRIP_TRAILING_WHITESPACE)


  