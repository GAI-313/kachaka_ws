profile_directory="${IPYTHONDIR:-${HOME}/.ipython}/profile_default"

mkdir -p "${profile_directory}"
cp -a "${PIXI_PROJECT_ROOT}/profile_ierk/." "${profile_directory}/"
