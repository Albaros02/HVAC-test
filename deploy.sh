
CONFIG_FILE="functions-config.json"

NO_VERIFY_FUNCTIONS=$(jq -r "development.noVerifyJwt[]" $CONFIG_FILE)
VERIFY_FUNCTIONS=$(jq -r ".development.verifyJwt[]" $CONFIG_FILE)

for function in $NO_VERIFY_FUNCTIONS; do
  echo "Desplegando $function con --no-verify-jwt"
  supabase functions deploy $function --no-verify-jwt
done

for function in $VERIFY_FUNCTIONS; do
  echo "Desplegando $function con verificacion de JWT"
  supabase functions deploy $function
done
