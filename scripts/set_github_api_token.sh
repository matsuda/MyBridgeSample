tokenFile=".github_api_token"
tokenPath="${SRCROOT}/${tokenFile}"
echo $tokenPath

if [ ! -e $tokenPath ]; then
	echo "${tokenFile} not exist"
	exit 0
fi

token=`cat $tokenPath`
echo "token : $token"

plistBuddy="/usr/libexec/PlistBuddy"
infoPlistSource="${SRCROOT}/${INFOPLIST_FILE}"
# currentToken=$($plistBuddy -c "Print GitHubAPIToken" $infoPlistSource)

infoPlistTemp="${TEMP_DIR}/Preprocessed-Info.plist"
# $plistBuddy -c "Set :GitHubAPIToken $token" $infoPlistTemp
$plistBuddy -c "Add :GitHubAPIToken string $token" $infoPlistTemp
