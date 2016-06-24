LAST_WD=`pwd`
RAW_PATH="$PATH"

augment_path() {

  if [ "$PWD" = "$LAST_WD" ]; then
    return 0;
  fi;

  # Set default targets, can be overriden by
  AUGMENT_PATH_TARGETS=("vendor/bin" "composer")

  PATH_ADDITION=""
  for target in ${AUGMENT_PATH_TARGETS[@]}; do
    scandir="$PWD"

    until [ "$scandir" = "" ]; do
      resolved_target="$scandir"/"$target"
      if [ -d "$resolved_target" ]; then
        PATH_ADDITION="$PATH_ADDITION:$resolved_target"
      elif [ -f "$resolved_target" ]; then
        resolved_target=$(readlink -e $(dirname "${resolved_target}"))
        PATH_ADDITION="$PATH_ADDITION:$resolved_target"
      fi
      scandir="${scandir%/*}"
    done


    LAST_WD=`pwd`
  done

  PATH="$PATH_ADDITION:$RAW_PATH"

}


PROMPT_COMMAND_OLD="${PROMPT_COMMAND%; augment_path}"
PROMPT_COMMAND="$PROMPT_COMMAND_OLD; augment_path"
