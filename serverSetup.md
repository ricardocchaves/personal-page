# Steps followed to get auto-deploy to server from git push
## 1. Installing hookshot
```
curl -sSL https://github.com/adnanh/webhook/releases/latest/download/webhook-linux-amd64.tar.gz | tar xz
sudo mv webhook-linux-amd64/webhook /usr/local/bin/
```
## 2. Install deploy script
## 3. Create hookshot config (hooks.json)
```
[
  {
    "id": "deploy",
    "execute-command": "/home/worker/personal-page/deploy.sh",
    "trigger-rule": {
      "match": {
        "type": "value",
        "value": "refs/heads/master",
        "parameter": {
          "source": "payload",
          "name": "ref"
        }
      }
    },
    "secret": "0762f942843f57d35b4987f13a378396fe20ee3c"
  }
]
```
## 4. Run hookshot
Create systemd unit, and then
```
sudo systemctl daemon-reexec
sudo systemctl enable --now hookshot.service
```
## 5. Setup reverse proxy in caddy
```
        handle /hooks/* {
                reverse_proxy localhost:9000
        }
```
## 6. Setup github webhook
On GitHub: Repo → Settings → Webhooks → Add webhook:
    Payload URL: https://www.ricardochaves.pt/hooks/deploy
    Content type: application/json
    Event: Just push
    Secret: (optional, but hookshot supports it — can add later)

# Secret
## 1. Generate secret
```
openssl rand -hex 20 > $HOME/webhook-secret.txt
```
## 2. Add it to hooks.json
## 3. Update github webhook settings
Repo/Settings/Webhooks/Edit
Add secret in "Secret" field
## 4. Restart service
sudo systemctl restart hookshot.service
