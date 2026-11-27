#!/bin/bash
# Instalación única del panel PuntoClick Admin en el VPS.
# Uso (en la Terminal de aaPanel, como root):
#   bash <(curl -fsSL https://raw.githubusercontent.com/eduardorafael794-afk/puntoclick-web/main/tools/setup-admin.sh)
set -e
REPO="git@github.com:eduardorafael794-afk/admin.puntoclick.git"
APP_DIR="/www/wwwroot/admin-puntoclick-app"
DATA_DIR="/www/admin-puntoclick-data"
KEY="/root/.ssh/puntoclick_admin"
PORT=3100
G='\033[1;32m'; Y='\033[1;33m'; R='\033[1;31m'; N='\033[0m'
paso(){ echo -e "\n${G}==> $1${N}"; }

[ "$(id -u)" = "0" ] || { echo -e "${R}Ejecuta esto como root.${N}"; exit 1; }

paso "1/6 Revisando Node y pm2"
command -v node >/dev/null || { echo -e "${R}No encuentro Node. Instálalo en aaPanel (App Store → Node.js version manager) y vuelve a ejecutar.${N}"; exit 1; }
command -v pm2 >/dev/null || npm install -g pm2 --no-audit --no-fund
echo "Node $(node -v) · pm2 $(pm2 -v)"
cat > /root/.puntoclick-admin.env <<EOF
export PATH="$(dirname "$(command -v node)"):$(dirname "$(command -v pm2)"):/usr/local/bin:/usr/bin:/bin"
export DATA_DIR="$DATA_DIR"
export PORT=$PORT
EOF
if ss -ltn 2>/dev/null | grep -q ":$PORT " && ! pm2 describe puntoclick-admin >/dev/null 2>&1; then
  echo -e "${R}El puerto $PORT ya está en uso por otro programa. Avísale a Claude.${N}"; exit 1
fi

paso "2/6 Llave de acceso a GitHub"
mkdir -p /root/.ssh && chmod 700 /root/.ssh
[ -f "$KEY" ] || ssh-keygen -t ed25519 -N "" -C "vps-puntoclick-admin" -f "$KEY" >/dev/null
export GIT_SSH_COMMAND="ssh -i $KEY -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"
until git ls-remote "$REPO" >/dev/null 2>&1; do
  echo -e "${Y}Copia esta línea completa:${N}\n"
  cat "$KEY.pub"
  echo -e "\n${Y}Pégala en: github.com/eduardorafael794-afk/admin.puntoclick/settings/keys → Add deploy key"
  echo -e "Title: VPS · Key: la línea de arriba · (no marques Allow write access) → Add key${N}"
  read -rp "Cuando la hayas agregado, presiona Enter… " _ </dev/tty
done
echo "Acceso a GitHub correcto."

paso "3/6 Descargando el panel"
if [ -d "$APP_DIR/.git" ]; then (cd "$APP_DIR" && git fetch -q origin main && git reset -q --hard origin/main); else git clone -q "$REPO" "$APP_DIR"; fi
cd "$APP_DIR"
npm install --omit=dev --no-audit --no-fund --silent
mkdir -p "$DATA_DIR" && chmod 700 "$DATA_DIR"

paso "4/6 Clave del panel y WhatsApp"
DATA_DIR="$DATA_DIR" node configurar.js </dev/tty

paso "5/6 Encendiendo el panel"
. /root/.puntoclick-admin.env
pm2 delete puntoclick-admin >/dev/null 2>&1 || true
DATA_DIR="$DATA_DIR" PORT=$PORT pm2 start server.js --name puntoclick-admin >/dev/null
pm2 save >/dev/null
sleep 2
curl -fs "http://127.0.0.1:$PORT/api/session" >/dev/null && echo "Panel funcionando en el puerto $PORT." || { echo -e "${R}El panel no respondió. Revisa: pm2 logs puntoclick-admin${N}"; exit 1; }

paso "6/6 Actualización automática"
chmod +x "$APP_DIR/update.sh"
( crontab -l 2>/dev/null | grep -v 'admin-puntoclick-app/update.sh'; echo "*/5 * * * * /bin/bash $APP_DIR/update.sh >> /var/log/puntoclick-admin-update.log 2>&1" ) | crontab -
echo "Listo: cada 5 minutos revisa si hay cambios en GitHub."

echo -e "\n${G}Instalación terminada.${N}"
echo -e "Último paso en aaPanel: Website → Add site → admin.puntoclick3d.com → Reverse proxy hacia http://127.0.0.1:$PORT → SSL (Let's Encrypt).\n"
